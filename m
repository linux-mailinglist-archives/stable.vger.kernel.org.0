Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71CBE1875A5
	for <lists+stable@lfdr.de>; Mon, 16 Mar 2020 23:31:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732820AbgCPWbS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Mar 2020 18:31:18 -0400
Received: from dvalin.narfation.org ([213.160.73.56]:49142 "EHLO
        dvalin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732818AbgCPWbS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Mar 2020 18:31:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1584397877;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p4v+CIGax1+8u1v3Hh1TvW3xNPrumU3Q+mfuz99jp/Y=;
        b=beSr/k/8JvnF4gm2XE1IZe8Ioo+m9bbJfvVdzrX6u4fJnxqVW1HZigW0r02lScbuSv9iby
        41wLZmi+uHr6YAV+SZITCAzhTH8DlmxSaL6w+vjUGuq0In4OfCUSKj0NvwC/5hENp4Gits
        ULi37wBzOXY6sF4JMXZtyGF5yoKDlb4=
From:   Sven Eckelmann <sven@narfation.org>
To:     stable@vger.kernel.org
Cc:     Sven Eckelmann <sven.eckelmann@open-mesh.com>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4.9 09/24] batman-adv: Always initialize fragment header priority
Date:   Mon, 16 Mar 2020 23:30:50 +0100
Message-Id: <20200316223105.6333-10-sven@narfation.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200316223105.6333-1-sven@narfation.org>
References: <20200316223105.6333-1-sven@narfation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Eckelmann <sven.eckelmann@open-mesh.com>

commit fe77d8257c4d838c5976557ddb87bd789f312412 upstream.

The batman-adv unuicast fragment header contains 3 bits for the priority of
the packet. These bits will be initialized when the skb->priority contains
a value between 256 and 263. But otherwise, the uninitialized bits from the
stack will be used.

Fixes: c0f25c802b33 ("batman-adv: Include frame priority in fragment header")
Signed-off-by: Sven Eckelmann <sven.eckelmann@open-mesh.com>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 net/batman-adv/fragmentation.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/batman-adv/fragmentation.c b/net/batman-adv/fragmentation.c
index f3ad92b06247..fef21f75892e 100644
--- a/net/batman-adv/fragmentation.c
+++ b/net/batman-adv/fragmentation.c
@@ -484,6 +484,8 @@ int batadv_frag_send_packet(struct sk_buff *skb,
 	 */
 	if (skb->priority >= 256 && skb->priority <= 263)
 		frag_header.priority = skb->priority - 256;
+	else
+		frag_header.priority = 0;
 
 	ether_addr_copy(frag_header.orig, primary_if->net_dev->dev_addr);
 	ether_addr_copy(frag_header.dest, orig_node->orig);
-- 
2.20.1


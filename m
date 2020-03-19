Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 310FD18B4D5
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:13:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728026AbgCSNNF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:13:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:59824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729074AbgCSNNE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:13:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A66021556;
        Thu, 19 Mar 2020 13:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623583;
        bh=CeS4ZfFNTDnHjmaCoZDg4O8W798qKPZe6yPihomZS+k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MPatmkjJavrDQZDcZADlac1MWEIi17kyqkJ5p/OIlHoS0tVV6+QkSep8tz9pzUhKX
         1kADT7lY8ScFVgcBCzoxxZx0V+9RnbMpIXv3VuWgsw7q007Dqye0fNC+To5cUT7sY1
         JBG+Nz+4BS3C0gV4Q2JTJMP/gKsTmNcasW+HiOlA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sven Eckelmann <sven.eckelmann@open-mesh.com>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4.9 59/90] batman-adv: Always initialize fragment header priority
Date:   Thu, 19 Mar 2020 14:00:21 +0100
Message-Id: <20200319123946.794943115@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123928.635114118@linuxfoundation.org>
References: <20200319123928.635114118@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/fragmentation.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/batman-adv/fragmentation.c
+++ b/net/batman-adv/fragmentation.c
@@ -484,6 +484,8 @@ int batadv_frag_send_packet(struct sk_bu
 	 */
 	if (skb->priority >= 256 && skb->priority <= 263)
 		frag_header.priority = skb->priority - 256;
+	else
+		frag_header.priority = 0;
 
 	ether_addr_copy(frag_header.orig, primary_if->net_dev->dev_addr);
 	ether_addr_copy(frag_header.dest, orig_node->orig);



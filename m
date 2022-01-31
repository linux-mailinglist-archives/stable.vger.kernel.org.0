Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 696F14A42CA
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:14:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240439AbiAaLOE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:14:04 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:45836 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359817AbiAaLMM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:12:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1979661170;
        Mon, 31 Jan 2022 11:12:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAAACC340E8;
        Mon, 31 Jan 2022 11:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627531;
        bh=syVE4GZKFypRsf0nIIvCwfJnwSh7ZYn+wdukRofgwOM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bwnmynZtc7U7YulLOlSmQrHZP+oFvSzEGnXawOjoviuHqnsFRkRIPUzlpk1Me0UyX
         JybQcV9fw1J5aLx8AMO2tE1Siwn1gnrOTFLk+/gi0LSKPqfqB2lVElO3JlvnDPOzZr
         4yRhee+fyJLu8AKQNPuThtp3xQ19QY7kxB9cRHBM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Jean Sacren <sakiwit@gmail.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 115/171] mptcp: clean up harmless false expressions
Date:   Mon, 31 Jan 2022 11:56:20 +0100
Message-Id: <20220131105233.934653316@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105229.959216821@linuxfoundation.org>
References: <20220131105229.959216821@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jean Sacren <sakiwit@gmail.com>

[ Upstream commit 59060a47ca50bbdb1d863b73667a1065873ecc06 ]

entry->addr.id is u8 with a range from 0 to 255 and MAX_ADDR_ID is 255.
We should drop both false expressions of (entry->addr.id > MAX_ADDR_ID).

We should also remove the obsolete parentheses in the first if branch.

Use U8_MAX for MAX_ADDR_ID and add a comment to show the link to
mptcp_addr_info.id as suggested by Mr. Matthieu Baerts.

Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Jean Sacren <sakiwit@gmail.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/pm_netlink.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 3be10bf22cf7c..15c89d4fea4d2 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -38,7 +38,8 @@ struct mptcp_pm_add_entry {
 	u8			retrans_times;
 };
 
-#define MAX_ADDR_ID		255
+/* max value of mptcp_addr_info.id */
+#define MAX_ADDR_ID		U8_MAX
 #define BITMAP_SZ DIV_ROUND_UP(MAX_ADDR_ID + 1, BITS_PER_LONG)
 
 struct pm_nl_pernet {
@@ -831,14 +832,13 @@ find_next:
 		entry->addr.id = find_next_zero_bit(pernet->id_bitmap,
 						    MAX_ADDR_ID + 1,
 						    pernet->next_id);
-		if ((!entry->addr.id || entry->addr.id > MAX_ADDR_ID) &&
-		    pernet->next_id != 1) {
+		if (!entry->addr.id && pernet->next_id != 1) {
 			pernet->next_id = 1;
 			goto find_next;
 		}
 	}
 
-	if (!entry->addr.id || entry->addr.id > MAX_ADDR_ID)
+	if (!entry->addr.id)
 		goto out;
 
 	__set_bit(entry->addr.id, pernet->id_bitmap);
-- 
2.34.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9251A4A8EA6
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 21:39:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354746AbiBCUik (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 15:38:40 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:38720 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354764AbiBCUgk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 15:36:40 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 99A9EB83503;
        Thu,  3 Feb 2022 20:36:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81881C340E8;
        Thu,  3 Feb 2022 20:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643920596;
        bh=27snDcMHmdboqii2MmwxWugX1Q1BDnFqJRQ8YQ86qqM=;
        h=From:To:Cc:Subject:Date:From;
        b=ObvoW2+Nus3Y/ldBEBv4g2n143WQs87QjfhQZHOrDrA9IR/n6l6S4+0wgaayeeQ8A
         SyN3NAXAWmWHhEfwJ1ukDvEzo1bVJdSUPDVpGGk/CqyhEIvq+9nJcbHXrugzZwE+L8
         UkO9VPuTw+IizlUNcc8KNVJUYtgrG/et+3OO724SRrxzlvK1t9sNg+tb+zlKvri/F8
         xF86Thw4628s0MLTEvoLftgyKtgPSGnOZja+9Hcm7MFFqrjjwTHCTPOY49q0zBmQPc
         WV4MZ16ZUwFeKi1dEyU7dY/IzoXjbg1xmB3TK9x2FWAbTE1+yQBDPAp+bnPRZjcO+K
         0aZbBDJHBkYuA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Olga Kornievskaia <kolga@netapp.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>,
        trond.myklebust@hammerspace.com, anna.schumaker@netapp.com,
        linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 1/9] NFSv4 only print the label when its queried
Date:   Thu,  3 Feb 2022 15:36:25 -0500
Message-Id: <20220203203633.4685-1-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Olga Kornievskaia <kolga@netapp.com>

[ Upstream commit 2c52c8376db7160a1dd8a681c61c9258405ef143 ]

When the bitmask of the attributes doesn't include the security label,
don't bother printing it. Since the label might not be null terminated,
adjust the printing format accordingly.

Signed-off-by: Olga Kornievskaia <kolga@netapp.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4xdr.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/nfs/nfs4xdr.c b/fs/nfs/nfs4xdr.c
index 3cd04c98da6bc..99facb5f186fd 100644
--- a/fs/nfs/nfs4xdr.c
+++ b/fs/nfs/nfs4xdr.c
@@ -4272,10 +4272,11 @@ static int decode_attr_security_label(struct xdr_stream *xdr, uint32_t *bitmap,
 		} else
 			printk(KERN_WARNING "%s: label too long (%u)!\n",
 					__func__, len);
+		if (label && label->label)
+			dprintk("%s: label=%.*s, len=%d, PI=%d, LFS=%d\n",
+				__func__, label->len, (char *)label->label,
+				label->len, label->pi, label->lfs);
 	}
-	if (label && label->label)
-		dprintk("%s: label=%s, len=%d, PI=%d, LFS=%d\n", __func__,
-			(char *)label->label, label->len, label->pi, label->lfs);
 	return status;
 
 out_overflow:
-- 
2.34.1


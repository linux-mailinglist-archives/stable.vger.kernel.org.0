Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47FF94A8F2C
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 21:42:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354887AbiBCUmj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 15:42:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356029AbiBCUk5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 15:40:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F088AC0619D1;
        Thu,  3 Feb 2022 12:36:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 916D460A77;
        Thu,  3 Feb 2022 20:36:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 366F2C340E8;
        Thu,  3 Feb 2022 20:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643920614;
        bh=czRuVdm4hdL5Ea907Q1CqurNlQHpEw3Smw/F2cDltok=;
        h=From:To:Cc:Subject:Date:From;
        b=HtuaJ84qLOEeppnDuviEAPoj71SeEfs92NC5cYqb8AZzwvzjO8vHM1GuWIwSRfchG
         40t+2NHTVxmvFbNktjJQPxdGJX9tpYIB1lnVS8ebP4xRWVjaPiyftzYG+GmG7Dinbh
         L9oppg0bSKlnNWVumgv3MOb/zojQRVYe9TtJ5GHc6qUNWwYEggt+rHq1nGn5Pg6GZK
         2btcra/JLcdBPOahVVNOFbOCWavK2Cq3FIUyRN2PQvUkLXyIvq78zrzZ81biDhEQQA
         8+CM9uxiQhL37TTAAeUwnJU2z27gvNqpLQ9RRCByDKPmsXoCqlpRgbVFP9XehAwyKn
         EqcDsGRTDSZgg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Olga Kornievskaia <kolga@netapp.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>,
        trond.myklebust@hammerspace.com, anna.schumaker@netapp.com,
        linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 1/7] NFSv4 only print the label when its queried
Date:   Thu,  3 Feb 2022 15:36:45 -0500
Message-Id: <20220203203651.5158-1-sashal@kernel.org>
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
index 0a7c4e30a385e..29dbb14b6fd11 100644
--- a/fs/nfs/nfs4xdr.c
+++ b/fs/nfs/nfs4xdr.c
@@ -4177,10 +4177,11 @@ static int decode_attr_security_label(struct xdr_stream *xdr, uint32_t *bitmap,
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


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 705314A8DFD
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 21:34:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351219AbiBCUeR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 15:34:17 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:38830 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354177AbiBCUcu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 15:32:50 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 730EF61A6D;
        Thu,  3 Feb 2022 20:32:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00CCCC36AE2;
        Thu,  3 Feb 2022 20:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643920369;
        bh=cNXuiQbp4eVaybtXIz+X39csbOButa7r68/wQKJtlsk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rda7/7CtwL+HbXYVSV78lNBy46gyWEdHv7l6XrmQ42yt93ybGW9H+HT1SYBXtj1oD
         6qhU8xTvL688dXSKburalrhYS0rVrn1tBFwfXp7kHzEOH52P5w4gT+TT9cw4DVnEI+
         wrnkopLg891loATBDpQklpl5fDaU0LLMG4gA3563S5xsz3mmVc8z1VBsPa9CKbbDlK
         m9IbedH/Ndz4SBk4lCG2VY/TarEWMjgS3bswgNgwEKD7xR2vbUDhZ8ETW1Cv7arD//
         udk0oJIbgWjsxHm8oNPt9Q+zTnLJodOJqc/TTRzd692nYJ1T1UGYOQSaECPQuw91lW
         A8HZbjJdmIkOA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Olga Kornievskaia <kolga@netapp.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>,
        trond.myklebust@hammerspace.com, anna.schumaker@netapp.com,
        linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 02/41] NFSv4 only print the label when its queried
Date:   Thu,  3 Feb 2022 15:32:06 -0500
Message-Id: <20220203203245.3007-2-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220203203245.3007-1-sashal@kernel.org>
References: <20220203203245.3007-1-sashal@kernel.org>
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
index a8cff19c6f00c..5e886518f2d45 100644
--- a/fs/nfs/nfs4xdr.c
+++ b/fs/nfs/nfs4xdr.c
@@ -4197,10 +4197,11 @@ static int decode_attr_security_label(struct xdr_stream *xdr, uint32_t *bitmap,
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
 }
 
-- 
2.34.1


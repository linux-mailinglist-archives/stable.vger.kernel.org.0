Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 331134A8D3E
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 21:30:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354066AbiBCU34 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 15:29:56 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:32862 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354054AbiBCU3x (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 15:29:53 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 65B8DB835A2;
        Thu,  3 Feb 2022 20:29:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 722A0C340EF;
        Thu,  3 Feb 2022 20:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643920191;
        bh=d+kEBIHewkuWC6lO+UBYJFu3t9iYpHMhNr5974kvkSo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DA2Z9mLCh7Pxnl/agn9wGbLrA4sXb/ikEivks/g/eHaW5FhTc0UX8qedP9/zmWRcc
         zAjlc75w7pIN2fHPqT3ZQbx0z1XGf7zT1Ks02N/dz+CnoetFEA3AVRyF8Iu4WzOsZE
         9Eh0ZSvK36HojNlwMdz745JQoalFGGDmUqc5BCL2x8+AtQtQlxB4z7aaJ4n+on/AgY
         QyPx5uTK7/fsYxW171o7k4Bo+sDkbvD/L+gtJJAylZOLOo3zlM0YNxnj3mlF6dJFHq
         dSSQWMB0GOa/NQYtkAqg6SB+9Lqs4bsa/ICcnhCz/qmFMXMlRJ8cy5QNJiDU/igxhw
         DtsIeSvdfqhlw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Olga Kornievskaia <kolga@netapp.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>,
        trond.myklebust@hammerspace.com, anna.schumaker@netapp.com,
        linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 02/52] NFSv4 only print the label when its queried
Date:   Thu,  3 Feb 2022 15:28:56 -0500
Message-Id: <20220203202947.2304-2-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220203202947.2304-1-sashal@kernel.org>
References: <20220203202947.2304-1-sashal@kernel.org>
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
index 69862bf6db001..801119b7a5964 100644
--- a/fs/nfs/nfs4xdr.c
+++ b/fs/nfs/nfs4xdr.c
@@ -4200,10 +4200,11 @@ static int decode_attr_security_label(struct xdr_stream *xdr, uint32_t *bitmap,
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


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5197144A2CF
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 02:23:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242904AbhKIBVe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 20:21:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:46194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243117AbhKIBTb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 20:19:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E27A61B03;
        Tue,  9 Nov 2021 01:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636420070;
        bh=8oDn/mKKwZW39jfc27elu3K7XvGSEnv0UEF+EV8qVY0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=boJ/ROJhiWSpfPM5Byzk80MYgGVsIW9j106//QG155JIDRjIpsjK+wojV0ag/zgzl
         FNKwICYuvJc2hiTefTlLJxvJg/JlyQk3PuQjpDm6215Tml2ZqALtJIWARQH09ZOx+8
         EEgNFtK43cA89HgWtmd+O6aNz8IX5g/FeXEsvEfFArV2FlDY+BTR2GOQSjqwGzTHoH
         8CRtODpp4DaB9v5pqiriQpEYaM8iLAeHl95E+Uk1dzWvAcFX6UEiJmslXQKgYIJzgT
         qyzFMVpTRdybTiOQ6u0/0zFbnNVm97xCRLTVDvw1W9KFt11RvIQzbTDNc9Vm9o0+D/
         ToplmFJvcFPKA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        syzbot <syzbot+89731ccb6fec15ce1c22@syzkaller.appspotmail.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Sasha Levin <sashal@kernel.org>, jmorris@namei.org,
        serge@hallyn.com, linux-security-module@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 32/39] smackfs: use __GFP_NOFAIL for smk_cipso_doi()
Date:   Mon,  8 Nov 2021 20:06:42 -0500
Message-Id: <20211109010649.1191041-32-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109010649.1191041-1-sashal@kernel.org>
References: <20211109010649.1191041-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>

[ Upstream commit f91488ee15bd3cac467e2d6a361fc2d34d1052ae ]

syzbot is reporting kernel panic at smk_cipso_doi() due to memory
allocation fault injection [1]. The reason for need to use panic() was
not explained. But since no fix was proposed for 18 months, for now
let's use __GFP_NOFAIL for utilizing syzbot resource on other bugs.

Link: https://syzkaller.appspot.com/bug?extid=89731ccb6fec15ce1c22 [1]
Reported-by: syzbot <syzbot+89731ccb6fec15ce1c22@syzkaller.appspotmail.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/smack/smackfs.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index 25705a72d31bc..9fdf404a318f9 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -721,9 +721,7 @@ static void smk_cipso_doi(void)
 		printk(KERN_WARNING "%s:%d remove rc = %d\n",
 		       __func__, __LINE__, rc);
 
-	doip = kmalloc(sizeof(struct cipso_v4_doi), GFP_KERNEL);
-	if (doip == NULL)
-		panic("smack:  Failed to initialize cipso DOI.\n");
+	doip = kmalloc(sizeof(struct cipso_v4_doi), GFP_KERNEL | __GFP_NOFAIL);
 	doip->map.std = NULL;
 	doip->doi = smk_cipso_doi_value;
 	doip->type = CIPSO_V4_MAP_PASS;
-- 
2.33.0


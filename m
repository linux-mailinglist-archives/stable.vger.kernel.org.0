Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64A3D44A356
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 02:24:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242313AbhKIB0n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 20:26:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:47704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243507AbhKIBXW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 20:23:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C2CBF61B40;
        Tue,  9 Nov 2021 01:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636420143;
        bh=oOJPV2CNc0bd5QaZ5EFIK0Cp7xJoqO2+pimK1Z2tLv0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fan2aw1f3wDiaLq5JhRmNCSqI/3LgQDIWb/xSdCVtUq1brUF9RP/WEqx7kqwv/NSW
         JtboXTKD+toBRDH0NLMXDpk6mFuqBQZy9prw6a01As7cCr9Ps7FUzVtBVc8xZvoPzH
         yjB+mA6Qvo/qrLWGOjs7MlZsxk5izo/NaAZbo5b2ID56IRMvx1GnKbHkJ7dTR/zDkJ
         PJsas8voXubya9892SnGjNpwpdDX6YUiVzETeHQz8jDxZiZXaCBm4YcZ3v/uvSsZQF
         cmYU8NWQXu+SlT6sC6xw8bGo8sZ+J1A+M/AEqYRo2uhj5cjorV+ZbNoQYw30Lut3ij
         Khb7MCK7K4ewQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        syzbot <syzbot+89731ccb6fec15ce1c22@syzkaller.appspotmail.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Sasha Levin <sashal@kernel.org>, jmorris@namei.org,
        serge@hallyn.com, linux-security-module@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 28/33] smackfs: use __GFP_NOFAIL for smk_cipso_doi()
Date:   Mon,  8 Nov 2021 20:08:02 -0500
Message-Id: <20211109010807.1191567-28-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109010807.1191567-1-sashal@kernel.org>
References: <20211109010807.1191567-1-sashal@kernel.org>
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
index e26e7fbb89657..cf1f92a04359a 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -716,9 +716,7 @@ static void smk_cipso_doi(void)
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


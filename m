Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FD5845C001
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:01:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343905AbhKXNED (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:04:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:41104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245592AbhKXNCV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:02:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2B55160295;
        Wed, 24 Nov 2021 12:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757336;
        bh=8oDn/mKKwZW39jfc27elu3K7XvGSEnv0UEF+EV8qVY0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RciA82v5WeAARf6dOoxqqkKYIrzK1m+3asuiEULfsERKpxwCu70SFxTy7kbGZda5j
         yJQ/i4dueP6gSY7R7n6OOCKx4vGLsTQyseGxKm56h3vU0y1eOjWOZd3J77HZtbWRbu
         4apFo5jA7kJwSo3eU7tUCRlNS9RrIZ13PtABvIWc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot <syzbot+89731ccb6fec15ce1c22@syzkaller.appspotmail.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 117/323] smackfs: use __GFP_NOFAIL for smk_cipso_doi()
Date:   Wed, 24 Nov 2021 12:55:07 +0100
Message-Id: <20211124115722.900861919@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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




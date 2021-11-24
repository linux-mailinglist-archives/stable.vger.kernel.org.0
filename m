Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4FB545BA1B
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:05:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242007AbhKXMHk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:07:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:33882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242282AbhKXMGk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:06:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F242660FBF;
        Wed, 24 Nov 2021 12:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637755410;
        bh=SVJ1+bjXfGnfETTDv75CBkHb2qQU6zm3q6RJWGvy200=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jpak3Rj909j5S1oO6P5tj0AjDNpRWLyMoJnrqu6oCp+EBvhzvD8Ry21d0ndFpBh1g
         2UX/sj2aZlFVQhxYjrWdRDoiHRQh6Ds3qtjt+Eu+dKQta4kldEJfrdi1PeIRHgU+KA
         eNPAw2imjXqxLbJjbrfjfCk2nw8lSQAMDt/j+azw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot <syzbot+93dba5b91f0fed312cbd@syzkaller.appspotmail.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 084/162] smackfs: use netlbl_cfg_cipsov4_del() for deleting cipso_v4_doi
Date:   Wed, 24 Nov 2021 12:56:27 +0100
Message-Id: <20211124115701.039259914@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115658.328640564@linuxfoundation.org>
References: <20211124115658.328640564@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>

[ Upstream commit 0934ad42bb2c5df90a1b9de690f93de735b622fe ]

syzbot is reporting UAF at cipso_v4_doi_search() [1], for smk_cipso_doi()
is calling kfree() without removing from the cipso_v4_doi_list list after
netlbl_cfg_cipsov4_map_add() returned an error. We need to use
netlbl_cfg_cipsov4_del() in order to remove from the list and wait for
RCU grace period before kfree().

Link: https://syzkaller.appspot.com/bug?extid=93dba5b91f0fed312cbd [1]
Reported-by: syzbot <syzbot+93dba5b91f0fed312cbd@syzkaller.appspotmail.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Fixes: 6c2e8ac0953fccdd ("netlabel: Update kernel configuration API")
Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/smack/smackfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index 40c8b2b8a4722..ce30b61c56171 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -740,7 +740,7 @@ static void smk_cipso_doi(void)
 	if (rc != 0) {
 		printk(KERN_WARNING "%s:%d map add rc = %d\n",
 		       __func__, __LINE__, rc);
-		kfree(doip);
+		netlbl_cfg_cipsov4_del(doip->doi, &nai);
 		return;
 	}
 }
-- 
2.33.0




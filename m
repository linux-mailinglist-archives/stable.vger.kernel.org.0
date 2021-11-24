Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F19545BD58
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:34:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243833AbhKXMha (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:37:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:52018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244455AbhKXMf2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:35:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F33DA610FB;
        Wed, 24 Nov 2021 12:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756497;
        bh=TslBu8qF10g5S/5SN3YoqK+yp13DOd4gZDb9BGhTW18=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ssi9cebyQjGQi6p3EoP+6UnPCEGaGgHd5C7Ou7rIH2J7PRVqYpgehvk4bdHscoDux
         yyAiE5DRyjerjKHQKGkgh16jnCUhtpRN20ElvS74Oy4QXAEmWEU5BZ0wBcG88epihL
         VR7rCQk5JlGRbVdSzIR21PRR9HA22OXBnCSXzudo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+3f91de0b813cc3d19a80@syzkaller.appspotmail.com,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 074/251] smackfs: Fix use-after-free in netlbl_catmap_walk()
Date:   Wed, 24 Nov 2021 12:55:16 +0100
Message-Id: <20211124115712.826831674@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115710.214900256@linuxfoundation.org>
References: <20211124115710.214900256@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

[ Upstream commit 0817534ff9ea809fac1322c5c8c574be8483ea57 ]

Syzkaller reported use-after-free bug as described in [1]. The bug is
triggered when smk_set_cipso() tries to free stale category bitmaps
while there are concurrent reader(s) using the same bitmaps.

Wait for RCU grace period to finish before freeing the category bitmaps
in smk_set_cipso(). This makes sure that there are no more readers using
the stale bitmaps and freeing them should be safe.

[1] https://lore.kernel.org/netdev/000000000000a814c505ca657a4e@google.com/

Reported-by: syzbot+3f91de0b813cc3d19a80@syzkaller.appspotmail.com
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/smack/smackfs.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index 009e83ee2d002..25705a72d31bc 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -859,6 +859,7 @@ static int smk_open_cipso(struct inode *inode, struct file *file)
 static ssize_t smk_set_cipso(struct file *file, const char __user *buf,
 				size_t count, loff_t *ppos, int format)
 {
+	struct netlbl_lsm_catmap *old_cat;
 	struct smack_known *skp;
 	struct netlbl_lsm_secattr ncats;
 	char mapcatset[SMK_CIPSOLEN];
@@ -948,9 +949,11 @@ static ssize_t smk_set_cipso(struct file *file, const char __user *buf,
 
 	rc = smk_netlbl_mls(maplevel, mapcatset, &ncats, SMK_CIPSOLEN);
 	if (rc >= 0) {
-		netlbl_catmap_free(skp->smk_netlabel.attr.mls.cat);
+		old_cat = skp->smk_netlabel.attr.mls.cat;
 		skp->smk_netlabel.attr.mls.cat = ncats.attr.mls.cat;
 		skp->smk_netlabel.attr.mls.lvl = ncats.attr.mls.lvl;
+		synchronize_rcu();
+		netlbl_catmap_free(old_cat);
 		rc = count;
 	}
 
-- 
2.33.0




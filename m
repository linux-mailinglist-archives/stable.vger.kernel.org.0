Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0CE4274693
	for <lists+stable@lfdr.de>; Tue, 22 Sep 2020 18:25:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726672AbgIVQZq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Sep 2020 12:25:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:52628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726566AbgIVQZq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Sep 2020 12:25:46 -0400
Received: from sol.attlocal.net (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0173A23A1B;
        Tue, 22 Sep 2020 16:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600791946;
        bh=TYZYFsETxKQokJa5RQ1ZT+XnfW77zUGnkWfO/996T6c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N6DyX9BvrTxWtntNUaLSrdcUAqIFDIgsKU0dDH2YUBI6/tUe1klJvijggIGn+R6ZV
         5DAddRWtDHwZbZY5fRAWkMjfWPUL+19EutKm/M4cYj+ll0P7spobZpu+IgikKPbmrZ
         XP6/Y4Rbt/ahLXyf2uulWDAOMPSITmkAU+qYq8S0=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
Cc:     syzkaller-bugs@googlegroups.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        syzbot+9f864abad79fae7c17e1@syzkaller.appspotmail.com
Subject: [PATCH] ext4: fix leaking sysfs kobject after failed mount
Date:   Tue, 22 Sep 2020 09:24:56 -0700
Message-Id: <20200922162456.93657-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <000000000000443d8a05afcff2b5@google.com>
References: <000000000000443d8a05afcff2b5@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

ext4_unregister_sysfs() only deletes the kobject.  The reference to it
needs to be put separately, like ext4_put_super() does.

This addresses the syzbot report
"memory leak in kobject_set_name_vargs (3)"
(https://syzkaller.appspot.com/bug?extid=9f864abad79fae7c17e1).

Reported-by: syzbot+9f864abad79fae7c17e1@syzkaller.appspotmail.com
Fixes: 72ba74508b28 ("ext4: release sysfs kobject when failing to enable quotas on mount")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/ext4/super.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index ea425b49b345..41953b86ffe3 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4872,6 +4872,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 
 failed_mount8:
 	ext4_unregister_sysfs(sb);
+	kobject_put(&sbi->s_kobj);
 failed_mount7:
 	ext4_unregister_li_request(sb);
 failed_mount6:

base-commit: ba4f184e126b751d1bffad5897f263108befc780
-- 
2.28.0


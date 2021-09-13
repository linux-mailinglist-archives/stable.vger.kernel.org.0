Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17102408CC2
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240674AbhIMNV0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:21:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:34848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239505AbhIMNUz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:20:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED25161248;
        Mon, 13 Sep 2021 13:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539149;
        bh=DxFXgINlU1ZqSukQUVP+lKKsrBZxEMsIzRCn1a5R9+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I+9p+S/U/MR3PgPm/T+4bsIPAWGYrrQyodyKyXHggG/nx+x0bjb65vzVnNxiTPXhR
         VV14fitFDDYxl/IWYlgpVLPuMI0E9lekhzKuaQbLOrL2FBP8sCRwnwJZEEEJx+MHCa
         I6yiLubKUSZYhDJhjumUiju5FHq4sGMUptqB+Tho=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>,
        Jeff Layton <jlayton@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 027/144] fcntl: fix potential deadlock for &fasync_struct.fa_lock
Date:   Mon, 13 Sep 2021 15:13:28 +0200
Message-Id: <20210913131048.858763277@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131047.974309396@linuxfoundation.org>
References: <20210913131047.974309396@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>

[ Upstream commit 2f488f698fda820f8e6fa0407630154eceb145d6 ]

There is an existing lock hierarchy of
&dev->event_lock --> &fasync_struct.fa_lock --> &f->f_owner.lock
from the following call chain:

  input_inject_event():
    spin_lock_irqsave(&dev->event_lock,...);
    input_handle_event():
      input_pass_values():
        input_to_handler():
          evdev_events():
            evdev_pass_values():
              spin_lock(&client->buffer_lock);
              __pass_event():
                kill_fasync():
                  kill_fasync_rcu():
                    read_lock(&fa->fa_lock);
                    send_sigio():
                      read_lock_irqsave(&fown->lock,...);

&dev->event_lock is HARDIRQ-safe, so interrupts have to be disabled
while grabbing &fasync_struct.fa_lock, otherwise we invert the lock
hierarchy. However, since kill_fasync which calls kill_fasync_rcu is
an exported symbol, it may not necessarily be called with interrupts
disabled.

As kill_fasync_rcu may be called with interrupts disabled (for
example, in the call chain above), we replace calls to
read_lock/read_unlock on &fasync_struct.fa_lock in kill_fasync_rcu
with read_lock_irqsave/read_unlock_irqrestore.

Signed-off-by: Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fcntl.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/fcntl.c b/fs/fcntl.c
index 3dc90e5293e6..fa0fdd829613 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -993,13 +993,14 @@ static void kill_fasync_rcu(struct fasync_struct *fa, int sig, int band)
 {
 	while (fa) {
 		struct fown_struct *fown;
+		unsigned long flags;
 
 		if (fa->magic != FASYNC_MAGIC) {
 			printk(KERN_ERR "kill_fasync: bad magic number in "
 			       "fasync_struct!\n");
 			return;
 		}
-		read_lock(&fa->fa_lock);
+		read_lock_irqsave(&fa->fa_lock, flags);
 		if (fa->fa_file) {
 			fown = &fa->fa_file->f_owner;
 			/* Don't send SIGURG to processes which have not set a
@@ -1008,7 +1009,7 @@ static void kill_fasync_rcu(struct fasync_struct *fa, int sig, int band)
 			if (!(sig == SIGURG && fown->signum == 0))
 				send_sigio(fown, fa->fa_fd, band);
 		}
-		read_unlock(&fa->fa_lock);
+		read_unlock_irqrestore(&fa->fa_lock, flags);
 		fa = rcu_dereference(fa->fa_next);
 	}
 }
-- 
2.30.2




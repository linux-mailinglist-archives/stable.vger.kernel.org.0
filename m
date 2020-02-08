Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8E291566E4
	for <lists+stable@lfdr.de>; Sat,  8 Feb 2020 19:38:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727959AbgBHShs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Feb 2020 13:37:48 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33772 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727752AbgBHS3i (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Feb 2020 13:29:38 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrH-0003dX-8P; Sat, 08 Feb 2020 18:29:35 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrG-000CLt-4a; Sat, 08 Feb 2020 18:29:34 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Dmitry Monakhov" <dmtrmonakhov@yandex-team.ru>,
        "Jan Kara" <jack@suse.cz>
Date:   Sat, 08 Feb 2020 18:19:42 +0000
Message-ID: <lsq.1581185940.74913539@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 043/148] quota: Check that quota is not dirty before
 release
In-Reply-To: <lsq.1581185939.857586636@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.82-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Monakhov <dmtrmonakhov@yandex-team.ru>

commit df4bb5d128e2c44848aeb36b7ceceba3ac85080d upstream.

There is a race window where quota was redirted once we drop dq_list_lock inside dqput(),
but before we grab dquot->dq_lock inside dquot_release()

TASK1                                                       TASK2 (chowner)
->dqput()
  we_slept:
    spin_lock(&dq_list_lock)
    if (dquot_dirty(dquot)) {
          spin_unlock(&dq_list_lock);
          dquot->dq_sb->dq_op->write_dquot(dquot);
          goto we_slept
    if (test_bit(DQ_ACTIVE_B, &dquot->dq_flags)) {
          spin_unlock(&dq_list_lock);
          dquot->dq_sb->dq_op->release_dquot(dquot);
                                                            dqget()
							    mark_dquot_dirty()
							    dqput()
          goto we_slept;
        }
So dquot dirty quota will be released by TASK1, but on next we_sleept loop
we detect this and call ->write_dquot() for it.
XFSTEST: https://github.com/dmonakhov/xfstests/commit/440a80d4cbb39e9234df4d7240aee1d551c36107

Link: https://lore.kernel.org/r/20191031103920.3919-2-dmonakhov@openvz.org
Signed-off-by: Dmitry Monakhov <dmtrmonakhov@yandex-team.ru>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ocfs2/quota_global.c  |  2 +-
 fs/quota/dquot.c         |  2 +-
 include/linux/quotaops.h | 10 ++++++++++
 3 files changed, 12 insertions(+), 2 deletions(-)

--- a/fs/ocfs2/quota_global.c
+++ b/fs/ocfs2/quota_global.c
@@ -714,7 +714,7 @@ static int ocfs2_release_dquot(struct dq
 
 	mutex_lock(&dquot->dq_lock);
 	/* Check whether we are not racing with some other dqget() */
-	if (atomic_read(&dquot->dq_count) > 1)
+	if (dquot_is_busy(dquot))
 		goto out;
 	/* Running from downconvert thread? Postpone quota processing to wq */
 	if (current == osb->dc_task) {
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -475,7 +475,7 @@ int dquot_release(struct dquot *dquot)
 
 	mutex_lock(&dquot->dq_lock);
 	/* Check whether we are not racing with some other dqget() */
-	if (atomic_read(&dquot->dq_count) > 1)
+	if (dquot_is_busy(dquot))
 		goto out_dqlock;
 	mutex_lock(&dqopt->dqio_mutex);
 	if (dqopt->ops[dquot->dq_id.type]->release_dqblk) {
--- a/include/linux/quotaops.h
+++ b/include/linux/quotaops.h
@@ -54,6 +54,16 @@ static inline struct dquot *dqgrab(struc
 	atomic_inc(&dquot->dq_count);
 	return dquot;
 }
+
+static inline bool dquot_is_busy(struct dquot *dquot)
+{
+	if (test_bit(DQ_MOD_B, &dquot->dq_flags))
+		return true;
+	if (atomic_read(&dquot->dq_count) > 1)
+		return true;
+	return false;
+}
+
 void dqput(struct dquot *dquot);
 int dquot_scan_active(struct super_block *sb,
 		      int (*fn)(struct dquot *dquot, unsigned long priv),


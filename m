Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB07412ED92
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:29:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730088AbgABW3o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:29:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:60930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730087AbgABW3o (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:29:44 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E0E321835;
        Thu,  2 Jan 2020 22:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578004183;
        bh=5bo8s5RzrtrnIWCOXBfYTXGQJcFuRTonMSREqfJgI8Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ky/Iq7mrmK+OrcM1i4S3O6qNkxjOjppTkLdD26rCG7FdxcfVrsf6qB0DA2DAu4XOr
         GjHTdD4x4unOD3aO55AhLfZcXYONJRY55Edf27j7qnI+ft6Oads3iW6uftkpjpE00X
         4WLyVVhpBJaOQ8Z3YYHWJ/RRSpna+4POBN+Owymw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 048/171] ALSA: timer: Limit max amount of slave instances
Date:   Thu,  2 Jan 2020 23:06:19 +0100
Message-Id: <20200102220553.672291540@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102220546.960200039@linuxfoundation.org>
References: <20200102220546.960200039@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit fdea53fe5de532969a332d6e5e727f2ad8bf084d ]

The fuzzer tries to open the timer instances as much as possible, and
this may cause a system hiccup easily.  We've already introduced the
cap for the max number of available instances for the h/w timers, and
we should put such a limit also to the slave timers, too.

This patch introduces the limit to the multiple opened slave timers.
The upper limit is hard-coded to 1000 for now, which should suffice
for any practical usages up to now.

Link: https://lore.kernel.org/r/20191106154257.5853-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/timer.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/sound/core/timer.c b/sound/core/timer.c
index e944d27f79c3..f8a4b2a2f8f6 100644
--- a/sound/core/timer.c
+++ b/sound/core/timer.c
@@ -87,6 +87,9 @@ static LIST_HEAD(snd_timer_slave_list);
 /* lock for slave active lists */
 static DEFINE_SPINLOCK(slave_active_lock);
 
+#define MAX_SLAVE_INSTANCES	1000
+static int num_slaves;
+
 static DEFINE_MUTEX(register_mutex);
 
 static int snd_timer_free(struct snd_timer *timer);
@@ -265,6 +268,10 @@ int snd_timer_open(struct snd_timer_instance **ti,
 			err = -EINVAL;
 			goto unlock;
 		}
+		if (num_slaves >= MAX_SLAVE_INSTANCES) {
+			err = -EBUSY;
+			goto unlock;
+		}
 		timeri = snd_timer_instance_new(owner, NULL);
 		if (!timeri) {
 			err = -ENOMEM;
@@ -274,6 +281,7 @@ int snd_timer_open(struct snd_timer_instance **ti,
 		timeri->slave_id = tid->device;
 		timeri->flags |= SNDRV_TIMER_IFLG_SLAVE;
 		list_add_tail(&timeri->open_list, &snd_timer_slave_list);
+		num_slaves++;
 		err = snd_timer_check_slave(timeri);
 		if (err < 0) {
 			snd_timer_close_locked(timeri, &card_dev_to_put);
@@ -363,6 +371,8 @@ static int snd_timer_close_locked(struct snd_timer_instance *timeri,
 	struct snd_timer_instance *slave, *tmp;
 
 	list_del(&timeri->open_list);
+	if (timeri->flags & SNDRV_TIMER_IFLG_SLAVE)
+		num_slaves--;
 
 	/* force to stop the timer */
 	snd_timer_stop(timeri);
-- 
2.20.1




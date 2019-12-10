Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44C89119B80
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 23:12:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728142AbfLJWIx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 17:08:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:35554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728986AbfLJWEg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 17:04:36 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E9A02073B;
        Tue, 10 Dec 2019 22:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576015475;
        bh=+FSfsTMhWnVbXHveRqF4bTYhm7dm42KvOsciyFqV9ek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WWsrAqW49fmgtunHsknrKAREpJfI41OBjmr617EMUq9jzjX9SPXmT0GO2HoICiq4k
         WyGqmbXXEBFfrfkTvBvZ/yCxPbU2v4qluBFLbAprkQYb93Sf27TQ+DWTN8GHQMTrmW
         Q+qzzH1ro74HnQnAeiyx0Si8C7HotQJeF+vvo+WY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.14 080/130] ALSA: timer: Limit max amount of slave instances
Date:   Tue, 10 Dec 2019 17:02:11 -0500
Message-Id: <20191210220301.13262-80-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210220301.13262-1-sashal@kernel.org>
References: <20191210220301.13262-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index c60dfd52e8a6d..22589a073423b 100644
--- a/sound/core/timer.c
+++ b/sound/core/timer.c
@@ -88,6 +88,9 @@ static LIST_HEAD(snd_timer_slave_list);
 /* lock for slave active lists */
 static DEFINE_SPINLOCK(slave_active_lock);
 
+#define MAX_SLAVE_INSTANCES	1000
+static int num_slaves;
+
 static DEFINE_MUTEX(register_mutex);
 
 static int snd_timer_free(struct snd_timer *timer);
@@ -266,6 +269,10 @@ int snd_timer_open(struct snd_timer_instance **ti,
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
@@ -275,6 +282,7 @@ int snd_timer_open(struct snd_timer_instance **ti,
 		timeri->slave_id = tid->device;
 		timeri->flags |= SNDRV_TIMER_IFLG_SLAVE;
 		list_add_tail(&timeri->open_list, &snd_timer_slave_list);
+		num_slaves++;
 		err = snd_timer_check_slave(timeri);
 		if (err < 0) {
 			snd_timer_close_locked(timeri, &card_dev_to_put);
@@ -364,6 +372,8 @@ static int snd_timer_close_locked(struct snd_timer_instance *timeri,
 	struct snd_timer_instance *slave, *tmp;
 
 	list_del(&timeri->open_list);
+	if (timeri->flags & SNDRV_TIMER_IFLG_SLAVE)
+		num_slaves--;
 
 	/* force to stop the timer */
 	snd_timer_stop(timeri);
-- 
2.20.1


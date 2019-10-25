Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4839E4CDF
	for <lists+stable@lfdr.de>; Fri, 25 Oct 2019 15:56:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2632793AbfJYN4S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Oct 2019 09:56:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:50564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2632795AbfJYN4R (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Oct 2019 09:56:17 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3FAA22459;
        Fri, 25 Oct 2019 13:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572011776;
        bh=wmDM3AG/qEIJGIcgSaYNHZAHKaejfltQf3svsNxsYKY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b3/PNdQ2q96mZ0C/6VCVZNH9xrNJAZ//TqG/OOv0D1IFFvFVO1xKR8/ij0x7xqssU
         IaPKofa6y7TZGRQgXngqYNZoWQ1eAiMW9SclCANY/Q4rf15ixd6aRQ1E76BlwPxzsu
         lRDwEIukzpSRF71VLP9DueD3/9wJQjZk0adDaD5w=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= 
        <amadeuszx.slawinski@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 06/37] ALSA: hda: Fix race between creating and refreshing sysfs entries
Date:   Fri, 25 Oct 2019 09:55:30 -0400
Message-Id: <20191025135603.25093-6-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191025135603.25093-1-sashal@kernel.org>
References: <20191025135603.25093-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>

[ Upstream commit ed180abba7f1fc3cf04ffa27767b1bcc8e8c842a ]

hda_widget_sysfs_reinit() can free underlying codec->widgets structure
on which widget_tree_create() operates. Add locking to prevent such
issues from happening.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=110382
Signed-off-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/hdaudio.h | 1 +
 sound/hda/hdac_device.c | 7 +++++++
 sound/hda/hdac_sysfs.c  | 3 +++
 3 files changed, 11 insertions(+)

diff --git a/include/sound/hdaudio.h b/include/sound/hdaudio.h
index cd1773d0e08f0..0c68783be26fc 100644
--- a/include/sound/hdaudio.h
+++ b/include/sound/hdaudio.h
@@ -82,6 +82,7 @@ struct hdac_device {
 	bool  link_power_control:1;
 
 	/* sysfs */
+	struct mutex widget_lock;
 	struct hdac_widget_tree *widgets;
 
 	/* regmap */
diff --git a/sound/hda/hdac_device.c b/sound/hda/hdac_device.c
index dbf02a3a8d2f2..020fbbbcf6f5c 100644
--- a/sound/hda/hdac_device.c
+++ b/sound/hda/hdac_device.c
@@ -55,6 +55,7 @@ int snd_hdac_device_init(struct hdac_device *codec, struct hdac_bus *bus,
 	codec->bus = bus;
 	codec->addr = addr;
 	codec->type = HDA_DEV_CORE;
+	mutex_init(&codec->widget_lock);
 	pm_runtime_set_active(&codec->dev);
 	pm_runtime_get_noresume(&codec->dev);
 	atomic_set(&codec->in_pm, 0);
@@ -141,7 +142,9 @@ int snd_hdac_device_register(struct hdac_device *codec)
 	err = device_add(&codec->dev);
 	if (err < 0)
 		return err;
+	mutex_lock(&codec->widget_lock);
 	err = hda_widget_sysfs_init(codec);
+	mutex_unlock(&codec->widget_lock);
 	if (err < 0) {
 		device_del(&codec->dev);
 		return err;
@@ -158,7 +161,9 @@ EXPORT_SYMBOL_GPL(snd_hdac_device_register);
 void snd_hdac_device_unregister(struct hdac_device *codec)
 {
 	if (device_is_registered(&codec->dev)) {
+		mutex_lock(&codec->widget_lock);
 		hda_widget_sysfs_exit(codec);
+		mutex_unlock(&codec->widget_lock);
 		device_del(&codec->dev);
 		snd_hdac_bus_remove_device(codec->bus, codec);
 	}
@@ -404,7 +409,9 @@ int snd_hdac_refresh_widgets(struct hdac_device *codec, bool sysfs)
 	}
 
 	if (sysfs) {
+		mutex_lock(&codec->widget_lock);
 		err = hda_widget_sysfs_reinit(codec, start_nid, nums);
+		mutex_unlock(&codec->widget_lock);
 		if (err < 0)
 			return err;
 	}
diff --git a/sound/hda/hdac_sysfs.c b/sound/hda/hdac_sysfs.c
index fb2aa344981e6..909d5ef1179c9 100644
--- a/sound/hda/hdac_sysfs.c
+++ b/sound/hda/hdac_sysfs.c
@@ -395,6 +395,7 @@ static int widget_tree_create(struct hdac_device *codec)
 	return 0;
 }
 
+/* call with codec->widget_lock held */
 int hda_widget_sysfs_init(struct hdac_device *codec)
 {
 	int err;
@@ -411,11 +412,13 @@ int hda_widget_sysfs_init(struct hdac_device *codec)
 	return 0;
 }
 
+/* call with codec->widget_lock held */
 void hda_widget_sysfs_exit(struct hdac_device *codec)
 {
 	widget_tree_free(codec);
 }
 
+/* call with codec->widget_lock held */
 int hda_widget_sysfs_reinit(struct hdac_device *codec,
 			    hda_nid_t start_nid, int num_nodes)
 {
-- 
2.20.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85FD856009
	for <lists+stable@lfdr.de>; Wed, 26 Jun 2019 05:47:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727561AbfFZDo2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 23:44:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:55818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727134AbfFZDo2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Jun 2019 23:44:28 -0400
Received: from sasha-vm.mshome.net (mobile-107-77-172-98.mobile.att.net [107.77.172.98])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C44B2168B;
        Wed, 26 Jun 2019 03:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561520667;
        bh=xR17BxfEYBNHnFrrfhHBkAgi/SaaOnl+TbEofMEfYbw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oyag4CL6+1ZLvPaA4F7z3IvxsgeGlkgcVvvPvKkz7/7WzUxIjbQZi0SjGOoM/ZUxw
         s8Eph5eWdz2IrOjgwJtDJhYDCZAjLCqU+MB8ICg8iFayig9nL9jcRAyhOgZKtu/9gH
         0/r8PojBrXWjojxCEhxZ5Som4t4qijpGW2I2YuJM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= 
        <amadeuszx.slawinski@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 19/34] ALSA: hdac: fix memory release for SST and SOF drivers
Date:   Tue, 25 Jun 2019 23:43:20 -0400
Message-Id: <20190626034335.23767-19-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190626034335.23767-1-sashal@kernel.org>
References: <20190626034335.23767-1-sashal@kernel.org>
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

[ Upstream commit 6d647b736a6b1cbf2f8deab0e6a94c34a6ea9d60 ]

During the integration of HDaudio support, we changed the way in which
we get hdev in snd_hdac_ext_bus_device_init() to use one preallocated
with devm_kzalloc(), however it still left kfree(hdev) in
snd_hdac_ext_bus_device_exit(). It leads to oopses when trying to
rmmod and modprobe. Fix it, by just removing kfree call.

SOF also uses some of the snd_hdac_ functions for HDAudio support but
allocated the memory with kzalloc. A matching fix is provided
separately to align all users of the snd_hdac_ library.

Fixes: 6298542fa33b ("ALSA: hdac: remove memory allocation from snd_hdac_ext_bus_device_init")
Reviewed-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/ext/hdac_ext_bus.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/sound/hda/ext/hdac_ext_bus.c b/sound/hda/ext/hdac_ext_bus.c
index 9c37d9af3023..08cc0ce3b924 100644
--- a/sound/hda/ext/hdac_ext_bus.c
+++ b/sound/hda/ext/hdac_ext_bus.c
@@ -173,7 +173,6 @@ EXPORT_SYMBOL_GPL(snd_hdac_ext_bus_device_init);
 void snd_hdac_ext_bus_device_exit(struct hdac_device *hdev)
 {
 	snd_hdac_device_exit(hdev);
-	kfree(hdev);
 }
 EXPORT_SYMBOL_GPL(snd_hdac_ext_bus_device_exit);
 
-- 
2.20.1


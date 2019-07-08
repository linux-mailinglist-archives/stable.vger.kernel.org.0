Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B3056229D
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:27:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731675AbfGHP1M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:27:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:55208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388989AbfGHP1L (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:27:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 04135204EC;
        Mon,  8 Jul 2019 15:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599630;
        bh=pr0lm044mwcPxHgiHra2h4YoUZv4LyNz3DCJMqQqOMY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gS5X856DcJKp1ZY6mCkqqZnp7nR1fhEse8aXQ1+95A9VyB8bAU4LU4pCNzKd604Fi
         hh4bwsokgyZIfoluI48TuihPgGYHM3oMqWPKaBC1IQ5mbVYLW1J6qjI737c1MBFhDO
         Rqz9gQhZA3snHmm1FP212YiTPv9fx3cFHW78X0aI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        =?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= 
        <amadeuszx.slawinski@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 24/90] ALSA: hdac: fix memory release for SST and SOF drivers
Date:   Mon,  8 Jul 2019 17:12:51 +0200
Message-Id: <20190708150523.848602664@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150521.829733162@linuxfoundation.org>
References: <20190708150521.829733162@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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




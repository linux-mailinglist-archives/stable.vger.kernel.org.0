Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD5C43CE1E1
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:12:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346799AbhGSP2N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:28:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:42740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346193AbhGSPZ3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:25:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 92BC1610D2;
        Mon, 19 Jul 2021 16:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710769;
        bh=CTqiA0nCJ1PAXq3EDSd5kAAfEFa48FGUGn2VsY6ulMs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OYNHDnXwIBC/8lj/f3ay91G4jN8ixKC3XzAZ1ymfQ2zccdPG4Kf2UnTJJ78WNXX/g
         jGUkYkyfUOWFAwoo4KNh///cbeZObQ/fviHufdNhOyZ4Ox7Y4eRgerg3B10Ml00ppj
         5tPtako1I0FYCvOg0qlk2IKBSHG43YpoPoLI45UQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 102/351] ALSA: control_led - fix initialization in the mode show callback
Date:   Mon, 19 Jul 2021 16:50:48 +0200
Message-Id: <20210719144947.874347548@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaroslav Kysela <perex@perex.cz>

[ Upstream commit e381a14c3e3a4e90e293d4eaa5a3ab8ae98b9973 ]

The str variable should be always initialized before use even if
the switch covers all cases. This is a minimalistic fix: Assign NULL,
the sprintf() may print '(null)' if something is corrupted.

Signed-off-by: Jaroslav Kysela <perex@perex.cz>
Link: https://lore.kernel.org/r/20210614071710.1786866-1-perex@perex.cz
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/control_led.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/core/control_led.c b/sound/core/control_led.c
index a90e31dbde61..ff7fd5e29551 100644
--- a/sound/core/control_led.c
+++ b/sound/core/control_led.c
@@ -397,7 +397,7 @@ static ssize_t show_mode(struct device *dev,
 			 struct device_attribute *attr, char *buf)
 {
 	struct snd_ctl_led *led = container_of(dev, struct snd_ctl_led, dev);
-	const char *str;
+	const char *str = NULL;
 
 	switch (led->mode) {
 	case MODE_FOLLOW_MUTE:	str = "follow-mute"; break;
-- 
2.30.2




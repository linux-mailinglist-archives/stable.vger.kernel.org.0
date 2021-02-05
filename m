Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 011EB31146A
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 23:07:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233113AbhBEWFr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 17:05:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:45256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232947AbhBEO5X (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 09:57:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 484DF65008;
        Fri,  5 Feb 2021 14:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612534233;
        bh=Xx1E0OToD1LOcnM9o3BZfsKZYtXxWkDt3JP/pCT2x8Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fS8XWQO6J09z2UPIHyqADeg7upzWyROAiVnWhUqaBnxe5wI1WYaf3Vi7+xnDSU0Wn
         E90pGu7cOmpH8vE8iQ6Jy4hEExbdlVIqJjdWEhr5GTLxwa2FB0R5nwPoYAH2OJI9js
         L2MMXqVV4zuPJ1GjzJxC+gmWPZqGUhoRM1QXK4xg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 29/57] ASoC: SOF: Intel: hda: Resume codec to do jack detection
Date:   Fri,  5 Feb 2021 15:06:55 +0100
Message-Id: <20210205140657.218213304@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210205140655.982616732@linuxfoundation.org>
References: <20210205140655.982616732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

[ Upstream commit bcd7059abc19e6ec5b2260dff6a008fb99c4eef9 ]

Instead of queueing jackpoll_work, runtime resume the codec to let it
use different jack detection methods based on jackpoll_interval.

This partially matches SOF driver's behavior with commit a6e7d0a4bdb0
("ALSA: hda: fix jack detection with Realtek codecs when in D3"), the
difference is SOF unconditionally resumes the codec.

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Link: https://lore.kernel.org/r/20210112181128.1229827-1-kai.heng.feng@canonical.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/hda-codec.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/sound/soc/sof/intel/hda-codec.c b/sound/soc/sof/intel/hda-codec.c
index 8b0ddc4b8227b..8d65004c917a1 100644
--- a/sound/soc/sof/intel/hda-codec.c
+++ b/sound/soc/sof/intel/hda-codec.c
@@ -93,8 +93,7 @@ void hda_codec_jack_check(struct snd_sof_dev *sdev)
 		 * has been recorded in STATESTS
 		 */
 		if (codec->jacktbl.used)
-			schedule_delayed_work(&codec->jackpoll_work,
-					      codec->jackpoll_interval);
+			pm_request_resume(&codec->core.dev);
 }
 #else
 void hda_codec_jack_wake_enable(struct snd_sof_dev *sdev) {}
-- 
2.27.0




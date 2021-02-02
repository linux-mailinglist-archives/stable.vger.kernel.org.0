Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6159030C548
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 17:19:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234966AbhBBQST (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 11:18:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:34978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235014AbhBBPHA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 10:07:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 73F0664DE1;
        Tue,  2 Feb 2021 15:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612278380;
        bh=chsoQVgOMFMKf0kMZfwuHu6gkK472skam4SXRssOxjg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Msq5V5KOil1YOd5y1SEB+Z57u8zhMrn3M0noU7iZn7FNmEVKEYxgSzDefdYqN+vQy
         H4dy9mFcgGkOix8T7Zabw1Gd0eRxhBLW7xs4pey8pAqFgTqNAhfphUVwS0RAK/9qoi
         GyMrdTMKMbaspajSdyJEi0G88yax1U9DP+LlRtzFIRlYeRN7zJr6N0mJFwlDh2pVaJ
         ilJPOqVXYWPYx94ZmMbkPSRlnZG99et4zKMuvIIiiWzLhca3Ac0k7NKxXuaft55x/M
         YHzB2ZfQxdcDI/G7Yl8Q+ITk9mdgKRajEsBhEc27KbiO0E7Tq8KuGZT1amCssaKNI/
         +W/O6Q+Vm/aHg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Schulman <james.schulman@cirrus.com>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, patches@opensource.cirrus.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.10 03/25] ASoC: wm_adsp: Fix control name parsing for multi-fw
Date:   Tue,  2 Feb 2021 10:05:53 -0500
Message-Id: <20210202150615.1864175-3-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210202150615.1864175-1-sashal@kernel.org>
References: <20210202150615.1864175-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Schulman <james.schulman@cirrus.com>

[ Upstream commit a8939f2e138e418c2b059056ff5b501eaf2eae54 ]

When switching between firmware types, the wrong control
can be selected when requesting control in kernel API.
Use the currently selected DSP firwmare type to select
the proper mixer control.

Signed-off-by: James Schulman <james.schulman@cirrus.com>
Acked-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20210115201105.14075-1-james.schulman@cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm_adsp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/codecs/wm_adsp.c b/sound/soc/codecs/wm_adsp.c
index dec8716aa8ef5..985b2dcecf138 100644
--- a/sound/soc/codecs/wm_adsp.c
+++ b/sound/soc/codecs/wm_adsp.c
@@ -2031,11 +2031,14 @@ static struct wm_coeff_ctl *wm_adsp_get_ctl(struct wm_adsp *dsp,
 					     unsigned int alg)
 {
 	struct wm_coeff_ctl *pos, *rslt = NULL;
+	const char *fw_txt = wm_adsp_fw_text[dsp->fw];
 
 	list_for_each_entry(pos, &dsp->ctl_list, list) {
 		if (!pos->subname)
 			continue;
 		if (strncmp(pos->subname, name, pos->subname_len) == 0 &&
+		    strncmp(pos->fw_name, fw_txt,
+			    SNDRV_CTL_ELEM_ID_NAME_MAXLEN) == 0 &&
 				pos->alg_region.alg == alg &&
 				pos->alg_region.type == type) {
 			rslt = pos;
-- 
2.27.0


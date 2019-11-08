Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE93DF478B
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 12:51:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390742AbfKHLrm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 06:47:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:36354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390369AbfKHLrl (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:47:41 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3B82D222CF;
        Fri,  8 Nov 2019 11:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213660;
        bh=fjra+qU2IHILUSaeMQ2IA40jQ4nA30zAozzoI8R+DHE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WTwe/oDafJkcf3JQ56atE2fsPEJqTJHfeNo/TeNx90z/HIQ4prdyMmvCX4kUE41Zq
         16EEnyfpEC8IA6+q3mCrMten8hoI9z0oh/qVNWB/eN5QNw6jO5V0lLcdmE+7ZRRUdK
         iojJRDxLPYQrHfjQVZNS2DSuZPajqNKG+qwktqzY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Colin Ian King <colin.king@canonical.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.4 15/44] ASoC: sgtl5000: avoid division by zero if lo_vag is zero
Date:   Fri,  8 Nov 2019 06:46:51 -0500
Message-Id: <20191108114721.15944-15-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108114721.15944-1-sashal@kernel.org>
References: <20191108114721.15944-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 9ab708aef61f5620113269a9d1bdb1543d1207d0 ]

In the case where lo_vag <= SGTL5000_LINE_OUT_GND_BASE, lo_vag
is set to zero and later vol_quot is computed by dividing by
lo_vag causing a division by zero error.  Fix this by avoiding
a zero division and set vol_quot to zero in this specific case
so that the lowest setting for i is correctly set.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/sgtl5000.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/sgtl5000.c b/sound/soc/codecs/sgtl5000.c
index 4808b70ec12cb..a3dd7030f629c 100644
--- a/sound/soc/codecs/sgtl5000.c
+++ b/sound/soc/codecs/sgtl5000.c
@@ -1415,7 +1415,7 @@ static int sgtl5000_set_power_regs(struct snd_soc_codec *codec)
 	 * Searching for a suitable index solving this formula:
 	 * idx = 40 * log10(vag_val / lo_cagcntrl) + 15
 	 */
-	vol_quot = (vag * 100) / lo_vag;
+	vol_quot = lo_vag ? (vag * 100) / lo_vag : 0;
 	lo_vol = 0;
 	for (i = 0; i < ARRAY_SIZE(vol_quot_table); i++) {
 		if (vol_quot >= vol_quot_table[i])
-- 
2.20.1


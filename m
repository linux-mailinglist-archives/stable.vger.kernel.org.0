Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92966107119
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:26:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728103AbfKVKeb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:34:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:59242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727425AbfKVKeb (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:34:31 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 679AD20708;
        Fri, 22 Nov 2019 10:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574418870;
        bh=fjra+qU2IHILUSaeMQ2IA40jQ4nA30zAozzoI8R+DHE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VY0VJuneOOZ08KF7amL9TNTg4f/dVKi/Lmho5vWM7EugDr+92s/Op/FdT9swm4Pv3
         Hz/BP1CZO3c01TV6M4oAcV/A8Z22XEmzpkV9+MORAliuB/q6CInkapB3Q7fWM14rSt
         ng5ShJ9MT870gFviddMpg2Gwfoqf/PBphrE7Bf+Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 026/159] ASoC: sgtl5000: avoid division by zero if lo_vag is zero
Date:   Fri, 22 Nov 2019 11:26:57 +0100
Message-Id: <20191122100724.490920259@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100704.194776704@linuxfoundation.org>
References: <20191122100704.194776704@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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




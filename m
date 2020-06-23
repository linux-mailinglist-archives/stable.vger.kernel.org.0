Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D31EE2065A1
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:51:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388613AbgFWUHb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:07:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:48100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388609AbgFWUH3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:07:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D09272064B;
        Tue, 23 Jun 2020 20:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592942849;
        bh=CaUoCBxYI9U26p0mgol98Ovh0DIucD7EMkmPGdlCuew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FktQ+Gy+t4yH+DLqk+PRR7DJcgd49mn/wtEFGixWmjj5HjhsR4vwbIneGoDo6kCdT
         1lPjARMiS5f/upWHzyMJcwpUrTpP7QdJCHuHskJ8enYZ0oO5s1JGeZvjqaS3S+ownF
         uyPc35LXZG+4hdr0ljbGd/AC4oFWktGBGgGMVnlM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yong Zhi <yong.zhi@intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 159/477] ASoC: max98373: reorder max98373_reset() in resume
Date:   Tue, 23 Jun 2020 21:52:36 +0200
Message-Id: <20200623195415.116201913@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yong Zhi <yong.zhi@intel.com>

[ Upstream commit 1a446873d7dd3a450f685928ce7f1907bde4583d ]

During S3 test, the following error was observed:

[ 726.174237] i2c_designware i2c_designware.0: platform_pm_resume+0x0/0x3d returned 0 after 0 usecs
[ 726.184187] max98373 i2c-MX98373:00: calling max98373_resume+0x0/0x30 [snd_soc_max98373] @ 12698, parent: i2c-11
[ 726.195589] max98373 i2c-MX98373:00: Reset command failed. (ret:-16)

When calling regmap_update_bits(), since map->reg_update_bits is NULL,
_regmap_read() is entered with the following logic:

	if (!map->cache_bypass) {
		ret = regcache_read(map, reg, val);
		if (ret == 0)
			return 0;
	}

	if (map->cache_only)
		return -EBUSY;

regcache_read() hits -EINVAL because MAX98373_R2000_SW_RESET is volatile,
as map->cache_only is set by codec suspend, thus -EBUSY is returned.
Fix by moving max98373_reset() after cache_only set to false in max98373_resume().

Signed-off-by: Yong Zhi <yong.zhi@intel.com>
Link: https://lore.kernel.org/r/1588376661-29799-1-git-send-email-yong.zhi@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/max98373.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/max98373.c b/sound/soc/codecs/max98373.c
index cae1def8902dd..96718e3a1ad0e 100644
--- a/sound/soc/codecs/max98373.c
+++ b/sound/soc/codecs/max98373.c
@@ -850,8 +850,8 @@ static int max98373_resume(struct device *dev)
 {
 	struct max98373_priv *max98373 = dev_get_drvdata(dev);
 
-	max98373_reset(max98373, dev);
 	regcache_cache_only(max98373->regmap, false);
+	max98373_reset(max98373, dev);
 	regcache_sync(max98373->regmap);
 	return 0;
 }
-- 
2.25.1




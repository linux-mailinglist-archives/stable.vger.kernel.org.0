Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B2E12C9B63
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:16:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389008AbgLAJHp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:07:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:44680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388399AbgLAJHn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:07:43 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 62FD2206CA;
        Tue,  1 Dec 2020 09:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813617;
        bh=8Mwmyg9MYFVAIzPRG0Kg3z1bONGvIvMTCc7BXhkFPrs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dqZAoVH28m3QyhWttiu7/i4X001JIbx0j2UrnOpf/S56S1exMTnx1+W/Sn7oN1FVO
         e69uXXtGgMb0cNnRXA2yQYqvIeqGgQHYN1bB77jp0JBnCBM3moWJVYDh2s2n35UtbS
         RTg7FagP7SD6AwPco0TZRfuPkRQucA8dTb/XXbxc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "alsa-devel@alsa-project.org, broonie@kernel.org, tiwai@suse.com,
        pierre-louis.bossart@linux.intel.com, mateusz.gorski@linux.intel.com,
        Cezary Rojewski" <cezary.rojewski@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Cezary Rojewski <cezary.rojewski@intel.com>
Subject: [PATCH 5.4 93/98] ASoC: Intel: Skylake: Enable codec wakeup during chip init
Date:   Tue,  1 Dec 2020 09:54:10 +0100
Message-Id: <20201201084659.624758613@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084652.827177826@linuxfoundation.org>
References: <20201201084652.827177826@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cezary Rojewski <cezary.rojewski@intel.com>

commit e603f11d5df8997d104ab405ff27640b90baffaa upstream.

Follow the recommendation set by hda_intel.c and enable HDMI/DP codec
wakeup during bus initialization procedure. Disable wakeup once init
completes.

Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20200305145314.32579-4-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: <stable@vger.kernel.org> # 5.4.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/intel/skylake/skl.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/soc/intel/skylake/skl.c
+++ b/sound/soc/intel/skylake/skl.c
@@ -129,6 +129,7 @@ static int skl_init_chip(struct hdac_bus
 	struct hdac_ext_link *hlink;
 	int ret;
 
+	snd_hdac_set_codec_wakeup(bus, true);
 	skl_enable_miscbdcge(bus->dev, false);
 	ret = snd_hdac_bus_init_chip(bus, full_reset);
 
@@ -137,6 +138,7 @@ static int skl_init_chip(struct hdac_bus
 		writel(0, hlink->ml_addr + AZX_REG_ML_LOSIDV);
 
 	skl_enable_miscbdcge(bus->dev, true);
+	snd_hdac_set_codec_wakeup(bus, false);
 
 	return ret;
 }



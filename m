Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFAE5272D21
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:37:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729094AbgIUQhj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:37:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:38242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729091AbgIUQhj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:37:39 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D45C6206B7;
        Mon, 21 Sep 2020 16:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706258;
        bh=0AsOqjbBkPZykoJS/EiWyx0FA+xrH0LXRfn/2dLrtzc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EaWXP88RKv/xtjuAWXKpu+EUjPGipgLE62AIqIVnqDACbMKlAQ2ncdzcrj+74PkHf
         SIKgkaFCnRyKTppSIbq5hT0k0q4Yqxb37HPvicoChf9EnrHjxqZqz2FFhVPBgYaEIh
         B8ls6whm8r4blUP8/I1P3IWDORidoofmhe56U2qs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rander Wang <rander.wang@intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 21/94] ALSA: hda: fix a runtime pm issue in SOF when integrated GPU is disabled
Date:   Mon, 21 Sep 2020 18:27:08 +0200
Message-Id: <20200921162036.518984044@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162035.541285330@linuxfoundation.org>
References: <20200921162035.541285330@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rander Wang <rander.wang@intel.com>

[ Upstream commit 13774d81f38538c5fa2924bdcdfa509155480fa6 ]

In snd_hdac_device_init pm_runtime_set_active is called to
increase child_count in parent device. But when it is failed
to build connection with GPU for one case that integrated
graphic gpu is disabled, snd_hdac_ext_bus_device_exit will be
invoked to clean up a HD-audio extended codec base device. At
this time the child_count of parent is not decreased, which
makes parent device can't get suspended.

This patch calls pm_runtime_set_suspended to decrease child_count
in parent device in snd_hdac_device_exit to match with
snd_hdac_device_init. pm_runtime_set_suspended can make sure that
it will not decrease child_count if the device is already suspended.

Signed-off-by: Rander Wang <rander.wang@intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
Signed-off-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Link: https://lore.kernel.org/r/20200902154218.1440441-1-kai.vehmanen@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/hdac_device.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/hda/hdac_device.c b/sound/hda/hdac_device.c
index 19deb306facb7..4a843eb7cc940 100644
--- a/sound/hda/hdac_device.c
+++ b/sound/hda/hdac_device.c
@@ -123,6 +123,8 @@ EXPORT_SYMBOL_GPL(snd_hdac_device_init);
 void snd_hdac_device_exit(struct hdac_device *codec)
 {
 	pm_runtime_put_noidle(&codec->dev);
+	/* keep balance of runtime PM child_count in parent device */
+	pm_runtime_set_suspended(&codec->dev);
 	snd_hdac_bus_remove_device(codec->bus, codec);
 	kfree(codec->vendor_name);
 	kfree(codec->chip_name);
-- 
2.25.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B528363E003
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:52:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231516AbiK3Sw4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:52:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231514AbiK3Swl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:52:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C0B8267A
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:52:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6115961D4F
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:52:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44E51C433C1;
        Wed, 30 Nov 2022 18:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669834356;
        bh=OS7k5IHaaA7nPZ1aTv4XgPqO+LcHs92Sxw1hXzbGk/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tD9xVXASPKGZs7txPtl4XR1B8ON7MV2DQSd8XhXbjZZNm/xbGwXnEOZeIG7hO90zR
         UxFTBLGypiXAClLRa58NtpdYOMdDPsMJEUWONO0dxA9akmJzi9diShxNnRmZi0fBVs
         rlcgMArr19aqm+13MMUybZCOAQyBQQaKSPmdIA80=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.0 223/289] ASoC: SOF: Intel: hda-codec: fix possible memory leak in hda_codec_device_init()
Date:   Wed, 30 Nov 2022 19:23:28 +0100
Message-Id: <20221130180549.172387095@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

commit e9441675edc1bb8dbfadacf68aafacca60d65a25 upstream.

If snd_hdac_device_register() fails, 'codec' and name allocated in
dev_set_name() called in snd_hdac_device_init() are leaked. Fix this
by calling put_device(), so they can be freed in snd_hda_codec_dev_release()
and kobject_cleanup().

Fixes: 829c67319806 ("ASoC: SOF: Intel: Introduce HDA codec init and exit routines")
Fixes: dfe66a18780d ("ALSA: hdac_ext: add extended HDA bus")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Link: https://lore.kernel.org/r/20221020110157.1450191-1-yangyingliang@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/intel/hda-codec.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/sound/soc/sof/intel/hda-codec.c
+++ b/sound/soc/sof/intel/hda-codec.c
@@ -109,11 +109,6 @@ EXPORT_SYMBOL_NS(hda_codec_jack_check, S
 #define is_generic_config(x)	0
 #endif
 
-static void hda_codec_device_exit(struct device *dev)
-{
-	snd_hdac_device_exit(dev_to_hdac_dev(dev));
-}
-
 static struct hda_codec *hda_codec_device_init(struct hdac_bus *bus, int addr, int type)
 {
 	struct hda_codec *codec;
@@ -126,12 +121,11 @@ static struct hda_codec *hda_codec_devic
 	}
 
 	codec->core.type = type;
-	codec->core.dev.release = hda_codec_device_exit;
 
 	ret = snd_hdac_device_register(&codec->core);
 	if (ret) {
 		dev_err(bus->dev, "failed to register hdac device\n");
-		snd_hdac_device_exit(&codec->core);
+		put_device(&codec->core.dev);
 		return ERR_PTR(ret);
 	}
 



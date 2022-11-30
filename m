Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C4C463E002
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:52:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231559AbiK3Sw4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:52:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231549AbiK3Swk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:52:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77F1AF11
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:52:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2D0D1B81CA6
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:52:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 658E7C433C1;
        Wed, 30 Nov 2022 18:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669834353;
        bh=wAM2RrphKK6hrGOiSZ7thggmjnRwAkLm4NS99SqovzY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2eUr2nH7roLZDu3+D+YC5i202diO0kJj1G8l8SN/EAxSpSGpoVAJaLLVOQHkR6T0M
         YFxsub2e9IP/HK3kf3rxO8HykQNVxx6XgWJdrCt4e2yo1BzAqYbEY+uAF5GP4+4Eiv
         I6U3lRsigLn9FVd0Mh89eCCBo8Xf5xXATwZ/JqiA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.0 222/289] ASoC: Intel: Skylake: fix possible memory leak in skl_codec_device_init()
Date:   Wed, 30 Nov 2022 19:23:27 +0100
Message-Id: <20221130180549.150405726@linuxfoundation.org>
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

commit 0e213813df02da048ffd22a2c4fac041768ca327 upstream.

If snd_hdac_device_register() fails, 'codec' and name allocated in
dev_set_name() called in snd_hdac_device_init() are leaked. Fix this
by calling put_device(), so they can be freed in snd_hda_codec_dev_release()
and kobject_cleanup().

Fixes: e4746d94d00c ("ASoC: Intel: Skylake: Introduce HDA codec init and exit routines")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Suggested-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://lore.kernel.org/r/20221020105937.1448951-1-yangyingliang@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/intel/skylake/skl.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/sound/soc/intel/skylake/skl.c
+++ b/sound/soc/intel/skylake/skl.c
@@ -689,11 +689,6 @@ static void load_codec_module(struct hda
 
 #endif /* CONFIG_SND_SOC_INTEL_SKYLAKE_HDAUDIO_CODEC */
 
-static void skl_codec_device_exit(struct device *dev)
-{
-	snd_hdac_device_exit(dev_to_hdac_dev(dev));
-}
-
 static struct hda_codec *skl_codec_device_init(struct hdac_bus *bus, int addr)
 {
 	struct hda_codec *codec;
@@ -706,12 +701,11 @@ static struct hda_codec *skl_codec_devic
 	}
 
 	codec->core.type = HDA_DEV_ASOC;
-	codec->core.dev.release = skl_codec_device_exit;
 
 	ret = snd_hdac_device_register(&codec->core);
 	if (ret) {
 		dev_err(bus->dev, "failed to register hdac device\n");
-		snd_hdac_device_exit(&codec->core);
+		put_device(&codec->core.dev);
 		return ERR_PTR(ret);
 	}
 



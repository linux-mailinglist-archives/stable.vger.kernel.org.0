Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 881C160FDCF
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 18:59:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236723AbiJ0Q70 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 12:59:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236847AbiJ0Q7S (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 12:59:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B3EF17F658
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 09:59:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F108623E8
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 16:59:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3A2BC433C1;
        Thu, 27 Oct 2022 16:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666889957;
        bh=9Q2BxoC9xi7BZB0hAPPy7aueUeTaepaqWecV801aMbM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=diL1Gb/mfZMYr4+9hZHA7/x57FLspgJWlO1CGJ7xLfBjYyY8+L6tg8DwEwXw5LifR
         ZCHxQGKplHl+8bvQKYyU62fbNRVnKtiWPQUTEGed+0X3dWFE9yZl3luFq4b8a8JURL
         0i75gLFS8vTMszm4I78id889DOHeu43phvkc0KHY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Javier Martinez Canillas <javierm@redhat.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 32/94] drm/vc4: Add module dependency on hdmi-codec
Date:   Thu, 27 Oct 2022 18:54:34 +0200
Message-Id: <20221027165058.399279812@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165057.208202132@linuxfoundation.org>
References: <20221027165057.208202132@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxime Ripard <maxime@cerno.tech>

[ Upstream commit d1c0b7de4dfa5505cf7a1d6220aa72aace4435d0 ]

The VC4 HDMI controller driver relies on the HDMI codec ASoC driver. In
order to set it up properly, in vc4_hdmi_audio_init(), our HDMI driver
will register a device matching the HDMI codec driver, and then register
an ASoC card using that codec.

However, if vc4 is compiled as a module, chances are that the hdmi-codec
driver will be too. In such a case, the module loader will have a very
narrow window to load the module between the device registration and the
card registration.

If it fails to load the module in time, the card registration will fail
with EPROBE_DEFER, and we'll abort the audio initialisation,
unregistering the HDMI codec device in the process.

The next time the bind callback will be run, it's likely that we end up
missing that window again, effectively preventing vc4 to probe entirely.

In order to prevent this, we can create a soft dependency of the vc4
driver on the HDMI codec one so that we're sure the HDMI codec will be
loaded before the VC4 module is, and thus we'll never end up in the
previous situation.

Fixes: 91e99e113929 ("drm/vc4: hdmi: Register HDMI codec")
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://patchwork.freedesktop.org/patch/msgid/20220902144111.3424560-1-maxime@cerno.tech
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_drv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/vc4/vc4_drv.c b/drivers/gpu/drm/vc4/vc4_drv.c
index 6b8dfa1e7650..c186ace7f83b 100644
--- a/drivers/gpu/drm/vc4/vc4_drv.c
+++ b/drivers/gpu/drm/vc4/vc4_drv.c
@@ -490,6 +490,7 @@ module_init(vc4_drm_register);
 module_exit(vc4_drm_unregister);
 
 MODULE_ALIAS("platform:vc4-drm");
+MODULE_SOFTDEP("pre: snd-soc-hdmi-codec");
 MODULE_DESCRIPTION("Broadcom VC4 DRM Driver");
 MODULE_AUTHOR("Eric Anholt <eric@anholt.net>");
 MODULE_LICENSE("GPL v2");
-- 
2.35.1




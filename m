Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6A385C0344
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 18:01:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232273AbiIUQBi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 12:01:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232741AbiIUQAX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 12:00:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5854A94138;
        Wed, 21 Sep 2022 08:53:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 391AFB830C1;
        Wed, 21 Sep 2022 15:52:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80B0FC43143;
        Wed, 21 Sep 2022 15:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663775533;
        bh=ytg24SidaYSBP4H8Utx5FohGolk1zys/IBm03XeRul8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YmRqXEPqDM2a9xMTCJkEsn/ZcaXm98tXr2IMEMcL+Fbi+lTJYooz11f0G3/vj/xuH
         xwo/a0KUpwK0whi/DeutvzMbaJH2yvJVTe3F9vkWxB6zp+vrb9JRzjKmBYQ0pACWa+
         5R92UxP6XOtla/KZL413m6rkXDfRNGJNVQacwtmc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 39/39] ALSA: hda/sigmatel: Fix unused variable warning for beep power change
Date:   Wed, 21 Sep 2022 17:46:44 +0200
Message-Id: <20220921153646.980428296@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220921153645.663680057@linuxfoundation.org>
References: <20220921153645.663680057@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

commit 51bdc8bb82525cd70feb92279c8b7660ad7948dd upstream.

The newly added stac_check_power_status() caused a compile warning
when CONFIG_SND_HDA_INPUT_BEEP is disabled.  Fix it.

Fixes: 414d38ba8710 ("ALSA: hda/sigmatel: Keep power up while beep is enabled")
Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/r/20220905130630.2845-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_sigmatel.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -4451,7 +4451,9 @@ static int stac_suspend(struct hda_codec
 
 static int stac_check_power_status(struct hda_codec *codec, hda_nid_t nid)
 {
+#ifdef CONFIG_SND_HDA_INPUT_BEEP
 	struct sigmatel_spec *spec = codec->spec;
+#endif
 	int ret = snd_hda_gen_check_power_status(codec, nid);
 
 #ifdef CONFIG_SND_HDA_INPUT_BEEP



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 442804BCF32
	for <lists+stable@lfdr.de>; Sun, 20 Feb 2022 15:58:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235011AbiBTOyI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 20 Feb 2022 09:54:08 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230108AbiBTOyH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 20 Feb 2022 09:54:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC06845AD8
        for <stable@vger.kernel.org>; Sun, 20 Feb 2022 06:53:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7378EB80D44
        for <stable@vger.kernel.org>; Sun, 20 Feb 2022 14:53:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A065BC340E8;
        Sun, 20 Feb 2022 14:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645368824;
        bh=rqkCyMVWtgNQyFXnyVB31y9DXzQkyiUyo2zqtX1hgI0=;
        h=Subject:To:Cc:From:Date:From;
        b=iNiuwgiO9EL3pjQ+DYz2owAEOkYEH8Re6zljH4RaHiyBlIoOxzXhUeXnr8qFHWHjA
         tKtguBLKmVSBiQI3wIBX9L6QJZFyxCjIElvt5Z7MrjAijEdMS5YxANWEYDb9+SxqwW
         XWd3+L6Gu4Av16l9Bi1DWXDfZrzZD6CuivfB4cYE=
Subject: FAILED: patch "[PATCH] ASoC: wm_adsp: Correct control read size when parsing" failed to apply to 5.16-stable tree
To:     ckeepax@opensource.cirrus.com, broonie@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 20 Feb 2022 15:53:41 +0100
Message-ID: <164536882154112@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.16-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a887f9c7a4d37a8e874ba8415a42a92a1b5139fc Mon Sep 17 00:00:00 2001
From: Charles Keepax <ckeepax@opensource.cirrus.com>
Date: Thu, 10 Feb 2022 17:20:51 +0000
Subject: [PATCH] ASoC: wm_adsp: Correct control read size when parsing
 compressed buffer

When parsing the compressed stream the whole buffer descriptor is
now read in a single cs_dsp_coeff_read_ctrl; on older firmwares
this descriptor is just 4 bytes but on more modern firmwares it is
24 bytes. The current code reads the full 24 bytes regardless, this
was working but reading junk for the last 20 bytes. However commit
f444da38ac92 ("firmware: cs_dsp: Add offset to cs_dsp read/write")
added a size check into cs_dsp_coeff_read_ctrl, causing the older
firmwares to now return an error.

Update the code to only read the amount of data appropriate for
the firmware loaded.

Fixes: 04ae08596737 ("ASoC: wm_adsp: Switch to using wm_coeff_read_ctrl for compressed buffers")
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20220210172053.22782-1-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>

diff --git a/sound/soc/codecs/wm_adsp.c b/sound/soc/codecs/wm_adsp.c
index f3672e3d1703..0582585236a2 100644
--- a/sound/soc/codecs/wm_adsp.c
+++ b/sound/soc/codecs/wm_adsp.c
@@ -1441,7 +1441,8 @@ static int wm_adsp_buffer_parse_coeff(struct cs_dsp_coeff_ctl *cs_ctl)
 	int ret, i;
 
 	for (i = 0; i < 5; ++i) {
-		ret = cs_dsp_coeff_read_ctrl(cs_ctl, 0, &coeff_v1, sizeof(coeff_v1));
+		ret = cs_dsp_coeff_read_ctrl(cs_ctl, 0, &coeff_v1,
+					     min(cs_ctl->len, sizeof(coeff_v1)));
 		if (ret < 0)
 			return ret;
 


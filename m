Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7ADCF66CC40
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:23:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234573AbjAPRXs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:23:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234547AbjAPRWp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:22:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42F9934C28
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 09:00:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F0AFDB8109E
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 17:00:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 524C0C433D2;
        Mon, 16 Jan 2023 17:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673888448;
        bh=u4hQSl1MZPh30s4tqOQFQFXwdNT+k+qhB3VVUnxHzy8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ARxfZd76F97atDIEb5RrK4vyEPe3hEINL4EACvkL2ehb4UkE2dmxlhvGu9puVnTRy
         XQU2NouYtO+W6VGiRCMjzTqfSxTVR9OajyfGzwh/46TCOM9B2jhu35WsZXti7PtM64
         beB5u9XGz/hPDBtWPAc3gtoMTAZfML4BdjumHNBg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 4.14 010/338] ASoC: ops: Correct bounds check for second channel on SX controls
Date:   Mon, 16 Jan 2023 16:48:03 +0100
Message-Id: <20230116154821.165614975@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
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

From: Charles Keepax <ckeepax@opensource.cirrus.com>

commit f33bcc506050f89433a52a3052054d4ebd37b1c1 upstream.

Currently the check against the max value for the control is being
applied after the value has had the minimum applied and been masked. But
the max value simply indicates the number of volume levels on an SX
control, and as such should just be applied on the raw value.

Fixes: 97eea946b939 ("ASoC: ops: Check bounds for second channel in snd_soc_put_volsw_sx()")
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20221125162348.1288005-1-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/soc-ops.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/sound/soc/soc-ops.c
+++ b/sound/soc/soc-ops.c
@@ -463,14 +463,15 @@ int snd_soc_put_volsw_sx(struct snd_kcon
 		return err;
 
 	if (snd_soc_volsw_is_stereo(mc)) {
-		val_mask = mask << rshift;
-		val2 = (ucontrol->value.integer.value[1] + min) & mask;
+		val2 = ucontrol->value.integer.value[1];
 
 		if (mc->platform_max && val2 > mc->platform_max)
 			return -EINVAL;
 		if (val2 > max)
 			return -EINVAL;
 
+		val_mask = mask << rshift;
+		val2 = (val2 + min) & mask;
 		val2 = val2 << rshift;
 
 		err = snd_soc_component_update_bits(component, reg2, val_mask,



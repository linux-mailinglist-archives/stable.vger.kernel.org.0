Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 930AC4BE443
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:58:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352303AbiBUKAo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 05:00:44 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353531AbiBUJ5b (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:57:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DECA913D02;
        Mon, 21 Feb 2022 01:26:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 79A8860F8C;
        Mon, 21 Feb 2022 09:26:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F3D3C340E9;
        Mon, 21 Feb 2022 09:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645435599;
        bh=s2FmeLYg45s5fZKmyXXZ8eeWA2DUYJTfH1h+F9G1sIs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hBY1ZGrXmknCi4OcgzU5P8dQemFGSLCXoRnUlVxk7yQz8VwcoNF3/4Fmpeu7BSLFo
         QIYaHeFlMPP6BNI85oMuwym9SZm0KYSFar8h0L5x4Pdug5efVi6Sf4IDASF410NpYo
         N5nm4n17H0EYs/R3mYBQcU6RzSqSbZqZBR2IAxVM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.16 188/227] ASoC: wm_adsp: Correct control read size when parsing compressed buffer
Date:   Mon, 21 Feb 2022 09:50:07 +0100
Message-Id: <20220221084941.068129878@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084934.836145070@linuxfoundation.org>
References: <20220221084934.836145070@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Charles Keepax <ckeepax@opensource.cirrus.com>

commit a887f9c7a4d37a8e874ba8415a42a92a1b5139fc upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/wm_adsp.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/sound/soc/codecs/wm_adsp.c
+++ b/sound/soc/codecs/wm_adsp.c
@@ -1448,7 +1448,8 @@ static int wm_adsp_buffer_parse_coeff(st
 	int ret, i;
 
 	for (i = 0; i < 5; ++i) {
-		ret = cs_dsp_coeff_read_ctrl(cs_ctl, &coeff_v1, sizeof(coeff_v1));
+		ret = cs_dsp_coeff_read_ctrl(cs_ctl, &coeff_v1,
+					     min(cs_ctl->len, sizeof(coeff_v1)));
 		if (ret < 0)
 			return ret;
 



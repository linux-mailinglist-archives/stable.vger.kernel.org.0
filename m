Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9AFF4ABD95
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 13:00:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388794AbiBGLpK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:45:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384709AbiBGL3i (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:29:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB891C0401CA;
        Mon,  7 Feb 2022 03:28:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7784460AB2;
        Mon,  7 Feb 2022 11:28:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5220DC004E1;
        Mon,  7 Feb 2022 11:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233283;
        bh=u3/akX/dz9ZO7Yp9P/0+QWrmMr/uEK5Ppvyr2pAXRic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cRFmOPzv10hMTRT6BL48zRmuMEEDXH4g3h5ozIn8i5dK2B5rdCUw1+t3fdGt+aPVb
         oYuMDz6FCYXcLgduts/z8TuPUtzFYy1BF24mrgzKW4zPEG/zduEbFspwG3d1Ln0/qR
         UQSvvnU8aRBEc6mREIa5BEmbzhmm0mTtOLp5Dino=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.15 074/110] ASoC: cpcap: Check for NULL pointer after calling of_get_child_by_name
Date:   Mon,  7 Feb 2022 12:06:47 +0100
Message-Id: <20220207103804.801499999@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103802.280120990@linuxfoundation.org>
References: <20220207103802.280120990@linuxfoundation.org>
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

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

commit f7a6021aaf02088870559f82fc13c58cda7fea1a upstream.

If the device does not exist, of_get_child_by_name() will return NULL
pointer.
And devm_snd_soc_register_component() does not check it.
Also, I have noticed that cpcap_codec_driver has not been used yet.
Therefore, it should be better to check it in order to avoid the future
dereference of the NULL pointer.

Fixes: f6cdf2d3445d ("ASoC: cpcap: new codec")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Link: https://lore.kernel.org/r/20220111025048.524134-1-jiasheng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/cpcap.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/soc/codecs/cpcap.c
+++ b/sound/soc/codecs/cpcap.c
@@ -1667,6 +1667,8 @@ static int cpcap_codec_probe(struct plat
 {
 	struct device_node *codec_node =
 		of_get_child_by_name(pdev->dev.parent->of_node, "audio-codec");
+	if (!codec_node)
+		return -ENODEV;
 
 	pdev->dev.of_node = codec_node;
 



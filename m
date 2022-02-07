Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 169424ABB8A
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:38:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376792AbiBGL3L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:29:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382702AbiBGLUo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:20:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63CB3C03E903;
        Mon,  7 Feb 2022 03:20:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6593461468;
        Mon,  7 Feb 2022 11:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47BACC340F0;
        Mon,  7 Feb 2022 11:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644232817;
        bh=p/9Eah5nhtugNJaw6mXassHwYlybfO93r0QZ0+5hfdo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jtqrvA1LFzS/DFL6sNHGarqqIGZJoQAQH1Xww+tzlXd5pB9oGZictZ3MIKFI8MNVF
         yaz9pek2fjlVC7KYkYKt4YCR/UUZOTHagFHwXyU01mi33sATuUke/RXwVNBBMdybAK
         JZHMiLsClMZ7rwo6iONv2M4cI7q78EygD/FhzCJ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.4 34/44] ASoC: cpcap: Check for NULL pointer after calling of_get_child_by_name
Date:   Mon,  7 Feb 2022 12:06:50 +0100
Message-Id: <20220207103754.262182914@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103753.155627314@linuxfoundation.org>
References: <20220207103753.155627314@linuxfoundation.org>
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
@@ -1541,6 +1541,8 @@ static int cpcap_codec_probe(struct plat
 {
 	struct device_node *codec_node =
 		of_get_child_by_name(pdev->dev.parent->of_node, "audio-codec");
+	if (!codec_node)
+		return -ENODEV;
 
 	pdev->dev.of_node = codec_node;
 



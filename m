Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 127C64E862B
	for <lists+stable@lfdr.de>; Sun, 27 Mar 2022 08:01:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235286AbiC0GDI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Mar 2022 02:03:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234613AbiC0GDG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Mar 2022 02:03:06 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47A4BD7D;
        Sat, 26 Mar 2022 23:01:28 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id h19so8849149pfv.1;
        Sat, 26 Mar 2022 23:01:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=6MKU8QUY1L2KLGR2DZj/SIjJO3VMsnbAwKdZVAvU38Q=;
        b=HeE1ltv1IyIhmk58qv1eyAf9pMH6GYBlfgasv7WjsmP493BjLvnvxh/Qr//YKmoprk
         dJHLY8dBuVcvUCQ5SbyTBHuU+TIKCJSKxkQVEmSF1cILKZtRrlQpUhkODPHOBWJw+n63
         jVf6yobuNTTtS/R/f0DJY1oZ5eAe+zzEKMB1UH1dRXBHojFqGb1VBXkIsMUaR9lKyukF
         rRa9rePYYGMCGVmKvqIdprDRs7zv0sMsUxRbb3jFMA0BUuUQcinalbpn+jyIJLg06fKH
         8E3Esd1XUqeAXkg6otjwhKUrf9AXzzdoOF77iBu+zix4sOTadvjTiQVXEjxowy2YkzNE
         hgQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=6MKU8QUY1L2KLGR2DZj/SIjJO3VMsnbAwKdZVAvU38Q=;
        b=G1AqvCQiNjLwO+yRry4Ia9fpQC8BF4ZeilhfspKXOrsPFfcLCpBDhQfLadkwa7QBgF
         4N13BdVVNlA+ZgPW4N3Z8KCR2VyWzCylSscwi/zGgENQ/F7rrmoQQhgPAV1M2/lU5WLp
         93JJTuHnHJD2BFChUVtYgvXMGbP9QclMGAJ2eiuSiLNUIrcmlhbnd9tOizsXhahjLmYY
         7MKtjYgKcspkEHmvt1O+Nt4z4mjU7hKYYr+fLcyh533CXWohp+55RofPIsT/Z41VEe4n
         efYwwFlMmGxe1EeNwdYanNI4ew8rFNj0NqEh/kUVYo+BSHIpuwf74rtNsEQ9te8712yN
         TA2A==
X-Gm-Message-State: AOAM530FfpqXf6yB3gd5VQk7eGiJacirxVLDYaSBCW9hOm+ad8eYg85Z
        JH6uQZMYg5l6weEZxz7d7jc=
X-Google-Smtp-Source: ABdhPJyePl/vuwUdTIAiOaZRsyJHZjTnbNl7woqQl9dyqCIcpM8g3SZVs/4/ckj/KQcrkLMUvw3Hkg==
X-Received: by 2002:a65:5a0d:0:b0:381:3c1e:9aca with SMTP id y13-20020a655a0d000000b003813c1e9acamr5741001pgs.562.1648360887480;
        Sat, 26 Mar 2022 23:01:27 -0700 (PDT)
Received: from localhost.localdomain ([115.220.243.108])
        by smtp.googlemail.com with ESMTPSA id ij17-20020a17090af81100b001c67c964d93sm15834043pjb.2.2022.03.26.23.01.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Mar 2022 23:01:27 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     vaibhav.sr@gmail.com
Cc:     mgreer@animalcreek.com, johan@kernel.org, elder@kernel.org,
        gregkh@linuxfoundation.org, greybus-dev@lists.linaro.org,
        linux-staging@lists.linux.dev, linux-kernel@vger.kernel.org,
        Xiaomeng Tong <xiam0nd.tong@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] greybus: audio_codec: fix three missing initializers for data
Date:   Sun, 27 Mar 2022 14:01:20 +0800
Message-Id: <20220327060120.4316-1-xiam0nd.tong@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

These three bugs are here:
	struct gbaudio_data_connection *data;

If the list '&codec->module_list' is empty then the 'data' will
keep unchanged. However, the 'data' is not initialized and filled
with trash value. As a result, if the value is not NULL, the check
'if (!data) {' will always be false and never exit expectly.

To fix these bug, just initialize 'data' with NULL.

Cc: stable@vger.kernel.org
Fixes: 6dd67645f22cf ("greybus: audio: Use single codec driver registration")
Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
---
 drivers/staging/greybus/audio_codec.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/greybus/audio_codec.c b/drivers/staging/greybus/audio_codec.c
index b589cf6b1d03..939e05af4dcf 100644
--- a/drivers/staging/greybus/audio_codec.c
+++ b/drivers/staging/greybus/audio_codec.c
@@ -397,7 +397,7 @@ static int gbcodec_hw_params(struct snd_pcm_substream *substream,
 	u8 sig_bits, channels;
 	u32 format, rate;
 	struct gbaudio_module_info *module;
-	struct gbaudio_data_connection *data;
+	struct gbaudio_data_connection *data = NULL;
 	struct gb_bundle *bundle;
 	struct gbaudio_codec_info *codec = dev_get_drvdata(dai->dev);
 	struct gbaudio_stream_params *params;
@@ -498,7 +498,7 @@ static int gbcodec_prepare(struct snd_pcm_substream *substream,
 {
 	int ret;
 	struct gbaudio_module_info *module;
-	struct gbaudio_data_connection *data;
+	struct gbaudio_data_connection *data = NULL;
 	struct gb_bundle *bundle;
 	struct gbaudio_codec_info *codec = dev_get_drvdata(dai->dev);
 	struct gbaudio_stream_params *params;
@@ -562,7 +562,7 @@ static int gbcodec_prepare(struct snd_pcm_substream *substream,
 static int gbcodec_mute_stream(struct snd_soc_dai *dai, int mute, int stream)
 {
 	int ret;
-	struct gbaudio_data_connection *data;
+	struct gbaudio_data_connection *data = NULL;
 	struct gbaudio_module_info *module;
 	struct gb_bundle *bundle;
 	struct gbaudio_codec_info *codec = dev_get_drvdata(dai->dev);
-- 
2.17.1


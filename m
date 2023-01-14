Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC9F166A9B1
	for <lists+stable@lfdr.de>; Sat, 14 Jan 2023 07:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbjANGkU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Jan 2023 01:40:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbjANGkC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Jan 2023 01:40:02 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2D834690
        for <stable@vger.kernel.org>; Fri, 13 Jan 2023 22:39:55 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id i1so2585655pfk.3
        for <stable@vger.kernel.org>; Fri, 13 Jan 2023 22:39:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ralston.id.au; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pf+ttLxtXQ5Tg06EZ5llJKWJ8N919hgnZEhiYC1yIGQ=;
        b=HewWjrPqtMm4rNX19tLbCkXiMuSSyxyvIi/0Pg+SYlq5L8zUMncIIeoGd4ygSc3ceW
         4KEg92m8X4bqVhCN0H0JnmyzpOrO50bYlpuI9sM3lQgXBIjI5hjakvhDg9BThpiblwA2
         ewMFktePK9wz5S1LehF/jN9wVHQSCJbYDld7w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pf+ttLxtXQ5Tg06EZ5llJKWJ8N919hgnZEhiYC1yIGQ=;
        b=gnrVU4nNmnerP/TzZGYuMASAaGAVOP84N0K54ZfE+UZ4YqvOuN/XhMWiBSpwdqVLLs
         RAUjL7VRIahbDA2g/b3jSucsZhniaxDkcK4nmR7uyXe1vmFfNgCTg7+pW7mqBa7BRGDv
         W8VSUvIt4emFWdxy70g381WoaXANy3qRr7PyTUahphADEuv27ruTHh6UobnY14ljKNBW
         j/tmj3NyX0LOy/TVvl7HjKTxo9tk+/t6j+YY6MvcrDWKK8IL9L9jfLeAPp4iL9ihpntE
         OyuJYJJ7W/qRGWtpP+hzvo424ZOypVFdqXG+XAghaBJrj3Z/P1NFYVLKseNE8dTkJbwg
         vppw==
X-Gm-Message-State: AFqh2kqn317L8VgSU7QwYJ9a/4ZcqFqj21Ddo+bXE271yHaq6P4DT0Eq
        NrSCbb2tegI1uUA5oo4dOKRC9w==
X-Google-Smtp-Source: AMrXdXvMqQTE+U8h12vDrWT+5a+mSkm254if1QyJbdFhijRfJmIIHYXEjRZm1uutlLoGqxbBEfU3rA==
X-Received: by 2002:a05:6a00:179a:b0:58b:bc3a:622a with SMTP id s26-20020a056a00179a00b0058bbc3a622amr5827687pfg.21.1673678395001;
        Fri, 13 Jan 2023 22:39:55 -0800 (PST)
Received: from leatherback.localnet ([49.3.3.1])
        by smtp.gmail.com with ESMTPSA id m2-20020a62a202000000b005869a33dd3bsm12893964pff.164.2023.01.13.22.39.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jan 2023 22:39:54 -0800 (PST)
From:   Michael Ralston <michael@ralston.id.au>
To:     tiwai@suse.de, stable@vger.kernel.org, gregkh@linuxfoundation.org
Subject: [PATCH] Revert "ALSA: usb-audio: Drop superfluous interface setup at parsing"
Date:   Sat, 14 Jan 2023 17:38:19 +1100
Message-ID: <5498668.31r3eYUQgx@leatherback>
In-Reply-To: <167362470314207@kroah.com>
References: <167362470314207@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit ac5e2fb425e1121ceef2b9d1b3ffccc195d55707.

The commit caused a regression on Behringer UMC404HD (and likely
others).  As the change was meant only as a minor optimization, it's
better to revert it to address the regression.

It appears that the original revert patch had spaces instead of tabs so it 
would not apply. Hopefully this fixes that. Please forgive my ignorance if I 
have misunderstood.

Reported-and-tested-by: Michael Ralston <michael@ralston.id.au>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/CAC2975JXkS1A5Tj9b02G_sy25ZWN-ys+tc9wmkoS=qPgKCogSg@mail.gmail.com
Link: https://lore.kernel.org/r/20230104150944.24918-1-tiwai@suse.de

diff --git a/sound/usb/stream.c b/sound/usb/stream.c
index f75601ca2d52..f10f4e6d3fb8 100644
--- a/sound/usb/stream.c
+++ b/sound/usb/stream.c
@@ -1222,6 +1222,12 @@ static int __snd_usb_parse_audio_interface(struct 
snd_usb_audio *chip,
 			if (err < 0)
 				return err;
 		}
+
+		/* try to set the interface... */
+		usb_set_interface(chip->dev, iface_no, 0);
+		snd_usb_init_pitch(chip, fp);
+		snd_usb_init_sample_rate(chip, fp, fp->rate_max);
+		usb_set_interface(chip->dev, iface_no, altno);
 	}
 	return 0;
 }





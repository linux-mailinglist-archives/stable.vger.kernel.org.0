Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07CF265B5DF
	for <lists+stable@lfdr.de>; Mon,  2 Jan 2023 18:30:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234857AbjABRaA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Jan 2023 12:30:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233250AbjABR3x (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Jan 2023 12:29:53 -0500
Received: from mail-oa1-x34.google.com (mail-oa1-x34.google.com [IPv6:2001:4860:4864:20::34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D490219F
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 09:29:50 -0800 (PST)
Received: by mail-oa1-x34.google.com with SMTP id 586e51a60fabf-1442977d77dso34273063fac.6
        for <stable@vger.kernel.org>; Mon, 02 Jan 2023 09:29:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ralston.id.au; s=google;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=MO3PF6p+afXm5zn13bWM83e/wB85pg2FekVhsPuYcGs=;
        b=pkJ6DHVo7HHwKQEtGFFNvfZ9sHymqGr4Bj+Gz8KCtTeq280xzPfMNzP0OevL3ZUcJ/
         pJePiusWU12+zVf8ThBOP8EyZcrB5A6kryr+iE1DHm53vL5jZ8cRvOcCB0QaZWrySe91
         DX0C2/NkNieipZxOw0AfWPZHuCLqAFxT9oK5w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MO3PF6p+afXm5zn13bWM83e/wB85pg2FekVhsPuYcGs=;
        b=yoRMrOpMXduzVeBxQerX0aVKEWpwaSMhde/x6/jj6x1NgvaSbRnJqSZmjA9PasDmlv
         ctjb6yBBr0CWi+wkKoLCk4Rz0gTSApEWyJZIc0Ubpi1U3Yf9h/dVEnXzk1kYvlklT675
         DtI+8OlItcIoq79vYt8ZDFzLB0kwlLmuHArRF9Q7sYvpoKTeDSkvackBZXNnOuYn3PCx
         VHwFmqzqYBZK2n52ohYpwHHNPG/lau6Xghmh47Qgd9jrt7qRvzmUXARb/OKTiNb6r4At
         p9QlnEgMSVjE73i8CQApCQTh9NctAS/wYSI0wtJb3wIfRGpfi/AiD2OGItlxjx0mNmnQ
         e4qQ==
X-Gm-Message-State: AFqh2ko2TkPx1NDpr8/BMyo5yaFXTfzkp0IVMBtRy00WaT2PRwT5LV9j
        Yxn0vBZB2tf2G5QVaQTfTTPvR6naTGd+LlUOkEpDacdDYz8aT1SsmYE=
X-Google-Smtp-Source: AMrXdXvyO8uVbMPjy4iw+DDTHcdUfmkOnyofYofSpArK6026+iSlt2535pEyIlkwhrLzSC/0boyvrHeOm2rfLYU88QY=
X-Received: by 2002:a05:6870:8dcf:b0:150:a904:9f9a with SMTP id
 lq15-20020a0568708dcf00b00150a9049f9amr414910oab.235.1672680589778; Mon, 02
 Jan 2023 09:29:49 -0800 (PST)
MIME-Version: 1.0
From:   Michael Ralston <michael@ralston.id.au>
Date:   Tue, 3 Jan 2023 04:29:13 +1100
Message-ID: <CAC2975JXkS1A5Tj9b02G_sy25ZWN-ys+tc9wmkoS=qPgKCogSg@mail.gmail.com>
Subject: USB-Audio regression on behringer UMC404HD
To:     alsa-devel@alsa-project.org, regressions@lists.linux.dev,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm currently experiencing a regression with the audio on my Behringer
U-Phoria UMC404HD.

Alsa info is at:
http://alsa-project.org/db/?f=3Df453b8cd0248fb5fdfa38e1b770e774102f66135

I get no audio in or out for this device with kernel versions 6.1.1 and 6.1=
.2.

The versions I have tried that work correctly include 5.15.86 LTS,
5.19.12, and 6.0.13=E2=80=9316.

When I run this on 6.1.1, it will just hang until I ctrl+c:
aplay -D plughw:1,0 /usr/share/sounds/alsa/Front_Center.wav

I've run strace on that command, and its output is at:
https://pastebin.com/WaxJpTMe

Nothing out of the ordinary occurs when aplay is run, according to the
kernel logs.

Please let me know how I can provide additional debugging information
if necessary.

Thanks
Michael

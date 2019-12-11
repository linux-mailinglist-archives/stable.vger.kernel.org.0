Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C98E4119FD4
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 01:21:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbfLKAV1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 19:21:27 -0500
Received: from mo-csw1514.securemx.jp ([210.130.202.153]:60844 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726913AbfLKAV1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Dec 2019 19:21:27 -0500
Received: by mo-csw.securemx.jp (mx-mo-csw1514) id xBB0L4lK009055; Wed, 11 Dec 2019 09:21:04 +0900
X-Iguazu-Qid: 34tKSOWc8Axu5wzLP9
X-Iguazu-QSIG: v=2; s=0; t=1576023664; q=34tKSOWc8Axu5wzLP9; m=KRvqLVtASM80eGQOphXM0WNlrloDfUUJ7MA+x3CcXas=
Received: from imx2.toshiba.co.jp (imx2.toshiba.co.jp [106.186.93.51])
        by relay.securemx.jp (mx-mr1513) id xBB0L3lO031772;
        Wed, 11 Dec 2019 09:21:04 +0900
Received: from enc01.localdomain ([106.186.93.100])
        by imx2.toshiba.co.jp  with ESMTP id xBB0L3CA025069;
        Wed, 11 Dec 2019 09:21:03 +0900 (JST)
Received: from hop001.toshiba.co.jp ([133.199.164.63])
        by enc01.localdomain  with ESMTP id xBB0L3u7015966;
        Wed, 11 Dec 2019 09:21:03 +0900
Date:   Wed, 11 Dec 2019 09:21:02 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable@vger.kernel.org
Subject: Re: stable RC build breakages (4.14.y, 4.19.y)
X-TSB-HOP: ON
Message-ID: <20191211002102.mr3re4rks2nmdkyf@toshiba.co.jp>
References: <20191210225743.GA4443@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191210225743.GA4443@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Tue, Dec 10, 2019 at 02:57:43PM -0800, Guenter Roeck wrote:
> v4.14.y:
> 
> arm64:defconfig:
> 
> arch/arm64/boot/dts/nvidia/tegra186-p2771-0000.dts:5:10: fatal error:
> 	dt-bindings/input/gpio-keys.h: No such file or directory
> 

The include/dt-bindings/input/gpio-keys.h is not provided.
We need to revert commit 9b7f85596a7c799d3715729188ea8f0f0f4b3c54(arm64:
tegra: Fix power key interrupt type on Jetson TX2).


> i386:allyesconfig:
> 
> drivers/crypto/geode-aes.c:174:2: error:
> 	implicit declaration of function 'crypto_sync_skcipher_clear_flags
> 
> and several similar errors.


crypto_sync_skcipher_clear_flags() was provided from 4.19. So we need to
fix the patch.

> 
> 
> ---
> v4.19.y:
> 
> arm64:defconfig:
> 
> arch/arm64/boot/dts/allwinner/sun50i-a64-pinebook.dts:82.1-7 Label or path codec not found
> arch/arm64/boot/dts/allwinner/sun50i-a64-pinebook.dts:86.1-14 Label or path codec_analog not found
> arch/arm64/boot/dts/allwinner/sun50i-a64-pinebook.dts:91.1-5 Label or path dai not found
> arch/arm64/boot/dts/allwinner/sun50i-a64-pinebook.dts:297.1-7 Label or path sound not found

I think we need to pick commit ec4a95409d5c28962e0097e8291aa7048f8b262a. 
But I have not examined it in detail.

> 
> i386:allyesconfig:
> 
> Same as v4.14.y.
> 
> Guenter
> 

Best regards,
  Nobuhiro

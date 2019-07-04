Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2004E5F75D
	for <lists+stable@lfdr.de>; Thu,  4 Jul 2019 13:47:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727548AbfGDLqz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Jul 2019 07:46:55 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:44842 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727436AbfGDLqz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Jul 2019 07:46:55 -0400
Received: by mail-qt1-f196.google.com with SMTP id 44so3814648qtg.11
        for <stable@vger.kernel.org>; Thu, 04 Jul 2019 04:46:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OvU3b/xbFG/w0vj131Yq/16MN+L6TW+bW9qLWxvMa7w=;
        b=VJVQKl91KjJNgJ41WNYuvRA4w2RXyuCci6L46+x/eI6ca3/opAgY3sub8cds0tPrUI
         lCJ4EUfsViaAHoTs48zi13Jkhu8kdPWbfa/SXJrw29DRB+XqVsVB2XMu0D1DIg0vvtft
         Cyqc+bQv9jQeZ6SrGBpKDYQ5hh7axiSfrSqv0/DsTYN6JTaunp0h8gn5k0dT/XUYFwMO
         zOegfWAnwpJXMzyG16CKLv/sntB3zWnG7ElTVT/+82lTMj7PZJWuHRvSkFyCoBg48SIb
         C7M8+Qft/2i5KUXLL9zvz78RNrqdctQA8LFKoJ99+rR+foTjejlhv09MJY4Ojvqg7JYg
         k7Og==
X-Gm-Message-State: APjAAAUpTCSrRfP8FRpbxhX8o6NrtzxSiokzEgs2ZUfB07+LyJ+oU02v
        /XWTk/JpV0xEwmDzE0uQn4wWkdL5tDss147664PHDQRj0wA=
X-Google-Smtp-Source: APXvYqwCw09bw3IBvvzhRxbFdYK/fOpcGNUhLE7usSCN1REjwM1xhXFy35qhpwFce4V80XDV7juFvZbRZsjkvvB413o=
X-Received: by 2002:a0c:b758:: with SMTP id q24mr36733423qve.45.1562240814388;
 Thu, 04 Jul 2019 04:46:54 -0700 (PDT)
MIME-Version: 1.0
References: <5d1dd15d.1c69fb81.90003.b2ac@mx.google.com>
In-Reply-To: <5d1dd15d.1c69fb81.90003.b2ac@mx.google.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Thu, 4 Jul 2019 13:46:36 +0200
Message-ID: <CAK8P3a1aTHOGOgRjHgFHS+vuDV2Kv2aY7-bEUBa2nx5aF_vVCA@mail.gmail.com>
Subject: Re: stable-rc build: 78 warnings 1 failures (stable-rc/v5.1.16-8-g57f5b343cdf95)
To:     "# 5.1.x" <stable@vger.kernel.org>
Cc:     Kernel Build Reports Mailman List 
        <kernel-build-reports@lists.linaro.org>,
        "Olof's autobuilder" <build@lixom.net>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Going through Olof's build report for 4.19.y:

On Thu, Jul 4, 2019 at 12:14 PM Olof's autobuilder <build@lixom.net> wrote:
>
>         arm.rpc_defconfig:
> arm-unknown-linux-gnueabi-gcc: error: unrecognized -march target: armv3m
> arm-unknown-linux-gnueabi-gcc: error: missing argument to '-march='
> arm-unknown-linux-gnueabi-gcc: error: unrecognized -march target: armv3m
> arm-unknown-linux-gnueabi-gcc: error: missing argument to '-march='

No mainline patch yet, this happens with gcc-9, which cannot build an
rpc kernel any more as armv3 support got dropped:

> arch/arm/mm/init.c:471:13: warning: unused variable 'itcm_end' [-Wunused-variable]
> arch/arm/mm/init.c:470:13: warning: unused variable 'dtcm_end' [-Wunused-variable]

Please backport this to 5.1-stable:

e6c4375f7c92 ("ARM: 8865/1: mm: remove unused variables")

> /tmp/ccUhzzYK.s:18119: Warning: using r15 results in unpredictable behaviour
> /tmp/ccUhzzYK.s:18191: Warning: using r15 results in unpredictable behaviour

I have a patch but not mainlined it yet.

> sound/pci/echoaudio/echoaudio_dsp.c:647:9: warning: iteration 1073741824 invokes undefined behavior [-Waggressive-loop-optimizations]
> sound/pci/echoaudio/echoaudio_dsp.c:658:9: warning: iteration 1073741824 invokes undefined behavior [-Waggressive-loop-optimizations]
> sound/pci/echoaudio/echoaudio_dsp.c:647:9: warning: iteration 1073741824 invokes undefined behavior [-Waggressive-loop-optimizations]

Have not seen this one yet, sorry.

> include/linux/string.h:340:9: warning: '__builtin_memset' offset [321, 344] from the object at 'buf' is out of the bounds of referenced subobject 'rdata' with type 'struct fc_rport_priv' at offset 0 [-Warray-bounds]
> include/linux/string.h:340:9: warning: '__builtin_memset' offset [321, 344] from the object at 'buf' is out of the bounds of referenced subobject 'rdata' with type 'struct fc_rport_priv' at offset 0 [-Warray-bounds]

Looks like a harmless warning from an unusal coding style. The issue is
still present in mainline and should be trivial to address by anyone using
gcc-9.

> include/linux/module.h:132:6: warning: 'init_module' specifies less restrictive attribute than its target 'rp_init': 'cold' [-Wmissing-attributes]

Please backport this to all stable kernels (2.6.39+):

423ea3255424 ("tty: rocket: fix incorrect forward declaration of 'rp_init()'"

>         arm64.allmodconfig:
> drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c:16563:1: warning: the frame size of 2592 bytes is larger than 2048 bytes [-Wframe-larger-than=]
> drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c:16905:1: warning: the frame size of 2560 bytes is larger than 2048 bytes [-Wframe-larger-than=]

My patch is waiting for mainline acceptance:

https://patchwork.kernel.org/patch/11022355/

> aarch64-unknown-linux-gnu-ld: warning: creating a DT_TEXTREL in object
> aarch64-unknown-linux-gnu-ld: warning: creating a DT_TEXTREL in object
> aarch64-unknown-linux-gnu-ld: warning: creating a DT_TEXTREL in object

no idea, I don't see this here.

>
>         i386.allmodconfig:

> drivers/iio/adc/rcar-gyroadc.c:510:5: warning: 'ret' may be used uninitialized in this function [-Wmaybe-uninitialized]

Yep, that's a bug, just sent a fix now.:
https://lore.kernel.org/lkml/20190704113800.3299636-1-arnd@arndb.de/

       Arnd

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DFD545CA74
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 17:58:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241659AbhKXRBH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 12:01:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbhKXRBH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Nov 2021 12:01:07 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AC7DC061574
        for <stable@vger.kernel.org>; Wed, 24 Nov 2021 08:57:57 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id x6so13351324edr.5
        for <stable@vger.kernel.org>; Wed, 24 Nov 2021 08:57:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=UdBZXe0/OdNbMWT96QBxOAD+Jmu/unJTcDn2GuJkXAM=;
        b=BToeq8ezAYnUTy0psrDefKtf/7Iww1+oa6VKPmegDwa+9gEs8T7BIc+IeiiSeduzSl
         T+8Ak3zihC/0eb3X/lxCmvWZfvLuxgROa7FbHknF/olDOulqIYURH6cn62avFllpTrX2
         lqzcnZEGWvRRxNw/feUv1Gqx20sMztLk99W+sNJuzHFnE5TEJumRRNHCJkwxeVZTWAD1
         uyjmZ7HpUa3DGfls1PXuSEXK3pQQ8z/Dmjf6EnQ2PVihdexBmJQDJO7R1UF+h+pjwwaP
         9qbovymfceQs+8yQ+W1ADrG5uObD8iHELB/afNFxcSRI+hcdCbLFb+QcoUcndihqhgzh
         pMEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=UdBZXe0/OdNbMWT96QBxOAD+Jmu/unJTcDn2GuJkXAM=;
        b=FTSDCSovDhi3Z/ug6LpqA6MivJb8yZ4gaAYxMHtR3aKLTX5ZrvLsuEGGwC8JdyKF0W
         s+pFTZs2AAP29s/ST07A5xfB6a8mDjDkzgvYt+Aiq0J80e2JUhVeXX/+8ueDZ9oO3gAn
         62IoIeIbuySLWKYm1Na1qVF3UFJ9VtVjKeFbG6yzOkkgEWj3gykmgebob4Re5xpqSxbV
         gIrJVcRqihEIrMp0O/zS18l0ecHC0YaF43mtjRb1vEp8mRNHy4t+rveAsNGC1bkyxX5m
         d02Egq2/LMIxfKh0R35AwGMvFKAxHokO1Q8H7NUujiMdqbEDHxDisvDU2S5O250v427X
         i9Cw==
X-Gm-Message-State: AOAM533Eh2lYe8aooSDn5GUfsKLw5AJ8cvU5hFRSBmQ+T/gm6J1X7pVI
        8KK0RIc+brvEnQwPXsJPtamu3T/SGYe3koVr07ZZviI1O24=
X-Google-Smtp-Source: ABdhPJwh6wEJTUS6qnUGmkYoB6UVkzT3F8s3Eowsn8XBqivhbbPDBmLXX1CX4C4WNWAY856ABl9IStBvSs34OlZ2vkQ=
X-Received: by 2002:a05:6402:d09:: with SMTP id eb9mr27192933edb.216.1637773071963;
 Wed, 24 Nov 2021 08:57:51 -0800 (PST)
MIME-Version: 1.0
From:   Scott Bruce <smbruce@gmail.com>
Date:   Wed, 24 Nov 2021 08:57:39 -0800
Message-ID: <CAPOoXdHhLdkP9KE4_9pPzUTdpFbN15wQp9SshJfvz1SxZWsRbA@mail.gmail.com>
Subject: WIP 5.15.5-rc1 build failure in sound/soc/sof/intel/hda-dai.c
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

It looks like the current work in progress branch for 5.15.5-rc1
picked up fe1bda72c1e8 "ASoC: SOF: Intel: hda-dai: fix potential
locking issue" without also picking 868ddfcef31f "ALSA: hda:
hdac_ext_stream: fix potential locking issues" from master. This
causes builds to fail on x86_64 using clang:

  ...
  CC [M]  drivers/misc/eeprom/at25.o
  CC [M]  drivers/block/pktcdvd.o
  LTO [M] sound/soc/codecs/snd-soc-max98088.lto.o
sound/soc/sof/intel/hda-dai.c:111:4: error: implicit declaration of
function 'snd_hdac_ext_stream_decouple_locked'
[-Werror,-Wimplicit-function-declaration]
                        snd_hdac_ext_stream_decouple_locked(bus, res, true);
                        ^
sound/soc/sof/intel/hda-dai.c:111:4: note: did you mean
'snd_hdac_ext_stream_decouple'?
./include/sound/hdaudio_ext.h:91:6: note:
'snd_hdac_ext_stream_decouple' declared here
void snd_hdac_ext_stream_decouple(struct hdac_bus *bus,
     ^
1 error generated.
make[4]: *** [scripts/Makefile.build:277: sound/soc/sof/intel/hda-dai.o] Error 1
make[3]: *** [scripts/Makefile.build:540: sound/soc/sof/intel] Error 2
make[2]: *** [scripts/Makefile.build:540: sound/soc/sof] Error 2
make[2]: *** Waiting for unfinished jobs....
  AR      drivers/misc/cb710/built-in.a
  CC [M]  drivers/misc/cb710/core.o
  CC [M]  net/netfilter/xt_nfacct.o
  ...

After cherry-picking the second commit (868ddfcef31f) builds complete normally.

In case it's relevant there's a third commit in this same series
that's also not included: 1465d06a6d85, "ALSA: hda: hdac_stream: fix
potential locking issue in snd_hdac_stream_assign()".

Scott

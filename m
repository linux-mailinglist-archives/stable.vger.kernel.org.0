Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E87020F092
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 10:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731472AbgF3Ie3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jun 2020 04:34:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727059AbgF3Ie3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Jun 2020 04:34:29 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DC7CC061755;
        Tue, 30 Jun 2020 01:34:29 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id j11so14103834oiw.12;
        Tue, 30 Jun 2020 01:34:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=Xvujs7uAlZ7v9VquTZvFNbU+VMvTAkp34dsAu9VXmjo=;
        b=KxiRDAkzJ8aG9D0Qr90cMtm85Rahd+HiuZQkZhIj+K/uwsvDMMZ1GlBjYcO3L8w3Ay
         BO11tTAe3RiVGGia8ZvGJVbsFv2RnWGkuEyIA7CW1bLicZF5MFD+7hmfJ0JNj4Ed75vg
         qFhmjVXpgO0VcNIOWGvLpTb9I1EdCr+jI4qRffdMgqPH/Es39pwUgdtyYD1UPnQ9CA7L
         xX0+kGodTdCB5kZaC7a1kyIpc6ZkMu0Om8vU5h5SOY5GsMDPpDVkIgFDjhb0IhIxTgJ3
         Tj5TUXU8WmyD5Gr5ynQjhDmxYOLzD41YiVJYRlBdeDin0l7VOhIkEbv/c1YanPGhU8qm
         1cTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=Xvujs7uAlZ7v9VquTZvFNbU+VMvTAkp34dsAu9VXmjo=;
        b=JVlvpfV3DjPCZoUx8UUb5ZL2ha7J/DJCYS61EI9pmkHcEITWpASz/JYoVuaC1znc1L
         I1WuS2YxCWxbFXiMLr6hx/vtosMb8A3SNg0vPYvRv7LgCd5vMqk2RlGo0efOEIO11obo
         AX5ddXHkyut5xlIefYrs3jEAktihNsEGw4ACUKqViJSLnOIppz9uUlbJdinmTzzhABNy
         s15OHFoe8Q4i3hytOe+GqyewFXhSYqJtzNw4NpwSAmGSeDOKMP2LAPn8CFcN4T7cyeFr
         zb/Tj/icm+mB7e0+gKZQmhfo7E00ABIyIAF6qd6dKNZ9Q3SfOcwH8Uu7IHKw/c1bY/HM
         tBQw==
X-Gm-Message-State: AOAM533dQTaeUyu0UyoY8poxw7flshdG2fw4YiSQt7SurTcggyr5VAEP
        OTeT5fCHIitIvyWqAqzXBdo3+qIP8l/nn1XTZMkvZBXT
X-Google-Smtp-Source: ABdhPJxad4tFEc/Did5pkIuHZfL40b8vqMlDvlHTmoM81ZIQ75oj6ttPsWfIVgkCxWLpqZ8+Ieh2b/cINyieF/NpPbE=
X-Received: by 2002:aca:603:: with SMTP id 3mr14319288oig.89.1593506068111;
 Tue, 30 Jun 2020 01:34:28 -0700 (PDT)
MIME-Version: 1.0
From:   richard clark <richard.xnu.clark@gmail.com>
Date:   Tue, 30 Jun 2020 16:34:17 +0800
Message-ID: <CAJNi4rNvzQ4Eqzxo-OokF+zfOvJ=kKUMUVGt8osji0mcaaxhkQ@mail.gmail.com>
Subject: External kmod build failed on KASAN-enabled kernel
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

The same kmod source code can be built on KASAN-disabled kernel
(5.7.0), but after enable it with CONFIG_KASAN=y, the kmod can't build
on the new installed KASAN-enabled kernel with below error message,
seems no relevant answers for this issue with google:

root@build-ws:/home/mm/slab# make

make -C /lib/modules/5.7.0/build M=/home/mm/slab modules

make[1]: Entering directory '/home/linux-5.7'

  CC [M]  /home/mm/slab/tap_slab.o

  MODPOST 1 modules

ERROR: modpost: "__asan_register_globals" [/home/mm/slab/tap_slab.ko] undefined!

ERROR: modpost: "__asan_unregister_globals"
[/home/mm/slab/tap_slab.ko] undefined!

ERROR: modpost: "__asan_load8_noabort" [/home/mm/slab/tap_slab.ko] undefined!

scripts/Makefile.modpost:94: recipe for target '__modpost' failed

make[2]: *** [__modpost] Error 1

Makefile:1642: recipe for target 'modules' failed

make[1]: *** [modules] Error 2

make[1]: Leaving directory '/home/linux-5.7'

Makefile:6: recipe for target 'default' failed

make: *** [default] Error 2
===
Regards,
Richard

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB3805ED5D
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 22:17:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726955AbfGCUR2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jul 2019 16:17:28 -0400
Received: from mail-qt1-f173.google.com ([209.85.160.173]:40274 "EHLO
        mail-qt1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726550AbfGCUR1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Jul 2019 16:17:27 -0400
Received: by mail-qt1-f173.google.com with SMTP id a15so5504486qtn.7
        for <stable@vger.kernel.org>; Wed, 03 Jul 2019 13:17:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=KLR0ipXn/sUWk0U5ISdXdPm1gbHE286ZosVaT+MC5gQ=;
        b=NiZM3uTA2MtpideGQC6PjpWOU1sEubbpMv4JTV0XRb23Bk80mG/V0mjqGZioTbNScT
         xFShD82zU92gSUN3DqhWWifVP1kBsVkUbze+1rKvaTGyV0dp2kohEjPbweNukexUzjSI
         m91h49M+Zho8Gnf0kF1HGSdup0JoVJnVROdAHMZGi9KO/vVkV8P0L6hH9sClT/KM0YQb
         VVMOB6LR4hCo/Br3NRAHChRVSvjxtVhMk8NWiWqbw65ZEMSNMoXX7mOnQuZkais+UkeZ
         6Xuy2OdSqk6ZqhrZlfor67nOI7w6p18Win5NKQuNU40xAL0RG+ac7wjcO7FoWTv+X18I
         0rNA==
X-Gm-Message-State: APjAAAXxaZ9tLFHQcFxYyFgiRJJb2cu/rB7UXyDVVueVVmrEX7YjZoPJ
        ORNCKFA/R4gWJ/S98Kqlli8Paw2p9pFOQITKyoNhDcB+Qzo=
X-Google-Smtp-Source: APXvYqx30EUkC4TCtBWpyo9wgmCPS4hAjBs3Oka5ieUppBje/dz2chQQzidrvyFxs3jpnzkQynKZKbQEAeb1xoohWKo=
X-Received: by 2002:aed:3e7c:: with SMTP id m57mr32222440qtf.204.1562185046455;
 Wed, 03 Jul 2019 13:17:26 -0700 (PDT)
MIME-Version: 1.0
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 3 Jul 2019 22:17:09 +0200
Message-ID: <CAK8P3a2yqf5WK37mud7k4oFn95rTJRqpOdZ+v6zJ-9xM0u11zw@mail.gmail.com>
Subject: [STABLE-4.4] proposed backports
To:     "4.4.y backports" <stable@vger.kernel.org>
Cc:     gregkh <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I looked at the kernelci.org output for 4.4.y and found a couple of
patches that need to be applied here:

0eca6fdb3193 ("ARC: Assume multiplier is always present")
1dec78585328 ("ARC: fix build warning in elf.h")
173a3efd3edb ("bug.h: work around GCC PR82365 in BUG()")
8535f2ba0a9b ("MIPS: math-emu: do not use bools for arithmetic")
67fc5dc8a541 ("MIPS: VDSO: Include $(ccflags-vdso) in o32,n32 .lds builds")
993dc737c099 ("mfd: omap-usb-tll: Fix register offsets")
386744425e35 ("swiotlb: Make linux/swiotlb.h standalone includible")

Further, the backport of commit 867bfa4a5fce ("fs/binfmt_flat.c: make
load_flat_shared_library() work") relies on commit bdd1d2d3d251 ("fs:
fix kernel_read prototype"). Either that gets backported as well, or
the new patch dropped or modified:

fs/binfmt_flat.c:832:35: warning: passing argument 2 of 'kernel_read'
makes integer from pointer without a cast [-Wint-conversion]
include/uapi/linux/binfmts.h:18:25: warning: passing argument 3 of
'kernel_read' makes pointer from integer without a cast
[-Wint-conversion]
fs/binfmt_flat.c:832:58: warning: passing argument 4 of 'kernel_read'
makes integer from pointer without a cast [-Wint-conversion]

       Arnd

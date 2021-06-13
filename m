Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0874F3A5923
	for <lists+stable@lfdr.de>; Sun, 13 Jun 2021 16:56:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231841AbhFMO6d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Jun 2021 10:58:33 -0400
Received: from mail-ed1-f50.google.com ([209.85.208.50]:36595 "EHLO
        mail-ed1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231755AbhFMO6d (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 13 Jun 2021 10:58:33 -0400
Received: by mail-ed1-f50.google.com with SMTP id w21so43009752edv.3
        for <stable@vger.kernel.org>; Sun, 13 Jun 2021 07:56:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=mYOiA3ZBNs5Wt2A7AYBz6YbQnyZrGKEskbnmlwiCaBo=;
        b=yB0rVbKoZJ1j7SJLP6Ftger4soScb3bygPcqNWu54o3XcvD7A6RPsaNaDdFIZjl7j3
         CilF/C40QBH7y0YrGtPjdOk42aP5H07uFVppSn4x6hwVZtfJeu9mVTTzyfFOLCj6+RH7
         um3geWG4+VuU3hKYLJ5daB7NYvCCmuPCALXbRSWw3PKRBuKOSCdl71R2yswhcTZr40ux
         Cij98Ht0Vnc6goXY/y55eNslFaP1z0api2lSv5DlFfZO7ZV9d0DjQWP21dbaMP7hzUB8
         BalrJskfe2RVVXPOJS82Akp6VlJR9ow4HT/2AxmEqvHphEM4hE1YNvQSK6veB7JGvFsW
         Y+KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=mYOiA3ZBNs5Wt2A7AYBz6YbQnyZrGKEskbnmlwiCaBo=;
        b=F4gHZ9vFz6w2Mj9QuKjciHXBIaNO1YJiIhmxg9oxsQgxqo7BIX++nldpK9TuFznekF
         0/BqtkHJ7fSTFHH/a/uQfhKumjblqDtZJWWRyXLN5DJn/hJHqMKQ1nA7dkRVVsAT2Laa
         WmaIEXbaJx1GszCkFAVCqg5qcUisL/aQ02wpxdtKRXuNBDaUpAwIT+KwvOnvqe3mTx2P
         kp0zXav277pesz2LeFCqFD+FLhvTYd9GEi3hmO3zjAzryUbtxAwEGBcAbSbuM6vKy0Co
         3TP6WzJQ6+ne4NJszjho98tFsT4XWCve+EUfpOptaf83lLf1AKdoU/PiCU1pTR5zt+nI
         FUPA==
X-Gm-Message-State: AOAM530vz0eISeJX62BZGQjnAQ069oYibbvuDVMJWCt53oMy1+WN4sHi
        w3K6zlVGqtbgx/NRfzD3dA20xbwIX/hVZOyepv0APg==
X-Google-Smtp-Source: ABdhPJwZSj0Vz9ZqHDObAcEe2jYlz4QzP1/DE7EmHZbRLgk7BNy41uyx6mjLHP2rd5ESSKNCo0lxMB02CFo4s1e6yy8=
X-Received: by 2002:a05:6402:220d:: with SMTP id cq13mr4806349edb.52.1623596131348;
 Sun, 13 Jun 2021 07:55:31 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sun, 13 Jun 2021 20:25:19 +0530
Message-ID: <CA+G9fYuBo_WgjtW1BugKLPeYnmLEe65zU7Ttt=FB2uqMzZy1eQ@mail.gmail.com>
Subject: compiler.h:417:38: error: call to '__compiletime_assert_59' declared
 with attribute error: BUILD_BUG_ON failed: sizeof(_i) > sizeof(long)
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     linux-stable <stable@vger.kernel.org>, lkft-triage@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following error was noticed on stable-rc 5.12, 5.10, 5.4, 4.19,
4.14, 4.9 and 4.4
for i386 and arm.

make --silent --keep-going --jobs=8
O=/home/tuxbuild/.cache/tuxmake/builds/current ARCH=arm
CROSS_COMPILE=arm-linux-gnueabihf- 'CC=sccache
arm-linux-gnueabihf-gcc' 'HOSTCC=sccache gcc'
In file included from /builds/linux/include/linux/kernel.h:11,
                 from /builds/linux/include/linux/list.h:9,
                 from /builds/linux/include/linux/preempt.h:11,
                 from /builds/linux/include/linux/hardirq.h:5,
                 from /builds/linux/include/linux/kvm_host.h:7,
                 from
/builds/linux/arch/arm/kvm/../../../virt/kvm/kvm_main.c:18:
In function '__gfn_to_hva_memslot',
    inlined from '__gfn_to_hva_many.part.6' at
/builds/linux/arch/arm/kvm/../../../virt/kvm/kvm_main.c:1446:9,
    inlined from '__gfn_to_hva_many' at
/builds/linux/arch/arm/kvm/../../../virt/kvm/kvm_main.c:1434:22:
/builds/linux/include/linux/compiler.h:417:38: error: call to
'__compiletime_assert_59' declared with attribute error: BUILD_BUG_ON
failed: sizeof(_i) > sizeof(long)
  _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
                                      ^
Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

ref:
https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc/-/jobs/1342604370#L389

--
Linaro LKFT
https://lkft.linaro.org

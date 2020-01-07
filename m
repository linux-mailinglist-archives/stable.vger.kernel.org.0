Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E769132D36
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 18:38:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728437AbgAGRin (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 12:38:43 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:34244 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728430AbgAGRin (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jan 2020 12:38:43 -0500
Received: by mail-lf1-f65.google.com with SMTP id l18so355375lfc.1
        for <stable@vger.kernel.org>; Tue, 07 Jan 2020 09:38:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=YShlSsj6Xvg1OPo/28mdVtM8iXSk9E0UBpNiD7d4cxc=;
        b=YazhU/1g6LwFUIZeow4DmwAk2IRXPDITZkAOr2G/j4sCa4bGbUL7sYUao55R8VZ3ZQ
         Jv2Ml2OB7SXId3CCh1zEulZ3QjsySlL3rT53Y4ldWMtvsqes3QDo+aeIgRm+/pLEA+Tm
         5aThR1u/u5iFNvsiBzluecy1q1OyXe9+IJ3tht63Sq7JFgqxTMRn03XZzN0fvRdggLQF
         p//PkUf6nff51015iEzpZHBUNPubmqTws917O69DZZ+pI/GRjcKWwhKPoFEHYjjXqdnz
         UekIRCddL2f1Z2MlbWBZJRAs1cl/r2UVmMtlSKhppAdCQdR1Iz9eiypKiHjS68jCEYSU
         whfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=YShlSsj6Xvg1OPo/28mdVtM8iXSk9E0UBpNiD7d4cxc=;
        b=ArEfESfnVSdB2vYK/Q/jZ98jxmIb7bXALvzSVUVZKePvmDosMZyO+NNd9p6zr8l4vU
         5bWfnB/B0dxE/EB3yArbA8dMCRT2JJ1fWSiBcgcrwnw02DyDOCik82cH6SLMUCVcqkjW
         H5ZhkPVnu/4krUUcZROO9Pcm5mjBFIbtqX2+pWQrzdhLlXV5BpsyfFUEkcCYG/L9HUhx
         QVET4ut1LmSkHx8vRK0kEhgsz/lcmk5KtbB30l9fy4AcEWwSo4anDL85ZF0DRw698Kn5
         DWqnhYroI0DZYy4FGmgp9LdLR2FtQFKO2piro2CoFgDEx/mWPur1ntCSDhk6j+dUMQhg
         xpgg==
X-Gm-Message-State: APjAAAWhn7em4pmHEab8UWGDiiDdoad7V860ytYr0zRy+ZCpAq5UnVkh
        qPv08yIh/5Rf8xRgFjElDb807lAlGju2sVKn3xN6yQ==
X-Google-Smtp-Source: APXvYqzQpfWSWht2AsmDB2uHaiszhuxs88LR7mPSu6VSKvyO2MAlyzIQvfINY/+/sMaehSvr/ao1iKhlBnfVVXZebDI=
X-Received: by 2002:ac2:54b4:: with SMTP id w20mr352825lfk.67.1578418721583;
 Tue, 07 Jan 2020 09:38:41 -0800 (PST)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 7 Jan 2020 23:08:30 +0530
Message-ID: <CA+G9fYvMX4gMi6hmTmukzgr1xPsoJsj0WTm=AS3hC5Mq-dLvsQ@mail.gmail.com>
Subject: Re: dma-direct: don't check swiotlb=force in dma_direct_map_resource
To:     hch@lst.de, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     robin.murphy@arm.com, m.szyprowski@samsung.com,
        linux- stable <stable@vger.kernel.org>,
        iommu@lists.linux-foundation.org,
        open list <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        lkft-triage@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Following build error on stable-rc 5.4.9-rc1 for arm architecture.

dma/direct.c: In function 'dma_direct_possible':
dma/direct.c:329:3: error: too many arguments to function 'dma_capable'
   dma_capable(dev, dma_addr, size, true);
   ^~~~~~~~~~~
In file included from
/srv/oe/build/tmp-lkft-glibc/work-shared/am57xx-evm/kernel-source/include/linux/dma-direct.h:12:0,
                 from
/srv/oe/build/tmp-lkft-glibc/work-shared/am57xx-evm/kernel-source/kernel/dma/direct.c:10:
/srv/oe/build/tmp-lkft-glibc/work-shared/am57xx-evm/kernel-source/arch/arm/include/asm/dma-direct.h:17:20:
note: declared here
 static inline bool dma_capable(struct device *dev, dma_addr_t addr,
size_t size)
                    ^~~~~~~~~~~
In file included from
/srv/oe/build/tmp-lkft-glibc/work-shared/am57xx-evm/kernel-source/include/linux/init.h:5:0,
                 from
/srv/oe/build/tmp-lkft-glibc/work-shared/am57xx-evm/kernel-source/include/linux/memblock.h:12,
                 from
/srv/oe/build/tmp-lkft-glibc/work-shared/am57xx-evm/kernel-source/kernel/dma/direct.c:7:
dma/direct.c: In function 'dma_direct_map_resource':
dma/direct.c:378:16: error: too many arguments to function 'dma_capable'
  if (unlikely(!dma_capable(dev, dma_addr, size, false))) {
                ^
/srv/oe/build/tmp-lkft-glibc/work-shared/am57xx-evm/kernel-source/include/linux/compiler.h:78:42:
note: in definition of macro 'unlikely'
 # define unlikely(x) __builtin_expect(!!(x), 0)
                                          ^
In file included from
/srv/oe/build/tmp-lkft-glibc/work-shared/am57xx-evm/kernel-source/include/linux/dma-direct.h:12:0,
                 from
/srv/oe/build/tmp-lkft-glibc/work-shared/am57xx-evm/kernel-source/kernel/dma/direct.c:10:
/srv/oe/build/tmp-lkft-glibc/work-shared/am57xx-evm/kernel-source/arch/arm/include/asm/dma-direct.h:17:20:
note: declared here
 static inline bool dma_capable(struct device *dev, dma_addr_t addr,
size_t size)
                    ^~~~~~~~~~~
/srv/oe/build/tmp-lkft-glibc/work-shared/am57xx-evm/kernel-source/scripts/Makefile.build:265:
recipe for target 'kernel/dma/direct.o' failed

Full build log link,
https://ci.linaro.org/view/lkft/job/openembedded-lkft-linux-stable-rc-5.4/DISTRO=lkft,MACHINE=am57xx-evm,label=docker-lkft/44/consoleText

-- 
Linaro LKFT
https://lkft.linaro.org

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8258568DEDE
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 18:27:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231181AbjBGR1c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 12:27:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230180AbjBGR1c (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 12:27:32 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E851715C97
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 09:26:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675790800;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A1UvW0wrHQWigj5Ouf4r26jfQmoM0gSCL18qsIrw6jw=;
        b=Tg+ABsdA/fzxLjz8Cr4uPoSxLllQFadiTYTzmMGpJlK0Mm9TDkYirnTzSpaXG3ZPWlCrli
        apvov+TXEJ3BipvBGmpbItA66toNGzm5MAVjjVx9jh9cAZM+4Ff4xSqkl0LC30l/rqgxAu
        C+VXB8xZG7K5gLJy4Pt8OuzDR8xRRWA=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-153-upacRr_GNeib2FSnZ6FB8w-1; Tue, 07 Feb 2023 12:26:36 -0500
X-MC-Unique: upacRr_GNeib2FSnZ6FB8w-1
Received: by mail-qt1-f198.google.com with SMTP id f22-20020a05622a1a1600b003b8674f2302so8946963qtb.7
        for <stable@vger.kernel.org>; Tue, 07 Feb 2023 09:26:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A1UvW0wrHQWigj5Ouf4r26jfQmoM0gSCL18qsIrw6jw=;
        b=H4mlkqY0RDqbjYsSrqBa9FOsg20aLu3yWbJ0dCsPuXZAx7vPbnSDOhFOit3xbSTSln
         G2qsyb7H3zhSNeJGeGHUEepQN6IUqc1MdljLD1yWbA2jtjfCfMyQy/C13jVmLEHCvqaa
         cgDSFPrnO+pRxEt2SRCQeb9vEFGzggCYHX0/rWxVKKiiEXjrHLtR7q/cR49zKO4AlIp4
         a8dsXwZDt19RLSPdPvDN8fKZEpX8Qqai06hb36VmBhW4dfSM99lxeox09YSFpq98aHpa
         +YDZfoJ5y+8+TPryKxLxjbhhJW0AhrP5BwkXU6JPc81yITdNg1hQ7XPSuhGw4K84bgXO
         L/hg==
X-Gm-Message-State: AO0yUKVWeeDRV2VsQAnqsbPeiN1aYCcSN3fGV2q1U0kAenVTpTA+6R28
        WN4K2mbjx5wsBGx3afullDv2LJ4h2HkXjvlovquWYYSsWPL0FOcwo/Q/xtn8o67Dc+f2YcZLDyS
        sL444qyG4CYup3Rh4
X-Received: by 2002:ac8:5f4a:0:b0:3b8:6801:90b3 with SMTP id y10-20020ac85f4a000000b003b8680190b3mr8018603qta.0.1675790796169;
        Tue, 07 Feb 2023 09:26:36 -0800 (PST)
X-Google-Smtp-Source: AK7set+G8xGUvyalZMLlK6nlAAPgyJL+bwcDkz+CtGrVcO3QWHRQv0maEwKkbLk5D0mzcwb/8BJN8A==
X-Received: by 2002:ac8:5f4a:0:b0:3b8:6801:90b3 with SMTP id y10-20020ac85f4a000000b003b8680190b3mr8018567qta.0.1675790795820;
        Tue, 07 Feb 2023 09:26:35 -0800 (PST)
Received: from x1n (bras-base-aurron9127w-grc-56-70-30-145-63.dsl.bell.ca. [70.30.145.63])
        by smtp.gmail.com with ESMTPSA id j24-20020a37ef18000000b0072396cb73cdsm9781553qkk.13.2023.02.07.09.26.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Feb 2023 09:26:35 -0800 (PST)
Date:   Tue, 7 Feb 2023 12:26:33 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Jann Horn <jannh@google.com>,
        Anders Roxell <anders.roxell@linaro.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH 6.1 000/208] 6.1.11-rc1 review
Message-ID: <Y+KJyTsiio0XMQJ+@x1n>
References: <20230207125634.292109991@linuxfoundation.org>
 <CA+G9fYtgJX507GJ3fG7-G+vGhG4BnU=kzu3fOH_a-_aMU0S_0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYtgJX507GJ3fG7-G+vGhG4BnU=kzu3fOH_a-_aMU0S_0w@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 07, 2023 at 10:35:19PM +0530, Naresh Kamboju wrote:
> On Tue, 7 Feb 2023 at 18:29, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 6.1.11 release.
> > There are 208 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu, 09 Feb 2023 12:55:54 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.11-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> Results from Linaro’s test farm.
> Following build regressions noticed while building
> selftests/vm/hugetlb-madvise.c
> with kselftest-merge configs.
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> Build errors:
> ----------
> hugetlb-madvise.c:242:13: warning: implicit declaration of function
> 'fallocate'; did you mean 'alloca'? [-Wimplicit-function-declaration]
>   242 |         if (fallocate(fd, 0, 0, NR_HUGE_PAGES * huge_page_size)) {
>       |             ^~~~~~~~~
>       |             alloca
> hugetlb-madvise.c:289:27: error: 'FALLOC_FL_PUNCH_HOLE' undeclared
> (first use in this function)
>   289 |         if (fallocate(fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
>       |                           ^~~~~~~~~~~~~~~~~~~~
> hugetlb-madvise.c:289:27: note: each undeclared identifier is reported
> only once for each function it appears in
> hugetlb-madvise.c:289:50: error: 'FALLOC_FL_KEEP_SIZE' undeclared
> (first use in this function)
>   289 |         if (fallocate(fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
>       |                                                  ^~~~~~~~~~~~~~~~~~~
> make[3]: *** [../lib.mk:145:
> /home/tuxbuild/.cache/tuxmake/builds/1/build/kselftest/vm/hugetlb-madvise]
> Error 1
> 
> Build log:
> https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc/-/jobs/3728198425#L1676
> https://storage.tuxsuite.com/public/linaro/lkft/builds/2LPeQeCIu0YEfltwqAFCvDaj29A/

I think we should drop the patch "[PATCH 6.1 012/208] selftests/vm: remove
__USE_GNU in hugetlb-madvise.c" from this merge.

That patch fixes commit 62f33fa22800 ("selftests/vm: use memfd for
hugetlb-madvise test"), but that's only in 6.2-rc1 and it's not in 6.1.

I don't really know why it got picked for 6.1 stable backport, because the
original patch doesn't contain "CC: stable".

Thanks,

-- 
Peter Xu


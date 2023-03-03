Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDBA56A921E
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 09:05:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbjCCIFQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 03:05:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbjCCIFP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 03:05:15 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EF141554D
        for <stable@vger.kernel.org>; Fri,  3 Mar 2023 00:04:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677830662;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s8QnxRpYQPEiLn8XmuErYmk8O10pIsFngcfQcnQ90xY=;
        b=NXlQAWcllUXRV1QijanlvM1TiCDCYlvyN6FQxtyWmG3ddp5Z9tJGors4QRIeS7ek02sFqx
        kJejqQChdpAvAi44PsF+c09Fd3UcqOyIOTn2uwQpagbzIwuXDWhkmMC77rbbcZvLdoYFfm
        4OIAP27l4a4CPDsNmldbpx2FvnQ5tSA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-482-OkJRvxfpMzW2qsU-WPJv6A-1; Fri, 03 Mar 2023 03:04:20 -0500
X-MC-Unique: OkJRvxfpMzW2qsU-WPJv6A-1
Received: by mail-wm1-f69.google.com with SMTP id l20-20020a05600c1d1400b003e10d3e1c23so2475511wms.1
        for <stable@vger.kernel.org>; Fri, 03 Mar 2023 00:04:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677830659;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=s8QnxRpYQPEiLn8XmuErYmk8O10pIsFngcfQcnQ90xY=;
        b=qjkk1qAC0NnfC6WolOEuJ8IMONxmE9RV36sBJDlGQJbN38XPXc3go2o0xWpoNuRJOn
         1DJ2/yOVAgu0W2LaI1spO5s/bSDURrmiJURpxBK3YfgcSbsnM8Olwo23GYOO8EM96sGN
         f3aGP+q8l1ybYtj46LTs+V6FvsBS7Ef80CRBy6G6i6eeebMX/qLYeSjb/OHtRbNYO/D/
         x/8LekjWQtwSw/3b9S0QlESL1APASFTQKyExuY49o7Gll7z26yWwwvBlxMDp+VkKPUOn
         0bCQdSfKQU44t5kFTHuf2f/8mpcVhVd3upD2mNJCYmbT4BrwHsBfUsKVtY7I5Kd8R5sj
         kfWw==
X-Gm-Message-State: AO0yUKVhpAxdbS1bDKxH7rbzjCrpbw4Hui5I2z3V2E4LzM5ivlx6Qvgc
        wL3NCXIPqTFZzNZYCMuBxdh5j8I3Vetkxe9W0ohMGnm119432EXHtTm7xCftYIyHL327bdLvsyk
        Zbdyekedr9Oo2uQ1C
X-Received: by 2002:a05:600c:3ac8:b0:3db:2922:2b99 with SMTP id d8-20020a05600c3ac800b003db29222b99mr788306wms.4.1677830658950;
        Fri, 03 Mar 2023 00:04:18 -0800 (PST)
X-Google-Smtp-Source: AK7set/BXLT+lMpnyKVQLibkm04GCkyPcxM5MUEDfKB9hdx14azQTgROHFPeVko3IYxqiAwD1NbohQ==
X-Received: by 2002:a05:600c:3ac8:b0:3db:2922:2b99 with SMTP id d8-20020a05600c3ac800b003db29222b99mr788279wms.4.1677830658649;
        Fri, 03 Mar 2023 00:04:18 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-121-8.dyn.eolo.it. [146.241.121.8])
        by smtp.gmail.com with ESMTPSA id v16-20020a05600c471000b003e9ded91c27sm5848475wmo.4.2023.03.03.00.04.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 00:04:18 -0800 (PST)
Message-ID: <9586d0f99e27483b600d8eb3b5c6635b50905d82.camel@redhat.com>
Subject: Re: [PATCH 6.1 00/42] 6.1.15-rc1 review
From:   Paolo Abeni <pabeni@redhat.com>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
        mptcp@lists.linux.dev, Florian Westphal <fw@strlen.de>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Anders Roxell <anders.roxell@linaro.org>
Date:   Fri, 03 Mar 2023 09:04:15 +0100
In-Reply-To: <CA+G9fYsn+AhWTFA+ZJmfFsM71WGLPOFemZp_vhFMMLUcgcAXKg@mail.gmail.com>
References: <20230301180657.003689969@linuxfoundation.org>
         <CA+G9fYtDGpgT4dckXD-y-N92nqUxuvue_7AtDdBcHrbOMsDZLg@mail.gmail.com>
         <ZAB6pP3MNy152f+7@kroah.com>
         <CA+G9fYsHbQyQFp+vMnmFKDSQxrmj-VKsexWq-aayxgrY+0O7KQ@mail.gmail.com>
         <CA+G9fYsn+AhWTFA+ZJmfFsM71WGLPOFemZp_vhFMMLUcgcAXKg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

On Fri, 2023-03-03 at 01:32 +0530, Naresh Kamboju wrote:
> On Thu, 2 Mar 2023 at 16:30, Naresh Kamboju <naresh.kamboju@linaro.org> w=
rote:
> >=20
> > On Thu, 2 Mar 2023 at 16:00, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >=20
> > > On Thu, Mar 02, 2023 at 03:49:31PM +0530, Naresh Kamboju wrote:
> > > > On Wed, 1 Mar 2023 at 23:42, Greg Kroah-Hartman
> > > > <gregkh@linuxfoundation.org> wrote:
> > > > >=20
> > > > > This is the start of the stable review cycle for the 6.1.15 relea=
se.
> > > > > There are 42 patches in this series, all will be posted as a resp=
onse
> > > > > to this one.  If anyone has any issues with these being applied, =
please
> > > > > let me know.
> > > > >=20
> > > > > Responses should be made by Fri, 03 Mar 2023 18:06:43 +0000.
> > > > > Anything received after that time might be too late.
> > > > >=20
> > > > > The whole patch series can be found in one patch at:
> > > > >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-revie=
w/patch-6.1.15-rc1.gz
> > > > > or in the git tree and branch at:
> > > > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linu=
x-stable-rc.git linux-6.1.y
> > > > > and the diffstat can be found below.
> > > > >=20
> > > > > thanks,
> > > > >=20
> > > > > greg k-h
> > > >=20
> > > > Regression found on Linux version 6.1.15-rc1 on 32-bit arm x15 and =
i386.
> > > >=20
> > > > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> > > >=20
> > > > ## Build
> > > > * kernel: 6.1.15-rc1
> > > > * git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-r=
c
> > > > * git branch: linux-6.1.y
> > > > * git commit: b6150251d4ddf8a80510c185d839631e252e6317
> > > > * git describe: v6.1.14-43-gb6150251d4dd
> > > > * test details:
> > > > https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/buil=
d/v6.1.14-43-gb6150251d4dd
> > > >=20
> > > > Regression test cases,
> > > > i386:
> > > > x15:
> > > >   * kselftest-net-mptcp/net_mptcp_mptcp_sockopt_sh
> > > >=20
> > > > # mptcp_sockopt: mptcp_sockopt.c:353: do_getsockopt_tcp_info:
> > > > Assertion `ti.d.size_user =3D=3D sizeof(struct tcp_info)' failed.
> > > > # mptcp_sockopt: mptcp_sockopt.c:353: do_getsockopt_tcp_info:
> > > > Assertion `ti.d.size_user =3D=3D sizeof(struct tcp_info)' failed.
> > > >=20
> > > > test log:
> > > > ----------
> > > >=20
> > > > # selftests: net/mptcp: mptcp_sockopt.sh
> >=20
> > ....
> >=20
> > > Nit, wrapping a log like this makes it hard to read, don't you think?
> >=20
> > Me either.
> > That is the reason I have shared "Assertion" above.
> >=20
> > >=20
> > > > # mptcp_sockopt: mptcp_sockopt.c:353: do_getsockopt_tcp_info:
> > > > Assertion `ti.d.size_user =3D=3D sizeof(struct tcp_info)' failed.
> > > > # server killed by signal 6
> > > > #
> > > > # FAIL: SOL_MPTCP getsockopt
> > > > # PASS: TCP_INQ cmsg/ioctl -t tcp
> > > > # PASS: TCP_INQ cmsg/ioctl -6 -t tcp
> > > > # PASS: TCP_INQ cmsg/ioctl -r tcp
> > > > # PASS: TCP_INQ cmsg/ioctl -6 -r tcp
> > > > # PASS: TCP_INQ cmsg/ioctl -r tcp -t tcp
> > > > not ok 6 selftests: net/mptcp: mptcp_sockopt.sh # exit=3D1
> > >=20
> > > Any chance you can bisect?
> >=20
> > We are running our bisection scripts.
>=20
> We have tested with 6.1.14 kselftests source again and it passes.
> Now that we have upgraded to 6.2.1 kselftests source, we find that
> there is this problem reported. so, not a kernel regression.

I read the above as you are running self-tests from 6.2.1 on top of an
older (6.1) kernel. Is that correct? If so failures are expected;
please use the self-tests and kernel from the same release.

Otherwise, could you please re-phrase the above?

Thanks,

Paolo



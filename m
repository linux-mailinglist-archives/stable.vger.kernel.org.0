Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7733D6A9761
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 13:42:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbjCCMl7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 07:41:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbjCCMl6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 07:41:58 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ABF25C131
        for <stable@vger.kernel.org>; Fri,  3 Mar 2023 04:41:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677847268;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FepeFCltrr6Y6adbFfF6ozHOJLVN2784TOOqblo8G3c=;
        b=Lcf1uUZz8KkgL9RDOAl7ULD6gXigtr4zdbUlbqNl1Ym8ViPdv7HVN3TtPmlvhniiFAeXvk
        5CPcFT/v7O7KZkaEO7yl4VsIlb13bBe71xI90b4OgVGvhaszlE5lTWmeGTFLsJ4vDluzzf
        X7KquPU5cFaDZuGVi7xqXzbQfm/qQZs=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-639-aOivSMdeNn-dS3iLyR3mrg-1; Fri, 03 Mar 2023 07:41:07 -0500
X-MC-Unique: aOivSMdeNn-dS3iLyR3mrg-1
Received: by mail-qt1-f199.google.com with SMTP id l2-20020ac87242000000b003bfecc6d046so1391193qtp.17
        for <stable@vger.kernel.org>; Fri, 03 Mar 2023 04:41:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677847266;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FepeFCltrr6Y6adbFfF6ozHOJLVN2784TOOqblo8G3c=;
        b=DNwiviCOORHBr2SDPCEe99Ctg8FA+CMyNI7cH689vf4FeZ3q0mpnoli8rJggp2ttSd
         uSVvlpxFZQAJRH5Ld+Aio+tjz5BZMgN+hDgscc2PlMn+eXKXgkDzseRjYodkLZdUQlV3
         QhLn/9CqUgds9NQjMK+ybQn4gDCVEt+Ujg33NR+m6F5kCOz7vg/3VevkoA4TniQ7wn1+
         1e09CAknuLXdIp9nNO47z++dGMlnID8fNXfMedJue/S/DfB+OvsyxDcMa9A6wOdaRLiu
         9d7ucuBA51TLFdGyfVLYJpPOnMCk5lIXNuRVdbFR1rZvCCxV0NcWmg8XWQnRtO8hycdn
         n7IA==
X-Gm-Message-State: AO0yUKX99yPj5sgBqi70fJzqfVV1cFiuG/iZxC6xwdNsEMd/RJ/L7aAI
        RMWDL70waLvUQouYJwSfe+bLbxu/LWrG26uXPRipWu4W585xn3Lr788CxIKi0sFcMRwD/Hce5zQ
        oSpNaxP+rbKics+PUR4GJ1Q==
X-Received: by 2002:a0c:dd94:0:b0:572:54c1:c14e with SMTP id v20-20020a0cdd94000000b0057254c1c14emr1924517qvk.5.1677847266312;
        Fri, 03 Mar 2023 04:41:06 -0800 (PST)
X-Google-Smtp-Source: AK7set/FBxS/cUG+PDkuwIhgP84j9mKZaexu2RFQNHEszy7xrIX+bUBvWrgOvHDO1VJWm6twPe6o2g==
X-Received: by 2002:a0c:dd94:0:b0:572:54c1:c14e with SMTP id v20-20020a0cdd94000000b0057254c1c14emr1924493qvk.5.1677847266015;
        Fri, 03 Mar 2023 04:41:06 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-121-8.dyn.eolo.it. [146.241.121.8])
        by smtp.gmail.com with ESMTPSA id r145-20020a37a897000000b0073b69922cfesm1639351qke.85.2023.03.03.04.41.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 04:41:05 -0800 (PST)
Message-ID: <d593e9434dba16a869ec48fcdfe8a3fe540c8a82.camel@redhat.com>
Subject: Re: [PATCH 6.1 00/42] 6.1.15-rc1 review
From:   Paolo Abeni <pabeni@redhat.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>, stable@vger.kernel.org,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de, mptcp@lists.linux.dev,
        Florian Westphal <fw@strlen.de>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Anders Roxell <anders.roxell@linaro.org>
Date:   Fri, 03 Mar 2023 13:41:00 +0100
In-Reply-To: <ZAHdrhY2P+sBI+xX@kroah.com>
References: <20230301180657.003689969@linuxfoundation.org>
         <CA+G9fYtDGpgT4dckXD-y-N92nqUxuvue_7AtDdBcHrbOMsDZLg@mail.gmail.com>
         <ZAB6pP3MNy152f+7@kroah.com>
         <CA+G9fYsHbQyQFp+vMnmFKDSQxrmj-VKsexWq-aayxgrY+0O7KQ@mail.gmail.com>
         <CA+G9fYsn+AhWTFA+ZJmfFsM71WGLPOFemZp_vhFMMLUcgcAXKg@mail.gmail.com>
         <9586d0f99e27483b600d8eb3b5c6635b50905d82.camel@redhat.com>
         <CA+G9fYuLQEfeTjx52NxbXV5914YJQ2tVd8k4SJjrAryujPjnqA@mail.gmail.com>
         <ZAG8dla274kYfxoK@kroah.com>
         <28afc90c1b8b51a36ced5b6026d1a64aeb7c0b14.camel@redhat.com>
         <ZAHdrhY2P+sBI+xX@kroah.com>
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

On Fri, 2023-03-03 at 12:44 +0100, Greg Kroah-Hartman wrote:
> On Fri, Mar 03, 2023 at 12:39:07PM +0100, Paolo Abeni wrote:
> > Additionally, some self-tests check for known bugs/regressions. Running
> > them on older kernel will cause real trouble, and checking for bug
> > presence in the running kernel would be problematic at best, I think.
>=20
> No, not at all, why wouldn't you want to test for know bugs and
> regressions and fail?  That's a great thing to do, and so you will know
> to backport those bugfixes to those older kernels if you have to use
> them.

I'm sorry, I likely was not clear at all. What I mean is that the self-
test for a bug may trigger e.g. memory corruption on the bugged kernel
(or more specifically to networking, the infamous, recurring
"unregister_netdevice: waiting for ...") which in turn could cause
random failures later.

If that specific case runs on older (unpatched) kernel will screw the
overall tests results. The same could happen in less-detectable way for
old bugs non explicitly checked by any test, but still triggered by the
test-suite. As a consequence I expect that the results observed running
newer self-tests on older kernel are unreliable.=20

Cheers,

Paolo


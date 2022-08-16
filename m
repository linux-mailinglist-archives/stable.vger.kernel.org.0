Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AC08595A31
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 13:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234592AbiHPLce (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 07:32:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234512AbiHPLcK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 07:32:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B28AB2B183
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 03:50:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660647040;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=caYZO9Hy0M/4ZkMPcZbbnX8HmFvRuXemwyrp6mx94R8=;
        b=fFgVxNL7Pm7UEH99+U8A5EeoQDmbvboLzi9DzOcyIL03+rtUifXf00qTjwoavTZrf6j6Hs
        DtObPwNyDi2nlkaqQmYKk1MqKzpWAHcxowkNWA/LDtghayIP9JopTCkvd413yBBHJPchc2
        pWci8xvoZ2HAGmow4afjCVYAYW4gsQ8=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-497-zZRNfp5gMb-1ru7Bt4uVTQ-1; Tue, 16 Aug 2022 06:50:39 -0400
X-MC-Unique: zZRNfp5gMb-1ru7Bt4uVTQ-1
Received: by mail-pg1-f197.google.com with SMTP id q193-20020a632aca000000b0041d95d7ee81so3756896pgq.3
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 03:50:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=caYZO9Hy0M/4ZkMPcZbbnX8HmFvRuXemwyrp6mx94R8=;
        b=I0J15LeK6yen0Gl1jX/aa4x53CWVfhyD4ktn6vlUkUqzP7chRiXn3Oz/cO6+7jBfnT
         zMU0ElGaO3w7j0vvGnxj8krQGx2RZgVq2yEHfp0twiYxM0fWGzQEyTA2PQuDoSaM806J
         256GDpAnu1nNwvaQ1ZqXdfN4iubsFGIfPOcOvmgEWsMfXFOo36GdFwWXFcDfu8UHs2vS
         5/LD5UhUbvahHWZ3PN9e/PxcNa4QJv1uK3gLU0UK6oHcjXZSolTviMQAzKSdCbCJyARM
         hs+Ku2y2LPMIhxddcSin4Z7S35ougzJLqOiDoA6dhnAiV9KKe05MYjGNSEzmcbIeadQj
         eO5w==
X-Gm-Message-State: ACgBeo3rpqOwRCIsGburSlb+xmeSnUJa9KwCTP6k0r6mOWnbmh/osgPF
        NQwv9iqFcTjvFQl2eN1wMnjCD6ca9WYJUCVbhqTyz3wVPCIsvfyPUyvgDWft8AcOWPpZjXB92mM
        rwzNYsqh7FSLnDkQW
X-Received: by 2002:a05:6a00:2446:b0:528:5f22:5b6f with SMTP id d6-20020a056a00244600b005285f225b6fmr20929864pfj.73.1660647038388;
        Tue, 16 Aug 2022 03:50:38 -0700 (PDT)
X-Google-Smtp-Source: AA6agR51yTgk5jUVGj6/Aw6G8JkIiwNEr4o/d3erGqUtLA1WoqisXJ3ZJgAkSF5xRTSIFpKRHaNSHQ==
X-Received: by 2002:a05:6a00:2446:b0:528:5f22:5b6f with SMTP id d6-20020a056a00244600b005285f225b6fmr20929845pfj.73.1660647038109;
        Tue, 16 Aug 2022 03:50:38 -0700 (PDT)
Received: from localhost ([240e:3a1:2ea:acc0:8cff:e01c:2dbf:2ae8])
        by smtp.gmail.com with ESMTPSA id u13-20020a170903124d00b0016c1e006b63sm8912983plh.64.2022.08.16.03.50.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 03:50:37 -0700 (PDT)
Date:   Tue, 16 Aug 2022 18:45:59 +0800
From:   Coiby Xu <coxu@redhat.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     bhe@redhat.com, msuchanek@suse.de, will@kernel.org,
        zohar@linux.ibm.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] arm64: kexec_file: use more system
 keyrings to verify kernel" failed to apply to 5.19-stable tree
Message-ID: <20220816104559.xwovh5y4bcx6n37a@Rk>
References: <166057758347124@kroah.com>
 <20220816063256.qzc6jh744i2zc6ou@Rk>
 <YvtOfWDg2SXdcqgL@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <YvtOfWDg2SXdcqgL@kroah.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 16, 2022 at 09:59:57AM +0200, Greg KH wrote:
>On Tue, Aug 16, 2022 at 02:32:56PM +0800, Coiby Xu wrote:
>> Hi Greg,
>>
>> Good to see you here:)
>>
>> On Mon, Aug 15, 2022 at 05:33:03PM +0200, gregkh@linuxfoundation.org wrote:
>> >
>> > The patch below does not apply to the 5.19-stable tree.
>> > If someone wants it applied there, or to any other stable or longterm
>> > tree, then please email the backport, including the original git commit
>> > id to <stable@vger.kernel.org>.
>> >
>> > thanks,
>> >
>> > greg k-h
>> >
>> > ------------------ original commit in Linus's tree ------------------
>> >
>> > > From 0d519cadf75184a24313568e7f489a7fc9b1be3b Mon Sep 17 00:00:00 2001
>> > From: Coiby Xu <coxu@redhat.com>
>> > Date: Thu, 14 Jul 2022 21:40:26 +0800
>> > Subject: [PATCH] arm64: kexec_file: use more system keyrings to verify kernel
>> > image signature
>> >
>> > Currently, when loading a kernel image via the kexec_file_load() system
>> > call, arm64 can only use the .builtin_trusted_keys keyring to verify
>> > a signature whereas x86 can use three more keyrings i.e.
>> > .secondary_trusted_keys, .machine and .platform keyrings. For example,
>> > one resulting problem is kexec'ing a kernel image  would be rejected
>> > with the error "Lockdown: kexec: kexec of unsigned images is restricted;
>> > see man kernel_lockdown.7".
>> >
>> > This patch set enables arm64 to make use of the same keyrings as x86 to
>> > verify the signature kexec'ed kernel image.
>> >
>> > Fixes: 732b7b93d849 ("arm64: kexec_file: add kernel signature verification support")
>> > Cc: stable@vger.kernel.org # 105e10e2cf1c: kexec_file: drop weak attribute from functions
>
>This is not a valid commit id in Linus's tree.
>
>> > Cc: stable@vger.kernel.org # 34d5960af253: kexec: clean up arch_kexec_kernel_verify_sig
>
>This is not a valid commit id in Linus's tree
>
>> > Cc: stable@vger.kernel.org # 83b7bb2d49ae: kexec, KEYS: make the code in bzImage64_verify_sig generic
>
>And this too is not a valid commit in Linus's tree.

Sorry for the confusion. The correct commit ids are as follows,

0738eceb6201 ("kexec: drop weak attribute from functions")
689a71493bd2 ("kexec: clean up arch_kexec_kernel_verify_sig")
c903dae8941d ("kexec, KEYS: make the code in bzImage64_verify_sig generic")

>
>>
>> I've added the above three patch prerequisites following [1]. I assume
>> there is a program automatically picking up this patch. But somehow it
>> fails to pick up the prerequisites first. Is it because the commit ids
>> change when the patches are finally applied to Linus's tree?
>
>Where did you get those commit ids from?

I got the commit ids when rebasing the patches onto the then latest
Linus tree or next-integrity tree.

>
>> If it's
>> true, how do we make sure the we have the correct commit ids? Note [1]
>> strongly recommends "Cc: stable@vger.kernel.org" to submit patches to
>> stable tree but it seems there is no way to know beforehand the correct
>> commit ids of the prerequisites that are yet to arrive in Linus's tree.
>
>Hopefully the git ids can be stable when they are merged to a
>maintainer's tree.  

I notice the commit ids of these patches in current next-integrity tree
are still different from Linus's tree. It seems there is no way to avoid
manually backporting a patch for similar cases unless the commit ids are
automatically fixed when Linus merges the patch or we could match a
commit by its subject.

> If not, then you can respond to this "failed" email
>with the full series of what needs to be done here, as I have no idea :(

Sure, I'll email the backport to stable@vger.kernel.org as the response
to this "failed" email.   

>
>thanks,
>
>greg k-h
>

-- 
Best regards,
Coiby


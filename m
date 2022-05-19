Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F09952DADF
	for <lists+stable@lfdr.de>; Thu, 19 May 2022 19:11:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242385AbiESRJD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 May 2022 13:09:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242375AbiESRI7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 May 2022 13:08:59 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 637549C2CF
        for <stable@vger.kernel.org>; Thu, 19 May 2022 10:08:58 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id b32so7010590ljf.1
        for <stable@vger.kernel.org>; Thu, 19 May 2022 10:08:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=21mvYV5KsNhLdpPcuH1GIlGrU0ZXZUibbxP2zX1vM6A=;
        b=n7z9pdTLw0VPyn2sJHa76u+47Fp2xaqLX6Kz0ujm6KegmVNUpVtZlMipOac9bgwEP2
         QXGr0cCwCzAOqvIYPQV85aa4Sz8KoOhDQZe6NitEg9/atZ+nDHIpRfUDb32PMhaVxNuF
         2/oJIuFAl9BsyDzdDZ9lYSfF4FNl++8+wo//Io1KaWEkNHs+hsWAx/+xMGKsav9FLyZx
         XczrNpN6Lld3vCqNQdaTkAOWo+1uOR0XmJs6uiNCV0aUwDlQLuj06IihBB/+fZ69EN+v
         HqzMyrFnwAC85q00F7wKhgKbODZyVNCrL+CfuPinTFbfcAV6jnJSLxKm0D6bl0g52txx
         2LfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=21mvYV5KsNhLdpPcuH1GIlGrU0ZXZUibbxP2zX1vM6A=;
        b=IhScjYFUK5yJGSZV90H9Dmt5NW95Ih11PAAzgURQdFeVBLjhOr65ll1/+8hBk3Xebx
         YqXR2K9BRqwK+GO5Zavr86uuPdG5R8VbtQUUEwEXY/xyPp58gjWWD70hnqHhfjLAOVms
         sJm+tkk9YSep8GTVt7dfQ5N44JehMI19fGNuJhsnR6B8Ny90BmHEgJn3glzcyyZgJi57
         cJMLTQf0w70w1w+d8H/Nd6gxAc3SmBlMJDuMq8uOZyQGiJVzJdVL+MSU5K3BT4rW8LJG
         VxEixWpG0H1va7WPPEX876RiV3ZRvD8wshg2v2k9E0ynsd0OXp8wmqyLXU2RF0/66mkF
         37HQ==
X-Gm-Message-State: AOAM530U/zRhVupG7MU2CTjPRJUwY3ormLaZl8/TUPDR7RVU+rozPdMJ
        W50dkgsmvlW22bpH5emKwyjzGy8RP2nXaCrNoU9WhA==
X-Google-Smtp-Source: ABdhPJypQznhdYDrBWrI2knSCpm36AytBgzL26mBsBu+Qp3cJuDwxjZOy2p+xjprBiYifTLB8APd1ij8kMXq6014WRA=
X-Received: by 2002:a2e:2e0f:0:b0:253:cc64:f47c with SMTP id
 u15-20020a2e2e0f000000b00253cc64f47cmr3301910lju.426.1652980136504; Thu, 19
 May 2022 10:08:56 -0700 (PDT)
MIME-Version: 1.0
References: <20220516154310.3685678-1-Ashish.Kalra@amd.com>
In-Reply-To: <20220516154310.3685678-1-Ashish.Kalra@amd.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Thu, 19 May 2022 10:08:44 -0700
Message-ID: <CAMkAt6r8yaiL38AqZWpbe=UT_MAV8fuOSvPCLJBAsT9pisf2tg@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: SVM: Use kzalloc for sev ioctl interfaces to
 prevent kernel memory leak.
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        Borislav Petkov <bp@alien8.de>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andy Nguyen <theflow@google.com>,
        David Rientjes <rientjes@google.com>,
        John Allen <john.allen@amd.com>, stable@vger.kernel.org,
        Michael Roth <michael.roth@amd.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 16, 2022 at 8:43 AM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
>
> From: Ashish Kalra <ashish.kalra@amd.com>
>
> For some sev ioctl interfaces, the length parameter that is passed maybe
> less than or equal to SEV_FW_BLOB_MAX_SIZE, but larger than the data
> that PSP firmware returns. In this case, kmalloc will allocate memory
> that is the size of the input rather than the size of the data.
> Since PSP firmware doesn't fully overwrite the allocated buffer, these
> sev ioctl interface may return uninitialized kernel slab memory.
>
> Reported-by: Andy Nguyen <theflow@google.com>
> Suggested-by: David Rientjes <rientjes@google.com>
> Suggested-by: Peter Gonda <pgonda@google.com>
> Cc: kvm@vger.kernel.org
> Cc: stable@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Fixes: eaf78265a4ab3 ("KVM: SVM: Move SEV code to separate file")
> Fixes: 2c07ded06427d ("KVM: SVM: add support for SEV attestation command")
> Fixes: 4cfdd47d6d95a ("KVM: SVM: Add KVM_SEV SEND_START command")
> Fixes: d3d1af85e2c75 ("KVM: SVM: Add KVM_SEND_UPDATE_DATA command")
> Fixes: eba04b20e4861 ("KVM: x86: Account a variety of miscellaneous allocations")
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>

Reviewed-by: Peter Gonda <pgonda@google.com>

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD072528BA7
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 19:13:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239210AbiEPRNW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 13:13:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343979AbiEPRNV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 13:13:21 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D1AE31DC8
        for <stable@vger.kernel.org>; Mon, 16 May 2022 10:13:19 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id a23so10843861ljd.9
        for <stable@vger.kernel.org>; Mon, 16 May 2022 10:13:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=lnCWwgYB3EALSRrRxrjPf1n9pXx9oCWVrfYCKzTAm98=;
        b=LRFEmYRBoMXSpZQdOYrb+Vu4h9LTz3chVOrf4UH1KxU8nXFyvtdMu7pVYlJFVaoA28
         vs10OOM/ZkZJYcxCryBaEMCHKHw2HXej4fFw+R8g/vQH/Y/Hw3LQV3RMmnh/nFofdw5M
         QLRqxjoSob5cyi20+56fFxCYH2VhvI4CFdKx6uPeBLPJ0viAMHWjXbYBPZMeCTULCpIW
         3sbY5B7SkeYkKLThbwwHnq5GI1a/R5Ld6iVANi6Oe1cTdgoxY/kY2UvexkwLPJjyOMxx
         8+XHyuaZ3BAP1DLSkwbh/P94twlCLQHB3OWlK2ri1tNa2KSct7PeXJjhIyWc4rroM4L7
         pa5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=lnCWwgYB3EALSRrRxrjPf1n9pXx9oCWVrfYCKzTAm98=;
        b=4xrTQn6ih9nvvv4nViVtBshMFNEOPLU1rycQYjGythPItUhmjoxQs3XUfMoN6z8jmg
         gzlKIDXIaQuWiT4C4Q/WaoE95rhjAg23V/DSAdqhk40i1iHxPpQn/zJY2qB2CYiCX+Bh
         /rSOvM1cf780xpZa7hgxslhGIUAhjNjiwGgslqkeY525jdbfkmW79QMIug668NaOPQmF
         OuCN+CFEY1CKuvWnTiuXvWw733MKV0VJg9vOAcVciqUQC9joZnKZempDht1INIOf+61j
         7hBFW3HiR+gbEyvppxuzrQd+QFxbjcDFfSUeNNC44WUZHVbw9sdbu++ip7SZCjPq6kz5
         O7TA==
X-Gm-Message-State: AOAM531Xrynnim9bMPC/qu23CnSj26ZLPTKd2meflKN80MgbolFsekJe
        V/rQxVI29jKp5DyPneE2i3NJmcExHNdQWx9tFwJVcQ==
X-Google-Smtp-Source: ABdhPJzBEHVsSiNzP4zR1stWQaPZPEfQAH5aioIofZ5uwEr6EpYfJWDt/2/kOV8YEszOtT3ZZ/C/6598MObVeLWWWgY=
X-Received: by 2002:a2e:bd09:0:b0:24b:9e3:30c6 with SMTP id
 n9-20020a2ebd09000000b0024b09e330c6mr11544182ljq.282.1652721197296; Mon, 16
 May 2022 10:13:17 -0700 (PDT)
MIME-Version: 1.0
References: <20220516154512.259759-1-john.allen@amd.com> <CAMkAt6oUxUFtNS4W0bzu13oWMdfnzfNrphH3OqwAkmxJcXhOqw@mail.gmail.com>
 <SN6PR12MB27678261F176C5D9B5BF64EF8ECF9@SN6PR12MB2767.namprd12.prod.outlook.com>
In-Reply-To: <SN6PR12MB27678261F176C5D9B5BF64EF8ECF9@SN6PR12MB2767.namprd12.prod.outlook.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Mon, 16 May 2022 10:13:05 -0700
Message-ID: <CAMkAt6q7kTGS5QgZRq9xc0HaEYyntmj3GRWehr-3Sb4y2eQ=HQ@mail.gmail.com>
Subject: Re: [PATCH v2] crypto: ccp - Use kzalloc for sev ioctl interfaces to
 prevent kernel memory leak
To:     "Kalra, Ashish" <Ashish.Kalra@amd.com>
Cc:     "Allen, John" <John.Allen@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andy Nguyen <theflow@google.com>,
        David Rientjes <rientjes@google.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Mon, May 16, 2022 at 9:02 AM Kalra, Ashish <Ashish.Kalra@amd.com> wrote:
>
> [AMD Official Use Only - General]
>
> Hello Peter,
>
> -----Original Message-----
> From: Peter Gonda <pgonda@google.com>
> Sent: Monday, May 16, 2022 10:53 AM
> To: Allen, John <John.Allen@amd.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>; Linux Crypto Mailing List <=
linux-crypto@vger.kernel.org>; Sean Christopherson <seanjc@google.com>; Len=
dacky, Thomas <Thomas.Lendacky@amd.com>; Kalra, Ashish <Ashish.Kalra@amd.co=
m>; LKML <linux-kernel@vger.kernel.org>; Andy Nguyen <theflow@google.com>; =
David Rientjes <rientjes@google.com>; stable@vger.kernel.org
> Subject: Re: [PATCH v2] crypto: ccp - Use kzalloc for sev ioctl interface=
s to prevent kernel memory leak
>
> On Mon, May 16, 2022 at 8:46 AM John Allen <john.allen@amd.com> wrote:
> >
> > For some sev ioctl interfaces, input may be passed that is less than
> > or equal to SEV_FW_BLOB_MAX_SIZE, but larger than the data that PSP
> > firmware returns. In this case, kmalloc will allocate memory that is
> > the size of the input rather than the size of the data. Since PSP
> > firmware doesn't fully overwrite the buffer, the sev ioctl interfaces
> > with the issue may return uninitialized slab memory.
> >
> > Currently, all of the ioctl interfaces in the ccp driver are safe, but
> > to prevent future problems, change all ioctl interfaces that allocate
> > memory with kmalloc to use kzalloc.
> >
> > Fixes: e799035609e15 ("crypto: ccp: Implement SEV_PEK_CSR ioctl
> > command")
> > Fixes: 76a2b524a4b1d ("crypto: ccp: Implement SEV_PDH_CERT_EXPORT
> > ioctl command")
> > Fixes: d6112ea0cb344 ("crypto: ccp - introduce SEV_GET_ID2 command")
> > Cc: stable@vger.kernel.org
> > Reported-by: Andy Nguyen <theflow@google.com>
> > Suggested-by: David Rientjes <rientjes@google.com>
> > Suggested-by: Peter Gonda <pgonda@google.com>
> > Signed-off-by: John Allen <john.allen@amd.com>
> > ---
> > v2:
> >   - Add fixes tags and CC stable@vger.kernel.org
> > ---
>
>
> >static int sev_ioctl_do_platform_status(struct sev_issue_cmd *argp) { st=
ruct sev_user_data_status data; int ret;
>
> >ret =3D __sev_do_cmd_locked(SEV_CMD_PLATFORM_STATUS, &data, &argp->error=
); if (ret) return ret;
>
> >if (copy_to_user((void __user *)argp->data, &data, sizeof(data))) ret =
=3D -EFAULT;
>
> >return ret;
> >}
>
> >Would it be safer to memset @data here to all zeros too?
>
> It will be, but this command/function is safe as firmware will fill in th=
e whole buffer here with the PLATFORM STATUS data retuned to the user.

That does seem safe for now but I thought we decided it would be
prudent to not trust the PSPs implementation here and clear all the
buffers that eventually get sent to userspace?

>
> Thanks,
> Ashish

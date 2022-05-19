Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BA4052DAEC
	for <lists+stable@lfdr.de>; Thu, 19 May 2022 19:11:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242133AbiESRHT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 May 2022 13:07:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241173AbiESRHS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 May 2022 13:07:18 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30B129C2C7
        for <stable@vger.kernel.org>; Thu, 19 May 2022 10:07:17 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id v8so8285831lfd.8
        for <stable@vger.kernel.org>; Thu, 19 May 2022 10:07:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZBzTfN538cxBF+q89A7MrTkcGPI553HZ7cX5UmHJfys=;
        b=B0Mu/43QbEIOlNIrY4EF6Nu9VKILrU5jInF7PJeWChpZlGVenW1CcucpwyTj5xpz2Z
         9BJ8VarPMzBRSmVfD8oVbg/DS4cvoIHaMVke/ZWI+u8FNxumHWBcEMh/ifz4r4ArBK79
         Izlrm8gSFCMY8EWlqttn/m0VKTJSwQxlLFdSGF5hbCXUMDxPgMsCNPhE822mEGsihzm8
         hDh9a6GVpgmwYpOxpjwsuP1EDOlU/7NgPHLphuwnYICM27RfSisYO58bc6btroxc3Huo
         GuEdhFK/AkvX68eTJmt8Xa30n5AOBcNCA7Gbk2rXpO9NAyaZVuae9c8d3wt3brM04Xkv
         aKFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZBzTfN538cxBF+q89A7MrTkcGPI553HZ7cX5UmHJfys=;
        b=m1qjDryYE0Mz03433Y2fSphU5pLB3Dkq85ztG/q/DjVnGb9OQJsV+rbvme8apFAQt4
         uqfLSlrzItkGhhwxqagKesqv8wpz59jxqVkFK0y66yHebh4VoFvnHAAwV0XFngeNQfnw
         /hnu8PWhDib18o178utSokSczNaGH4bTq7jMgarEjiIdxzBBXXcssxtnbvjiN2lMUYPf
         sC/v1C+mMuM2OG1Y+X28cNqg4n/FYQZUmGJbeD1r3frXnmgURkDiTM+eOYBO6AEHUeQ7
         YeHj4KyVEdrO2ZLCEXkWbBdZmR9zozccrlPUcb8zLVWFRvzEkItcJsh2lO4Bjd1Veaw7
         ZoIw==
X-Gm-Message-State: AOAM5327Zx+HewQij/5Dfus2LWEcWTTxR8dyPP3Q1Bi85Dun/AMhJKU8
        x3YVr82J2NgahZaWifdejB8eF91DNd22dyldLuKaiA==
X-Google-Smtp-Source: ABdhPJxxxdKP9TrSrJ1YhuI+eB9YOKpKXMYmaWR0EnKvCcI2zCLJBZAr1P2MAvT+1/RWMg3ZJu8s6kfpkgU7FL7qp3k=
X-Received: by 2002:a05:6512:23a6:b0:477:943a:818d with SMTP id
 c38-20020a05651223a600b00477943a818dmr3942903lfv.644.1652980035171; Thu, 19
 May 2022 10:07:15 -0700 (PDT)
MIME-Version: 1.0
References: <20220518153126.265074-1-john.allen@amd.com>
In-Reply-To: <20220518153126.265074-1-john.allen@amd.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Thu, 19 May 2022 10:07:03 -0700
Message-ID: <CAMkAt6p7YCZye7C974TLBzrXE3Wt=m6bFGOrV=p8g8w7P3fnbw@mail.gmail.com>
Subject: Re: [PATCH v4] crypto: ccp - Use kzalloc for sev ioctl interfaces to
 prevent kernel memory leak
To:     John Allen <john.allen@amd.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        Ashish Kalra <Ashish.Kalra@amd.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andy Nguyen <theflow@google.com>,
        David Rientjes <rientjes@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 18, 2022 at 8:31 AM John Allen <john.allen@amd.com> wrote:
>
> For some sev ioctl interfaces, input may be passed that is less than or
> equal to SEV_FW_BLOB_MAX_SIZE, but larger than the data that PSP
> firmware returns. In this case, kmalloc will allocate memory that is the
> size of the input rather than the size of the data. Since PSP firmware
> doesn't fully overwrite the buffer, the sev ioctl interfaces with the
> issue may return uninitialized slab memory.
>
> Currently, all of the ioctl interfaces in the ccp driver are safe, but
> to prevent future problems, change all ioctl interfaces that allocate
> memory with kmalloc to use kzalloc and memset the data buffer to zero
> in sev_ioctl_do_platform_status.
>
> Fixes: 38103671aad3 ("crypto: ccp: Use the stack and common buffer for status commands")
> Fixes: e799035609e15 ("crypto: ccp: Implement SEV_PEK_CSR ioctl command")
> Fixes: 76a2b524a4b1d ("crypto: ccp: Implement SEV_PDH_CERT_EXPORT ioctl command")
> Fixes: d6112ea0cb344 ("crypto: ccp - introduce SEV_GET_ID2 command")
> Cc: stable@vger.kernel.org
> Reported-by: Andy Nguyen <theflow@google.com>
> Suggested-by: David Rientjes <rientjes@google.com>
> Suggested-by: Peter Gonda <pgonda@google.com>
> Signed-off-by: John Allen <john.allen@amd.com>

Reviewed-by: Peter Gonda <pgonda@google.com>

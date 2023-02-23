Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FB886A122F
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 22:40:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbjBWVkG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 16:40:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbjBWVkF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 16:40:05 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEB1E38658
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 13:40:02 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id ee7so32323132edb.2
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 13:40:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=eu4dlgDvM7BF/2CvEqDDQA7UHs/G9uWjlrCzs/6VT/8=;
        b=OBJUot5ArA8AuZr5Am1iNpiGcg163grwYHt/S/lfdzEng2GEOmwCK61b4pdn9e1Rvz
         9ZdxgOBLRiDoqtPUUEXz/Z1CFCLXAhoMCcyW2xMALKstCSjCh62EgVAkaFd3JSDOIfp4
         63bQ2FerOD+OayzoALa+Mh6V67wCIFrWQjsEw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eu4dlgDvM7BF/2CvEqDDQA7UHs/G9uWjlrCzs/6VT/8=;
        b=hfpdn4n/TeO6d8D9GRyPlTQjsLQ+ZEzFDuhv+p2F90nXyRT8KpEZaU67v1fcx770p9
         FQ7Qje4/0QGMXsmmsy+4m/zs7eR8N/euPy9SPYJe8XLyrAooAlTjNnxqUfbXFID9c1aU
         pE4VYf59Pbp02g/bmKcOuOc7553dxnCdW9kjFCrQPGtCAKR2QpOnb6S0SGqVLe842xH8
         hQPMAVt71nUpnqTmPxXbyQtn1/udEL+Phl01yoXeRKZ8hQJFqEpubspZDTHKOlN/4pru
         XAQK7cpFngd7pwVsbsEtbCGgOSKb4YshCO6keImVxYSy1ocg2+WOc+gbIW/uDndQJmS3
         9AeQ==
X-Gm-Message-State: AO0yUKW2Dfag7kaXzcAGyoRmIrSS++JeEGA8oEz0F6eho3sy/A6o4VE9
        DKBpswYbFlt97dVd9JTN1N+h2tyvalAIzy+8JCosyA==
X-Google-Smtp-Source: AK7set8k+27vYBNnxwxF+K6mFCDApBLRhMwJHEu80Nx+ZLGowoHCS1ai23tBiszp9xy4nBIEooi7og==
X-Received: by 2002:a17:906:4fd5:b0:878:54e3:e3e1 with SMTP id i21-20020a1709064fd500b0087854e3e3e1mr26177615ejw.73.1677188400725;
        Thu, 23 Feb 2023 13:40:00 -0800 (PST)
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com. [209.85.208.46])
        by smtp.gmail.com with ESMTPSA id c9-20020a50d649000000b004af64086a0esm2345042edj.35.2023.02.23.13.39.59
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Feb 2023 13:39:59 -0800 (PST)
Received: by mail-ed1-f46.google.com with SMTP id h16so47591317edz.10
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 13:39:59 -0800 (PST)
X-Received: by 2002:a17:907:988c:b0:877:747e:f076 with SMTP id
 ja12-20020a170907988c00b00877747ef076mr9516620ejc.0.1677188399093; Thu, 23
 Feb 2023 13:39:59 -0800 (PST)
MIME-Version: 1.0
References: <20230223141542.672463796@linuxfoundation.org> <adc1b0b7-f837-fbb4-332b-4ce18fc55709@roeck-us.net>
 <Y/eVSi4ZTcOmPBTv@kroah.com> <cfd03ee0-b47a-644d-4364-79601025f35f@roeck-us.net>
 <CAHk-=whCG1zudvDsqdFo89pHARvDv4=r6vaZ8GWc_Q9amxBM6Q@mail.gmail.com>
 <Y/fC3d3RqoeawG0Y@dev-arch.thelio-3990X> <CAHk-=whkNnShBugM01Kzcypkp+f-uHeBWuAgtUiMpiSZuW+QDQ@mail.gmail.com>
 <Y/fZbQEEPBNZQ2w7@kroah.com>
In-Reply-To: <Y/fZbQEEPBNZQ2w7@kroah.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 23 Feb 2023 13:39:42 -0800
X-Gmail-Original-Message-ID: <CAHk-=whiuJH_DYQZw1hPtibDQZcNy8QYf1cZJCsezuPobSXCKw@mail.gmail.com>
Message-ID: <CAHk-=whiuJH_DYQZw1hPtibDQZcNy8QYf1cZJCsezuPobSXCKw@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/37] 5.15.96-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>, stable@vger.kernel.org,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 23, 2023 at 1:24 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> Quilt should be depending on patch here, I think it's something in my
> set of "turn this series of patches into a mbox, split the mbox up into
> patches" sequence that is causing the problem.

Well, it might also be that quilt just re-generates the patch with
'diff', and then in the process loses the information again.

We can happily continue to support the "we lost the executable bit",
since it sounds like Nathan is willing to cook up a patch.

I'm just too lazy and personally unaffected to care (and too busy with
merges - excuses, excuses).

            Linus

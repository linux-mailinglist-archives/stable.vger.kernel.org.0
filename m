Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 705126C3444
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 15:32:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230346AbjCUOcg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Mar 2023 10:32:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbjCUOcf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 10:32:35 -0400
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3032328E5A
        for <stable@vger.kernel.org>; Tue, 21 Mar 2023 07:32:34 -0700 (PDT)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-5416698e889so283846337b3.2
        for <stable@vger.kernel.org>; Tue, 21 Mar 2023 07:32:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1679409153;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OmS3t1LwSeW338eitL1eo04EnlDGMFXbCu5WC9Yqvp4=;
        b=eaHIqClsqkyiwh4owGMT27gw2xakCe4WwFVG20FbcIHUt4IeC1EsFmGzovXuVlg505
         YXI0HHIlTK2EQHMY6mZe0IQQJBZo2H1lzKw9W7oLFNQuUfeDByS+/BWCS7NaAPpvlqlz
         Mnjxv/nh06Hsgcfw5/fI/pSWh12zQ4YmUEd4+iO0bIKyjm2pd7WI3YKrMQQqT8cWJNgB
         R09eIk5RctQBEN0gCYDo3wUX6yIyuLh4Co6mW4a3ZDUh5WX8GQ82RImO5bAYHN7R06rb
         Tp78QMmgmmfbR6T0qUg0ncqpqUMVu7tTFxzb8pz/O9uZIeLcliQ6h7UZnVgxqNhBlbP+
         cB6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679409153;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OmS3t1LwSeW338eitL1eo04EnlDGMFXbCu5WC9Yqvp4=;
        b=Smy0bRSMFYgjWWMuys8yeLjEEXompPZQEDO5IUWZs+fz8foMumJUcd7PVI15NoCE3y
         PF4TCnKXowWr0YmQT4jMz/fhoRz7fYbBWDzdBUAq0HBujEoeNQXLsHWFD/mq3m5kRtOJ
         mAat4u1zJHteE37wdIh3YSt/piivGenV5YJjhKjeOMSKtoeLx8/YBzF4qPMiz38WFyKt
         2Ug6FKbli06oWXdJu0rojlSIXTpBB0vJW4nu7+4DmVE8OqVtYw5lwY0SKrxa+wD3107Z
         7u+Z1ZK8Hh4dRsK4yV4uUyAK8vrny4Jx4HCuPo0v6qQaqE2JKESNPBDcJPJ7EZDTaBWK
         SmIA==
X-Gm-Message-State: AAQBX9dcM5BXQZ6VH5lBaidX/RJSBkbye49smsZP0QM92V4/hQWFsiDm
        gguyKqahC5r2E/45MSNo/F1L79JDy6V+peZ40KCNyQ==
X-Google-Smtp-Source: AKy350bMfhgrUwhrDjXQqTRfgFwcKP21gdqb/eViDu2agJULxb9Y+o3veXuQIkEiG3nDI4hBrEr0oR/B0ZiOowmemnY=
X-Received: by 2002:a81:b3c1:0:b0:541:9895:4ce9 with SMTP id
 r184-20020a81b3c1000000b0054198954ce9mr1175290ywh.9.1679409153285; Tue, 21
 Mar 2023 07:32:33 -0700 (PDT)
MIME-Version: 1.0
References: <20230320131845.3138015-1-ardb@kernel.org> <20230320131845.3138015-5-ardb@kernel.org>
In-Reply-To: <20230320131845.3138015-5-ardb@kernel.org>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Tue, 21 Mar 2023 15:32:21 +0100
Message-ID: <CACRpkdbRf9NL4+m+bJZ16x5uCMb2rDYmBk3xTwmVDFykDTmnMQ@mail.gmail.com>
Subject: Re: [PATCH v4 04/12] ARM: entry: Fix iWMMXT TIF flag handling
To:     Ard Biesheuvel <ardb@kernel.org>, Nicolas Pitre <nico@fluxnic.net>,
        Nicolas Pitre <npitre@baylibre.com>
Cc:     linux-arm-kernel@lists.infradead.org, linux@armlinux.org.uk,
        Frederic Weisbecker <frederic@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 20, 2023 at 2:19=E2=80=AFPM Ard Biesheuvel <ardb@kernel.org> wr=
ote:

> The conditional MOVS instruction that appears to have been added to test
> for the TIF_USING_IWMMXT thread_info flag only sets the N and Z
> condition flags and register R7, none of which are referenced in the
> subsequent code. This means that the instruction does nothing, which
> means that we might misidentify faulting FPE instructions as iWMMXT
> instructions on kernels that were built to support both.
>
> This seems to have been part of the original submission of the code, and
> so this has never worked as intended, and nobody ever noticed, and so we
> might decide to just leave this as-is. However, with the ongoing move
> towards multiplatform kernels, the issue becomes more likely to
> manifest, and so it is better to fix it.
>
> So check whether we are dealing with an undef exception regarding
> coprocessor index #0 or #1, and if so, load the thread_info flag and
> only dispatch it as a iWMMXT trap if the flag is set.
>
> Cc: <stable@vger.kernel.org> # v2.6.9+
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

Looks right to me.
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

The code dates back before git history, but it was introduced in
Linux v2.6.9 and it looks like Nicolas Pitre wrote it so let's just
ping him and see what he remembers about this!

Yours,
Linus Walleij

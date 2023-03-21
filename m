Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 124BB6C3AA6
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 20:33:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbjCUTdu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Mar 2023 15:33:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbjCUTdt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 15:33:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2CC5574F4
        for <stable@vger.kernel.org>; Tue, 21 Mar 2023 12:32:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC04961DD7
        for <stable@vger.kernel.org>; Tue, 21 Mar 2023 19:32:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CD09C433A4
        for <stable@vger.kernel.org>; Tue, 21 Mar 2023 19:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679427166;
        bh=2hTJAPDPwCHR9HR+TlToIXnIVAWTFBm302dtPSH9zic=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Ibmc0hJSPQTEijZShHnDX8yT7Uw+glP+mLy7uFyZtgEcZDoEER04N7q9HoujMuNYZ
         WSUadPDVt2+5qcuke+2cU4HF8HkbhNGd88V8+1ISJs4lQ3pv5vV/CWI4h6joqXarGD
         gZ3PgQwF7zr7QgyL9YfQU+bYGeLHU2wvoKXXWBuKFpHfWcjR4c60tU2tvGo04TskOm
         4aVtCGF6t4DQ6Ip2RCEIjr87feMrfvpvoeBkM8nMk6dGY47/1vK+z1iPhHL5fiW71g
         jl255pGlIDjqFSuZEpLsfTdCghDzVMUIvEcDK+gAfiRHEluCgvSuRbk8P7Gs72iB0E
         28mDx6QDLPKgw==
Received: by mail-lf1-f52.google.com with SMTP id t11so20538968lfr.1
        for <stable@vger.kernel.org>; Tue, 21 Mar 2023 12:32:45 -0700 (PDT)
X-Gm-Message-State: AO0yUKWls8L6Szc6alteNYMOkPyff0EogwxOQQVuSvdD8chtkRa7waiO
        5Kk5ECDPxAMwHgYPOgWgdzLxPSZNxGVx7aP/6Z8=
X-Google-Smtp-Source: AK7set8Tkl1y74GPuFrvRjHAttWXCOBrJzLXEyBoQdnExVEM/5NM6BzM21zq+Xwj7xELpO9A0qTp4W5S5hECz76800o=
X-Received: by 2002:ac2:48b2:0:b0:4d5:ca32:6ae4 with SMTP id
 u18-20020ac248b2000000b004d5ca326ae4mr1206995lfg.4.1679427164012; Tue, 21 Mar
 2023 12:32:44 -0700 (PDT)
MIME-Version: 1.0
References: <20230320131845.3138015-1-ardb@kernel.org> <20230320131845.3138015-5-ardb@kernel.org>
 <CACRpkdbRf9NL4+m+bJZ16x5uCMb2rDYmBk3xTwmVDFykDTmnMQ@mail.gmail.com> <2q3srsro-n086-s7r1-5o68-8r0qs2467s5r@onlyvoer.pbz>
In-Reply-To: <2q3srsro-n086-s7r1-5o68-8r0qs2467s5r@onlyvoer.pbz>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Tue, 21 Mar 2023 20:32:32 +0100
X-Gmail-Original-Message-ID: <CAMj1kXFhqDkwXn7Th62E47U7A_tzEdmNy_0aPidVsVhtnud3cA@mail.gmail.com>
Message-ID: <CAMj1kXFhqDkwXn7Th62E47U7A_tzEdmNy_0aPidVsVhtnud3cA@mail.gmail.com>
Subject: Re: [PATCH v4 04/12] ARM: entry: Fix iWMMXT TIF flag handling
To:     Nicolas Pitre <npitre@baylibre.com>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Frederic Weisbecker <frederic@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 21 Mar 2023 at 20:19, Nicolas Pitre <npitre@baylibre.com> wrote:
>
> On Mon, Mar 20, 2023 at 2:19=E2=80=AFPM Ard Biesheuvel <ardb@kernel.org> =
wrote:
>
> > The conditional MOVS instruction that appears to have been added to tes=
t
> > for the TIF_USING_IWMMXT thread_info flag only sets the N and Z
> > condition flags and register R7, none of which are referenced in the
> > subsequent code.
>
> Really?
>
> As far as I know, the rsb instruction is a "reversed subtract" and that
> also sets the carry flag.
>
> And so does a move with a shifter argument (the last dropped bit is
> moved to the carry flag).
>
> What am I missing?
>

No, you are absolutely right. I looked up the wrong encoding in the
ARM ARM. MOVS without a shift preserves the carry flag, but the
variant you used here behaves as you describe.

So the code is correct - apologies for the noise.

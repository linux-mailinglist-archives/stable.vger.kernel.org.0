Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A2324DC0D6
	for <lists+stable@lfdr.de>; Thu, 17 Mar 2022 09:19:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230515AbiCQIUt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Mar 2022 04:20:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231148AbiCQIUp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Mar 2022 04:20:45 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD538E543D;
        Thu, 17 Mar 2022 01:19:28 -0700 (PDT)
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
        by gnuweeb.org (Postfix) with ESMTPSA id 49D277E327;
        Thu, 17 Mar 2022 08:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1647505167;
        bh=erDkI0CJIdZgCBurSkI0GWcsHJcYoAwTyF5CrVqSAKE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=AJQytdpum/Y0laE9vsSbeAwEq21Zjbsh5ohOuBABrABZDwGchiASQMlVp2Aai3FvU
         hF32NM1dTjXFSTLtF0PwoRXTnztwMFGiOyQObnE2X/oLVSxzsY5Mk15n2Kvbk4BbRj
         ZpoeEPBcU0hQwzeai9Pu9JW3yGSgVAxXEdBvu+9omKZ7P9RY31rfnWeJBBhIVX+FBy
         s+tQUGRJw9Ulnfm7u0bNvPC2wLS9+b1gd0GCHjpZS22XHnLWv67aChEUc4vXeb3Ytx
         W2/TWDA5JIM5ozO1BR/cV5FfbjqmGuciCLFd6OjozPseyTcg+EAqdhDgS0UXQE0fsT
         vdycqyVeABZgQ==
Received: by mail-lf1-f50.google.com with SMTP id l20so7674289lfg.12;
        Thu, 17 Mar 2022 01:19:27 -0700 (PDT)
X-Gm-Message-State: AOAM5325GKn+MuuseFAUuTn+8DrG5QSyWq71+AOJyyt+0maOMOBp52yz
        9idMGPn5BhSpAO7d2lzBm2PSF4iJhDoAACSNkB8=
X-Google-Smtp-Source: ABdhPJwbvJ7jbKQaDeT459FS5y4yvW9VsskaJVgOHyPveOX8kbq9A46v7DR+2MbSw1x7aCPkn1krDyfNhalhOpux48g=
X-Received: by 2002:ac2:5fe3:0:b0:448:5ba2:445f with SMTP id
 s3-20020ac25fe3000000b004485ba2445fmr2230947lfg.682.1647505165164; Thu, 17
 Mar 2022 01:19:25 -0700 (PDT)
MIME-Version: 1.0
References: <20220310015306.445359-1-ammarfaizi2@gnuweeb.org>
In-Reply-To: <20220310015306.445359-1-ammarfaizi2@gnuweeb.org>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
Date:   Thu, 17 Mar 2022 15:19:07 +0700
X-Gmail-Original-Message-ID: <CAFBCWQLJ6vCWePF0W4U7mont=Jn4QfDUq-8UpOcm37yqtbkQ8Q@mail.gmail.com>
Message-ID: <CAFBCWQLJ6vCWePF0W4U7mont=Jn4QfDUq-8UpOcm37yqtbkQ8Q@mail.gmail.com>
Subject: Re: [PATCH v5 0/2] Two x86 fixes
To:     Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gmail.com>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        David.Laight@aculab.com, Dave Hansen <dave.hansen@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Tony Luck <tony.luck@intel.com>,
        Yazen Ghannam <yazen.ghannam@amd.com>,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        "GNU/Weeb Mailing List" <gwml@vger.gnuweeb.org>, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 10, 2022 at 8:53 AM Ammar Faizi wrote:
> Two x86 fixes in this series.
>
> 1) x86/delay: Fix the wrong Assembly constraint in delay_loop() function.
> 2) x86/MCE/AMD: Fix memory leak when `threshold_create_bank()` fails.

Ping (1)!
Borislav? Thomas?

Ref: https://lore.kernel.org/lkml/20220310015306.445359-1-ammarfaizi2@gnuweeb.org/

-- 
Ammar Faizi

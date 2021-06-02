Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ECB6398D5D
	for <lists+stable@lfdr.de>; Wed,  2 Jun 2021 16:46:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230072AbhFBOrt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Jun 2021 10:47:49 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:40350 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbhFBOrt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Jun 2021 10:47:49 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1622645164;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=o4hONCFQBcPOxlxyQ9LyYWxu0os9m0Btu4PMhynyl2o=;
        b=nQL/05UddfciHYwDihadZs3yYtqYkqUoqQ85iB85Hh5QwJvgRGXqN78rqWgLOVuE+GXcpq
        InpfyKB5L8CBrhB1DvTf5/xYeZ/NRg/um9nnuvYhQB5TQAY/atFJsCcUoQKBSONWDmA8F4
        cEPUAf0I4G6gUyU22oWYuwDvTRYrVj/UMPBkzF3O2iPWUURYeOCg0Ulj90iuq6n14OTUQI
        2vU4OMx3EAxqk6l9F0FcQSnUw9sASWY/zVQLvK3ZFviXKpfraY/vb/HCGfvQNlxredjwrf
        RQBJIdeesk2wqqC/KixInKadrIsVanbHd3CEKflJiDQKe3FEs/MS5obietgk+Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1622645164;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=o4hONCFQBcPOxlxyQ9LyYWxu0os9m0Btu4PMhynyl2o=;
        b=6truFWXPjcwI2gFE9yAy2Yll/2thUzrz7O7D6f0GZuUJbYNgKfA5jLSwtnogCqkm7OdeQz
        8LPVijtH8rAhmiBw==
To:     Borislav Petkov <bp@alien8.de>
Cc:     LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Yu-cheng Yu <yu-cheng.yu@intel.com>,
        syzbot+2067e764dbcd10721e2e@syzkaller.appspotmail.com,
        stable@vger.kernel.org
Subject: Re: [patch 2/8] x86/fpu: Prevent state corruption in __fpu__restore_sig()
In-Reply-To: <YLeDx+EohkPpjabd@zn.tnic>
References: <20210602095543.149814064@linutronix.de> <20210602101618.462908825@linutronix.de> <YLeDx+EohkPpjabd@zn.tnic>
Date:   Wed, 02 Jun 2021 16:46:04 +0200
Message-ID: <874keg1g0j.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 02 2021 at 15:12, Borislav Petkov wrote:
>>  /* Validate an xstate header supplied by userspace (ptrace or sigreturn=
) */
>> -int validate_user_xstate_header(const struct xstate_header *hdr)
>> +static int validate_user_xstate_header(const struct xstate_header *hdr)
>
> Can't do that yet - that one is still called from regset.c:
>
> arch/x86/kernel/fpu/regset.c: In function =E2=80=98xstateregs_set=E2=80=
=99:
> arch/x86/kernel/fpu/regset.c:135:10: error: implicit declaration of funct=
ion =E2=80=98validate_user_xstate_header=E2=80=99 [-Werror=3Dimplicit-funct=
ion-declaration]
>   135 |    ret =3D validate_user_xstate_header(&xsave->header);
>       |          ^~~~~~~~~~~~~~~~~~~~~~~~~~~
> cc1: some warnings being treated as errors
>
> Maybe after the 5th patch which kills that usage too.

Gah, yes. I had the patches ordered differently and then failed to do a
full step by step recompile after reshuffling them. Fixed localy.

Thanks,

        tglx

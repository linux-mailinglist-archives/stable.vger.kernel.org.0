Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 646973FBC92
	for <lists+stable@lfdr.de>; Mon, 30 Aug 2021 20:38:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbhH3Sjf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Aug 2021 14:39:35 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:36162
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229738AbhH3Sje (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Aug 2021 14:39:34 -0400
Received: from mussarela (201-69-234-220.dial-up.telesp.net.br [201.69.234.220])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 093D340178;
        Mon, 30 Aug 2021 18:38:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1630348719;
        bh=dP2bWFnr904Q3phxdSJFO6HdgfMSWA65sEUBMQrG98c=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Type:In-Reply-To;
        b=tEEdtAHGeXWPANZY9GSNFafDKT6z1GKu2nWOlfBIS5uxclCTIR+OK6BAg4Or0lddr
         7eM/MOYbnRMI5cy14s8OTfzI3xxyCdrpWicFgGEmp7NF6tDKlRXWzrSj9R525VyKXY
         HWGPF9TAWc7iCr/1oDyPbxDz9t0FApF31/RyuLlsG7z8NijAQBbfUa5pwF/hIsltuK
         dCHv/HjFi6HCXmZgfdKFZPxT7KpfIKDHbyW/XA0MLwQnFn6HwuJhPQiLtu5SF28/gZ
         hvxsKGH9U8JRSo6Jkhe7JH+B0fo94WfYDbFxmE+l73jzJu78L+rEdssvswM0inoqzc
         6xPnmnMin+MHg==
Date:   Mon, 30 Aug 2021 15:38:34 -0300
From:   Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
To:     Pavel Machek <pavel@denx.de>
Cc:     stable@vger.kernel.org, kernel list <linux-kernel@vger.kernel.org>,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org
Subject: Re: CVE-2021-3600 aka bpf: Fix 32 bit src register truncation on
 div/mod
Message-ID: <YS0lqmZg5Lq0scVv@mussarela>
References: <20210826102337.GA7362@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210826102337.GA7362@duo.ucw.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 26, 2021 at 12:23:37PM +0200, Pavel Machek wrote:
> Hi!
> 
> As far as I can tell, CVE-2021-3600 is still a problem for 4.14 and
> 4.19.
> 
> Unfortunately, those kernels lack BPF_JMP32 support, and that support
> is too big and intrusive to backport.
> 
> So I tried to come up with solution without JMP32 support... only to
> end up with not seeing the bug in the affected code.
> 
> Changelog says:
> 
>     bpf: Fix 32 bit src register truncation on div/mod
>     
>     While reviewing a different fix, John and I noticed an oddity in one of the
>     BPF program dumps that stood out, for example:
>     
>       # bpftool p d x i 13
>        0: (b7) r0 = 808464450
>        1: (b4) w4 = 808464432
>        2: (bc) w0 = w0
>        3: (15) if r0 == 0x0 goto pc+1
>        4: (9c) w4 %= w0
>       [...]
>     
>     In line 2 we noticed that the mov32 would 32 bit truncate the original src
>     register for the div/mod operation. While for the two operations the dst
>     register is typically marked unknown e.g. from adjust_scalar_min_max_vals()
>     the src register is not, and thus verifier keeps tracking original bounds,
>     simplified:
> 
> So this explains "mov32 w0, w0" is problematic, and fixes the bug by
> replacing it with jmp32. Unfortunately, I can't do that in 4.19; plus
> I don't really see how the bug is solved -- we avoided adding mov32
> sequence that triggers the problem, but the problematic sequence could
> still be produced by the userspace, no?
> 
> Does adjust_scalar_min_max_vals still need fixing?
> 
> Do you have any hints how to solve this in 4.19?
> 
> Best regards,
> 								Pavel
> -- 
> DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
> HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

Hi, Pavel.

I have just sent the fixes for 4.14. I sent fixes for 4.19 last Friday.

The problem here is that the verifier assumes the source register has a given
value, but the fixups change that value to something else when it is truncated.

The fixups run after the verifier, so a similar sequence produced by userspace
will be correctly verified, so no fixes are necessary on adjust_scalar_min_max
for this specific issue. The fixed-up code is not verified again.

The challenge in providing those fixes to 4.14 and 4.19 is the absence of JMP32
in those kernels. So, AX was taken as a temporary, so it would still work on
JITs.

Cascardo.

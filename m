Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5963F3F8611
	for <lists+stable@lfdr.de>; Thu, 26 Aug 2021 13:06:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231485AbhHZLHT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Aug 2021 07:07:19 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:49878
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231406AbhHZLHT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Aug 2021 07:07:19 -0400
Received: from mussarela (1.general.cascardo.us.vpn [10.172.70.58])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id D23783F36A;
        Thu, 26 Aug 2021 11:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1629975984;
        bh=8mClFa8njHChT6sq4TnLBNQxvsYUcvl4mxEKYINgKVU=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Type:In-Reply-To;
        b=f2r7zfFaFqf5INf4zLQW5gtUvUx3OAeIL30pHaggICPAxGsuMV/SuupOS3dVcGMcS
         fwJRZlhLq3vqlJ+CTEZgvi1tIv03PYfmjdtCtL5L2sKqBbH0wIkCr7N5XvwbluB4GQ
         i/uOy0x2JOLhNagOftc6p7Qyw4vQT8jD7w1SFiLIHXJritqYZrUQIi6S4SMQK0lPoa
         UMZmgp4E9SB+dmIY4fybrE3C1fjRUpedjSZmKST7i3MUsNeZX8iPv+Rup8SP3zlXzI
         darrJqVRJE5YQ4hWuDbQ8kE1Ae81s45/1vB1ZGGs9weCsWdsutTkVpLlf2/5d0TaMT
         i1y1APkgwZNNw==
Date:   Thu, 26 Aug 2021 08:06:19 -0300
From:   Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
To:     Pavel Machek <pavel@denx.de>
Cc:     stable@vger.kernel.org, kernel list <linux-kernel@vger.kernel.org>,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        carnil@debian.org
Subject: Re: CVE-2021-3600 aka bpf: Fix 32 bit src register truncation on
 div/mod
Message-ID: <YSd1q9Llm1vsWbXT@mussarela>
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

We have fixed this in our 4.15 kernels with help from Daniel, John, Alexei and
Salvatore. I am a little busy right now, but will make time to work on the
commits we had for 4.19. 4.19 is also affected by CVE-2021-3444, IIRC.

When I get back to it, I may try to answer some of your questions.

Cascardo.

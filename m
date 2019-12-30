Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E85E712D4EE
	for <lists+stable@lfdr.de>; Tue, 31 Dec 2019 00:14:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727746AbfL3XOf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Dec 2019 18:14:35 -0500
Received: from mail-qv1-f68.google.com ([209.85.219.68]:33988 "EHLO
        mail-qv1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727695AbfL3XOf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Dec 2019 18:14:35 -0500
Received: by mail-qv1-f68.google.com with SMTP id o18so12900927qvf.1
        for <stable@vger.kernel.org>; Mon, 30 Dec 2019 15:14:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=jO81914J26kusqpC86zZi6OGoB/7iKBbQpWs5ZvOpXI=;
        b=HNISyecp13BPtFpRvvGx0+V/0AGRan9c4lpLJaPfK9+WKP5mIXn39PGkNcSpGijNEE
         Keuven8GBn9BRmS+N1GHAHoCr5mjhKYR2ya/G5EfUQGv1Ci17Kt2MOHLzdl9k+3kGJee
         EjGosVOYqh7bYgC8XXu/rY5OIqpX3/i7WQsrW39+PpdKy0tneJ9oXJrOgxkSNNhsgHrW
         9kFT5u5tsDUZW92hDsqfy1gc3Y14z6DEOQC8bY/aUP4dXiCoj/HfqGuvTMr/RnkQbufB
         DaMCIcwEIqons4DSRfBcN06vEX1BxKNvJ7Cht/6Miicg+jS3QI1Zi8LRAarU0tYxUa4A
         FaTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=jO81914J26kusqpC86zZi6OGoB/7iKBbQpWs5ZvOpXI=;
        b=uQXXo7I8/2Dtzl7U+rkXDeBruhW7d7LbTAUHFTtyVXuYPlE8ZaPfVLzFh4IbGCyDm4
         19iYGZd1Xhwm98IJsDvwiJTYDgV9HncIb2R8f4VC4sclND8gbXJDLCl8An/XONmZ3b4Z
         Eu0KFdOFiEWGJmxcuZx3v3l9yLo0Sl8ZQuQkVC3w1GBfWWB5h8sOb3EUCErlAIfpdY6U
         7QtTnAL6FKQU7JJpbe88ZFPG3cjNLIDf/zaKgCpf38i4eKOLiO6o69Wq71RmNWbfriOI
         /189P1CEiDDRoJSsqSftnrqkBF+nKZzQJgurdJA7Zu0rmE8//G80SYKsOX6Bn23tyWGt
         TxWA==
X-Gm-Message-State: APjAAAVMSkUNUKHSMiQBsZ0M2lMtCcBnyocrLdZ8O99ekLNkqMpSJVUI
        KDrAZUeKa0FOsyj2WwUZbMcP0stOl+9sbTjuGRqcIg==
X-Google-Smtp-Source: APXvYqxVWdh9I7Vf8vB75oO4YoPp+qy9+xAjtNkIFmc15HsXG4+Acr8d4KUOSxTqS0JoYBxVUDhqboZXpaeoTok2AwU=
X-Received: by 2002:a0c:d788:: with SMTP id z8mr44746719qvi.211.1577747673604;
 Mon, 30 Dec 2019 15:14:33 -0800 (PST)
MIME-Version: 1.0
References: <20191211204753.242298-8-pomonis@google.com> <20191225235523.470232075B@mail.kernel.org>
In-Reply-To: <20191225235523.470232075B@mail.kernel.org>
From:   Marios Pomonis <pomonis@google.com>
Date:   Mon, 30 Dec 2019 15:14:22 -0800
Message-ID: <CAKXAmdgLV5BZ1JHU0qLcUaQksD6FE3x2cuYkT6jqjGcrxsag-g@mail.gmail.com>
Subject: Re: [PATCH v2 07/13] KVM: x86: Protect MSR-based index computations
 in fixed_msr_to_seg_unit() from Spectre-v1/L1TF attacks
To:     Sasha Levin <sashal@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, rkrcmar@redhat.com,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

These build issues can be fixed by including linux/nospec.h to
arch/x86/kvm/mtrr.c. Below you can find a patch that compiles on both
v4.9.206 and v4.4.206.

Please let me know if you need anything else.

Marios

=3D=3D=3D=3D=3D=3D=3D=3D
diff --git a/arch/x86/kvm/mtrr.c b/arch/x86/kvm/mtrr.c
index 0149ac59c273..f223f1315998 100644
--- a/arch/x86/kvm/mtrr.c
+++ b/arch/x86/kvm/mtrr.c
@@ -18,6 +18,7 @@

 #include <linux/kvm_host.h>
 #include <asm/mtrr.h>
+#include <linux/nospec.h>

 #include "cpuid.h"
 #include "mmu.h"
@@ -202,11 +203,15 @@ static bool fixed_msr_to_seg_unit(u32 msr, int
*seg, int *unit)
                break;
        case MSR_MTRRfix16K_80000 ... MSR_MTRRfix16K_A0000:
                *seg =3D 1;
-               *unit =3D msr - MSR_MTRRfix16K_80000;
+               *unit =3D array_index_nospec(
+                       msr - MSR_MTRRfix16K_80000,
+                       MSR_MTRRfix16K_A0000 - MSR_MTRRfix16K_80000 + 1);
                break;
        case MSR_MTRRfix4K_C0000 ... MSR_MTRRfix4K_F8000:
                *seg =3D 2;
-               *unit =3D msr - MSR_MTRRfix4K_C0000;
+               *unit =3D array_index_nospec(
+                       msr - MSR_MTRRfix4K_C0000,
+                       MSR_MTRRfix4K_F8000 - MSR_MTRRfix4K_C0000 + 1);
                break;
        default:
                return false;

On Wed, Dec 25, 2019 at 3:55 PM Sasha Levin <sashal@kernel.org> wrote:
>
> Hi,
>
> [This is an automated email]
>
> This commit has been processed because it contains a "Fixes:" tag,
> fixing commit: de9aef5e1ad6 ("KVM: MTRR: introduce fixed_mtrr_segment tab=
le").
>
> The bot has tested the following trees: v5.4.5, v5.3.18, v4.19.90, v4.14.=
159, v4.9.206, v4.4.206.
>
> v5.4.5: Build OK!
> v5.3.18: Build OK!
> v4.19.90: Build OK!
> v4.14.159: Build OK!
> v4.9.206: Build failed! Errors:
>     arch/x86/kvm/mtrr.c:205:11: error: implicit declaration of function =
=E2=80=98array_index_nospec=E2=80=99; did you mean =E2=80=98array_index_mas=
k_nospec=E2=80=99? [-Werror=3Dimplicit-function-declaration]
>
> v4.4.206: Build failed! Errors:
>     arch/x86/kvm/mtrr.c:205:11: error: implicit declaration of function =
=E2=80=98array_index_nospec=E2=80=99; did you mean =E2=80=98array_index_mas=
k_nospec=E2=80=99? [-Werror=3Dimplicit-function-declaration]
>
>
> NOTE: The patch will not be queued to stable trees until it is upstream.
>
> How should we proceed with this patch?
>
> --
> Thanks,
> Sasha



--=20
Marios Pomonis
Software Engineer, Security
GCP Platform Security
US-KIR-6THC

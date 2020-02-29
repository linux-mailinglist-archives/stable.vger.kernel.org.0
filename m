Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5A6517492A
	for <lists+stable@lfdr.de>; Sat, 29 Feb 2020 21:17:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727491AbgB2URu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Feb 2020 15:17:50 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:34148 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727314AbgB2URt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Feb 2020 15:17:49 -0500
Received: by mail-io1-f66.google.com with SMTP id z190so7409243iof.1
        for <stable@vger.kernel.org>; Sat, 29 Feb 2020 12:17:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wmpPmvsEIyrnQOguFJJRRPmk+nI9F2PZon3IZMblz1w=;
        b=wLO3hacNd3AO+uNA1CnNg95qpWPAeIVIN8j5Qi8kcMlj0w/64vVB58E2UUwauDE13S
         JWxSJf2cO+VtN1eX5PUa75e2ImrKlI9yfywbApSzce7XacU7yCTNVimHDh+2c/j4Isr8
         bcaQsNDcIluValQQMdy8PtzZqMzrCKRIT7c2B8YfrBK5SrWi4dFUgKjLc9t0jrjuxxzU
         y6GdV19Fg9H1Vuq71UeKMoFiX8RhHj/Ge+CF9GCNJVanHzRV7JvXYTyfrmHopclIEf+t
         16gm3SPcyONEDIECix611Gguwbr9/B6LX+HvcU/Wa0ZwVnu8uj1G1R+TdzZ16t8fSi+I
         ZWaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wmpPmvsEIyrnQOguFJJRRPmk+nI9F2PZon3IZMblz1w=;
        b=fTFXz3Gwr4B+9IAKVPHuAIV0fA5wbNUnnba/cT0V2FAOLGcxhdJj7an4PIJJe2rm82
         Ndq/yDb7w8JcWQpov2c385RqGuLv0RzxWPxl1WxOkDl1JnWnvBz2VWhZJngQDcQnn9Bi
         3GkgJVb77cOxrPoRILwdroyEDb5tYvKITnZuFbm1AMa0JS3rw6IskCxKMmqKfEKrUrdA
         X91kcHk2wQTUcZt2H+xiNhWwxS547Pr/ccjVlQwBv+M42QQfHFCeuo7HPBmEyv2mFVHo
         2E7djCiMMeqEW4cQiLxAk/1C2jqCNZHO27yQTEwzfjGKkMkodpRSvb9qu9/h9yw5dvkq
         TQvA==
X-Gm-Message-State: APjAAAV14gqES6huP55kqDMPTR8+Vd3Fix5eMHDfDh2MGMhwGsDhd2NY
        lPN3op0OMrrrsQ/ZayzHSIiscTpxWPwX0W9VTrgxTg==
X-Google-Smtp-Source: APXvYqx3dpUf2n7ik6bI7eu9iMF2etEOearvMVPaaE0Ih/aI/ITxpHjzDEm78SmGWjK9fgGtSnoWNixiYwPJYeSJKwc=
X-Received: by 2002:a02:cc58:: with SMTP id i24mr8110735jaq.24.1583007468804;
 Sat, 29 Feb 2020 12:17:48 -0800 (PST)
MIME-Version: 1.0
References: <1582570596-45387-1-git-send-email-pbonzini@redhat.com>
 <1582570596-45387-2-git-send-email-pbonzini@redhat.com> <41d80479-7dbc-d912-ff0e-acd48746de0f@web.de>
 <CAOQ_QshE7SMX2cO7H+21Fkdpg53oE2D3xrHPJHR_MCfH4r9QCQ@mail.gmail.com>
 <CALMp9eRETy1RLWHWKtFHqpcpFHbQKtPgJHDD_N+LPzaUPx-Jvg@mail.gmail.com> <e8fe4664-d948-f239-4ec9-82d9010b7d26@web.de>
In-Reply-To: <e8fe4664-d948-f239-4ec9-82d9010b7d26@web.de>
From:   Jim Mattson <jmattson@google.com>
Date:   Sat, 29 Feb 2020 12:17:37 -0800
Message-ID: <CALMp9eR9zcXO64n7hDTzZHPkfV8qtuMHAbc=nLX8S8x7Crum+A@mail.gmail.com>
Subject: Re: [FYI PATCH 1/3] KVM: nVMX: Don't emulate instructions in guest mode
To:     Jan Kiszka <jan.kiszka@web.de>
Cc:     Oliver Upton <oupton@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since UMIP emulation is broken, I'm not sure why anyone would use it.
(Sorry, Paolo.)

On Sat, Feb 29, 2020 at 11:21 AM Jan Kiszka <jan.kiszka@web.de> wrote:
>
> On 29.02.20 20:00, Jim Mattson wrote:
> > On Sat, Feb 29, 2020 at 10:33 AM Oliver Upton <oupton@google.com> wrote:
> >>
> >> Hi Jan,
> >>
> >> On Sat, Feb 29, 2020 at 10:00 AM Jan Kiszka <jan.kiszka@web.de> wrote:
> >>> Is this expected to cause regressions on less common workloads?
> >>> Jailhouse as L1 now fails when Linux as L2 tries to boot a CPU: L2-Linux
> >>> gets a triple fault on load_current_idt() in start_secondary(). Only
> >>> bisected so far, didn't debug further.
> >>
> >> I'm guessing that Jailhouse doesn't use 'descriptor table exiting', so
> >> when KVM gets the corresponding exit from L2 the emulation burden is
> >> on L0. We now refuse the emulation, which kicks a #UD back to L2. I
> >> can get a patch out quickly to address this case (like the PIO exiting
> >> one that came in this series) but the eventual solution is to map
> >> emulator intercept checks into VM-exits + call into the
> >> nested_vmx_exit_reflected() plumbing.
> >
> > If Jailhouse doesn't use descriptor table exiting, why is L0
> > intercepting descriptor table instructions? Is this just so that L0
> > can partially emulate UMIP on hardware that doesn't support it?
> >
>
> That seems to be the case: My host lacks umip, L1 has it. So, KVM is
> intercepting descriptor table load instructions to emulate umip.
> Jailhouse never activates that interception.
>
> Jan

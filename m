Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06A261748AE
	for <lists+stable@lfdr.de>; Sat, 29 Feb 2020 19:33:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727403AbgB2Sd0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Feb 2020 13:33:26 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:39460 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727274AbgB2SdZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Feb 2020 13:33:25 -0500
Received: by mail-lj1-f195.google.com with SMTP id o15so7032088ljg.6
        for <stable@vger.kernel.org>; Sat, 29 Feb 2020 10:33:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=J0QUgzZ4WkYGkcRzl+slh7S/9xKhHLAbeIDFRLeX4rY=;
        b=Pv97Pxv7b0wU24jRqR7G5YZY9n7APjj/ALQ0caAR8Id0ktGWCsHqyGFZSeA/LEdfFf
         iDCHTWuZ1WbLL9I4uSLaRgXcjiZA7cDOhmAHiAzEeiOT8S7hJjAWmDSCXEZTtxP994x2
         OPkkRsAgjae6w3YWRKvH+CeSbsJyCde7zx9/FR5qbYJ4R6rFyjVxNewl8BAXWJ3pJLJ8
         rQtFdml4SigigKM/eAG2tEbVglD32SraR7GlDPKd31DE42SD9L25jP4a1Lsshl2xuRYP
         vKD9joU/IWNwS19M6od5S3XeeydZiNxrxDQKWrc0CMs5QPPY3H9ZA4nt64xZiT2WoxHJ
         og6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=J0QUgzZ4WkYGkcRzl+slh7S/9xKhHLAbeIDFRLeX4rY=;
        b=Qh9jQda1zq6A4FcTlHTmsGO5PqRS/eAdeLk4xl7j9FNmuAKNmJW6P01M1n43+mc7eh
         ebK0jq71a3agzu2WX2M7nEVvhhokLP1Xocxb60KH3PkeVh/6pBZw7jwPS/P+gqvrPfGd
         jnbjLi2PjPt7kdd94N5RpGsiedrZBS7FJzEQ/LyXxypJTwOeKcv2jv5SXCe5Ym0GC2yY
         QEIOGtWCR1GYDFOaDbaT1Llvr2x27qBaySoKros28CM9gxxbQBLOxV9XXtI1SzltsBbl
         q32V88i8Fn1K7buM3JrDENzZxs1lSI47qjxK1ZE4rYN4MOc29jSKAsy5C+zeSLomoBUb
         1grw==
X-Gm-Message-State: ANhLgQ1Oxi52okAfZT5+IJz7ucpCURTnPLF1CiLtcN5lXreGwQSzmPDq
        ex8oTT/g69kjURHCfQ+BNH3hyo0mDj497Y8vGcom0Q==
X-Google-Smtp-Source: ADFU+vtSviI3qlY7iSQKY0tYuP5O6rDtodZyvgxGWul1aApy5++Pdps2sONbzNDv2OmtBRGkjQOImS5ZTyGBxCEfcHU=
X-Received: by 2002:a2e:3608:: with SMTP id d8mr6575052lja.152.1583001203709;
 Sat, 29 Feb 2020 10:33:23 -0800 (PST)
MIME-Version: 1.0
References: <1582570596-45387-1-git-send-email-pbonzini@redhat.com>
 <1582570596-45387-2-git-send-email-pbonzini@redhat.com> <41d80479-7dbc-d912-ff0e-acd48746de0f@web.de>
In-Reply-To: <41d80479-7dbc-d912-ff0e-acd48746de0f@web.de>
From:   Oliver Upton <oupton@google.com>
Date:   Sat, 29 Feb 2020 10:33:12 -0800
Message-ID: <CAOQ_QshE7SMX2cO7H+21Fkdpg53oE2D3xrHPJHR_MCfH4r9QCQ@mail.gmail.com>
Subject: Re: [FYI PATCH 1/3] KVM: nVMX: Don't emulate instructions in guest mode
To:     Jan Kiszka <jan.kiszka@web.de>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>, stable@vger.kernel.org,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Jan,

On Sat, Feb 29, 2020 at 10:00 AM Jan Kiszka <jan.kiszka@web.de> wrote:
> Is this expected to cause regressions on less common workloads?
> Jailhouse as L1 now fails when Linux as L2 tries to boot a CPU: L2-Linux
> gets a triple fault on load_current_idt() in start_secondary(). Only
> bisected so far, didn't debug further.

I'm guessing that Jailhouse doesn't use 'descriptor table exiting', so
when KVM gets the corresponding exit from L2 the emulation burden is
on L0. We now refuse the emulation, which kicks a #UD back to L2. I
can get a patch out quickly to address this case (like the PIO exiting
one that came in this series) but the eventual solution is to map
emulator intercept checks into VM-exits + call into the
nested_vmx_exit_reflected() plumbing.

--
Thanks,
Oliver

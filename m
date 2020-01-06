Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B42413192E
	for <lists+stable@lfdr.de>; Mon,  6 Jan 2020 21:18:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727025AbgAFUSX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jan 2020 15:18:23 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:46235 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726742AbgAFUSX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jan 2020 15:18:23 -0500
Received: by mail-io1-f65.google.com with SMTP id t26so49970425ioi.13
        for <stable@vger.kernel.org>; Mon, 06 Jan 2020 12:18:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4Rcg5ibwjG8y5aZAcf4B6F5Z9gExCdMlFDQO0Lciu24=;
        b=lqiq0v9HxFYQSzvoTItL5VboCgvXcPwJrDfjRt4tRzrNP91NfyDXsOiJ0/fojLIeK3
         cZDHOPcKfYWr1Imrjm4ukSv9jgmuqIUFul4cWpToTfFisGt9agV5pyTQYUhw/d56TCA1
         TED+wvKRPwaaajR6wEOAcNtQqO4eOcvinx1dX2jdTd2Kemd8PzCsuPJGravprw31HYd/
         /Q4rQfBCmTNo24mSI3jiIJdTm1ysoZI5RejQGz1yQd0FjM+dJ3zBPY7kWWX0BAepujEy
         B0rIjdFhlP24gElV5/X3YMNSxkww59fgjkVGTad5O92J+/njh17oPYTfbM5B7a3NrsxH
         MpTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4Rcg5ibwjG8y5aZAcf4B6F5Z9gExCdMlFDQO0Lciu24=;
        b=k0QMxiKg54EWsrfD4fX7Y4Rsi89TFknF8bMyp+0SswOB+FdMZ/Zc5Z//MjB5tGeWxC
         VlqFlbifzaldAX4kcEOxOl3jrwdf322tUD/XIl2kErxeeYWNrNp4h86jTXIifcM+GCsE
         sR0ucYQ8C7aZFKJkIDeFtXnxBSMATARjZzUhgLehjIRpLg6bk/61k0ZpT2PmoBowalIi
         ynKRf8yNlpuJ6KnWtJZJ8xs/0LHEU/Dbsu/2xzbMl6xmYTIcQxgomXDgq71eCc/XcQmJ
         MmkwVQclDUVV2tfZZEM2NvxG/NMVl4rc7zwmvAgr/ScGLSg+gkHXU/g9Ux9XQTRK7ZL0
         Qb9w==
X-Gm-Message-State: APjAAAUbY7d5l+kp+9Q2MjTAU9ToZ+cXeEP05UlXbgrCSUdl0+gGdqD2
        fEg6uyKpi83t96p78pp5V0KUobcoVMOvRqgvMgcs7g==
X-Google-Smtp-Source: APXvYqxjZclUu0eB6nMi8sSpfdOj8OZ6c2MrV6ct440WVHQXTLBSRRbC9HlKNRn8NRGFiuthiYpgPudrQf4lSXaDVdI=
X-Received: by 2002:a02:c906:: with SMTP id t6mr73461739jao.75.1578341902473;
 Mon, 06 Jan 2020 12:18:22 -0800 (PST)
MIME-Version: 1.0
References: <20191211204753.242298-1-pomonis@google.com> <20191211204753.242298-8-pomonis@google.com>
In-Reply-To: <20191211204753.242298-8-pomonis@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 6 Jan 2020 12:18:11 -0800
Message-ID: <CALMp9eSvJYzuYmn6sUo5zNGLAmA=d_Pu4DcmCQTMAFCP_dBHsg@mail.gmail.com>
Subject: Re: [PATCH v2 07/13] KVM: x86: Protect MSR-based index computations
 in fixed_msr_to_seg_unit() from Spectre-v1/L1TF attacks
To:     Marios Pomonis <pomonis@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Nick Finco <nifi@google.com>, Andrew Honig <ahonig@google.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 11, 2019 at 12:48 PM Marios Pomonis <pomonis@google.com> wrote:
>
> This fixes a Spectre-v1/L1TF vulnerability in fixed_msr_to_seg_unit().
> This function contains index computations based on the
> (attacker-controlled) MSR number.
>
> Fixes: commit de9aef5e1ad6 ("KVM: MTRR: introduce fixed_mtrr_segment table")
>
> Signed-off-by: Nick Finco <nifi@google.com>
> Signed-off-by: Marios Pomonis <pomonis@google.com>
> Reviewed-by: Andrew Honig <ahonig@google.com>
> Cc: stable@vger.kernel.org

Reviewed-by: Jim Mattson <jmattson@google.com>

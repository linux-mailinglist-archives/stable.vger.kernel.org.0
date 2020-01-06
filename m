Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 228E913191F
	for <lists+stable@lfdr.de>; Mon,  6 Jan 2020 21:17:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbgAFURN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jan 2020 15:17:13 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:44897 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726721AbgAFURN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jan 2020 15:17:13 -0500
Received: by mail-il1-f195.google.com with SMTP id z12so7171027iln.11
        for <stable@vger.kernel.org>; Mon, 06 Jan 2020 12:17:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LxvwhJJ0uR0l3XlAR6Ya25i11ON7evDplvpGhKU4LZo=;
        b=NCc+tSWRs4DoBDCc2IweeZQ/X1n5EKwZ4hA9koLfWxjBZi0elUS+ckWbY4YxEZ/bKF
         TXE53YiO1FSF9lxsO+D5SpWLwFhJaGbfG3I6y6ihNxGuRDsByIXHBwnp8VQZV10ZrYPF
         JNGgY6LQXJIW9WYui/HJtuXmqAPzvTIQB2/jI6eL/AnfoMsSWPhErI4X4rEckqjVUsVC
         BmSRf7yOcomjqmZlfdK8Ly8fMnlt0H1ufQBoGYiQu6LH8gP4qT1rEOGiuDNVlwxfPqfq
         LN06g7d6u+1ivjvWNtPZFoSvydyU2MyCUuE4XXrUI4dTImUMwmh4/R+JkHYtefn12tCP
         CkWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LxvwhJJ0uR0l3XlAR6Ya25i11ON7evDplvpGhKU4LZo=;
        b=k44nEw2LfQpMtU2ioBf8nIhwjmxBJu0Q6FCnszZYmceys2Ha6ZWtnHV7dldBfVnQ7Z
         kvRJdoz/0KueZXiufkwrcBEe45n6uwmXUlXE3KNQFOTUYCk6Fk0Iy+VbMS7fFsOBMJ1J
         V1W5gyyuU6i49swvvE60klZjTduzvDhs3/r2fEnZiFMjQ8HNC5DRONWy3vUyG3dVBLZe
         WSJQjME8OmJgFDmWJ+OXg34Gt8Q3yUUIAb52wPB3AsMbz2ACRvm16Ejdbuk31JYqybU3
         yArXXXXbQkhu2r1AZZ/RGxuzdkI/KkGWjpiUv2Cg+koAJvxyTYypABy5Y4a3T+DxxltT
         jcYA==
X-Gm-Message-State: APjAAAUdOrosE7JN1/z46Xc3NzbIePZvFnzIlyt1liL5RCx/ZZjfATbR
        JYnu0aKZlhuSrq0LJKKeVGmEq6suISbF/SXo1cjv3A==
X-Google-Smtp-Source: APXvYqz+I+w1AKAX4I685EkhXLV0JGNj7Ig7L3KcjNLDo2lQBjrY4YdOG2hhx8MIKccUvvq8iyzLWgCunGxYEoz2vTI=
X-Received: by 2002:a05:6e02:8eb:: with SMTP id n11mr89886746ilt.26.1578341832825;
 Mon, 06 Jan 2020 12:17:12 -0800 (PST)
MIME-Version: 1.0
References: <20191211204753.242298-1-pomonis@google.com> <20191211204753.242298-4-pomonis@google.com>
In-Reply-To: <20191211204753.242298-4-pomonis@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 6 Jan 2020 12:17:01 -0800
Message-ID: <CALMp9eRVZpUMacu38Kpp5iQoSP=3Pcy3WQBO+wm9wDBpSmqSbg@mail.gmail.com>
Subject: Re: [PATCH v2 03/13] KVM: x86: Refactor picdev_write() to prevent
 Spectre-v1/L1TF attacks
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
> This fixes a Spectre-v1/L1TF vulnerability in picdev_write().
> It replaces index computations based on the (attacked-controlled) port
> number with constants through a minor refactoring.
>
> Fixes: commit 85f455f7ddbe ("KVM: Add support for in-kernel PIC emulation")
>
> Signed-off-by: Nick Finco <nifi@google.com>
> Signed-off-by: Marios Pomonis <pomonis@google.com>
> Reviewed-by: Andrew Honig <ahonig@google.com>
> Cc: stable@vger.kernel.org

Reviewed-by: Jim Mattson <jmattson@google.com>

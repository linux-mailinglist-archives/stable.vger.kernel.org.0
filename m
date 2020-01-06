Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 105F213193C
	for <lists+stable@lfdr.de>; Mon,  6 Jan 2020 21:20:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbgAFUUG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jan 2020 15:20:06 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:42582 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726734AbgAFUUG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jan 2020 15:20:06 -0500
Received: by mail-io1-f67.google.com with SMTP id n11so43220816iom.9
        for <stable@vger.kernel.org>; Mon, 06 Jan 2020 12:20:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TLp/ufTp0fYjzVGW4DuTeiICdn7BWt7SHYlnsorurds=;
        b=ZBuZ0lTtXh/HFFduyGbHQ9mz6qhkf8isglZMJ6rkGMDKlIz348zz+FJBrCXiecfNaM
         G9XU0aDZUJkspgvq3dFrptFOtCxw7/9q6e0oYnK4KIO+tN/R91Gho+qO1JCbvEKUAZ9B
         +DgRmsuBBUYTJ8icaKwHyadigaTDz5JFzR+Bo1+tsDQ0c0N2tI06q1X4Zz9aDcm0HIVR
         nTRaKaCZ91cXY6OTZ8kS7QNPWIxeMgLEwMscPMAiEggKYcabM9fBWnPCP9DCezGB+Fxa
         Mmws4V8umADBZPcQsWfcItQzOaa1cL8vCQopvUyD7PBZAt8gfpLwO1Y+ZF9DyQ43UM+Y
         Q+FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TLp/ufTp0fYjzVGW4DuTeiICdn7BWt7SHYlnsorurds=;
        b=Q5nGoI1wRbtDvtk+7jrd8lmOq4n1rujjXOA6Oe50sXCTO4mramE1hpK/R5pyE+fIST
         KDQfu17bfMU/wfd0dJ9DVY/n/uO6POx9wL/y9XZO4RwOYEFd/LwJdMuTw+6Afq9l9pO+
         76MeRUd3QmyWkNF53bw7zgnbt34d2IWHTHqd1Q59LBGXWm2FFRW2N8SpQIvt0yq52IZr
         vohqiPsaxztXnqSErLDiypbHik+jRU3FA1m8zQdUMRLg/TPhjYwFhrqKPatYTV4ovB4n
         ZefH3aEDR3WsQ9h+PEFSI6FMioKy6zcGJ7YdlSw7zIRJu6JApSYreywyRWGh9NHPC5+K
         AjAw==
X-Gm-Message-State: APjAAAW/t3JG7SULZ6Bx7DAKE54m/vY0OiQT2n9CrVlXzihq/NZRFra4
        ladI9C04VJN2/F60A/F6clZnrC0Bp0LLL8qZx3BNww==
X-Google-Smtp-Source: APXvYqwumr0YiUR0oP6hMxgSGdJNExJQPdoLDRU2fDq+CxkJ0j2PVxuRSCVAbrGf9CGxXEwqGtmFfotDtPJwPjeEIiU=
X-Received: by 2002:a02:3312:: with SMTP id c18mr79437851jae.24.1578342005752;
 Mon, 06 Jan 2020 12:20:05 -0800 (PST)
MIME-Version: 1.0
References: <20191211204753.242298-1-pomonis@google.com> <20191211204753.242298-14-pomonis@google.com>
In-Reply-To: <20191211204753.242298-14-pomonis@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 6 Jan 2020 12:19:53 -0800
Message-ID: <CALMp9eSixcb+LMxNV6t-_FHzxPHDRV45R3FZ835xvpqk6hM1Gg@mail.gmail.com>
Subject: Re: [PATCH v2 13/13] KVM: x86: Protect pmu_intel.c from
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

On Wed, Dec 11, 2019 at 12:49 PM Marios Pomonis <pomonis@google.com> wrote:
>
> This fixes Spectre-v1/L1TF vulnerabilities in intel_find_fixed_event()
> and intel_rdpmc_ecx_to_pmc().
> kvm_rdpmc() (ancestor of intel_find_fixed_event()) and
> reprogram_fixed_counter() (ancestor of intel_rdpmc_ecx_to_pmc()) are
> exported symbols so KVM should treat them conservatively from a security
> perspective.
>
> Fixes: commit 25462f7f5295 ("KVM: x86/vPMU: Define kvm_pmu_ops to support vPMU function dispatch")
>
> Signed-off-by: Nick Finco <nifi@google.com>
> Signed-off-by: Marios Pomonis <pomonis@google.com>
> Reviewed-by: Andrew Honig <ahonig@google.com>
> Cc: stable@vger.kernel.org

Reviewed-by: Jim Mattson <jmattson@google.com>

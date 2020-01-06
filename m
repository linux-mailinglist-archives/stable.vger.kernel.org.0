Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4811B131922
	for <lists+stable@lfdr.de>; Mon,  6 Jan 2020 21:17:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726760AbgAFURc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jan 2020 15:17:32 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:38182 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726734AbgAFURc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jan 2020 15:17:32 -0500
Received: by mail-il1-f196.google.com with SMTP id f5so43631191ilq.5
        for <stable@vger.kernel.org>; Mon, 06 Jan 2020 12:17:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2CX2u59yxqQEiQeQX3TdwASVbTfuTtyRiCwtCS2hV9M=;
        b=r8n4416RC0OjW2zQZKUoUGwBPq+fLIjkEFiWRwI2k9OC6xfH8LexxBEoS0JBAKL4ep
         glcWvgtALerSfVE7MX3hVQsEzoDEMEvdBi2XV5OuFjQ/+rHFaGLv0Y6TVIKJeGE2K4xr
         hPGAu2ZsOO47P84w3U2lb5Pq6FkNZ97fG315dOqz+ZHZ92dKtbrauczGHZ4UiFER5Qzw
         tvRcP0oEPyL8O/VjBoyZq1h3n8jcz936VNWZIW7jJO35SZiO6p4mFIjXs27PSe3mz4hr
         vLfja4o0UrgiZvGv7Wem6QD7qJ7tYB3zq9tgK/CX8e77skiBewq9ETOr5AZrOs8zMWm2
         1CWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2CX2u59yxqQEiQeQX3TdwASVbTfuTtyRiCwtCS2hV9M=;
        b=CghVGMEZ8/9C/IaZq0AK6C5SMaCId4N+Z5jy2MKt2A08ekL3hmt/5Cfp/BDtaRDJ5C
         Vj25MZ9HP9uXXv+XKtzaOyYVncCUSxXMppT138Wtaydpz1GLwjyX+s3eSZXRMZ0spm9Q
         DQUQ7Ce1BlMf5mJxvd2c8cU6Uay2PGbB8GxRHz1pABOVrrrPk7xmSx0KO96r5vCqzQZO
         tuzabrrCmq1hdSFeqUNHniln1+qjOU4aL7P9SzeIPY7hhUS5rQwvyqrc/GoVT5aBUbQQ
         95i3hM1ndnPh845ZrXYJXMimkD4JKNqsbpBGBsvsBoZ2CSXsccylBYPtVbcg0bKEzycB
         iLHg==
X-Gm-Message-State: APjAAAWYVeDjFbiRCxhoMQASsPojSx4Baa/Q7ktcLlEBB+klRtDiYTjk
        r8q1T8eivd4eCMMqfKhpIdG92FqRJZfErOok3Hn+jA==
X-Google-Smtp-Source: APXvYqyReQmw36zPln5QfGWBGVhIpVbv13BJN1T5wbGPlk3lk3Azd0+w4PYXRQmNj1E1SHsoTt2laBhaYWd3jSRwsW4=
X-Received: by 2002:a92:8458:: with SMTP id l85mr88666783ild.296.1578341851389;
 Mon, 06 Jan 2020 12:17:31 -0800 (PST)
MIME-Version: 1.0
References: <20191211204753.242298-1-pomonis@google.com> <20191211204753.242298-5-pomonis@google.com>
In-Reply-To: <20191211204753.242298-5-pomonis@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 6 Jan 2020 12:17:20 -0800
Message-ID: <CALMp9eTCTj-V0ihi0sQAkjOpKA2HzNY85WiX9LxRQODGvGN1aw@mail.gmail.com>
Subject: Re: [PATCH v2 04/13] KVM: x86: Protect ioapic_read_indirect() from
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
> This fixes a Spectre-v1/L1TF vulnerability in ioapic_read_indirect().
> This function contains index computations based on the
> (attacker-controlled) IOREGSEL register.
>
> Fixes: commit a2c118bfab8b ("KVM: Fix bounds checking in ioapic indirect register reads (CVE-2013-1798)")
>
> Signed-off-by: Nick Finco <nifi@google.com>
> Signed-off-by: Marios Pomonis <pomonis@google.com>
> Reviewed-by: Andrew Honig <ahonig@google.com>
> Cc: stable@vger.kernel.org

Reviewed-by: Jim Mattson <jmattson@google.com>

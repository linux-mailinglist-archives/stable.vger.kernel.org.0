Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC2C102C41
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 20:00:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727617AbfKSTAp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 14:00:45 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:45085 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727295AbfKSTAl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Nov 2019 14:00:41 -0500
Received: by mail-io1-f66.google.com with SMTP id v17so13345018iol.12
        for <stable@vger.kernel.org>; Tue, 19 Nov 2019 11:00:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0tlDOLamzXoB2txFi3bDr1lzl/uIOL5HoxDwsrMLE1Y=;
        b=QxgP7imn6TlYA7oi3x9pxhpZOtUUaToTMcAcmJRBH/dLvkCpP3EdF2QL5G4i2nA8DU
         Cq+DjhaOlof76EnZkWYD2y0d3NEa2cuX34uGwANcP8or0pu2JcTmaUh3imVEevFXQ0oU
         O897Np0pV2Lfk02x/PJCjyFa5f30yLGFkuqm4+nhsflv8PN6PWLoqmlsRWvdYL1oxSj4
         +Kk4EgtTSaAsd1+R6VwqACpKGRgTrKpWxfvCwfx8Rydm7W2xNXO6CWReFmqJ3/J3t3jT
         LaSgIxuo3K3zT6ApVC0ucLKXr6/Q4y/JkdQwvHRwoFYK92mXUVnopO42DcP5XeeHXX9g
         /7cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0tlDOLamzXoB2txFi3bDr1lzl/uIOL5HoxDwsrMLE1Y=;
        b=khHGVnS0KImRGnMyXNk5nwxy8p83bP49zUb9uwHwVcvnslWKmWYlD35XnAr6yrQCA/
         3Da58EH1MDO/Qu46+2an7q4IIOj3QJ23qsLo7kjoe+/zG11b39mBBfdtIFFIFYRp/4Rt
         VHxbyutdaoZBVQsOtSllrSXrEtcXzMobswu9FZe8okU4HyAO+vdEIy4dW14vTjPaHLxJ
         iYG9lRQKzGclNmtl6NmSF5Bjm8piCVsmZpLFTQZN9K3bCqCCKzPyNMeI41ZIO+hkgqxE
         wI9CTczh/MSfwpJSkptI1+VrvwKiCa6P/jr0qFeAwiIDSmG4tusnn8pld//tMyJAsDOL
         IKsA==
X-Gm-Message-State: APjAAAWcn8pCaAsAVA4G21R3J5PsQnpKNekHDfBu+TvrKEcyNR18bfiN
        QP5lScCrM6MVUM2ow4+hx6aNl5I1t82CvjnSb8j3fg==
X-Google-Smtp-Source: APXvYqxrjt4bI9Z0ev5yPYL85atGFtMdcQsDoCEeiQ6jKiUgcWy9z7waZeREcBFeRT8RtQahzj5rQTQXHIYn4AAp6Ck=
X-Received: by 2002:a6b:e016:: with SMTP id z22mr12327691iog.296.1574190039715;
 Tue, 19 Nov 2019 11:00:39 -0800 (PST)
MIME-Version: 1.0
References: <1574101067-5638-1-git-send-email-pbonzini@redhat.com> <1574101067-5638-3-git-send-email-pbonzini@redhat.com>
In-Reply-To: <1574101067-5638-3-git-send-email-pbonzini@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 19 Nov 2019 11:00:28 -0800
Message-ID: <CALMp9eTzAFYt1wkXT+OEx=vNs0rrCvp=8XG8Jbwwaj3mSPPF+Q@mail.gmail.com>
Subject: Re: [PATCH 2/5] KVM: x86: do not modify masked bits of shared MSRs
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 18, 2019 at 10:17 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> "Shared MSRs" are guest MSRs that are written to the host MSRs but
> keep their value until the next return to userspace.  They support
> a mask, so that some bits keep the host value, but this mask is
> only used to skip an unnecessary MSR write and the value written
> to the MSR is always the guest MSR.
>
> Fix this and, while at it, do not update smsr->values[slot].curr if
> for whatever reason the wrmsr fails.  This should only happen due to
> reserved bits, so the value written to smsr->values[slot].curr
> will not match when the user-return notifier and the host value will
> always be restored.  However, it is untidy and in rare cases this
> can actually avoid spurious WRMSRs on return to userspace.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Jim Mattson <jmattson@google.com>

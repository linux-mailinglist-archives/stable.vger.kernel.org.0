Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F204A787DA
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 10:58:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727206AbfG2I6o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 04:58:44 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:34672 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727195AbfG2I6o (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Jul 2019 04:58:44 -0400
Received: by mail-lf1-f68.google.com with SMTP id b29so34247708lfq.1;
        Mon, 29 Jul 2019 01:58:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=I1Kj7YUPvkqZu0AVoqLEWB0rMOmtYob12XhQjO3Ri6Q=;
        b=cqvfLHPFUr5VxLj7mTj7MPXkdMQrlElRYzxTAKvcRGsHMjXI10VTKm4NlH9fEjQCX7
         +HyrBLZh73kMWXuARtvgjMlo6mHSUe5xs+i/Jhy4EblsDE7sji2m1JzJ3oaeyt/EuFnb
         mK0hJ18HHpmV3uHcNB5U6SBZc7ICPlwSSgwX5eQbHPsRuHa9PhFEJnjhPo29ufjn+mwK
         REBtU646Guh/uerj6wz5DOsVddH3mBBhJ/5AGJO97VwAofsGZeelKO0q0Lemqj50c/Dz
         nsneBBBi7xzaAPaX/70YoFTn0x2CY4K+SXJKHtxuWSOA8+6uFU4I2i+2HPZNAGKevH7s
         fV4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=I1Kj7YUPvkqZu0AVoqLEWB0rMOmtYob12XhQjO3Ri6Q=;
        b=MgHmd4uYtFe8WB38OOp4+SUMj6T76r5U+PX7+WqTQePF+FWrZqlLYdvvtH9SbuxYff
         RfHnvD+7JlYP/ogyZMlyCZRHI2Ny2wTd230B9EBwEMKWPFj0J5Wk616AdU0OlXXO09Ew
         /WUOhJjegZbdXNouxW4CH3q+rW7xPRdeZmiEM00WYgppMc7pIGkLHTd+hsZY0Qa/Htfx
         QYHyCh3fRXpLPd676/YpiXA5rr5Ldj/v6c4vXgNxb93YwMqfHDJq0a2tI6y736u0hCyl
         a5Yb/g1uJHyUCLm5oJa1DqgcbAkeEn46kzTHmIwn7JxEh3S2wmbPuW5paej+s3LLeJn6
         tVgw==
X-Gm-Message-State: APjAAAXBZryT5ctImfqcZnTuRQsY2Nta8R30GPnHmVuSWY2ELajUXD5D
        7Ak0m4er+tJAn+yHcGB4BqX6bjm2z3qPuUtD9/1iIA==
X-Google-Smtp-Source: APXvYqwEYMRATv6hJXcp2sN2uBqY7MeCPBYc/cx7vGGCDzzL9FkPA8m7NHC3RC8RJW7yXkhUwM+YmkfaE0n50XYnM0E=
X-Received: by 2002:a19:4349:: with SMTP id m9mr50210064lfj.64.1564390721868;
 Mon, 29 Jul 2019 01:58:41 -0700 (PDT)
MIME-Version: 1.0
References: <20190725104645.30642-1-vkuznets@redhat.com> <20190725104645.30642-2-vkuznets@redhat.com>
In-Reply-To: <20190725104645.30642-2-vkuznets@redhat.com>
From:   Jack Wang <jack.wang.usish@gmail.com>
Date:   Mon, 29 Jul 2019 10:58:30 +0200
Message-ID: <CA+res+RfqpT=g1QbCqr3OkHVzFFSAt3cfCYNcwqiemWmOifFxg@mail.gmail.com>
Subject: Re: [PATCH stable-4.19 1/2] KVM: nVMX: do not use dangling shadow
 VMCS after guest reset
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     stable@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Vitaly Kuznetsov <vkuznets@redhat.com> =E4=BA=8E2019=E5=B9=B47=E6=9C=8825=
=E6=97=A5=E5=91=A8=E5=9B=9B =E4=B8=8B=E5=8D=883:29=E5=86=99=E9=81=93=EF=BC=
=9A
>
> From: Paolo Bonzini <pbonzini@redhat.com>
>
> [ Upstream commit 88dddc11a8d6b09201b4db9d255b3394d9bc9e57 ]
>
> If a KVM guest is reset while running a nested guest, free_nested will
> disable the shadow VMCS execution control in the vmcs01.  However,
> on the next KVM_RUN vmx_vcpu_run would nevertheless try to sync
> the VMCS12 to the shadow VMCS which has since been freed.
>
> This causes a vmptrld of a NULL pointer on my machime, but Jan reports
> the host to hang altogether.  Let's see how much this trivial patch fixes=
.
>
> Reported-by: Jan Kiszka <jan.kiszka@siemens.com>
> Cc: Liran Alon <liran.alon@oracle.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Hi all,

Do we need to backport the fix also to stable 4.14?  It applies
cleanly and compiles fine.

Regards,
Jack Wang

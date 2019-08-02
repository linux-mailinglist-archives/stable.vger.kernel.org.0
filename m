Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E475A7E742
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 02:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388527AbfHBAqb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Aug 2019 20:46:31 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:45752 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388445AbfHBAqa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Aug 2019 20:46:30 -0400
Received: by mail-ot1-f65.google.com with SMTP id x21so10856697otq.12;
        Thu, 01 Aug 2019 17:46:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=CDFD46ut81E8VwlqLjeuyvzxSwZjo8F7gM2/ZFXswBY=;
        b=gxLOwZ9riE7793zK9fk23yKTiEUO9gK9RGH62fXyYY638iwz7Kx2gM7FJV3kIR6VSq
         Jxj0w9iTO6LHbisVugKd3b5rCJA/M0qm5DNwL6v6TAh+sryfOt2bGopy1/Ua/MgWbZHl
         VzbwNDoW84HXeF+Ex8dNpDqU+GbE5y7mARy5v92TXaaS1LbOMWn2pYu2TqyvJq1ucAn0
         /l/rIc/oanU39m0Vtl28mzBUKEwpbcqdvuu/B1x1J/hUfc8QNhSayOZQyTUjf/m2udzH
         Noqg77gH815OcnAWGtOCf85DWwWDeEaSzts6QBLlnU1reoXtS4IwvaZZt6rWdV1iGWQX
         0fGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=CDFD46ut81E8VwlqLjeuyvzxSwZjo8F7gM2/ZFXswBY=;
        b=Utg9AQAdueeX1RIaRApSBMsH6y3Q+H5QpSjB6NlYVP1XUr1l+FJGdfO9JXxr7hny7J
         YCu+/EXO0gA95YcsnsSDVGeK+XjHptWtQYP8nX69qFbv/TnjZJONt9w+M4/eycrWEo3G
         JuG686FwXniGVaDiT+8jLiKkDUvhPDGqEOjpFqu8EYkc7gUBHnkHOQ3UAI4pR008WBUv
         Lbk6kKmOp+uWCe2yigo9N4zUT5ZQSH4bAysNxQwn7HyFQo6tU15hTkBa+zcBEVRtHPWx
         Um4CoDet9RH/0EbPl+IMZuXc0TgxEKPG5Qc6FD/MncTPIdtyxkFcBl2uC8Y9BJdjcaPI
         fgzg==
X-Gm-Message-State: APjAAAUeV32asdgSibIGCHrOmZfJ7bwtxM5uLONkFDul/gEiugjCN1KM
        cCQ4NtfDBJgqzkXznlnd9hvqNeFGHyfGhsQHiy4=
X-Google-Smtp-Source: APXvYqzhD3YpXIGxB6FHMwt9IWh9FBRrgHSvj6HDzjm7u8XqADLVKWFaW/xHw9haPVsRAJ86ZuKbeMMezkUr1WqyiI8=
X-Received: by 2002:a9d:62c4:: with SMTP id z4mr93889061otk.56.1564706789925;
 Thu, 01 Aug 2019 17:46:29 -0700 (PDT)
MIME-Version: 1.0
References: <1564630214-28442-1-git-send-email-wanpengli@tencent.com> <20190801133133.955E4216C8@mail.kernel.org>
In-Reply-To: <20190801133133.955E4216C8@mail.kernel.org>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Fri, 2 Aug 2019 08:46:11 +0800
Message-ID: <CANRm+Cy1wWSwn7HH-dNWeR6FX1TT_M7t_9vvRMdCKFATmvFDkA@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] KVM: Fix leak vCPU's VMCS value into other pCPU
To:     Sasha Levin <sashal@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "# v3 . 10+" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 1 Aug 2019 at 21:31, Sasha Levin <sashal@kernel.org> wrote:
>
> Hi,
>
> [This is an automated email]
>
> This commit has been processed because it contains a "Fixes:" tag,
> fixing commit: 98f4a1467612 KVM: add kvm_arch_vcpu_runnable() test to kvm=
_vcpu_on_spin() loop.
>
> The bot has tested the following trees: v5.2.4, v5.1.21, v4.19.62, v4.14.=
134, v4.9.186, v4.4.186.
>
> v5.2.4: Build failed! Errors:
>     arch/arm64/kvm/../../../virt/kvm/kvm_main.c:2483:31: error: =E2=80=98=
struct kvm_vcpu=E2=80=99 has no member named =E2=80=98async_pf=E2=80=99
>
> v5.1.21: Build failed! Errors:
>     arch/arm64/kvm/../../../virt/kvm/kvm_main.c:2415:31: error: =E2=80=98=
struct kvm_vcpu=E2=80=99 has no member named =E2=80=98async_pf=E2=80=99

Thanks for reporting this, after more grep, it seems that just x86 and
s390 enable async_pf in their Makefile. So I can move 'if
(!list_empty_careful(&vcpu->async_pf.done))' checking to
kvm_arch_dy_runnable(), Paolo, do you have more comments to v3 before
I send a new version?

Regards,
Wanpeng Li

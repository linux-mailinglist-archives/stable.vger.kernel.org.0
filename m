Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2D4178865
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 11:29:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726818AbfG2J33 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 05:29:29 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:42262 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726496AbfG2J33 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Jul 2019 05:29:29 -0400
Received: by mail-lj1-f193.google.com with SMTP id t28so57878460lje.9;
        Mon, 29 Jul 2019 02:29:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=EUZh/qN6trgEx5OPsgFHbmysYhr2RtqhZ92QIyN8AEU=;
        b=FYsVdZc3ErugKgik5hDEvCr15AinQhzBFMahAbFB5F9NIyb1PqtWUyHnntQT5Rt/wj
         MVY9p5JBtv1d1yiqwgLJ9wWpjnsaX12Z9SZtGFfwR6xkhyoXdINNFatlaHLVy5rLh5Hx
         1ufVdL/r2xXzl66rawHYIEYaJd54mnZ2yYA7wsTp6z9xXap+Z732dMFkewF4MK2eD6Tb
         SZamUOimPY5chm+FG0aSbEGhcTXSMTVfkZKUYct4Nr9Gb7sHILdV1AkUXukIHxkdLpxm
         Uv4YgJKGexZLGIfddYlTFjViUe7V/p+0n6tDoJi+JWNZB6sR0S+YcJv/mtHazfFdvr1V
         kc2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=EUZh/qN6trgEx5OPsgFHbmysYhr2RtqhZ92QIyN8AEU=;
        b=hrergS5qDQyDLXMiLqMgE+hpP//wjuCnDkbral3WdwaoVXoJNoHdOFzmexUnj5WtWa
         dnSDpHVOqMIT9R43unZ5t2LRh8tBxe0bHA/4KMupvlFuPRxO3fJVEz3TjhQYp1EcRfMc
         jMrX8SaMOAP21Np3d1JXHCw01OnkrfOypaLQ225RBHsjI4W+MEJJDTmqHVXdtxe58qSs
         JHhI7LAue4Vpx8T6q6Q7FlDHjAr8dWWdpQQvjhb5NFM4vg1cvP7nhNrmA0Gpa9lw+Q6B
         bwXFYdeD5VLGLM+AD4EC55G4AHpBslNqBS3hUGRvkkYtH3toUWZQAW0syfdK/XmKsNCG
         R5oA==
X-Gm-Message-State: APjAAAVBWAz6tEE84hazPIyy5VlRokhXltt2wwhxStkrGMkTJNV240Df
        5NtGRnV4cXC17vtjMDUsVtqxczmIe1qP4J7dgWo=
X-Google-Smtp-Source: APXvYqwuqXvkd4fTU0Tgw1H9qOUd+bTU1QtFu6vVjIgA665YQgraHkIFI+cq1rQdpAn2o/LX1/TPkgxS0JPKQkPm5lc=
X-Received: by 2002:a2e:834e:: with SMTP id l14mr11299714ljh.158.1564392567034;
 Mon, 29 Jul 2019 02:29:27 -0700 (PDT)
MIME-Version: 1.0
References: <20190725104645.30642-1-vkuznets@redhat.com> <20190725104645.30642-2-vkuznets@redhat.com>
 <CA+res+RfqpT=g1QbCqr3OkHVzFFSAt3cfCYNcwqiemWmOifFxg@mail.gmail.com> <2ea5d588-8573-6653-b848-0b06d1f98310@redhat.com>
In-Reply-To: <2ea5d588-8573-6653-b848-0b06d1f98310@redhat.com>
From:   Jack Wang <jack.wang.usish@gmail.com>
Date:   Mon, 29 Jul 2019 11:29:16 +0200
Message-ID: <CA+res+ShqmPcJWj+0F7X8=0DM_ys8HCP+rjg4Nv-7o06EipJQw@mail.gmail.com>
Subject: Re: [PATCH stable-4.19 1/2] KVM: nVMX: do not use dangling shadow
 VMCS after guest reset
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, stable@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> =E4=BA=8E2019=E5=B9=B47=E6=9C=8829=E6=
=97=A5=E5=91=A8=E4=B8=80 =E4=B8=8A=E5=8D=8811:10=E5=86=99=E9=81=93=EF=BC=9A
>
> On 29/07/19 10:58, Jack Wang wrote:
> > Vitaly Kuznetsov <vkuznets@redhat.com> =E4=BA=8E2019=E5=B9=B47=E6=9C=88=
25=E6=97=A5=E5=91=A8=E5=9B=9B =E4=B8=8B=E5=8D=883:29=E5=86=99=E9=81=93=EF=
=BC=9A
> >>
> >> From: Paolo Bonzini <pbonzini@redhat.com>
> >>
> >> [ Upstream commit 88dddc11a8d6b09201b4db9d255b3394d9bc9e57 ]
> >>
> >> If a KVM guest is reset while running a nested guest, free_nested will
> >> disable the shadow VMCS execution control in the vmcs01.  However,
> >> on the next KVM_RUN vmx_vcpu_run would nevertheless try to sync
> >> the VMCS12 to the shadow VMCS which has since been freed.
> >>
> >> This causes a vmptrld of a NULL pointer on my machime, but Jan reports
> >> the host to hang altogether.  Let's see how much this trivial patch fi=
xes.
> >>
> >> Reported-by: Jan Kiszka <jan.kiszka@siemens.com>
> >> Cc: Liran Alon <liran.alon@oracle.com>
> >> Cc: stable@vger.kernel.org
> >> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> >
> > Hi all,
> >
> > Do we need to backport the fix also to stable 4.14?  It applies
> > cleanly and compiles fine.
>
> The reproducer required newer kernels that support KVM_GET_NESTED_STATE
> and KVM_SET_NESTED_STATE, so it would be hard to test it.  However, the
> patch itself should be safe.
>
> Paolo

Thanks Paolo for confirmation. I'm asking because we had one incident
in our production with 4.14.129 kernel,
System is Skylake Gold cpu, first kvm errors, host hung afterwards

kernel: [1186161.091160] kvm: vmptrld           (null)/6bfc00000000 failed
kernel: [1186161.091537] kvm: vmclear fail:           (null)/6bfc00000000
kernel: [1186186.490300] watchdog: BUG: soft lockup - CPU#54 stuck for
23s! [qemu:16639]

Hi Sasha, hi Greg,

Would be great if you can pick this patch also to 4.14 kernel.

Best regards,
Jack Wang

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2654CF0812
	for <lists+stable@lfdr.de>; Tue,  5 Nov 2019 22:17:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729830AbfKEVRY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Nov 2019 16:17:24 -0500
Received: from mail-oi1-f193.google.com ([209.85.167.193]:38974 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729813AbfKEVRY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Nov 2019 16:17:24 -0500
Received: by mail-oi1-f193.google.com with SMTP id v138so18937615oif.6
        for <stable@vger.kernel.org>; Tue, 05 Nov 2019 13:17:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PpxrzK7EMOTdgRJmBeuah8l9gL1LKP2zbjc+vtc00Ps=;
        b=mn0WWhLYGqn7h0gcRknjXDBVLncQwGAyV2IdSDjRy5zjt6mydls1/4NVBdMRbs5+gJ
         UEhHfb7YQKyZL/mngY/Bqk+c2b1MPiSfyIaoqrMdn3oMGxF0J/35Y3MOvZ+W1AUWmffT
         wzlJRbhxrWOxt0lxmaZqa449QMdjPustViMU1vnorZtIBrnvaJPMzE21t8Xfr/Q4ykR2
         DWBWhygGkopylSrm7h6HdP35KH/jTghbHGPFyr3dEP6xw1xfpIT/ABGgrOEiWFN5DZXi
         pMZMHG8vsnSwJg2mzYIn511PfAr15eOMbZdhqF9G1mN+QZ554rN7iPWt0pfVAmQd02l4
         RCzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PpxrzK7EMOTdgRJmBeuah8l9gL1LKP2zbjc+vtc00Ps=;
        b=tI0OdC698tKBFw33WdOfX2Y3ubabfzsarPuN/FXnLQSLQUaxVpMJN/R+ZVq9FKefP9
         +OMljfNbAkHbJFZbX+Zv63/Q+NY3+2Za0KcfZV/p9GIDsjno924hRCshIHRV/GQNbxIv
         R3TejSHD9SyvG3DIyon/WsIcEuDCW7pSVAfl3DfI5VuAOiTw+ZSPZNQ6yqDOJ1B6Zk29
         GjhPk/1Btz0ZjIS7lrbdXhqy/izuDstMvcjQJ2uikw4ENVpAKHp203/BCbSvR8lEn4ps
         1GNbCWnpZ12PL8yghbLZCZI2lx6jII3ZiA3B5XptcV/mvGoK0/+oSP4u6Gh9bK6Oww3d
         QlBQ==
X-Gm-Message-State: APjAAAXzfoWYqynfofMumsZZjvtov6SMDeYE9oQIvdGtCB0UVOZqVZp0
        mE9gF/hXrWYOlyHamnLRNI2ZJwX1QNCE1d6ztvdB9Q==
X-Google-Smtp-Source: APXvYqw4AtzATQMris28NR0xZ8N8ybbyzXZkQEYaD+kJu4qYcOoxKTGGRoAoKW24zPfgP+UhgECQCmSZinq7o+MHBvw=
X-Received: by 2002:aca:c64c:: with SMTP id w73mr900195oif.161.1572988642954;
 Tue, 05 Nov 2019 13:17:22 -0800 (PST)
MIME-Version: 1.0
References: <20191029153051.24367-1-catalin.marinas@arm.com>
 <CALAqxLXuxZVg0kqNQXF_dH17NzH9m14-Ci_rzruHzmms0V7pvg@mail.gmail.com>
 <20191105102902.GB29852@willie-the-truck> <20191105165433.GD22987@arrakis.emea.arm.com>
In-Reply-To: <20191105165433.GD22987@arrakis.emea.arm.com>
From:   John Stultz <john.stultz@linaro.org>
Date:   Tue, 5 Nov 2019 13:17:11 -0800
Message-ID: <CALAqxLWYJvHO3YYbQHmgg0yThx_kqM7HBFnnxrcWkG1-LXeCQQ@mail.gmail.com>
Subject: Re: [PATCH] arm64: Ensure VM_WRITE|VM_SHARED ptes are clean by default
To:     Catalin Marinas <catalin.marinas@arm.com>
Cc:     Will Deacon <will@kernel.org>, Alistair Delva <adelva@google.com>,
        Sandeep Patil <sspatil@google.com>,
        stable <stable@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Steve Capper <Steve.Capper@arm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 5, 2019 at 8:54 AM Catalin Marinas <catalin.marinas@arm.com> wrote:
> On Tue, Nov 05, 2019 at 10:29:03AM +0000, Will Deacon wrote:
> > On Mon, Nov 04, 2019 at 05:16:42PM -0800, John Stultz wrote:
> > > On Tue, Oct 29, 2019 at 8:31 AM Catalin Marinas <catalin.marinas@arm.com> wrote:
> > > >
> > > > Shared and writable mappings (__S.1.) should be clean (!dirty) initially
> > > > and made dirty on a subsequent write either through the hardware DBM
> > > > (dirty bit management) mechanism or through a write page fault. A clean
> > > > pte for the arm64 kernel is one that has PTE_RDONLY set and PTE_DIRTY
> > > > clear.
> > > >
> > > > The PAGE_SHARED{,_EXEC} attributes have PTE_WRITE set (PTE_DBM) and
> > > > PTE_DIRTY clear. Prior to commit 73e86cb03cf2 ("arm64: Move PTE_RDONLY
> > > > bit handling out of set_pte_at()"), it was the responsibility of
> > > > set_pte_at() to set the PTE_RDONLY bit and mark the pte clean if the
> > > > software PTE_DIRTY bit was not set. However, the above commit removed
> > > > the pte_sw_dirty() check and the subsequent setting of PTE_RDONLY in
> > > > set_pte_at() while leaving the PAGE_SHARED{,_EXEC} definitions
> > > > unchanged. The result is that shared+writable mappings are now dirty by
> > > > default
> > > >
> > > > Fix the above by explicitly setting PTE_RDONLY in PAGE_SHARED{,_EXEC}.
> > > > In addition, remove the superfluous PTE_DIRTY bit from the kernel PROT_*
> > > > attributes.
> > > >
> > > > Fixes: 73e86cb03cf2 ("arm64: Move PTE_RDONLY bit handling out of set_pte_at()")
> > > > Cc: <stable@vger.kernel.org> # 4.14.x-
> > > > Cc: Will Deacon <will@kernel.org>
> > > > Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> [...]
> > As an experiment, can you try reverting just the part of the patch that
> > removes PTE_DIRTY from the PROT_* definitions? (see below)
>
> Another thing worth trying is reverting commit 747a70e60b72 ("arm64: Fix
> copy-on-write referencing in HugeTLB") when this patch is applied. That
> commit is not just about hugetlb but changes pte_same() to ignore
> PTE_RDONLY on the assumption that this is set by set_pte_at(). We
> subsequently changed set_pte_at() to drop PTE_RDONLY.

Just to confirm, reverting 747a70e60b72 instead of aa57157be69f also
seems to avoid the issue I'm seeing.

I've not tried Will patch but I'll do that next. Though its not clear
if you wanted me to revert 747a70e60b72 on top of Will's test patch or
not?

thanks
-john

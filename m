Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEF7C3DD7D5
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 15:48:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234116AbhHBNsT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 09:48:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234260AbhHBNrw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Aug 2021 09:47:52 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66380C061381
        for <stable@vger.kernel.org>; Mon,  2 Aug 2021 06:47:33 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id l11-20020a7bcf0b0000b0290253545c2997so8862wmg.4
        for <stable@vger.kernel.org>; Mon, 02 Aug 2021 06:47:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZosgW5P/FRPWGDl9IhPM3Dl11PT0YSNjES1UOYC23P4=;
        b=iSwcVNXbwMj6bVndtAFh7/bVmULdw+Y4ZH4kvjV+Mb+DxmGuikESzaj9cZHzvQhcFz
         2eSHGQSrKDRpbtKb/YrDbNUibFkKb8uFFnLk+qF8lmUt43Ukaxxq/v2lDPf36NI/ZRr1
         VXf1q8muGbwUkVEgTkW2yIhJfPzY1gVV7HEaMODfE67CUAezeMGlH1xyXDm8GyIAqTSf
         X2Ye+SXcHcjI8EFlHa5CEW/ZYQ/qXGLCRNdkqaBRZhA7vMLLuIJlJUa8IM00fF1ft3l0
         8Jrr8L8IQh/ExzlathQ0Iqs3f13X25ek8ua+hPjVzfA0RJPAWlAii6VnDph3LkL1thD0
         AatA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZosgW5P/FRPWGDl9IhPM3Dl11PT0YSNjES1UOYC23P4=;
        b=PounmMeVZsQsNLUv98KreEqYqzMxfZbCjvac82IMRuqNsd2CJhWDQR7Qsin+H4cXtw
         9mGcciCadzNAoszR3t/QRvdVa8DhrQvXlUCWBdShZK0PDpby9jEoIqIqyViKAwhEJxzI
         jWyZd1Dkh1aBATz7PW09eHn/9S5xje/8rnD1c0EbFeMl7mQQu9OtRdnjJyA40c3UYLJJ
         8XByYWWOEOHOJSMjwLlIvTh/vwdoo2krJu2wkk5+LYLPScmf7+lKR66PE/ySbS6m4pGP
         1yt1OXyrIDWA703OCLRQWxjIYObWFFXfsTonheD+BU8R3XMJA0qrDxluCCvy0N3Etqw4
         7/RQ==
X-Gm-Message-State: AOAM530HRt/SXKtsHxAzOniQhMmc018wizAXZX9xG98QswqTcY/MQUIL
        xfG5ZujKqfturSk1m52pjvv4eg==
X-Google-Smtp-Source: ABdhPJyu3MDRDzEwimKK8eR6XfIVIZgUH41B1Kmkh8eOZJZPZLglJQmXQDBg756DblUv9SmM0jIVwQ==
X-Received: by 2002:a05:600c:2306:: with SMTP id 6mr16843468wmo.115.1627912051856;
        Mon, 02 Aug 2021 06:47:31 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:210:44fe:c9a8:c2b2:3798])
        by smtp.gmail.com with ESMTPSA id b14sm11551749wrm.43.2021.08.02.06.47.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 06:47:31 -0700 (PDT)
Date:   Mon, 2 Aug 2021 14:47:28 +0100
From:   Quentin Perret <qperret@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        kernel-team@android.com, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] arm64: Move .hyp.rodata outside of the
 _sdata.._edata range
Message-ID: <YQf3cKjMa9rrGRqP@google.com>
References: <20210802123830.2195174-1-maz@kernel.org>
 <20210802123830.2195174-2-maz@kernel.org>
 <YQfu6+3uo6qlxrpv@google.com>
 <87mtq00yqd.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mtq00yqd.wl-maz@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Monday 02 Aug 2021 at 14:20:42 (+0100), Marc Zyngier wrote:
> Hi Quentin,
> 
> On Mon, 02 Aug 2021 14:11:07 +0100,
> Quentin Perret <qperret@google.com> wrote:
> > 
> > Hi Marc,
> > 
> > On Monday 02 Aug 2021 at 13:38:29 (+0100), Marc Zyngier wrote:
> > > The HYP rodata section is currently lumped together with the BSS,
> > > which isn't exactly what is expected (it gets registered with
> > > kmemleak, for example).
> > > 
> > > Move it away so that it is actually marked RO. As an added
> > > benefit, it isn't registered with kmemleak anymore.
> > 
> > 2d7bf218ca73 ("KVM: arm64: Add .hyp.data..ro_after_init ELF section")
> > states explicitly that the hyp ro_after_init section should remain RW in
> > the host as it is expected to modify it before initializing EL2. But I
> > can't seem to trigger anything with this patch applied, so I'll look
> > into this a bit more.
> 
> The switch to RO happens quite late. And if the host was to actually
> try and change things there, it would be screwed anyway (we will have
> already removed the pages from its S2).

Yes, clearly mapping rodata RO in host happens much later than I
thought, so this should indeed be fine.

> I wouldn't be surprised if this was a consequence of the way we now
> build the HYP object, and the comment in the original commit may not
> be valid anymore.

Just had a quick look and that still seems valid, at least for some
things (e.g. see how we set hyp_cpu_logical_map[] early from EL1 while
it is clearly annotated as __ro_after_init in the EL2 code).

> > 
> > > Fixes: 380e18ade4a5 ("KVM: arm64: Introduce a BSS section for use at Hyp")
> > 
> > Not sure this is the patch to blame?
> 
> My bad, this is plain wrong. I'm not sure it can be applied earlier
> though if my rambling above is correct.

By the look of it going all the way back to 2d7bf218ca73 (in David's
PSCI proxy series) should actually be correct. But not sure if that's
really going to make a difference before the patch you've mentioned
above as the kmemleak issue will only be visible once we have a host
stage-2, so no big deal.

Thanks,
Quentin

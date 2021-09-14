Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 271CF40BC55
	for <lists+stable@lfdr.de>; Wed, 15 Sep 2021 01:43:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235929AbhINXov (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Sep 2021 19:44:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235825AbhINXou (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Sep 2021 19:44:50 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2728C061574
        for <stable@vger.kernel.org>; Tue, 14 Sep 2021 16:43:30 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id g13-20020a17090a3c8d00b00196286963b9so3535389pjc.3
        for <stable@vger.kernel.org>; Tue, 14 Sep 2021 16:43:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=8O+Hy6We6pSl0DNT8xui4/8ZZ/lZgMhSAyPrG/8P2Ww=;
        b=oBbEAG+7FvjkbqO7CpvRLFUIxM3766nu3aMkROo6iWBNl+TYiwyE3gtvbgifiEov3l
         2Gq682Im2gXqCtjoMObMjTRSsP+KYH/KoviNQzjlvP/qqw+cFHzSPBfVUzhciitBkEMf
         QstU8wTvI4+7x9gztxTlEhQv1RUiS4pBfuP+otYpBsQJxscX/Xnh6GT/c3k8aG4KKvBJ
         9Vag7UGjME5jWsPFG0J4KmhykpaX+b2ydeG/za6E6zL3r8w2ohtyp8MGw++ceNfpPws0
         OVJYrvSM/1tKBRHoZfvWibTBQOJMZ/t3efk2/xjycZ2Z2uBqAdX546KLbLMwFiyZOolx
         Ky/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=8O+Hy6We6pSl0DNT8xui4/8ZZ/lZgMhSAyPrG/8P2Ww=;
        b=bH4+TfGlNPQna7LQHQP7kK7IUYna1gBSPTPrn1PoohgINYFw2DpeCJacZSP+qcExLc
         oQaaB5oM4xiEjJE5zOmyXmDlY6C3sR8p/rUBcEfTunkkzsv5fmDP4Y/4u5i9JX0bIPKY
         H/G0w+8Z0BsrepZVR4CxWSVJMgr9V/o4z2GLGsj6CHL3TZxRpnFAtSDMmvbYUeDP2c5d
         oeIfc6ROO7R7PT/e3szX1srbH2FV92bkjigeHxB6lKBsyZNIA0ZKMvUlcAYrDxoGMD5U
         HtlBhsMDBywCFt3gVsJiLB512MCokGlO8puWLzEhFgDJV/x20oDXrBGo3KeHhEOBEena
         HApQ==
X-Gm-Message-State: AOAM532Xf0QnqEyXn/QrfDSgb1oYvI97GPf+FoQQVMplBMonP4jM5ZJd
        GmSh/UuWbVgYPrYARv8Yg/uKag==
X-Google-Smtp-Source: ABdhPJyj23XbbLxNyB4sJkNtXn+USgxVzCsmWrwtl0ite0P6RNMul8bZnegi9bZ3G4X1QsMqKyJIFg==
X-Received: by 2002:a17:90a:f002:: with SMTP id bt2mr4963401pjb.207.1631663010164;
        Tue, 14 Sep 2021 16:43:30 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id v23sm11084092pff.155.2021.09.14.16.43.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 16:43:29 -0700 (PDT)
Date:   Tue, 14 Sep 2021 23:43:25 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Gonda <pgonda@google.com>
Cc:     kvm list <kvm@vger.kernel.org>, Marc Orr <marcorr@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: SEV: Acquire vcpu mutex when updating VMSA
Message-ID: <YUEznQvx+bycn9Iq@google.com>
References: <20210914200639.3305617-1-pgonda@google.com>
 <YUEVQDEvLbdJF+sj@google.com>
 <CAMkAt6rSsKuzE__pAodiJR9wFU-B3942+kdkQG-3M+jxhVco2w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMkAt6rSsKuzE__pAodiJR9wFU-B3942+kdkQG-3M+jxhVco2w@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 14, 2021, Peter Gonda wrote:
> That looks reasonable to me. I didn't know if changes headed for LTS
> should be smaller so I avoided doing this refactor. From:
> https://www.kernel.org/doc/html/v4.11/process/stable-kernel-rules.html#stable-kernel-rules
> seems to say less than 100 lines is ideal.

Most the rules are more like guidelines ;-)  In seriousness, there's a balance to
be had between minimizing the diff and keeping everything maintainable.  E.g. if
the fix is kept small and then the upstream code is immediately refactored, any
future fixes to the refactored code will be harder to backport.  And the actual
fix would also be poorly tested in upstream since folks would be testing the
refactored version of the code.

> I guess this could also be a "theoretical race condition” anyways so maybe
> not for LTS anyways.

If there's doubt, write a test :-)  The "theoretical race condition" thing is to
discourage people from backporting fixes for ridiculously tiny windows that may
or may not be exploitable.  This is a giant gaping chasm that userspace can drive
a car through, e.g. literally "do KVM_RUN at the same time".

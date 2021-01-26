Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32E0E3055F5
	for <lists+stable@lfdr.de>; Wed, 27 Jan 2021 09:40:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231386AbhA0IkC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jan 2021 03:40:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S316902AbhAZXMF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jan 2021 18:12:05 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E549C0613ED
        for <stable@vger.kernel.org>; Tue, 26 Jan 2021 15:10:16 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id jx18so134888pjb.5
        for <stable@vger.kernel.org>; Tue, 26 Jan 2021 15:10:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HQObKKSE5vuDsoooUB32J7Kk+tA9rn8yWjz82H0MqC8=;
        b=IsXZ6AVsbd6O9Z0cFT3PBS/RJNtNM2XJtyaaO0UwmfubfXJoIdSncE7qf0pmXEDit3
         H8dX/ubGwBjS6aA4Q2sSM7Onoa3N3i3/V6LcwH/ryOrbDmmjVqTeti6AUbYZJ8c9HdQi
         D1TfpWnzciIxEy4DkfQyf9U5EeyWpFDmgFPHCaIWJkWzjQwa7BljNsU3peKEfCY4zLgk
         UVoYirmVQrL/GbuA7oEohpSHUtmla6fTZ6y1IYsp5WIgRFEujTU+QlKNadINq5yKzpWl
         rsrnYI2DT8IFm1XFhtMRCeQGHR1+Nn25595y0VuVGvxpbOfrbzDHxTioqvFYA6jgC2PB
         s8Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HQObKKSE5vuDsoooUB32J7Kk+tA9rn8yWjz82H0MqC8=;
        b=g4nF/Vl7BE4irfUxWXKBY7zHpXCpNg22BequhdEOv+MxZc2yh/ftJHub1ChnYAqzXP
         /QyufjYk0moSwB8lQqfUMyruTKPPDgKVTpqZRSnKB7EzGHstj6B5blB81ACzRSyjZUSm
         dpwY4MPPAyUg4eRYpZk31P0cQqobE9UmZCg0BvSLNjsDJMLG1Gfz1OpdSYsDqg7GQHuG
         mjlNqjS0HPu+YawjTtR/6QhCShqTNTGHZNYcuy0PgjusuBwA1M+oSsfBs2bv59hBY7xp
         Q2qhPx0qV3jnzBMY5mZFh61J33A8PYJPDgu48EK3AhqiwL0BGL3LRsH1lFVt708OuGsI
         OEBw==
X-Gm-Message-State: AOAM531hncUant1Xu0bwPGcTHUN3pxJ4mfDXcwc0jIghmxq7SlmKKyQd
        qjv3H0o4AGkY+MbRRb87mfQvYg==
X-Google-Smtp-Source: ABdhPJxl7q69Ha3Jh0Ps46T3ONL6qVzI+3HdbBTFQIcdgZ5tsJeSGhBc8xHENLjPewRZWZT0KTYgqQ==
X-Received: by 2002:a17:90a:7e82:: with SMTP id j2mr2147173pjl.217.1611702615801;
        Tue, 26 Jan 2021 15:10:15 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id m77sm155892pfd.82.2021.01.26.15.10.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 15:10:15 -0800 (PST)
Date:   Tue, 26 Jan 2021 15:10:08 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Peter Gonda <pgonda@google.com>, kvm@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>, x86@kernel.org,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix unsynchronized access to sev members through
 svm_register_enc_region
Message-ID: <YBChUOc1iKZv8TJ1@google.com>
References: <20210126185431.1824530-1-pgonda@google.com>
 <6407cdf6-5dc7-96c0-343b-d2c0e1d7aaa4@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6407cdf6-5dc7-96c0-343b-d2c0e1d7aaa4@amd.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 26, 2021, Tom Lendacky wrote:
> On 1/26/21 12:54 PM, Peter Gonda wrote:
> > sev_pin_memory assumes that callers hold the kvm->lock. This was true for
> > all callers except svm_register_enc_region since it does not originate
> > from svm_mem_enc_op. Also added lockdep annotation to help prevent
> > future regressions.
> 
> I'm not exactly sure what the problem is that your fixing? What is the
> symptom that you're seeing?

svm_register_enc_region() calls sev_pin_memory() without holding kvm->lock.  If
userspace does multiple KVM_MEMORY_ENCRYPT_REG_REGION in parallel, it could
circumvent the rlimit(RLIMIT_MEMLOCK) check.

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82A6B4353E5
	for <lists+stable@lfdr.de>; Wed, 20 Oct 2021 21:37:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231485AbhJTTj5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Oct 2021 15:39:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231360AbhJTTj5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Oct 2021 15:39:57 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76C9FC061749
        for <stable@vger.kernel.org>; Wed, 20 Oct 2021 12:37:42 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id n36-20020a17090a5aa700b0019fa884ab85so1291260pji.5
        for <stable@vger.kernel.org>; Wed, 20 Oct 2021 12:37:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lWYe9rn5e9oEHLDCI62/+vmQMjjh/6S+KCip52ZzywU=;
        b=sxzdOq1oGrm/5AwX5lW7IzpVq3HI19eImCfYcLU54BhAw3OF57B9QYP+5sHBYQRueS
         z6VKj+WcD//I6Nrm/ruyvlIs63Tw5IEuNq3SzsIdtOC5o+5Kfxgc7IBuEflDDilfR3dI
         DPaSF8gp6IbGl4Q1EF9hYK37y8Zs5d7NmXmnxHnTG/fRq/NCAUsAqHxcL8rwrH6ndMkT
         biRowKPaS3LEoqz730TT8jo0I/I49PtG5qtR3JQkWCFJfTZnMquY+umz7Lme9uRs/ETK
         QlSbb2oNEQxuG8Rv9MZr4pDWVI5LPfwmlgYl7iHxrt6uVzMzu/79ULW8NYIPXG14/8QE
         S/dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lWYe9rn5e9oEHLDCI62/+vmQMjjh/6S+KCip52ZzywU=;
        b=q7P/AFigSW7QLrsMWr892/u+zIkB/SGtV6IAmprXY8eRkXIRDVyT1Sh7nIIbirvjMX
         6nKuXGwEbgEN0SN76Fm0OP7dNHpfQ2m6CUzLwmxi+1+uno08rEdlduKfXfmMxN7w+rnE
         hDqvsH4IfqhR4Etqyo+oCo2/d6FWeRoE2VwDwYJvSW0JnPdAvO7M0MK+5RYT1pdtxKru
         gWUZpKLysLJ0paiDYX54RihGfNPymnYNvNtDlnwAWPqll+wPvOKtaG1Mo0SiwgxWWT11
         kC36nFPzQBLycftIGVTWPTjXp5phTuyivgoe+ZQ6ldNXNFYJ91JOwUvprxZzJgvv2NwV
         LXGg==
X-Gm-Message-State: AOAM530+i4lIrJMCD5L527pbmnumya+RgbtRhuOzlse3QOt+bbpN337b
        UjtStNheUcm9hE/NCvYb7FqrQw==
X-Google-Smtp-Source: ABdhPJyswwvwef6Te/xzJRzb75gIE1AxwGiGRBSEd84RsmFl1n7vfv/a6xaWDNzw3SPvGn+aAjyh1w==
X-Received: by 2002:a17:903:1252:b0:13d:f3f6:2e1c with SMTP id u18-20020a170903125200b0013df3f62e1cmr984499plh.73.1634758661626;
        Wed, 20 Oct 2021 12:37:41 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id u11sm3490396pfg.2.2021.10.20.12.37.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 12:37:41 -0700 (PDT)
Date:   Wed, 20 Oct 2021 19:37:37 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        wanpengli@tencent.com, stable@vger.kernel.org
Subject: Re: [PATCH] KVM: nVMX: promptly process interrupts delivered while
 in guest mode
Message-ID: <YXBwAbbRJFfEVGxY@google.com>
References: <20211020145231.871299-2-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211020145231.871299-2-pbonzini@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 20, 2021, Paolo Bonzini wrote:
> Since commit c300ab9f08df ("KVM: x86: Replace late check_nested_events() hack with
> more precise fix") there is no longer the certainty that check_nested_events()
> tries to inject an external interrupt vmexit to L1 on every call to vcpu_enter_guest.
> Therefore, even in that case we need to set KVM_REQ_EVENT.  This ensures
> that inject_pending_event() is called, and from there kvm_check_nested_events().
> 
> Fixes: c300ab9f08df ("KVM: x86: Replace late check_nested_events() hack with more precise fix")
> Cc: stable@vger.kernel.org
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>

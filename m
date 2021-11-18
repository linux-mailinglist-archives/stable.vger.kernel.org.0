Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5355456046
	for <lists+stable@lfdr.de>; Thu, 18 Nov 2021 17:17:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233046AbhKRQUN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Nov 2021 11:20:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232992AbhKRQUN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Nov 2021 11:20:13 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 656C1C061748
        for <stable@vger.kernel.org>; Thu, 18 Nov 2021 08:17:13 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id z6so4472190plk.6
        for <stable@vger.kernel.org>; Thu, 18 Nov 2021 08:17:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SBcIQzCX8Yq5J7qmrIFRGqarw+SHho/cn1etZqGWWXg=;
        b=J5q10V4d8pi9a9wYxUYPyW3JVjZzW7L7/yOJAKCE2ks7Q5GEUqNMovDlFEDpQXkzrb
         B+J6JYrmxgMrAIMtL8FE6INACm8S5p9UygDANUSLgQTqSA8jos4/XsOUS8rYVH9UGlv3
         E4sc8EfhDRU64uE9IKM/7taVdAyaW75nMsczSPsf4cKbIZMxXqXqbvP9A9XJzXh4wmw/
         H1kKPS9OX1nRPTdsDTP1qoqd8jvveeHzwyFGNt8V9cpZSBPAO0TrBrK4oTzmH1nQeIZT
         AE1rbvCypa3znaIRhI0leraXk39igTRXK6hXVG9xogK7XvRlPbGb9oU66+HokmZU/UZR
         soQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SBcIQzCX8Yq5J7qmrIFRGqarw+SHho/cn1etZqGWWXg=;
        b=LAriih2WFde6cT30NuyvocTc0BHZ8PctH8iupYVoz99l9/xSv2kJcuaTWK7T6loZKW
         eqM1WfuXAaPreXGKgGMWleLpOimV3p19qOq5n0dKElpudiMtpPvzSHZM9iU6O/saYy/r
         kUPCf420VJIn/74UFFYKHu+8aN6c1fAn0RA4yCX4NClR4728L1M78qTTGp2qUNFbtghq
         Y+QHO56UkZhTHG621FMZGpeVG2OvGvyy3ELyAGdAtQFNZnW7vK0DRmRBlyxSuo7FDgp3
         GeplfS8kvikfcOwSafRoeL894e+DMvFJCumY24xvtiU1fo/LmyfTiAa5TiXrOSr1qsm1
         sgyg==
X-Gm-Message-State: AOAM531aHGZ1RHO8v3Cf949bjAvo7BNv4tyfhgaEpvFDc8McgKV2+XGW
        v70HGSyH1wbkrIUdWoR806LVRg==
X-Google-Smtp-Source: ABdhPJzGVTCI02WZkeU94xIqEOFMTcYNEQT1GyEoQZIVk9gFGNyOROoxkz2LqIeWOQmktUvz6cUmsA==
X-Received: by 2002:a17:90a:ad47:: with SMTP id w7mr11953097pjv.16.1637252232716;
        Thu, 18 Nov 2021 08:17:12 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id p19sm116176pfo.92.2021.11.18.08.17.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 08:17:12 -0800 (PST)
Date:   Thu, 18 Nov 2021 16:17:08 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] KVM: x86: check PIR even for vCPUs with disabled APICv
Message-ID: <YZZ8hAjbIJnkkraD@google.com>
References: <20211118072531.1534938-1-pbonzini@redhat.com>
 <8ad47d43a7c8ae19f09cc6ada73665d6e348e213.camel@redhat.com>
 <4ee9fe58-73ca-98fd-3d79-198e1093f722@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ee9fe58-73ca-98fd-3d79-198e1093f722@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 18, 2021, Paolo Bonzini wrote:
> On 11/18/21 10:56, Maxim Levitsky wrote:
> > vmx_sync_pir_to_irr has 'if (KVM_BUG_ON(!vcpu->arch.apicv_active,
> > vcpu->kvm))' That has to be removed I think for this to work.
> 
> Good point.

Hmm, I think I'd prefer to keep it as

	if (KVM_BUG_ON(!enable_apicv))
		return -EIO;

since calling it directly or failing to nullify vmx_x86_ops.sync_pir_to_irr when
APICv is unsupported would lead to all sorts of errors.  It's not a strong
preference though.

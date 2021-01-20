Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC6AD2FD899
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 19:47:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730918AbhATRhQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Jan 2021 12:37:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388950AbhATRgQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Jan 2021 12:36:16 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72EF9C0613D3
        for <stable@vger.kernel.org>; Wed, 20 Jan 2021 09:35:36 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id b8so12904769plx.0
        for <stable@vger.kernel.org>; Wed, 20 Jan 2021 09:35:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XEjQaUzbJuiAaARQ1H+QTbfo88nVVFggDqUyz04sd/o=;
        b=UggOssZYf42FCAHpakKlUYcverV5T05kN3+rBUkyHejuV0toljDMJ6NPzu/hk7PeCt
         p7M2z52VT+TC/U6ubZCOKmtPVbq330+Bt3cpyAXc2YoyLM3xOcXHtZ4hmqWd8yEJ9N7T
         t7RwF7llqnc06av1XQ8h1ZLhNtKHDM09cFgHWhlZYgsb5UdbfxK7R6fP1dRu0A3L6JFK
         HUUOJfEAlsqnL1zodg7Lhff1YCGq7QWaosePKrhJa+/1LBP7Rg7ynADxrCQVbJCnh40o
         h3R0KmrCIsNfT8kmuueXrdYa854sD14n237V7/NGkebAtTtxiI3xwJIKVL3EsccTxuPM
         W0xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XEjQaUzbJuiAaARQ1H+QTbfo88nVVFggDqUyz04sd/o=;
        b=gsyZJECloRLyB7fPYctoDUxRsDJIlcx8SjkbXGDsUdlWcXZeUDxl8Rvw+OZFPAZZ/F
         wJRZYeFQyv4Dmuw7ulGAVdD15vPDXtFnulICq2/LA4SnRGDy1bC3BCySSmGuIbBQifFm
         kenxrZZ9I4hXCLXE39r4+Zu/eYGXCro4StbjEWVxuAXspk55a1CcS5+3gf5zBo5cwLhm
         vA6DgK9dLPNUUCRkYWJoROIdSdRtCDAo8u6F5uMxGBIw4tQPtmoMUlwsxoChe5ZiM5F1
         87QnS6AeLR0hy2vBnXz/wZgxRnvT/uB9/doVUoo7NXlvjwj7midtSiqqi95BRJ51o8bW
         jbCw==
X-Gm-Message-State: AOAM531ij1CMxA1DfVEEVLz85tOIW5VCpNxHm+lBKz0d/xR0GyS0LwDP
        Gy1ZXkW9ZjPMcXRIKbnta6VnOg==
X-Google-Smtp-Source: ABdhPJzGfhfk59jHFYaJTfNS9l+aCZa9slzza/lzsUBsBh6ilovyQ3Vd9PUAajLwFGi1aLHDjSF2Kw==
X-Received: by 2002:a17:90a:eacf:: with SMTP id ev15mr6889060pjb.209.1611164135770;
        Wed, 20 Jan 2021 09:35:35 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id w19sm3060725pgf.23.2021.01.20.09.35.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 09:35:34 -0800 (PST)
Date:   Wed, 20 Jan 2021 09:35:28 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     jarkko@kernel.org
Cc:     linux-sgx@vger.kernel.org, dave.hansen@intel.com,
        kai.huang@intel.com, haitao.huang@intel.com,
        stable@vger.kernel.org,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Jethro Beekman <jethro@fortanix.com>
Subject: Re: [PATCH v4] x86/sgx: Fix the call order of synchronize_srcu() in
 sgx_release()
Message-ID: <YAhp4Jrj6hIcvgRC@google.com>
References: <20210115014638.15037-1-jarkko@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210115014638.15037-1-jarkko@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 15, 2021, jarkko@kernel.org wrote:
> From: Jarkko Sakkinen <jarkko@kernel.org>
> 
> The most trivial example of a race condition can be demonstrated with this
> example where mm_list contains just one entry:
> 
> CPU A                   CPU B
> sgx_release()
>                         sgx_mmu_notifier_release()
>                         list_del_rcu()
> sgx_encl_release()
>                         synchronize_srcu()
> cleanup_srcu_struct()
> 
> To fix this, call synchronize_srcu() before checking whether mm_list is
> empty in sgx_release().

Why haven't you included the splat that Haitao provided?  That would go a long
way to helping answer Boris' question about exactly what is broken...

> Cc: stable@vger.kernel.org
> Fixes: 1728ab54b4be ("x86/sgx: Add a page reclaimer")
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Suggested-by: Haitao Huang <haitao.huang@linux.intel.com>
> Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> ---
> v4:
> - Rewrite the commit message.
> - Just change the call order. *_expedited() is out of scope for this
>   bug fix.
> v3: Fine-tuned tags, and added missing change log for v2.
> v2: Switch to synchronize_srcu_expedited().
>  arch/x86/kernel/cpu/sgx/driver.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/driver.c b/arch/x86/kernel/cpu/sgx/driver.c
> index f2eac41bb4ff..53056345f5f8 100644
> --- a/arch/x86/kernel/cpu/sgx/driver.c
> +++ b/arch/x86/kernel/cpu/sgx/driver.c
> @@ -65,11 +65,16 @@ static int sgx_release(struct inode *inode, struct file *file)
>  
>  		spin_unlock(&encl->mm_lock);
>  
> +		/*
> +		 * The call is need even if the list empty, because sgx_encl_mmu_notifier_release()
> +		 * could have initiated a new grace period.
> +		 */
> +		synchronize_srcu(&encl->srcu);

I don't think this completely fixes the issue as sgx_release() isn't guaranteed
to trigger cleanup_srcu_struct(), e.g. the reclaimer can also have a reference
to the enclave.

> +
>  		/* The enclave is no longer mapped by any mm. */
>  		if (!encl_mm)
>  			break;
>  
> -		synchronize_srcu(&encl->srcu);
>  		mmu_notifier_unregister(&encl_mm->mmu_notifier, encl_mm->mm);
>  		kfree(encl_mm);
>  	}
> -- 
> 2.29.2
> 

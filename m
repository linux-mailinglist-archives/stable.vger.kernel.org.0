Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCD794D2376
	for <lists+stable@lfdr.de>; Tue,  8 Mar 2022 22:40:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241520AbiCHVlP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Mar 2022 16:41:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350521AbiCHVlP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Mar 2022 16:41:15 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 292C54EF65
        for <stable@vger.kernel.org>; Tue,  8 Mar 2022 13:40:18 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id 9so273219pll.6
        for <stable@vger.kernel.org>; Tue, 08 Mar 2022 13:40:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yXDaNo5Twd/bGEPxBGrFiEAJws30Rt0Ob1hJFSeUBOc=;
        b=IvPbWr4sdruoLMR3M5bVRCv+/fvvN6Q9iH9X9WBrVD77yqOVgFgTEbLjWrHdVvhnzS
         Jdqsp3i5uigJsJBQkt5uNlsgtojX66vWFpD14Ni2Dvj0XAL/S8ZSb2w83nJEs33SGlme
         xngzlmHbH2P31Dk9RZwV7j76ob1ZQHJFoe9oxqv0FtjyN7WYqwWbePqk6xEhXN3fJQ47
         2OFFAToBIbrJQs1oLg2gkpNhoav0/1Go3AkK+lzgul5yUQXZD32n0ideLop7RRXFk4dK
         NKoGcNe6LyE37UxhdLLOlUrD5Kds78hPE9A1GaSkHQmefmOQSga+zg23tkfCpPVnqffe
         TQ1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yXDaNo5Twd/bGEPxBGrFiEAJws30Rt0Ob1hJFSeUBOc=;
        b=ita+kmWG6WpyCEVmjgaId8Hr7/3k7GW5aio4QqUzZKorYzfIHaiOWG0V4zAEcO5eZC
         bcG3/r9uzCrPSVld9kb0pKFk0DbYSYae8eaCMZSRtGoBzKKReR9dg/RDNfo5qyqRFjEQ
         NojBGQUDzg1+z8L1UeQiOjDpLrij2iebJ9cyAWdkz12VjlQ27c2uuPccIUFZbCmwRpef
         3cQ3CsTTc+61gseh+hH0KVV54pcVJlTZQFBbhHFsDRGcCfaKhx0crMd+xWmnhtSBteac
         B7YoENeBNKK3sHmtAApAR8u8rW26NmXXnSAtNWxCuZLk/hTXLYpMK11tcTWwpA9s0xV8
         VzJQ==
X-Gm-Message-State: AOAM531zX1+FW8iUhmvHsH2FmCsabMumKT8gkv8lZ2UPTTldq+Gq/WHs
        hj/bQ1fIgMYp6WkNQ0Fvd9dbeQ==
X-Google-Smtp-Source: ABdhPJzIvEjtibl34ljAgC2zisZuhQHc+ubnA5X6exOS8Uary99PfIF6h1GnY4PY7ybF9nQVYK4x7A==
X-Received: by 2002:a17:90a:7f92:b0:1bc:f09:59 with SMTP id m18-20020a17090a7f9200b001bc0f090059mr7006696pjl.98.1646775617478;
        Tue, 08 Mar 2022 13:40:17 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id nv4-20020a17090b1b4400b001bf64a39579sm3915281pjb.4.2022.03.08.13.40.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 13:40:16 -0800 (PST)
Date:   Tue, 8 Mar 2022 21:40:13 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Gleb Natapov <gleb@redhat.com>, Rik van Riel <riel@redhat.com>,
        bgardon@google.com, stable@vger.kernel.org
Subject: Re: [PATCH RESEND 1/2] KVM: Prevent module exit until all VMs are
 freed
Message-ID: <YifNPekMfIta+xcv@google.com>
References: <20220303183328.1499189-1-dmatlack@google.com>
 <20220303183328.1499189-2-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220303183328.1499189-2-dmatlack@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 03, 2022, David Matlack wrote:
> Tie the lifetime the KVM module to the lifetime of each VM via
> kvm.users_count. This way anything that grabs a reference to the VM via
> kvm_get_kvm() cannot accidentally outlive the KVM module.
> 
> Prior to this commit, the lifetime of the KVM module was tied to the
> lifetime of /dev/kvm file descriptors, VM file descriptors, and vCPU
> file descriptors by their respective file_operations "owner" field.
> This approach is insufficient because references grabbed via
> kvm_get_kvm() do not prevent closing any of the aforementioned file
> descriptors.
> 
> This fixes a long standing theoretical bug in KVM that at least affects
> async page faults. kvm_setup_async_pf() grabs a reference via
> kvm_get_kvm(), and drops it in an asynchronous work callback. Nothing
> prevents the VM file descriptor from being closed and the KVM module
> from being unloaded before this callback runs.
> 
> Fixes: af585b921e5d ("KVM: Halt vcpu if page it tries to access is swapped out")

And (or)

  Fixes: 3d3aab1b973b ("KVM: set owner of cpu and vm file operations")

because the above is x86-centric, at a glance PPC and maybe s390 have issues
beyond async #PF.

> Cc: stable@vger.kernel.org
> Suggested-by: Ben Gardon <bgardon@google.com>
> [ Based on a patch from Ben implemented for Google's kernel. ]
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  virt/kvm/kvm_main.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 35ae6d32dae5..b59f0a29dbd5 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -117,6 +117,8 @@ EXPORT_SYMBOL_GPL(kvm_debugfs_dir);
>  
>  static const struct file_operations stat_fops_per_vm;
>  
> +static struct file_operations kvm_chardev_ops;
> +
>  static long kvm_vcpu_ioctl(struct file *file, unsigned int ioctl,
>  			   unsigned long arg);
>  #ifdef CONFIG_KVM_COMPAT
> @@ -1131,6 +1133,11 @@ static struct kvm *kvm_create_vm(unsigned long type)
>  	preempt_notifier_inc();
>  	kvm_init_pm_notifier(kvm);
>  
> +	if (!try_module_get(kvm_chardev_ops.owner)) {

The "try" aspect is unnecessary.  Stealing from Paolo's version, 

	/* KVM is pinned via open("/dev/kvm"), the fd passed to this ioctl(). */
	__module_get(kvm_chardev_ops.owner);

> +		r = -ENODEV;
> +		goto out_err;
> +	}
> +
>  	return kvm;
>  
>  out_err:
> @@ -1220,6 +1227,7 @@ static void kvm_destroy_vm(struct kvm *kvm)
>  	preempt_notifier_dec();
>  	hardware_disable_all();
>  	mmdrop(mm);
> +	module_put(kvm_chardev_ops.owner);
>  }
>  
>  void kvm_get_kvm(struct kvm *kvm)
> 
> base-commit: b13a3befc815eae574d87e6249f973dfbb6ad6cd
> prerequisite-patch-id: 38f66d60319bf0bc9bf49f91f0f9119e5441629b
> prerequisite-patch-id: 51aa921d68ea649d436ea68e1b8f4aabc3805156
> -- 
> 2.35.1.616.g0bdcbb4464-goog
> 

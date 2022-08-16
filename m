Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09AFC5954A1
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 10:11:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231510AbiHPILI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 04:11:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232011AbiHPIKQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 04:10:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 62F43B9404
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 23:35:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660631741;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=u5SSYyHWYufP+2mno9/TspwkXTe4pXs/cik4h5ea5lE=;
        b=YZ+P/KAZXcOwUXS4MSPAAs6CyiFctks1SpMQsD4eRfN8RbXORu0LvywEpfwtNsXhrHXVVw
        dK2YNNpjwWBawXQlGxuvu0M5vCE017nlss+7HHrmuV+PwxnLFXJbj7AovK5d2PtP/vapfg
        EQDBW1yzEQT7OUS4cWZKmEbvVbaOy8Q=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-324-weMDEZQWOeGuNFJ-TKdGQQ-1; Tue, 16 Aug 2022 02:35:40 -0400
X-MC-Unique: weMDEZQWOeGuNFJ-TKdGQQ-1
Received: by mail-pj1-f69.google.com with SMTP id i2-20020a17090a650200b001f4f79056a6so9302087pjj.9
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 23:35:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=u5SSYyHWYufP+2mno9/TspwkXTe4pXs/cik4h5ea5lE=;
        b=N91VxzWEyz4emGvtJw99bzYbf8si6hp9pgYMThSBXMtQO1TJDKdYC0ZYcLLMJj0VnF
         9ArgXCGa2tPhITgVRtG0Uh+6774AIQ9MzSwxl4TJ6zhX3n+Wd/wJn7YnVJ6gBHvCY6Os
         MLvGC/x5Jymzrc2frvsc6Chz1nNecI7uKJdphjqNGFE5RSPe+kW0yhYMROOO+UlrLgT+
         iTU70rt0IBuUb7iLSENkpgIYz4d9osQJ6aAFNGd++cAuesN6pumBHAc2MvyR4qGvtgWy
         5cEISyAxGtKRU0Z37cfmT5cPcvq3aM2gOKq6wJsa70R+eXhGo1AfS49n8G/ZgvKkQ8Ze
         6fYw==
X-Gm-Message-State: ACgBeo0/D1IgirCTTzXAfxW5LWbqrktiWCuXvPaWmuQPJrMgBC3Z3wCV
        ujk7wm1KVSq0ABhS/DEBI+g3mXxpx3omMOV3MuM8ky8xJBanKJ54lLaIDhEjRO0scSM4azhGP61
        hVn/XRCI9ZcuDEUiH
X-Received: by 2002:a63:9141:0:b0:41d:22d:1910 with SMTP id l62-20020a639141000000b0041d022d1910mr16806348pge.145.1660631739135;
        Mon, 15 Aug 2022 23:35:39 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4QHt/uYo8sHsEPzOJdISoGrNmvdUyMqb5bvjp/tPiQikw2hKe91Fx+Z4nYDVDttUEAc2xGlg==
X-Received: by 2002:a63:9141:0:b0:41d:22d:1910 with SMTP id l62-20020a639141000000b0041d022d1910mr16806332pge.145.1660631738879;
        Mon, 15 Aug 2022 23:35:38 -0700 (PDT)
Received: from localhost ([240e:3a1:2ea:acc0:8cff:e01c:2dbf:2ae8])
        by smtp.gmail.com with ESMTPSA id rj14-20020a17090b3e8e00b001f731a1ed88sm5764594pjb.2.2022.08.15.23.35.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 23:35:38 -0700 (PDT)
Date:   Tue, 16 Aug 2022 14:32:56 +0800
From:   Coiby Xu <coxu@redhat.com>
To:     gregkh@linuxfoundation.org
Cc:     bhe@redhat.com, msuchanek@suse.de, will@kernel.org,
        zohar@linux.ibm.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] arm64: kexec_file: use more system
 keyrings to verify kernel" failed to apply to 5.19-stable tree
Message-ID: <20220816063256.qzc6jh744i2zc6ou@Rk>
References: <166057758347124@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <166057758347124@kroah.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

Good to see you here:)

On Mon, Aug 15, 2022 at 05:33:03PM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 5.19-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From 0d519cadf75184a24313568e7f489a7fc9b1be3b Mon Sep 17 00:00:00 2001
>From: Coiby Xu <coxu@redhat.com>
>Date: Thu, 14 Jul 2022 21:40:26 +0800
>Subject: [PATCH] arm64: kexec_file: use more system keyrings to verify kernel
> image signature
>
>Currently, when loading a kernel image via the kexec_file_load() system
>call, arm64 can only use the .builtin_trusted_keys keyring to verify
>a signature whereas x86 can use three more keyrings i.e.
>.secondary_trusted_keys, .machine and .platform keyrings. For example,
>one resulting problem is kexec'ing a kernel image  would be rejected
>with the error "Lockdown: kexec: kexec of unsigned images is restricted;
>see man kernel_lockdown.7".
>
>This patch set enables arm64 to make use of the same keyrings as x86 to
>verify the signature kexec'ed kernel image.
>
>Fixes: 732b7b93d849 ("arm64: kexec_file: add kernel signature verification support")
>Cc: stable@vger.kernel.org # 105e10e2cf1c: kexec_file: drop weak attribute from functions
>Cc: stable@vger.kernel.org # 34d5960af253: kexec: clean up arch_kexec_kernel_verify_sig
>Cc: stable@vger.kernel.org # 83b7bb2d49ae: kexec, KEYS: make the code in bzImage64_verify_sig generic

I've added the above three patch prerequisites following [1]. I assume
there is a program automatically picking up this patch. But somehow it
fails to pick up the prerequisites first. Is it because the commit ids
change when the patches are finally applied to Linus's tree? If it's
true, how do we make sure the we have the correct commit ids? Note [1]
strongly recommends "Cc: stable@vger.kernel.org" to submit patches to
stable tree but it seems there is no way to know beforehand the correct
commit ids of the prerequisites that are yet to arrive in Linus's tree.

[1] https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

>Acked-by: Baoquan He <bhe@redhat.com>
>Cc: kexec@lists.infradead.org
>Cc: keyrings@vger.kernel.org
>Cc: linux-security-module@vger.kernel.org
>Co-developed-by: Michal Suchanek <msuchanek@suse.de>
>Signed-off-by: Michal Suchanek <msuchanek@suse.de>
>Acked-by: Will Deacon <will@kernel.org>
>Signed-off-by: Coiby Xu <coxu@redhat.com>
>Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
>
>diff --git a/arch/arm64/kernel/kexec_image.c b/arch/arm64/kernel/kexec_image.c
>index 9ec34690e255..5ed6a585f21f 100644
>--- a/arch/arm64/kernel/kexec_image.c
>+++ b/arch/arm64/kernel/kexec_image.c
>@@ -14,7 +14,6 @@
> #include <linux/kexec.h>
> #include <linux/pe.h>
> #include <linux/string.h>
>-#include <linux/verification.h>
> #include <asm/byteorder.h>
> #include <asm/cpufeature.h>
> #include <asm/image.h>
>@@ -130,18 +129,10 @@ static void *image_load(struct kimage *image,
> 	return NULL;
> }
>
>-#ifdef CONFIG_KEXEC_IMAGE_VERIFY_SIG
>-static int image_verify_sig(const char *kernel, unsigned long kernel_len)
>-{
>-	return verify_pefile_signature(kernel, kernel_len, NULL,
>-				       VERIFYING_KEXEC_PE_SIGNATURE);
>-}
>-#endif
>-
> const struct kexec_file_ops kexec_image_ops = {
> 	.probe = image_probe,
> 	.load = image_load,
> #ifdef CONFIG_KEXEC_IMAGE_VERIFY_SIG
>-	.verify_sig = image_verify_sig,
>+	.verify_sig = kexec_kernel_verify_pe_sig,
> #endif
> };
>

-- 
Best regards,
Coiby


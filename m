Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2340957B856
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 16:24:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbiGTOYr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Jul 2022 10:24:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiGTOYr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Jul 2022 10:24:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F7B22718;
        Wed, 20 Jul 2022 07:24:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3065FB81E8B;
        Wed, 20 Jul 2022 14:24:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86ADCC3411E;
        Wed, 20 Jul 2022 14:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658327084;
        bh=uZmlk4L16kHiiiMJsIDyQCxOHqW3mlXAesVQgZ/Qo9s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mNFK6baGAMSJglZ5hOlc2nOiYM3sOufjgKNYZ/yCmEuhqGGO7635dl7vFpiXkQIfQ
         DKlB1yaaDxxq1nlTY/AcuUheq8yvt4xsoVj8QSKNiWLCNAL4oOfcRzxvHVYFcHYYN/
         FghNi1GU6PxXJpIxBq5FMxE33bkNZESbGtcEOwRI=
Date:   Wed, 20 Jul 2022 16:24:40 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Eric Snowberg <eric.snowberg@oracle.com>
Cc:     linux-integrity@vger.kernel.org, zohar@linux.ibm.com,
        dmitry.kasatkin@gmail.com, jmorris@namei.org, serge@hallyn.com,
        matthewgarrett@google.com, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] lockdown: Fix kexec lockdown bypass with ima policy
Message-ID: <YtgQKHwPAVBSHjcY@kroah.com>
References: <20220719171647.3574253-1-eric.snowberg@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220719171647.3574253-1-eric.snowberg@oracle.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 19, 2022 at 01:16:47PM -0400, Eric Snowberg wrote:
> The lockdown LSM is primarily used in conjunction with UEFI Secure Boot.
> This LSM may also be used on machines without UEFI.  It can also be enabled
> when UEFI Secure Boot is disabled. One of lockdown's features is to prevent
> kexec from loading untrusted kernels. Lockdown can be enabled through a
> bootparam or after the kernel has booted through securityfs.
> 
> If IMA appraisal is used with the "ima_appraise=log" boot param,
> lockdown can be defeated with kexec on any machine when Secure Boot is
> disabled or unavailable. IMA prevents setting "ima_appraise=log"
> from the boot param when Secure Boot is enabled, but this does not cover
> cases where lockdown is used without Secure Boot.
> 
> To defeat lockdown, boot without Secure Boot and add ima_appraise=log
> to the kernel command line; then:
> 
> $ echo "integrity" > /sys/kernel/security/lockdown
> $ echo "appraise func=KEXEC_KERNEL_CHECK appraise_type=imasig" > \
>   /sys/kernel/security/ima/policy
> $ kexec -ls unsigned-kernel
> 
> Add a call to verify ima appraisal is set to "enforce" whenever lockdown
> is enabled. This fixes CVE-2022-21505.
> 
> Fixes: 29d3c1c8dfe7 ("kexec: Allow kexec_file() with appropriate IMA policy when locked down")
> Signed-off-by: Eric Snowberg <eric.snowberg@oracle.com>
> Acked-by: Mimi Zohar <zohar@linux.ibm.com>
> ---
>  security/integrity/ima/ima_policy.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
> index 73917413365b..a8802b8da946 100644
> --- a/security/integrity/ima/ima_policy.c
> +++ b/security/integrity/ima/ima_policy.c
> @@ -2247,6 +2247,10 @@ bool ima_appraise_signature(enum kernel_read_file_id id)
>  	if (id >= READING_MAX_ID)
>  		return false;
>  
> +	if (id == READING_KEXEC_IMAGE && !(ima_appraise & IMA_APPRAISE_ENFORCE)
> +	    && security_locked_down(LOCKDOWN_KEXEC))
> +		return false;
> +
>  	func = read_idmap[id] ?: FILE_CHECK;
>  
>  	rcu_read_lock();
> -- 
> 2.27.0
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>

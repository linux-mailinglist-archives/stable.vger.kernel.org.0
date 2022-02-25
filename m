Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D9914C4486
	for <lists+stable@lfdr.de>; Fri, 25 Feb 2022 13:22:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234953AbiBYMWi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Feb 2022 07:22:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231874AbiBYMWh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Feb 2022 07:22:37 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 661DB1AA4BB
        for <stable@vger.kernel.org>; Fri, 25 Feb 2022 04:22:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645791724;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QauBS956aI32DQr3500iFylmaLR8eqAqdY3RxT4SSZA=;
        b=dmZVTP2XaBZ4gbG75rQfmoGKBaljcExna6E1hrxzI4oIiQHXVkdQ9keh2IYaoXMpeXlep1
        +NkiIJH+y8asGaPFHXmiKky+r9H9shQDPRS0UQP3/MK1z2hcVPvkmakz63ZzpV+08WKVn+
        SMB5tvK6AFi+osIdp6qdtOt951DaGRc=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-270-VyNIDiV1NtWHUU-E9KK9iQ-1; Fri, 25 Feb 2022 07:22:02 -0500
X-MC-Unique: VyNIDiV1NtWHUU-E9KK9iQ-1
Received: by mail-ed1-f69.google.com with SMTP id f9-20020a0564021e8900b00412d0a6ef0dso2248496edf.11
        for <stable@vger.kernel.org>; Fri, 25 Feb 2022 04:22:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=QauBS956aI32DQr3500iFylmaLR8eqAqdY3RxT4SSZA=;
        b=oXEnv4UC8jd8LacJMA0iQ0cEuAbvbXq9oXYr0lUlp48tpYKt0cFokgpV2dWI8US4s3
         U/uOi4d0NnVOzN6Ppg+6sRP+2b+X+WemMCI8zStm8qAflOWAtagTBtrFzarMNVaEh8Ri
         EDRlIT6rknerw3HjSJaqvBpvD4N0PqPNHQBlvI5QSq8B5Ja3c27/tV9Bl/lihaoP4Ttv
         qgu5izvf4CtSHR+pjMXCiQaSQZypW0ihTchJ0e/LBn2wn14MR+uj7VVMICTk3lT6vef7
         WgnoZqmupF9MlfMnlojD4bM8M2lsJM/xBZzMnPAMVhe3ebyM3jK9gJLxScYhpXILHec5
         PybA==
X-Gm-Message-State: AOAM531jXdcvWs5/9aKEcZEedUrFENgxZj9uy6Ew+S8VL6Dl0Z/6L1js
        22wnq8LCzRcR983ovZBqfRoBty2KcvYka2tfFAHM/wQXZ5GjZ9aKS8Q/vc6U3zgXqid5XLg4G63
        otMg6t5UIxAJhHbNa
X-Received: by 2002:a17:906:c092:b0:6cd:f3a1:a11e with SMTP id f18-20020a170906c09200b006cdf3a1a11emr5800389ejz.185.1645791721575;
        Fri, 25 Feb 2022 04:22:01 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy27Wj+jj5nmhfeig2bdNLKAPb7tNI2CobOsV0FdBfQhLuPYWpEp3zbpioF/vEy2vT40DDgMQ==
X-Received: by 2002:a17:906:c092:b0:6cd:f3a1:a11e with SMTP id f18-20020a170906c09200b006cdf3a1a11emr5800367ejz.185.1645791721091;
        Fri, 25 Feb 2022 04:22:01 -0800 (PST)
Received: from ?IPV6:2001:1c00:c1e:bf00:1db8:22d3:1bc9:8ca1? (2001-1c00-0c1e-bf00-1db8-22d3-1bc9-8ca1.cable.dynamic.v6.ziggo.nl. [2001:1c00:c1e:bf00:1db8:22d3:1bc9:8ca1])
        by smtp.gmail.com with ESMTPSA id n13-20020a170906164d00b006d078076e6asm946581ejd.100.2022.02.25.04.22.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Feb 2022 04:22:00 -0800 (PST)
Message-ID: <cfab3d5e-9eaf-7e23-83c6-acaf3382411c@redhat.com>
Date:   Fri, 25 Feb 2022 13:22:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: FAILED: patch "[PATCH] platform/x86: amd-pmc: Set QOS during
 suspend on CZN w/ timer" failed to apply to 5.16-stable tree
Content-Language: en-US
To:     gregkh@linuxfoundation.org, mario.limonciello@amd.com,
        rafael.j.wysocki@intel.com
Cc:     stable@vger.kernel.org
References: <164578883415493@kroah.com>
From:   Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <164578883415493@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi All,

On 2/25/22 12:33, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.16-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Mario, I presume you want this backported to the 5.16 kernels ?

If so please provide a backport for Greg to apply.

Regards,

Hans



> 
> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 
> From 68af28426b3ca1bf9ba21c7d8bdd0ff639e5134c Mon Sep 17 00:00:00 2001
> From: Mario Limonciello <mario.limonciello@amd.com>
> Date: Wed, 23 Feb 2022 11:52:37 -0600
> Subject: [PATCH] platform/x86: amd-pmc: Set QOS during suspend on CZN w/ timer
>  wakeup
> 
> commit 59348401ebed ("platform/x86: amd-pmc: Add special handling for
> timer based S0i3 wakeup") adds support for using another platform timer
> in lieu of the RTC which doesn't work properly on some systems. This path
> was validated and worked well before submission. During the 5.16-rc1 merge
> window other patches were merged that caused this to stop working properly.
> 
> When this feature was used with 5.16-rc1 or later some OEM laptops with the
> matching firmware requirements from that commit would shutdown instead of
> program a timer based wakeup.
> 
> This was bisected to commit 8d89835b0467 ("PM: suspend: Do not pause
> cpuidle in the suspend-to-idle path").  This wasn't supposed to cause any
> negative impacts and also tested well on both Intel and ARM platforms.
> However this changed the semantics of when CPUs are allowed to be in the
> deepest state. For the AMD systems in question it appears this causes a
> firmware crash for timer based wakeup.
> 
> It's hypothesized to be caused by the `amd-pmc` driver sending `OS_HINT`
> and all the CPUs going into a deep state while the timer is still being
> programmed. It's likely a firmware bug, but to avoid it don't allow setting
> CPUs into the deepest state while using CZN timer wakeup path.
> 
> If later it's discovered that this also occurs from "regular" suspends
> without a timer as well or on other silicon, this may be later expanded to
> run in the suspend path for more scenarios.
> 
> Cc: stable@vger.kernel.org # 5.16+
> Suggested-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Link: https://lore.kernel.org/linux-acpi/BL1PR12MB51570F5BD05980A0DCA1F3F4E23A9@BL1PR12MB5157.namprd12.prod.outlook.com/T/#mee35f39c41a04b624700ab2621c795367f19c90e
> Fixes: 8d89835b0467 ("PM: suspend: Do not pause cpuidle in the suspend-to-idle path")
> Fixes: 23f62d7ab25b ("PM: sleep: Pause cpuidle later and resume it earlier during system transitions")
> Fixes: 59348401ebed ("platform/x86: amd-pmc: Add special handling for timer based S0i3 wakeup"
> Reviewed-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
> Link: https://lore.kernel.org/r/20220223175237.6209-1-mario.limonciello@amd.com
> Reviewed-by: Hans de Goede <hdegoede@redhat.com>
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> 
> diff --git a/drivers/platform/x86/amd-pmc.c b/drivers/platform/x86/amd-pmc.c
> index 4c72ba68b315..b1103f85a85a 100644
> --- a/drivers/platform/x86/amd-pmc.c
> +++ b/drivers/platform/x86/amd-pmc.c
> @@ -21,6 +21,7 @@
>  #include <linux/module.h>
>  #include <linux/pci.h>
>  #include <linux/platform_device.h>
> +#include <linux/pm_qos.h>
>  #include <linux/rtc.h>
>  #include <linux/suspend.h>
>  #include <linux/seq_file.h>
> @@ -85,6 +86,9 @@
>  #define PMC_MSG_DELAY_MIN_US		50
>  #define RESPONSE_REGISTER_LOOP_MAX	20000
>  
> +/* QoS request for letting CPUs in idle states, but not the deepest */
> +#define AMD_PMC_MAX_IDLE_STATE_LATENCY	3
> +
>  #define SOC_SUBSYSTEM_IP_MAX	12
>  #define DELAY_MIN_US		2000
>  #define DELAY_MAX_US		3000
> @@ -131,6 +135,7 @@ struct amd_pmc_dev {
>  	struct device *dev;
>  	struct pci_dev *rdev;
>  	struct mutex lock; /* generic mutex lock */
> +	struct pm_qos_request amd_pmc_pm_qos_req;
>  #if IS_ENABLED(CONFIG_DEBUG_FS)
>  	struct dentry *dbgfs_dir;
>  #endif /* CONFIG_DEBUG_FS */
> @@ -521,6 +526,14 @@ static int amd_pmc_verify_czn_rtc(struct amd_pmc_dev *pdev, u32 *arg)
>  	rc = rtc_alarm_irq_enable(rtc_device, 0);
>  	dev_dbg(pdev->dev, "wakeup timer programmed for %lld seconds\n", duration);
>  
> +	/*
> +	 * Prevent CPUs from getting into deep idle states while sending OS_HINT
> +	 * which is otherwise generally safe to send when at least one of the CPUs
> +	 * is not in deep idle states.
> +	 */
> +	cpu_latency_qos_update_request(&pdev->amd_pmc_pm_qos_req, AMD_PMC_MAX_IDLE_STATE_LATENCY);
> +	wake_up_all_idle_cpus();
> +
>  	return rc;
>  }
>  
> @@ -538,24 +551,31 @@ static int __maybe_unused amd_pmc_suspend(struct device *dev)
>  	/* Activate CZN specific RTC functionality */
>  	if (pdev->cpu_id == AMD_CPU_ID_CZN) {
>  		rc = amd_pmc_verify_czn_rtc(pdev, &arg);
> -		if (rc < 0)
> -			return rc;
> +		if (rc)
> +			goto fail;
>  	}
>  
>  	/* Dump the IdleMask before we send hint to SMU */
>  	amd_pmc_idlemask_read(pdev, dev, NULL);
>  	msg = amd_pmc_get_os_hint(pdev);
>  	rc = amd_pmc_send_cmd(pdev, arg, NULL, msg, 0);
> -	if (rc)
> +	if (rc) {
>  		dev_err(pdev->dev, "suspend failed\n");
> +		goto fail;
> +	}
>  
>  	if (enable_stb)
>  		rc = amd_pmc_write_stb(pdev, AMD_PMC_STB_PREDEF);
> -	if (rc)	{
> +	if (rc) {
>  		dev_err(pdev->dev, "error writing to STB\n");
> -		return rc;
> +		goto fail;
>  	}
>  
> +	return 0;
> +fail:
> +	if (pdev->cpu_id == AMD_CPU_ID_CZN)
> +		cpu_latency_qos_update_request(&pdev->amd_pmc_pm_qos_req,
> +						PM_QOS_DEFAULT_VALUE);
>  	return rc;
>  }
>  
> @@ -579,12 +599,15 @@ static int __maybe_unused amd_pmc_resume(struct device *dev)
>  	/* Write data incremented by 1 to distinguish in stb_read */
>  	if (enable_stb)
>  		rc = amd_pmc_write_stb(pdev, AMD_PMC_STB_PREDEF + 1);
> -	if (rc)	{
> +	if (rc)
>  		dev_err(pdev->dev, "error writing to STB\n");
> -		return rc;
> -	}
>  
> -	return 0;
> +	/* Restore the QoS request back to defaults if it was set */
> +	if (pdev->cpu_id == AMD_CPU_ID_CZN)
> +		cpu_latency_qos_update_request(&pdev->amd_pmc_pm_qos_req,
> +						PM_QOS_DEFAULT_VALUE);
> +
> +	return rc;
>  }
>  
>  static const struct dev_pm_ops amd_pmc_pm_ops = {
> @@ -722,6 +745,7 @@ static int amd_pmc_probe(struct platform_device *pdev)
>  	amd_pmc_get_smu_version(dev);
>  	platform_set_drvdata(pdev, dev);
>  	amd_pmc_dbgfs_register(dev);
> +	cpu_latency_qos_add_request(&dev->amd_pmc_pm_qos_req, PM_QOS_DEFAULT_VALUE);
>  	return 0;
>  
>  err_pci_dev_put:
> 


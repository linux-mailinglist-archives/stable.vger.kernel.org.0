Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD75C4C2C04
	for <lists+stable@lfdr.de>; Thu, 24 Feb 2022 13:46:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232686AbiBXMqd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Feb 2022 07:46:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232520AbiBXMqc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Feb 2022 07:46:32 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DD55328F949
        for <stable@vger.kernel.org>; Thu, 24 Feb 2022 04:46:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645706762;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RJEDc2Q2XnRo4yiaq/wUfWxJ4pjQE58p0MWyydExWwY=;
        b=DxlkNiCdYLimqBnAp/ZGEF7IPHn9xZW1bFwknAXYAMw63syYpelmhxlZZMYwuwy4wJJCEs
        Ieu1UagRCbrrxpGNd9GUnDcBSj1M0XV6irheoMG955GDoCuNXBQDN81riGJifAWaztnNDG
        GKHvDxlSh52QSgD4qbmJdZkorPsqoBk=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-604-4eEdn1dqM4uEjL41IKih4g-1; Thu, 24 Feb 2022 07:46:01 -0500
X-MC-Unique: 4eEdn1dqM4uEjL41IKih4g-1
Received: by mail-ej1-f69.google.com with SMTP id kw5-20020a170907770500b006ba314a753eso1147619ejc.21
        for <stable@vger.kernel.org>; Thu, 24 Feb 2022 04:46:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=RJEDc2Q2XnRo4yiaq/wUfWxJ4pjQE58p0MWyydExWwY=;
        b=2Ch+EWnKGZvncRiPcwEmdgH5eBV9nfYSztxHDIqUD9M7Cb8HU75NR45bD0vyFb1G84
         FetTPWkqe3ePzjHAY+zoAz7CZxGB0YyoZf6N71mGzLg1JiJA4MzGCapwkPgEWbsMHz/y
         1tOwc45SEAiTIUkyFPM7ByEMdMNDhbgauE01UJjcIPyzN5EVUaA9o5dfJQekKxwQA40a
         QK1cOjr/CvK1SBoZ7BcUgLGvAaEAblbKAO5pS47bX7Z65vu7c1CuZ3Sh+h+i4LmGWwIU
         wVaOYXF4NErVNvY3vsJQlP5djyDnOwFCi48eiv4gwbSOZaQ44nqksfdF7yCUpzbFuKqI
         /JDA==
X-Gm-Message-State: AOAM533/J7zDOkZIz5krGDjYmkDk1xjHQUJco1fzheBNTYRYMbJ9AzSh
        O8wPCou2gR/Ehn4/RBqEu6YvwdjL1AxHSeQFndGhFqPKtXnqjKLg39TlR2mmDWEvFvHAXf3vDr2
        xJE6mgFwk0BaFvUNc
X-Received: by 2002:a17:906:7751:b0:6ce:e3c:81a6 with SMTP id o17-20020a170906775100b006ce0e3c81a6mr2029243ejn.278.1645706759701;
        Thu, 24 Feb 2022 04:45:59 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyFBH8hYxDstdVmnmh3/0yF4wTorYC6ZZIPDQ6owILPwc7gw2uwys3+1jy4whh76/bEEGBMfA==
X-Received: by 2002:a17:906:7751:b0:6ce:e3c:81a6 with SMTP id o17-20020a170906775100b006ce0e3c81a6mr2029228ejn.278.1645706759380;
        Thu, 24 Feb 2022 04:45:59 -0800 (PST)
Received: from ?IPV6:2001:1c00:c1e:bf00:1db8:22d3:1bc9:8ca1? (2001-1c00-0c1e-bf00-1db8-22d3-1bc9-8ca1.cable.dynamic.v6.ziggo.nl. [2001:1c00:c1e:bf00:1db8:22d3:1bc9:8ca1])
        by smtp.gmail.com with ESMTPSA id m4sm1313437ejl.45.2022.02.24.04.45.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Feb 2022 04:45:58 -0800 (PST)
Message-ID: <1ba8e841-c5fb-0665-1d33-a228249bd293@redhat.com>
Date:   Thu, 24 Feb 2022 13:45:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v3] platform/x86: amd-pmc: Set QOS during suspend on CZN
 w/ timer wakeup
Content-Language: en-US
To:     Mario Limonciello <mario.limonciello@amd.com>,
        Mark Gross <mgross@linux.intel.com>,
        "open list:X86 PLATFORM DRIVERS" 
        <platform-driver-x86@vger.kernel.org>
Cc:     Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Goswami Sanket <Sanket.Goswami@amd.com>,
        stable@vger.kernel.org,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
References: <20220223175237.6209-1-mario.limonciello@amd.com>
From:   Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <20220223175237.6209-1-mario.limonciello@amd.com>
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

Hi,

On 2/23/22 18:52, Mario Limonciello wrote:
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

Thank you for your patch, I've applied this patch to my review-hans 
branch:
https://git.kernel.org/pub/scm/linux/kernel/git/pdx86/platform-drivers-x86.git/log/?h=review-hans

I'll also add this to the pdx86/fixes branch and send a
fixes pull-req to Linus with this included.

Note it will show up in those branches once I've pushed my
local branch there, which might take a while.

Once I've run some tests on this branch the patches there will be
added to the platform-drivers-x86/for-next branch and eventually
will be included in the pdx86 pull-request to Linus for the next
merge-window.

Regards,

Hans


> ---
> changes from v2->v3:
>  * Create a define for the latency value, and document it
>  * Minor comment rewording
>  * Add Rafael's tag
> 
>  drivers/platform/x86/amd-pmc.c | 42 ++++++++++++++++++++++++++--------
>  1 file changed, 33 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/platform/x86/amd-pmc.c b/drivers/platform/x86/amd-pmc.c
> index 4c72ba68b315..18b0f6ee65ce 100644
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


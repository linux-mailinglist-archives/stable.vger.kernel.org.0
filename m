Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B5436C7C2A
	for <lists+stable@lfdr.de>; Fri, 24 Mar 2023 11:04:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbjCXKEY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Mar 2023 06:04:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231254AbjCXKEX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Mar 2023 06:04:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8BF11A4BF;
        Fri, 24 Mar 2023 03:04:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8DDCDB82357;
        Fri, 24 Mar 2023 10:04:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73DCEC433D2;
        Fri, 24 Mar 2023 10:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679652260;
        bh=8+n/g8D7fA39riz19Ut1Cr74s9l1rB4rM9KIMmbszOQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cJuAyXXkH9p46rBWBlX4YTit8Ot5+QQH4LlLtMVOsjdpjRUnWTDc+EFM9xJL1OhKe
         FkJe+v48Vr9XCKvaMg6YoUXF/3dwgQXkzH3Ff7JCEur9AI+fG/acjEXEpkwE5QW939
         8vR/Ezsbq2/nGAD2ttYxhpgp4T3cxaDe+uAigtlhJ2EMNdRmI2Dz1Ayzt+cGDP2T0c
         QSc4oYp4aO9OnMMKPnRR8jyTNQjTQeLUt5fhA8KyZUOP1SF1aMzvdCXQc3eEgRmuX8
         JfZL4keo0VvY02LHg36MUqA8x4qy7PNcloF0vBHVkrvZ0qv9DqJ8q16HpAmGvR5L+p
         W/M8uO6d2BQ8g==
Date:   Fri, 24 Mar 2023 15:34:07 +0530
From:   Manivannan Sadhasivam <mani@kernel.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        linux-arm-msm@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] cpufreq: qcom-cpufreq-hw: fix double IO unmap and
 resource release on exit
Message-ID: <20230324100407.GA4259@thinkpad>
References: <20230323174026.950622-1-krzysztof.kozlowski@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230323174026.950622-1-krzysztof.kozlowski@linaro.org>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 23, 2023 at 06:40:26PM +0100, Krzysztof Kozlowski wrote:
> Commit 054a3ef683a1 ("cpufreq: qcom-hw: Allocate qcom_cpufreq_data
> during probe") moved getting memory resource and iomap from
> qcom_cpufreq_hw_cpu_init() to the probe function, however it left
> untouched cleanup in qcom_cpufreq_hw_cpu_exit().
> 
> During device unbind this will lead to doule release of resource and
> double iounmap(), first by qcom_cpufreq_hw_cpu_exit() and second via
> managed resources:
> 
>   resource: Trying to free nonexistent resource <0x0000000018593000-0x0000000018593fff>
>   Trying to vunmap() nonexistent vm area (0000000088a7d4dc)
>   ...
>   vunmap (mm/vmalloc.c:2771 (discriminator 1))
>   iounmap (mm/ioremap.c:60)
>   devm_ioremap_release (lib/devres.c:19)
>   devres_release_all (drivers/base/devres.c:506 drivers/base/devres.c:535)
>   device_unbind_cleanup (drivers/base/dd.c:523)
>   device_release_driver_internal (drivers/base/dd.c:1248 drivers/base/dd.c:1263)
>   device_driver_detach (drivers/base/dd.c:1300)
>   unbind_store (drivers/base/bus.c:243)
>   drv_attr_store (drivers/base/bus.c:127)
>   sysfs_kf_write (fs/sysfs/file.c:137)
>   kernfs_fop_write_iter (fs/kernfs/file.c:334)
>   vfs_write (include/linux/fs.h:1851 fs/read_write.c:491 fs/read_write.c:584)
>   ksys_write (fs/read_write.c:637)
>   __arm64_sys_write (fs/read_write.c:646)
>   invoke_syscall (arch/arm64/include/asm/current.h:19 arch/arm64/kernel/syscall.c:57)
>   el0_svc_common.constprop.0 (arch/arm64/include/asm/daifflags.h:28 arch/arm64/kernel/syscall.c:150)
>   do_el0_svc (arch/arm64/kernel/syscall.c:194)
>   el0_svc (arch/arm64/include/asm/daifflags.h:28 arch/arm64/kernel/entry-common.c:133 arch/arm64/kernel/entry-common.c:142 arch/arm64/kernel/entry-common.c:638)
>   el0t_64_sync_handler (arch/arm64/kernel/entry-common.c:656)
>   el0t_64_sync (arch/arm64/kernel/entry.S:591)
> 
> Fixes: 054a3ef683a1 ("cpufreq: qcom-hw: Allocate qcom_cpufreq_data during probe")
> Cc: <stable@vger.kernel.org>
> Cc: Manivannan Sadhasivam <mani@kernel.org>
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>

Thanks,
Mani

> ---
>  drivers/cpufreq/qcom-cpufreq-hw.c | 11 ++---------
>  1 file changed, 2 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/cpufreq/qcom-cpufreq-hw.c b/drivers/cpufreq/qcom-cpufreq-hw.c
> index 2f581d2d617d..b2d2907200a9 100644
> --- a/drivers/cpufreq/qcom-cpufreq-hw.c
> +++ b/drivers/cpufreq/qcom-cpufreq-hw.c
> @@ -43,7 +43,6 @@ struct qcom_cpufreq_soc_data {
>  
>  struct qcom_cpufreq_data {
>  	void __iomem *base;
> -	struct resource *res;
>  
>  	/*
>  	 * Mutex to synchronize between de-init sequence and re-starting LMh
> @@ -590,16 +589,12 @@ static int qcom_cpufreq_hw_cpu_exit(struct cpufreq_policy *policy)
>  {
>  	struct device *cpu_dev = get_cpu_device(policy->cpu);
>  	struct qcom_cpufreq_data *data = policy->driver_data;
> -	struct resource *res = data->res;
> -	void __iomem *base = data->base;
>  
>  	dev_pm_opp_remove_all_dynamic(cpu_dev);
>  	dev_pm_opp_of_cpumask_remove_table(policy->related_cpus);
>  	qcom_cpufreq_hw_lmh_exit(data);
>  	kfree(policy->freq_table);
>  	kfree(data);
> -	iounmap(base);
> -	release_mem_region(res->start, resource_size(res));
>  
>  	return 0;
>  }
> @@ -718,17 +713,15 @@ static int qcom_cpufreq_hw_driver_probe(struct platform_device *pdev)
>  	for (i = 0; i < num_domains; i++) {
>  		struct qcom_cpufreq_data *data = &qcom_cpufreq.data[i];
>  		struct clk_init_data clk_init = {};
> -		struct resource *res;
>  		void __iomem *base;
>  
> -		base = devm_platform_get_and_ioremap_resource(pdev, i, &res);
> +		base = devm_platform_ioremap_resource(pdev, i);
>  		if (IS_ERR(base)) {
> -			dev_err(dev, "Failed to map resource %pR\n", res);
> +			dev_err(dev, "Failed to map resource index %d\n", i);
>  			return PTR_ERR(base);
>  		}
>  
>  		data->base = base;
> -		data->res = res;
>  
>  		/* Register CPU clock for each frequency domain */
>  		clk_init.name = kasprintf(GFP_KERNEL, "qcom_cpufreq%d", i);
> -- 
> 2.34.1
> 

-- 
மணிவண்ணன் சதாசிவம்

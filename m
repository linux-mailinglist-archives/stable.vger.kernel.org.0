Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49FB9512310
	for <lists+stable@lfdr.de>; Wed, 27 Apr 2022 21:47:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234672AbiD0TuU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Apr 2022 15:50:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234669AbiD0TuQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Apr 2022 15:50:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1F58528E04
        for <stable@vger.kernel.org>; Wed, 27 Apr 2022 12:47:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651088819;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v3OklSdyVLYyhlHQbDyM2Zei+HHJAielq60YtiKYkDc=;
        b=S655zj8L0osE31qdxiodeQrvMGpdcwvLSzV8elxnzQnRfJbSqLwG7hzKsHt7ki+UkFu1g6
        kg6/fqsIJ8fvg+jukimQ0B6TTM01VfYoGHDaZhESQGO9d21wvFZwRhLjtnl/FdDOkXTmOW
        XPEOhhJkIOIqaQ0aJZQFDSYY6/c5I9g=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-208-2_9E3xHbPVulLP6Ztsum2Q-1; Wed, 27 Apr 2022 15:46:57 -0400
X-MC-Unique: 2_9E3xHbPVulLP6Ztsum2Q-1
Received: by mail-ej1-f72.google.com with SMTP id o8-20020a170906974800b006f3a8be7502so1726348ejy.8
        for <stable@vger.kernel.org>; Wed, 27 Apr 2022 12:46:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=v3OklSdyVLYyhlHQbDyM2Zei+HHJAielq60YtiKYkDc=;
        b=X6FcDbH8mIXuoNI2bOHzmwY3CyMskmQAdJ4cnqmPWic9EGMOsLncgnoIw9Wuv7PLnz
         UyQLig/HSgth4htRBAoApLJnI/3zPPOXO+MXz6WQhf1KebWODbf3K4lp9JJGpopdAQWS
         pz/ruCqMA5DaUQD/Q/P6C563mRapkzq5vjYpwRSegdNKIa7h6wGUzQTdIOqPQivkckpC
         13pyQewi9RDkK9vlt6BEdJ8j/hQfp6qoGLzi7xsA25kEsmdTBdeA7r9ivTeI+BNpByG5
         eehG/nxMabOe3IsSjS2Wx8xJ3d64Tc56jaRXtP3C9aw0AYoIGCrj7DtsHPKqopumSUy5
         tq2Q==
X-Gm-Message-State: AOAM53183Zoyt2TvAmp/w+B47xdWy+p0vH6UxZWgpFMkH/fTpsyWTNj5
        ShdPwW4SaX9WdSzxguAdXv32WTjGNVqq9+z4YlAmantr1jXZC7zS2+7a7q71NdrNbwb7Dnzo+u2
        dcIuHakpNgP0+Rcbh
X-Received: by 2002:a17:907:6da5:b0:6f3:c4b1:378b with SMTP id sb37-20020a1709076da500b006f3c4b1378bmr4979669ejc.307.1651088816607;
        Wed, 27 Apr 2022 12:46:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJymvr44AuMeVFSaW3C3BvlE0J5N9rDfBjLEZEqGt/VOJXE6CZNNVtdPgdZBiYcPPiYwnEi6UQ==
X-Received: by 2002:a17:907:6da5:b0:6f3:c4b1:378b with SMTP id sb37-20020a1709076da500b006f3c4b1378bmr4979648ejc.307.1651088816319;
        Wed, 27 Apr 2022 12:46:56 -0700 (PDT)
Received: from ?IPV6:2001:1c00:c1e:bf00:d69d:5353:dba5:ee81? (2001-1c00-0c1e-bf00-d69d-5353-dba5-ee81.cable.dynamic.v6.ziggo.nl. [2001:1c00:c1e:bf00:d69d:5353:dba5:ee81])
        by smtp.gmail.com with ESMTPSA id g16-20020a170906521000b006d58773e992sm7332748ejm.188.2022.04.27.12.46.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Apr 2022 12:46:55 -0700 (PDT)
Message-ID: <a531d7e3-9481-3047-d7a0-c350e0596d53@redhat.com>
Date:   Wed, 27 Apr 2022 21:46:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH] platform/x86/dell: add buffer allocation/free functions
 for SMI calls
Content-Language: en-US
To:     Juergen Gross <jgross@suse.com>, xen-devel@lists.xenproject.org,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dell.Client.Kernel@dell.com
Cc:     Stuart Hayes <stuart.w.hayes@gmail.com>,
        Mark Gross <markgross@kernel.org>, stable@vger.kernel.org
References: <20220318150950.16843-1-jgross@suse.com>
From:   Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <20220318150950.16843-1-jgross@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 3/18/22 16:09, Juergen Gross wrote:
> The dcdbas driver is used to call SMI handlers for both, dcdbas and
> dell-smbios-smm. Both drivers allocate a buffer for communicating
> with the SMI handler. The physical buffer address is then passed to
> the called SMI handler via %ebx.
> 
> Unfortunately this doesn't work when running in Xen dom0, as the
> physical address obtained via virt_to_phys() is only a guest physical
> address, and not a machine physical address as needed by SMI.
> 
> The problem in dcdbas is easy to correct, as dcdbas is using
> dma_alloc_coherent() for allocating the buffer, and the machine
> physical address is available via the DMA address returned in the DMA
> handle.
> 
> In order to avoid duplicating the buffer allocation code in
> dell-smbios-smm, add a generic buffer allocation function to dcdbas
> and use it for both drivers. This is especially fine regarding driver
> dependencies, as dell-smbios-smm is already calling dcdbas to generate
> the SMI request.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Juergen Gross <jgross@suse.com>

Thank you for your patch, I've applied this patch to my review-hans 
branch:
https://git.kernel.org/pub/scm/linux/kernel/git/pdx86/platform-drivers-x86.git/log/?h=review-hans

Note it will show up in my review-hans branch once I've pushed my
local branch there, which might take a while.

Once I've run some tests on this branch the patches there will be
added to the platform-drivers-x86/for-next branch and eventually
will be included in the pdx86 pull-request to Linus for the next
merge-window.

Regards,

Hans



> ---
>  drivers/platform/x86/dell/dcdbas.c          | 127 +++++++++++---------
>  drivers/platform/x86/dell/dcdbas.h          |   9 ++
>  drivers/platform/x86/dell/dell-smbios-smm.c |  14 ++-
>  3 files changed, 87 insertions(+), 63 deletions(-)
> 
> diff --git a/drivers/platform/x86/dell/dcdbas.c b/drivers/platform/x86/dell/dcdbas.c
> index 5e63d6225048..02bcac619018 100644
> --- a/drivers/platform/x86/dell/dcdbas.c
> +++ b/drivers/platform/x86/dell/dcdbas.c
> @@ -40,13 +40,10 @@
>  
>  static struct platform_device *dcdbas_pdev;
>  
> -static u8 *smi_data_buf;
> -static dma_addr_t smi_data_buf_handle;
> -static unsigned long smi_data_buf_size;
>  static unsigned long max_smi_data_buf_size = MAX_SMI_DATA_BUF_SIZE;
> -static u32 smi_data_buf_phys_addr;
>  static DEFINE_MUTEX(smi_data_lock);
>  static u8 *bios_buffer;
> +static struct smi_buffer smi_buf;
>  
>  static unsigned int host_control_action;
>  static unsigned int host_control_smi_type;
> @@ -54,23 +51,49 @@ static unsigned int host_control_on_shutdown;
>  
>  static bool wsmt_enabled;
>  
> +int dcdbas_smi_alloc(struct smi_buffer *smi_buffer, unsigned long size)
> +{
> +	smi_buffer->virt = dma_alloc_coherent(&dcdbas_pdev->dev, size,
> +					      &smi_buffer->dma, GFP_KERNEL);
> +	if (!smi_buffer->virt) {
> +		dev_dbg(&dcdbas_pdev->dev,
> +			"%s: failed to allocate memory size %lu\n",
> +			__func__, size);
> +		return -ENOMEM;
> +	}
> +	smi_buffer->size = size;
> +
> +	dev_dbg(&dcdbas_pdev->dev, "%s: phys: %x size: %lu\n",
> +		__func__, (u32)smi_buffer->dma, smi_buffer->size);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(dcdbas_smi_alloc);
> +
> +void dcdbas_smi_free(struct smi_buffer *smi_buffer)
> +{
> +	if (!smi_buffer->virt)
> +		return;
> +
> +	dev_dbg(&dcdbas_pdev->dev, "%s: phys: %x size: %lu\n",
> +		__func__, (u32)smi_buffer->dma, smi_buffer->size);
> +	dma_free_coherent(&dcdbas_pdev->dev, smi_buffer->size,
> +			  smi_buffer->virt, smi_buffer->dma);
> +	smi_buffer->virt = NULL;
> +	smi_buffer->dma = 0;
> +	smi_buffer->size = 0;
> +}
> +EXPORT_SYMBOL_GPL(dcdbas_smi_free);
> +
>  /**
>   * smi_data_buf_free: free SMI data buffer
>   */
>  static void smi_data_buf_free(void)
>  {
> -	if (!smi_data_buf || wsmt_enabled)
> +	if (!smi_buf.virt || wsmt_enabled)
>  		return;
>  
> -	dev_dbg(&dcdbas_pdev->dev, "%s: phys: %x size: %lu\n",
> -		__func__, smi_data_buf_phys_addr, smi_data_buf_size);
> -
> -	dma_free_coherent(&dcdbas_pdev->dev, smi_data_buf_size, smi_data_buf,
> -			  smi_data_buf_handle);
> -	smi_data_buf = NULL;
> -	smi_data_buf_handle = 0;
> -	smi_data_buf_phys_addr = 0;
> -	smi_data_buf_size = 0;
> +	dcdbas_smi_free(&smi_buf);
>  }
>  
>  /**
> @@ -78,39 +101,29 @@ static void smi_data_buf_free(void)
>   */
>  static int smi_data_buf_realloc(unsigned long size)
>  {
> -	void *buf;
> -	dma_addr_t handle;
> +	struct smi_buffer tmp;
> +	int ret;
>  
> -	if (smi_data_buf_size >= size)
> +	if (smi_buf.size >= size)
>  		return 0;
>  
>  	if (size > max_smi_data_buf_size)
>  		return -EINVAL;
>  
>  	/* new buffer is needed */
> -	buf = dma_alloc_coherent(&dcdbas_pdev->dev, size, &handle, GFP_KERNEL);
> -	if (!buf) {
> -		dev_dbg(&dcdbas_pdev->dev,
> -			"%s: failed to allocate memory size %lu\n",
> -			__func__, size);
> -		return -ENOMEM;
> -	}
> -	/* memory zeroed by dma_alloc_coherent */
> +	ret = dcdbas_smi_alloc(&tmp, size);
> +	if (ret)
> +		return ret;
>  
> -	if (smi_data_buf)
> -		memcpy(buf, smi_data_buf, smi_data_buf_size);
> +	/* memory zeroed by dma_alloc_coherent */
> +	if (smi_buf.virt)
> +		memcpy(tmp.virt, smi_buf.virt, smi_buf.size);
>  
>  	/* free any existing buffer */
>  	smi_data_buf_free();
>  
>  	/* set up new buffer for use */
> -	smi_data_buf = buf;
> -	smi_data_buf_handle = handle;
> -	smi_data_buf_phys_addr = (u32) virt_to_phys(buf);
> -	smi_data_buf_size = size;
> -
> -	dev_dbg(&dcdbas_pdev->dev, "%s: phys: %x size: %lu\n",
> -		__func__, smi_data_buf_phys_addr, smi_data_buf_size);
> +	smi_buf = tmp;
>  
>  	return 0;
>  }
> @@ -119,14 +132,14 @@ static ssize_t smi_data_buf_phys_addr_show(struct device *dev,
>  					   struct device_attribute *attr,
>  					   char *buf)
>  {
> -	return sprintf(buf, "%x\n", smi_data_buf_phys_addr);
> +	return sprintf(buf, "%x\n", (u32)smi_buf.dma);
>  }
>  
>  static ssize_t smi_data_buf_size_show(struct device *dev,
>  				      struct device_attribute *attr,
>  				      char *buf)
>  {
> -	return sprintf(buf, "%lu\n", smi_data_buf_size);
> +	return sprintf(buf, "%lu\n", smi_buf.size);
>  }
>  
>  static ssize_t smi_data_buf_size_store(struct device *dev,
> @@ -155,8 +168,8 @@ static ssize_t smi_data_read(struct file *filp, struct kobject *kobj,
>  	ssize_t ret;
>  
>  	mutex_lock(&smi_data_lock);
> -	ret = memory_read_from_buffer(buf, count, &pos, smi_data_buf,
> -					smi_data_buf_size);
> +	ret = memory_read_from_buffer(buf, count, &pos, smi_buf.virt,
> +					smi_buf.size);
>  	mutex_unlock(&smi_data_lock);
>  	return ret;
>  }
> @@ -176,7 +189,7 @@ static ssize_t smi_data_write(struct file *filp, struct kobject *kobj,
>  	if (ret)
>  		goto out;
>  
> -	memcpy(smi_data_buf + pos, buf, count);
> +	memcpy(smi_buf.virt + pos, buf, count);
>  	ret = count;
>  out:
>  	mutex_unlock(&smi_data_lock);
> @@ -306,11 +319,11 @@ static ssize_t smi_request_store(struct device *dev,
>  
>  	mutex_lock(&smi_data_lock);
>  
> -	if (smi_data_buf_size < sizeof(struct smi_cmd)) {
> +	if (smi_buf.size < sizeof(struct smi_cmd)) {
>  		ret = -ENODEV;
>  		goto out;
>  	}
> -	smi_cmd = (struct smi_cmd *)smi_data_buf;
> +	smi_cmd = (struct smi_cmd *)smi_buf.virt;
>  
>  	switch (val) {
>  	case 2:
> @@ -326,20 +339,20 @@ static ssize_t smi_request_store(struct device *dev,
>  		 * Provide physical address of command buffer field within
>  		 * the struct smi_cmd to BIOS.
>  		 *
> -		 * Because the address that smi_cmd (smi_data_buf) points to
> +		 * Because the address that smi_cmd (smi_buf.virt) points to
>  		 * will be from memremap() of a non-memory address if WSMT
>  		 * is present, we can't use virt_to_phys() on smi_cmd, so
>  		 * we have to use the physical address that was saved when
>  		 * the virtual address for smi_cmd was received.
>  		 */
> -		smi_cmd->ebx = smi_data_buf_phys_addr +
> +		smi_cmd->ebx = (u32)smi_buf.dma +
>  				offsetof(struct smi_cmd, command_buffer);
>  		ret = dcdbas_smi_request(smi_cmd);
>  		if (!ret)
>  			ret = count;
>  		break;
>  	case 0:
> -		memset(smi_data_buf, 0, smi_data_buf_size);
> +		memset(smi_buf.virt, 0, smi_buf.size);
>  		ret = count;
>  		break;
>  	default:
> @@ -356,7 +369,7 @@ EXPORT_SYMBOL(dcdbas_smi_request);
>  /**
>   * host_control_smi: generate host control SMI
>   *
> - * Caller must set up the host control command in smi_data_buf.
> + * Caller must set up the host control command in smi_buf.virt.
>   */
>  static int host_control_smi(void)
>  {
> @@ -367,14 +380,14 @@ static int host_control_smi(void)
>  	s8 cmd_status;
>  	u8 index;
>  
> -	apm_cmd = (struct apm_cmd *)smi_data_buf;
> +	apm_cmd = (struct apm_cmd *)smi_buf.virt;
>  	apm_cmd->status = ESM_STATUS_CMD_UNSUCCESSFUL;
>  
>  	switch (host_control_smi_type) {
>  	case HC_SMITYPE_TYPE1:
>  		spin_lock_irqsave(&rtc_lock, flags);
>  		/* write SMI data buffer physical address */
> -		data = (u8 *)&smi_data_buf_phys_addr;
> +		data = (u8 *)&smi_buf.dma;
>  		for (index = PE1300_CMOS_CMD_STRUCT_PTR;
>  		     index < (PE1300_CMOS_CMD_STRUCT_PTR + 4);
>  		     index++, data++) {
> @@ -405,7 +418,7 @@ static int host_control_smi(void)
>  	case HC_SMITYPE_TYPE3:
>  		spin_lock_irqsave(&rtc_lock, flags);
>  		/* write SMI data buffer physical address */
> -		data = (u8 *)&smi_data_buf_phys_addr;
> +		data = (u8 *)&smi_buf.dma;
>  		for (index = PE1400_CMOS_CMD_STRUCT_PTR;
>  		     index < (PE1400_CMOS_CMD_STRUCT_PTR + 4);
>  		     index++, data++) {
> @@ -450,7 +463,7 @@ static int host_control_smi(void)
>   * This function is called by the driver after the system has
>   * finished shutting down if the user application specified a
>   * host control action to perform on shutdown.  It is safe to
> - * use smi_data_buf at this point because the system has finished
> + * use smi_buf.virt at this point because the system has finished
>   * shutting down and no userspace apps are running.
>   */
>  static void dcdbas_host_control(void)
> @@ -464,18 +477,18 @@ static void dcdbas_host_control(void)
>  	action = host_control_action;
>  	host_control_action = HC_ACTION_NONE;
>  
> -	if (!smi_data_buf) {
> +	if (!smi_buf.virt) {
>  		dev_dbg(&dcdbas_pdev->dev, "%s: no SMI buffer\n", __func__);
>  		return;
>  	}
>  
> -	if (smi_data_buf_size < sizeof(struct apm_cmd)) {
> +	if (smi_buf.size < sizeof(struct apm_cmd)) {
>  		dev_dbg(&dcdbas_pdev->dev, "%s: SMI buffer too small\n",
>  			__func__);
>  		return;
>  	}
>  
> -	apm_cmd = (struct apm_cmd *)smi_data_buf;
> +	apm_cmd = (struct apm_cmd *)smi_buf.virt;
>  
>  	/* power off takes precedence */
>  	if (action & HC_ACTION_HOST_CONTROL_POWEROFF) {
> @@ -583,11 +596,11 @@ static int dcdbas_check_wsmt(void)
>  		return -ENOMEM;
>  	}
>  
> -	/* First 8 bytes is for a semaphore, not part of the smi_data_buf */
> -	smi_data_buf_phys_addr = bios_buf_paddr + 8;
> -	smi_data_buf = bios_buffer + 8;
> -	smi_data_buf_size = remap_size - 8;
> -	max_smi_data_buf_size = smi_data_buf_size;
> +	/* First 8 bytes is for a semaphore, not part of the smi_buf.virt */
> +	smi_buf.dma = bios_buf_paddr + 8;
> +	smi_buf.virt = bios_buffer + 8;
> +	smi_buf.size = remap_size - 8;
> +	max_smi_data_buf_size = smi_buf.size;
>  	wsmt_enabled = true;
>  	dev_info(&dcdbas_pdev->dev,
>  		 "WSMT found, using firmware-provided SMI buffer.\n");
> diff --git a/drivers/platform/x86/dell/dcdbas.h b/drivers/platform/x86/dell/dcdbas.h
> index c3cca5433525..942a23ddded0 100644
> --- a/drivers/platform/x86/dell/dcdbas.h
> +++ b/drivers/platform/x86/dell/dcdbas.h
> @@ -105,5 +105,14 @@ struct smm_eps_table {
>  	u64 num_of_4k_pages;
>  } __packed;
>  
> +struct smi_buffer {
> +	u8 *virt;
> +	unsigned long size;
> +	dma_addr_t dma;
> +};
> +
> +int dcdbas_smi_alloc(struct smi_buffer *smi_buffer, unsigned long size);
> +void dcdbas_smi_free(struct smi_buffer *smi_buffer);
> +
>  #endif /* _DCDBAS_H_ */
>  
> diff --git a/drivers/platform/x86/dell/dell-smbios-smm.c b/drivers/platform/x86/dell/dell-smbios-smm.c
> index 320c032418ac..4d375985c85f 100644
> --- a/drivers/platform/x86/dell/dell-smbios-smm.c
> +++ b/drivers/platform/x86/dell/dell-smbios-smm.c
> @@ -20,6 +20,7 @@
>  
>  static int da_command_address;
>  static int da_command_code;
> +static struct smi_buffer smi_buf;
>  static struct calling_interface_buffer *buffer;
>  static struct platform_device *platform_device;
>  static DEFINE_MUTEX(smm_mutex);
> @@ -57,7 +58,7 @@ static int dell_smbios_smm_call(struct calling_interface_buffer *input)
>  	command.magic = SMI_CMD_MAGIC;
>  	command.command_address = da_command_address;
>  	command.command_code = da_command_code;
> -	command.ebx = virt_to_phys(buffer);
> +	command.ebx = smi_buf.dma;
>  	command.ecx = 0x42534931;
>  
>  	mutex_lock(&smm_mutex);
> @@ -101,9 +102,10 @@ int init_dell_smbios_smm(void)
>  	 * Allocate buffer below 4GB for SMI data--only 32-bit physical addr
>  	 * is passed to SMI handler.
>  	 */
> -	buffer = (void *)__get_free_page(GFP_KERNEL | GFP_DMA32);
> -	if (!buffer)
> -		return -ENOMEM;
> +	ret = dcdbas_smi_alloc(&smi_buf, PAGE_SIZE);
> +	if (ret)
> +		return ret;
> +	buffer = (void *)smi_buf.virt;
>  
>  	dmi_walk(find_cmd_address, NULL);
>  
> @@ -138,7 +140,7 @@ int init_dell_smbios_smm(void)
>  
>  fail_wsmt:
>  fail_platform_device_alloc:
> -	free_page((unsigned long)buffer);
> +	dcdbas_smi_free(&smi_buf);
>  	return ret;
>  }
>  
> @@ -147,6 +149,6 @@ void exit_dell_smbios_smm(void)
>  	if (platform_device) {
>  		dell_smbios_unregister_device(&platform_device->dev);
>  		platform_device_unregister(platform_device);
> -		free_page((unsigned long)buffer);
> +		dcdbas_smi_free(&smi_buf);
>  	}
>  }


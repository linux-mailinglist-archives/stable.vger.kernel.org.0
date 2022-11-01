Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26C7A6149A4
	for <lists+stable@lfdr.de>; Tue,  1 Nov 2022 12:42:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231290AbiKALmH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 07:42:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231289AbiKALlt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 07:41:49 -0400
X-Greylist: delayed 10319 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 01 Nov 2022 04:34:41 PDT
Received: from chronos.abteam.si (chronos.abteam.si [IPv6:2a01:4f8:140:90ea::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 448EB6364;
        Tue,  1 Nov 2022 04:34:40 -0700 (PDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by chronos.abteam.si (Postfix) with ESMTP id 8C5945D000A6;
        Tue,  1 Nov 2022 12:34:38 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=bstnet.org; h=
        content-transfer-encoding:content-type:content-type:in-reply-to
        :from:from:references:content-language:subject:subject
        :user-agent:mime-version:date:date:message-id; s=default; t=
        1667302477; x=1669116878; bh=w0S4kzOF/nYIfpjQVL70Imy+ZJK8fWizqlL
        +ed92z3w=; b=Z/wDlvyR8x/YWvMI6VQ+mG1RT+iypQuVAHmWIEsVAuNggVjFAF9
        1x8Z7YFHSZ/gOnA4Q1Dr3F7rBo8IO3p2d+9ChnZVJJ4URYNPfRD1p/cXwmZDwXJn
        +RqV/wo+ZDJ284kIT7xwbQsyCrawJZvvcdo9A15QxKs08WbCsmiJgjYs=
X-Virus-Scanned: Debian amavisd-new at chronos.abteam.si
Received: from chronos.abteam.si ([127.0.0.1])
        by localhost (chronos.abteam.si [127.0.0.1]) (amavisd-new, port 10026)
        with LMTP id fFLLcw9RpGAy; Tue,  1 Nov 2022 12:34:37 +0100 (CET)
Received: from [IPV6:2a00:ee2:4d00:602:9f2b:eb04:ae5e:7a5f] (unknown [IPv6:2a00:ee2:4d00:602:9f2b:eb04:ae5e:7a5f])
        (Authenticated sender: boris@abteam.si)
        by chronos.abteam.si (Postfix) with ESMTPSA id B6F375D000A3;
        Tue,  1 Nov 2022 12:34:36 +0100 (CET)
Message-ID: <13425444-c4bc-5107-4d86-4a19c619e575@bstnet.org>
Date:   Tue, 1 Nov 2022 12:34:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH 6.0 20/20] fbdev/core: Remove
 remove_conflicting_pci_framebuffers()
Content-Language: en-US
To:     Thomas Zimmermann <tzimmermann@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     stable@vger.kernel.org,
        Javier Martinez Canillas <javierm@redhat.com>
References: <20221024112934.415391158@linuxfoundation.org>
 <20221024112935.205547130@linuxfoundation.org>
 <ba4caf7a-9e1f-d5fb-f20c-dba81dc00c06@bstnet.org>
 <88e835b3-4075-e1a3-9201-8ab5c8eaaaff@suse.de>
From:   "Boris V." <borisvk@bstnet.org>
In-Reply-To: <88e835b3-4075-e1a3-9201-8ab5c8eaaaff@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,NO_DNS_FOR_FROM,
        SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 01/11/2022 11:34, Thomas Zimmermann wrote:
> (cc: Alex Williamson)
>
> Hi
>
> Am 01.11.22 um 09:42 schrieb Boris V.:
>> On 24/10/2022 13:31, Greg Kroah-Hartman wrote:
>>> From: Thomas Zimmermann <tzimmermann@suse.de>
>>>
>>> commit 9d69ef1838150c7d87afc1a87aa658c637217585 upstream.
>>>
>>> Remove remove_conflicting_pci_framebuffers() and implement similar
>>> functionality in aperture_remove_conflicting_pci_device(), which was
>>> the only caller. Removes an otherwise unused interface and streamlines
>>> the aperture helper. No functional changes.
>>>
>>> Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
>>> Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
>>> Link: 
>>> https://patchwork.freedesktop.org/patch/msgid/20220718072322.8927-5-tzimmermann@suse.de
>>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>> ---
>>>   drivers/video/aperture.c         |   30 ++++++++++++++----------
>>>   drivers/video/fbdev/core/fbmem.c |   48 
>>> ---------------------------------------
>>>   include/linux/fb.h               |    2 -
>>>   3 files changed, 18 insertions(+), 62 deletions(-)
>>>
>>> --- a/drivers/video/aperture.c
>>> +++ b/drivers/video/aperture.c
>>> @@ -335,30 +335,36 @@ EXPORT_SYMBOL(aperture_remove_conflictin
>>>    */
>>>   int aperture_remove_conflicting_pci_devices(struct pci_dev *pdev, 
>>> const char *name)
>>>   {
>>> +    bool primary = false;
>>>       resource_size_t base, size;
>>>       int bar, ret;
>>> -    /*
>>> -     * WARNING: Apparently we must kick fbdev drivers before vgacon,
>>> -     * otherwise the vga fbdev driver falls over.
>>> -     */
>>> -#if IS_REACHABLE(CONFIG_FB)
>>> -    ret = remove_conflicting_pci_framebuffers(pdev, name);
>>> -    if (ret)
>>> -        return ret;
>>> +#ifdef CONFIG_X86
>>> +    primary = pdev->resource[PCI_ROM_RESOURCE].flags & 
>>> IORESOURCE_ROM_SHADOW;
>>>   #endif
>>> -    ret = vga_remove_vgacon(pdev);
>>> -    if (ret)
>>> -        return ret;
>>>       for (bar = 0; bar < PCI_STD_NUM_BARS; ++bar) {
>>>           if (!(pci_resource_flags(pdev, bar) & IORESOURCE_MEM))
>>>               continue;
>>> +
>>>           base = pci_resource_start(pdev, bar);
>>>           size = pci_resource_len(pdev, bar);
>>> -        aperture_detach_devices(base, size);
>>> +        ret = aperture_remove_conflicting_devices(base, size, 
>>> primary, name);
>>> +        if (ret)
>>> +            break;
>>>       }
>>> +    if (ret)
>>> +        return ret;
>>> +
>>> +    /*
>>> +     * WARNING: Apparently we must kick fbdev drivers before vgacon,
>>> +     * otherwise the vga fbdev driver falls over.
>>> +     */
>>> +    ret = vga_remove_vgacon(pdev);
>>> +    if (ret)
>>> +        return ret;
>>> +
>>>       return 0;
>>>   }
>>> --- a/drivers/video/fbdev/core/fbmem.c
>>> +++ b/drivers/video/fbdev/core/fbmem.c
>>> @@ -1788,54 +1788,6 @@ int remove_conflicting_framebuffers(stru
>>>   EXPORT_SYMBOL(remove_conflicting_framebuffers);
>>>   /**
>>> - * remove_conflicting_pci_framebuffers - remove firmware-configured 
>>> framebuffers for PCI devices
>>> - * @pdev: PCI device
>>> - * @name: requesting driver name
>>> - *
>>> - * This function removes framebuffer devices (eg. initialized by 
>>> firmware)
>>> - * using memory range configured for any of @pdev's memory bars.
>>> - *
>>> - * The function assumes that PCI device with shadowed ROM drives a 
>>> primary
>>> - * display and so kicks out vga16fb.
>>> - */
>>> -int remove_conflicting_pci_framebuffers(struct pci_dev *pdev, const 
>>> char *name)
>>> -{
>>> -    struct apertures_struct *ap;
>>> -    bool primary = false;
>>> -    int err, idx, bar;
>>> -
>>> -    for (idx = 0, bar = 0; bar < PCI_STD_NUM_BARS; bar++) {
>>> -        if (!(pci_resource_flags(pdev, bar) & IORESOURCE_MEM))
>>> -            continue;
>>> -        idx++;
>>> -    }
>>> -
>>> -    ap = alloc_apertures(idx);
>>> -    if (!ap)
>>> -        return -ENOMEM;
>>> -
>>> -    for (idx = 0, bar = 0; bar < PCI_STD_NUM_BARS; bar++) {
>>> -        if (!(pci_resource_flags(pdev, bar) & IORESOURCE_MEM))
>>> -            continue;
>>> -        ap->ranges[idx].base = pci_resource_start(pdev, bar);
>>> -        ap->ranges[idx].size = pci_resource_len(pdev, bar);
>>> -        pci_dbg(pdev, "%s: bar %d: 0x%lx -> 0x%lx\n", __func__, bar,
>>> -            (unsigned long)pci_resource_start(pdev, bar),
>>> -            (unsigned long)pci_resource_end(pdev, bar));
>>> -        idx++;
>>> -    }
>>> -
>>> -#ifdef CONFIG_X86
>>> -    primary = pdev->resource[PCI_ROM_RESOURCE].flags &
>>> -                    IORESOURCE_ROM_SHADOW;
>>> -#endif
>>> -    err = remove_conflicting_framebuffers(ap, name, primary);
>>> -    kfree(ap);
>>> -    return err;
>>> -}
>>> -EXPORT_SYMBOL(remove_conflicting_pci_framebuffers);
>>> -
>>> -/**
>>>    *    register_framebuffer - registers a frame buffer device
>>>    *    @fb_info: frame buffer info structure
>>>    *
>>> --- a/include/linux/fb.h
>>> +++ b/include/linux/fb.h
>>> @@ -615,8 +615,6 @@ extern ssize_t fb_sys_write(struct fb_in
>>>   /* drivers/video/fbmem.c */
>>>   extern int register_framebuffer(struct fb_info *fb_info);
>>>   extern void unregister_framebuffer(struct fb_info *fb_info);
>>> -extern int remove_conflicting_pci_framebuffers(struct pci_dev *pdev,
>>> -                           const char *name);
>>>   extern int remove_conflicting_framebuffers(struct apertures_struct 
>>> *a,
>>>                          const char *name, bool primary);
>>>   extern int fb_prepare_logo(struct fb_info *fb_info, int rotate);
>>>
>>>
>>>
>>>
>>
>> Hello,
>>
>> this patch seems to disable console/framebuffer when vfio-pci is used.
>> I hava 2 nvidia GPUs one is used for host and other is passed through 
>> to VM.
>
> Vfio uses this helper to unload the driver before passing it to a VM 
> AFAIU. But unless you're using nouveau, you're on your own.
>
> Best regards
> Thomas
>

But this happens at boot, when vfio-pci module is loaded. Not when VM is 
started.
And console/framebuffer is unloaded for primary/boot GPU, not the one 
passed to VM.
Also no GPU driver is loaded at this point. And there was no problem 
before, it stopped working with 6.0.4 kernel.


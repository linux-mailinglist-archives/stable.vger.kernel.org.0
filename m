Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC48A678BFC
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 00:25:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231713AbjAWXZ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Jan 2023 18:25:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231245AbjAWXZ1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Jan 2023 18:25:27 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0999044AA
        for <stable@vger.kernel.org>; Mon, 23 Jan 2023 15:25:26 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id r18so10180702pgr.12
        for <stable@vger.kernel.org>; Mon, 23 Jan 2023 15:25:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=GasCXjZfz4MKYwJwHukl2pdBsZh67+I2N//D6B0zamU=;
        b=COGaZlvx3SmciGbu81hqZMERAREQRETI+4VTzCPg6LKJp23kxLfHvHfpOUs4bKBqWu
         gFJVG/9kDBuy5X0d+p5+2PwX7cBxod5kBuk9g0uEhgkv4qDhZIVKdnKESJVSfxgE8eOv
         CBIN6ukh39D9A/61L5BrBdQP75QsJtzQgbPytVKEKyTyppnxR4KFMy2ASiZ2L8UAxiIZ
         00chSNQO9TYkDnkm/ISgrcVcgUuOKxtIa4S7fnsaOX3lWQaBGUzWwILYdg5eJ0osZPrn
         lCyIqd23QFlu6Wfe3NMGZlKnGq8azy9zbiDeaKOhTf94qid8OgL5tHXidNvCR5skYLlO
         leOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GasCXjZfz4MKYwJwHukl2pdBsZh67+I2N//D6B0zamU=;
        b=8FMDoJLyt4AN8Y/M8sl1kHl/HzSKa4DPkJnpFZ82i8QETi1G10Gvpnqpx6xRLCFQDD
         /+gSSQSJtFlk2tyb6zVogsERMBzgrKAyAc6bxVhBl7awZfkSOPLUR7tOrfu8dYzUDI+M
         4ByN/kKzTVA/z/Tw3SMKZ3Ate3+51BKzmdh4utrva0vQIK68LjA8K8VBWbdqILkO9x0a
         GeJDotjZ5Qi1kIB/Sk+svesxUd3LLMuEhSFOFckdbCbHgwp/Im3m6nWCB/N/a2jgecwO
         J/X4j3vOFL+4YBTs1QGqdcs/jxQ+XIsFpRwf4en5b/k/HF7Kk13wh8tjseSRqG3xqqPO
         l/QQ==
X-Gm-Message-State: AFqh2kpX5GrF0MW51UGU8ycSwRiH7FzqHVeyIugghyo7bexSYZlkwCb6
        rkwlGRLSxWgLobJpEprB35yjyw==
X-Google-Smtp-Source: AMrXdXtKaCGhioZ+WbBswMlqM+frTa0+XrI+F2SEhHfvnPnW3wauc2C2OwdTpdc0TPV/nL3XbZ/9aQ==
X-Received: by 2002:a05:6a00:189a:b0:582:13b5:d735 with SMTP id x26-20020a056a00189a00b0058213b5d735mr935518pfh.0.1674516325300;
        Mon, 23 Jan 2023 15:25:25 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id u29-20020a056a00099d00b0058bbdaaa5e4sm125739pfg.162.2023.01.23.15.25.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 15:25:24 -0800 (PST)
Date:   Mon, 23 Jan 2023 23:25:21 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Wei Wang <wei.w.wang@intel.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        =?utf-8?B?5p+z6I+B5bOw?= <liujingfeng@qianxin.com>
Subject: Re: [PATCH v1] KVM: destruct kvm_io_device while unregistering it
 from kvm_io_bus
Message-ID: <Y88XYR0L2DyiKnIM@google.com>
References: <20221229123302.4083-1-wei.w.wang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221229123302.4083-1-wei.w.wang@intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 29, 2022, Wei Wang wrote:
> Current usage of kvm_io_device requires users to destruct it with an extra
> call of kvm_iodevice_destructor after the device gets unregistered from
> the kvm_io_bus. This is not necessary and can cause errors if a user
> forgot to make the extra call.
> 
> Simplify the usage by combining kvm_iodevice_destructor into
> kvm_io_bus_unregister_dev. This reduces LOCs a bit for users and can
> avoid the leakage of destructing the device explicitly.
> 
> The fix was originally provided by Sean Christopherson.
> Link: https://lore.kernel.org/lkml/DS0PR11MB6373F27D0EE6CD28C784478BDCEC9@DS0PR11MB6373.namprd11.prod.outlook.com/T/
> Fixes: 5d3c4c79384a ("KVM: Stop looking for coalesced MMIO zones if the bus is destroyed")
> Cc: stable@vger.kernel.org
> Reported-by: 柳菁峰 <liujingfeng@qianxin.com>
> Signed-off-by: Wei Wang <wei.w.wang@intel.com>
> ---
>  include/kvm/iodev.h       |  6 ------
>  virt/kvm/coalesced_mmio.c |  1 -
>  virt/kvm/eventfd.c        |  1 -
>  virt/kvm/kvm_main.c       | 24 +++++++++++++++---------
>  4 files changed, 15 insertions(+), 17 deletions(-)
> 
> diff --git a/include/kvm/iodev.h b/include/kvm/iodev.h
> index d75fc4365746..56619e33251e 100644
> --- a/include/kvm/iodev.h
> +++ b/include/kvm/iodev.h
> @@ -55,10 +55,4 @@ static inline int kvm_iodevice_write(struct kvm_vcpu *vcpu,
>  				 : -EOPNOTSUPP;
>  }
>  
> -static inline void kvm_iodevice_destructor(struct kvm_io_device *dev)
> -{
> -	if (dev->ops->destructor)
> -		dev->ops->destructor(dev);
> -}
> -
>  #endif /* __KVM_IODEV_H__ */
> diff --git a/virt/kvm/coalesced_mmio.c b/virt/kvm/coalesced_mmio.c
> index 0be80c213f7f..d7135a5e76f8 100644
> --- a/virt/kvm/coalesced_mmio.c
> +++ b/virt/kvm/coalesced_mmio.c
> @@ -195,7 +195,6 @@ int kvm_vm_ioctl_unregister_coalesced_mmio(struct kvm *kvm,
>  			 */
>  			if (r)
>  				break;
> -			kvm_iodevice_destructor(&dev->dev);

The comment lurking above this is now stale.

>  		}
>  	}
>  
> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
> index 2a3ed401ce46..1b277afb545b 100644
> --- a/virt/kvm/eventfd.c
> +++ b/virt/kvm/eventfd.c
> @@ -898,7 +898,6 @@ kvm_deassign_ioeventfd_idx(struct kvm *kvm, enum kvm_bus bus_idx,
>  		bus = kvm_get_bus(kvm, bus_idx);
>  		if (bus)
>  			bus->ioeventfd_count--;
> -		ioeventfd_release(p);
>  		ret = 0;
>  		break;
>  	}
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 13e88297f999..582757ebdce6 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -5200,6 +5200,12 @@ static struct notifier_block kvm_reboot_notifier = {
>  	.priority = 0,
>  };
>  
> +static void kvm_iodevice_destructor(struct kvm_io_device *dev)
> +{
> +	if (dev->ops->destructor)
> +		dev->ops->destructor(dev);
> +}
> +
>  static void kvm_io_bus_destroy(struct kvm_io_bus *bus)
>  {
>  	int i;
> @@ -5423,7 +5429,7 @@ int kvm_io_bus_register_dev(struct kvm *kvm, enum kvm_bus bus_idx, gpa_t addr,
>  int kvm_io_bus_unregister_dev(struct kvm *kvm, enum kvm_bus bus_idx,
>  			      struct kvm_io_device *dev)
>  {
> -	int i, j;
> +	int i;
>  	struct kvm_io_bus *new_bus, *bus;
>  
>  	lockdep_assert_held(&kvm->slots_lock);
> @@ -5453,18 +5459,18 @@ int kvm_io_bus_unregister_dev(struct kvm *kvm, enum kvm_bus bus_idx,
>  	rcu_assign_pointer(kvm->buses[bus_idx], new_bus);
>  	synchronize_srcu_expedited(&kvm->srcu);
>  
> -	/* Destroy the old bus _after_ installing the (null) bus. */
> +	/*
> +	 * If (null) bus is installed, destroy the old bus, including all the
> +	 * attached devices. Otherwise, destroy the caller's device only.
> +	 */
>  	if (!new_bus) {
>  		pr_err("kvm: failed to shrink bus, removing it completely\n");
> -		for (j = 0; j < bus->dev_count; j++) {
> -			if (j == i)
> -				continue;
> -			kvm_iodevice_destructor(bus->range[j].dev);
> -		}
> +		kvm_io_bus_destroy(bus);
> +		return -ENOMEM;

Returning an error code is unnecessary if unregister_dev() destroys the bus.
Nothing ultimately consumes the result, e.g. kvm_vm_ioctl_unregister_coalesced_mmio()
intentionally ignores the result other than to bail from the loop, and destroying
the bus means it will immediately bail from the loop anyways.

>  	}
>  
> -	kfree(bus);
> -	return new_bus ? 0 : -ENOMEM;
> +	kvm_iodevice_destructor(dev);
> +	return 0;

Unless I'm misreading things, this path leaks "bus".

Given that that intent is to send the fix for stable, that this is as much a
cleanup as it is a bug fix, and that it's not super trivial, I'm inclined to queue
my patch and then land this on top as cleanup.

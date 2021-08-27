Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C17E63F982E
	for <lists+stable@lfdr.de>; Fri, 27 Aug 2021 12:38:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233315AbhH0KhA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Aug 2021 06:37:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34019 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244939AbhH0Kg7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Aug 2021 06:36:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630060570;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OK+rr9b/Jw0dJzAaDuML7H7rr3SvkFLHUl/CvBr97bA=;
        b=bkcS9c84UjYazr0hUonIN8WUqBJnXp+Ect7yBnxLGvH3G5B085PW3a/MeYxGOv6MHja6LB
        rIYDp6bBLWbCpLf3+Mw18seRv684yy1lYcOGCxAl2SxdOZ2QOVZNhfgBAX7PUBokmH9U58
        CTJgTCm72QzXZoUVY2h3mqXnTmIgcew=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-245-RvJFTQU9OkaTBnw07A6aeA-1; Fri, 27 Aug 2021 06:36:09 -0400
X-MC-Unique: RvJFTQU9OkaTBnw07A6aeA-1
Received: by mail-ed1-f69.google.com with SMTP id m16-20020a056402511000b003bead176527so3046535edd.10
        for <stable@vger.kernel.org>; Fri, 27 Aug 2021 03:36:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OK+rr9b/Jw0dJzAaDuML7H7rr3SvkFLHUl/CvBr97bA=;
        b=Tw4FUw7A524DDR6xhFMzgbyb2M+1uBwk27Kn7+5psLFpDBgT/cXmTviB7w+SG9hMU7
         2XdbmacKr/JtZCJ5fl79CqNMIraAWJuNNE6JvXvo9A1lN4HuOL90f6iUHz4otSrSODv7
         uyuTT/U6Fpt5vD3sRczJ76One+LAv2UJvpCl10be+Ilhuui5gKVY07B/jK/d8fKaa/dk
         u8teirNATrWC8rzfsz8a6KRWTWy6fLiGTVBl8YqAYL2YizDT+vGUf5WHfzKqZQcgtCW7
         X9k3Kgl+ngXb6usRIzjILMmj5I1bfGlFUYw9SLyAArOwtIRcOGGYF+3vQfgS/DwfIy9X
         hjAA==
X-Gm-Message-State: AOAM533QicwgOcuh/8gLfGvxAekA4B2bBRpaKq10/oj6/BaZk0TfN2rg
        +nRWfsCyufztWiTUHuyunApNdLsBTOkz+ronwLn++xzquPMOvxyKkJUJeM/bKPpcKaJjR87gx6f
        NUGa6CQnpKCoAzdCD
X-Received: by 2002:a17:906:c252:: with SMTP id bl18mr9131855ejb.519.1630060567838;
        Fri, 27 Aug 2021 03:36:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx/hBwaZShGBxHr+PffpmFYGnPtNYQvxu+yonhbFtAD3+yTXCvYJm0WXNfxYm8Wbqb0411boA==
X-Received: by 2002:a17:906:c252:: with SMTP id bl18mr9131837ejb.519.1630060567604;
        Fri, 27 Aug 2021 03:36:07 -0700 (PDT)
Received: from x1.localdomain (2001-1c00-0c1e-bf00-1054-9d19-e0f0-8214.cable.dynamic.v6.ziggo.nl. [2001:1c00:c1e:bf00:1054:9d19:e0f0:8214])
        by smtp.gmail.com with ESMTPSA id o17sm3135949edc.58.2021.08.27.03.36.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Aug 2021 03:36:07 -0700 (PDT)
Subject: Re: [PATCH v2 1/1] libata: libata: add ATA_HORKAGE_NO_NCQ_TRIM for
 Samsung 860 and 870 SSDs
To:     Kate Hsuan <hpa@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Damien Le Moal <damien.lemoal@wdc.com>
Cc:     linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20210827053344.15087-1-hpa@redhat.com>
 <20210827053344.15087-2-hpa@redhat.com>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <26680b02-ae3b-cbc8-4cb4-ca08722327df@redhat.com>
Date:   Fri, 27 Aug 2021 12:36:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210827053344.15087-2-hpa@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Kate,

Some background info for other people following this thread, as discussed here:
https://bugzilla.kernel.org/show_bug.cgi?id=201693
https://bugzilla.kernel.org/show_bug.cgi?id=203475

There are a lot of users who are reporting disk issues (including data
corruption with Samsung 860 and 870 SSDs. Coming up with fixes for this 
has taken longer then it should because I failed to realize for a long
time that there really are 2 separate issues here:

https://bugzilla.kernel.org/show_bug.cgi?id=203475#c34

"""
So after completely re-reading / analyzing both this bug as well as bug 201693 with a fresh pair of eyes (since the last time I did this was a long time ago) I agree. After careful reading / analysis it seems that there really are 2 different bugs here impacting both the 860 EVO and the 870 EVO:

1. Queued Trim commands are causing issues on Intel + ASmedia + Marvell controllers

2. Things are seriously broken on AMD controllers and only completely disabling NCQ altogether helps there.


I will submit a kernel patch (with a Fixes tag so that it gets backported to stable series) for 1. right away; and I've asked a colleague to start working on a new ATA horkage flag which disables NCQ on AMD SATA controllers only, so that we can add that flag (together with the ATA_HORKAGE_NO_NCQ_TRIM flag which my patch adds) to the 860 EVO and the 870 EVO to also resolve 2.
"""

I asked Kate to write this patch to address 2., note this patch is to be applied
on top of my " libata: add ATA_HORKAGE_NO_NCQ_TRIM for Samsung 860 and 870 SSDs"
patch.

Kate, thank you for your patch. There are several issues which need
to be addressed before this patch can be accepted, starting with the
commit message.

It seems that you used the commit message as my patch as a template, but
you forgot to change the Subject (the first line) for the next version please
change the subject to something correctly describing this patch.

I also see that you gave this patch a version of 2, but since this patch
does not replace my patch, in other words it is a different patch you
should have just made it v1. Anyways lets just make the next version v3
to avoid confusion.

The rest of the commit message should have 1 paragraph describing the reason
why the patch is necessary + a second paragraph describing what the patch
is doing to address this. Your cover-letter would be a good candidate for
the second paragraph, resulting in for example something like this as
body of the commit message:

"""
Many users are reporting that the Samsung 860 and 870 SSDs are having
various issues when combined with AMD SATA controllers and only completely
disabling NCQ helps to avoid these issues.

Entirely disabling NCQ for Samsung 860/870 SSD will cause I/O performance
drop. In this case, a flag ATA_HORKAGE_NONCQ_ON_AMD is introduced to used
to perform additional check for these SSDs. If it finds it's parent ATA
controller is AMD then NCQ will be disabled. Otherwise the NCQ is kept to
enable.
"""

On 8/27/21 7:33 AM, Kate Hsuan wrote:
> A flag ATA_HORKAGE_NONCQ_ON_ASMEDIA_AMD_MARVELL is added to disable NCQ
> on AMD/MAREL/ASMEDIA chipsets.
> 
> Samsung 860/870 SSD are disabled to use NCQ trim functions but it will
> lead to performace drop. From the bugzilla, we could realize the issues
> only appears on those chipset mentioned above. So this flag could be
> used to only disable NCQ on specific chipsets.
> 
> Fixes: ca6bfcb2f6d9 ("libata: Enable queued TRIM for Samsung SSD 860")
> BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=203475
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
> Signed-off-by: Kate Hsuan <hpa@redhat.com>
> ---
>  drivers/ata/libata-core.c | 37 ++++++++++++++++++++++++++++++++-----
>  include/linux/libata.h    |  3 +++
>  2 files changed, 35 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index cc459ce90018..50f635669dd4 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -2119,6 +2119,8 @@ static inline u8 ata_dev_knobble(struct ata_device *dev)
>  static void ata_dev_config_ncq_send_recv(struct ata_device *dev)
>  {
>  	struct ata_port *ap = dev->link->ap;
> +	struct device *parent = NULL;
> +	struct pci_dev *pcidev = NULL;
>  	unsigned int err_mask;
>  
>  	if (!ata_log_supported(dev, ATA_LOG_NCQ_SEND_RECV)) {
> @@ -2138,9 +2140,32 @@ static void ata_dev_config_ncq_send_recv(struct ata_device *dev)
>  		memcpy(cmds, ap->sector_buf, ATA_LOG_NCQ_SEND_RECV_SIZE);
>  
>  		if (dev->horkage & ATA_HORKAGE_NO_NCQ_TRIM) {
> -			ata_dev_dbg(dev, "disabling queued TRIM support\n");
> -			cmds[ATA_LOG_NCQ_SEND_RECV_DSM_OFFSET] &=
> -				~ATA_LOG_NCQ_SEND_RECV_DSM_TRIM;
> +			if (dev->horkage & ATA_HORKAGE_NONCQ_ON_ASMEDIA_AMD_MARVELL)
> +			{
> +				// get parent device for the controller vendor ID
> +				for(parent = dev->tdev.parent; parent != NULL; parent = parent->parent)
> +				{
> +					if(dev_is_pci(parent))
> +					{
> +						pcidev = to_pci_dev(parent);
> +						if (pcidev->vendor == PCI_VENDOR_ID_MARVELL ||
> +							pcidev->vendor == PCI_VENDOR_ID_AMD 	||
> +							pcidev->vendor == PCI_VENDOR_ID_ASMEDIA )
> +						{
> +							ata_dev_dbg(dev, "Disable NCQ -> vendor ID %x product ID %x\n", 
> +												pcidev->vendor, pcidev->device);
> +							cmds[ATA_LOG_NCQ_SEND_RECV_DSM_OFFSET] &=
> +								~ATA_LOG_NCQ_SEND_RECV_DSM_TRIM;
> +						}
> +						break;
> +					}
> +				}
> +			}else
> +			{
> +				ata_dev_dbg(dev, "disabling queued TRIM support\n");
> +				cmds[ATA_LOG_NCQ_SEND_RECV_DSM_OFFSET] &=
> +					~ATA_LOG_NCQ_SEND_RECV_DSM_TRIM;
> +			}

Please don't nest the handling of the new ATA_HORKAGE_NONCQ_ON_AMD flag with the handling of other flags.

Also you are just disabling queued-trims now, which my patch already does, instead the new check should
completely disable NCQ, this means moving the check to ata_dev_config_ncq() adding the new check
after this check:

        if (dev->horkage & ATA_HORKAGE_NONCQ) {
                snprintf(desc, desc_sz, "NCQ (not used)");
                return 0;
        }

And then do the same, but only if pcidev->vendor == PCI_VENDOR_ID_AMD.



>  		}
>  	}
>  }
> @@ -3951,9 +3976,11 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
>  	{ "Samsung SSD 850*",		NULL,	ATA_HORKAGE_NO_NCQ_TRIM |
>  						ATA_HORKAGE_ZERO_AFTER_TRIM, },
>  	{ "Samsung SSD 860*",           NULL,   ATA_HORKAGE_NO_NCQ_TRIM |
> -						ATA_HORKAGE_ZERO_AFTER_TRIM, },
> +						ATA_HORKAGE_ZERO_AFTER_TRIM |
> +						ATA_HORKAGE_NONCQ_ON_ASMEDIA_AMD_MARVELL, },
>  	{ "Samsung SSD 870*",           NULL,   ATA_HORKAGE_NO_NCQ_TRIM |
> -						ATA_HORKAGE_ZERO_AFTER_TRIM, },
> +						ATA_HORKAGE_ZERO_AFTER_TRIM |
> +						ATA_HORKAGE_NONCQ_ON_ASMEDIA_AMD_MARVELL, },
>  	{ "FCCT*M500*",			NULL,	ATA_HORKAGE_NO_NCQ_TRIM |
>  						ATA_HORKAGE_ZERO_AFTER_TRIM, },
>  
> diff --git a/include/linux/libata.h b/include/linux/libata.h
> index 3fcd24236793..ec17f1f3fbf6 100644
> --- a/include/linux/libata.h
> +++ b/include/linux/libata.h
> @@ -422,6 +422,9 @@ enum {
>  	ATA_HORKAGE_NOTRIM	= (1 << 24),	/* don't use TRIM */
>  	ATA_HORKAGE_MAX_SEC_1024 = (1 << 25),	/* Limit max sects to 1024 */
>  	ATA_HORKAGE_MAX_TRIM_128M = (1 << 26),	/* Limit max trim size to 128M */
> +	ATA_HORKAGE_NONCQ_ON_ASMEDIA_AMD_MARVELL = (1 << 27), /*Disable NCQ only on 
> +							ASMeida, AMD, and Marvell 
> +							Chipset*/

When we initially discussed this I know I said that we would need to disable
NCQ on AMD + ASMEDIA + Marvell hosts, but after carefully reading both bugs again
I've come to the conclusion that for Asmedia and Marvell SATA hosts just disabling
trimmed queue as my patch does is enough. So please rename this to:

ATA_HORKAGE_NONCQ_ON_AMD

(and only check for an AMD vendor-id when doing the check).

>  
>  	 /* DMA mask for user DMA control: User visible values; DO NOT
>  	    renumber */
> 

Regards,

Hans


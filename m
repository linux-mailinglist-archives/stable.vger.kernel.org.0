Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D03A53C4C1
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 08:17:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230201AbiFCGRX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 02:17:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiFCGRW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 02:17:22 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE10D1409C;
        Thu,  2 Jun 2022 23:17:20 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id E060821C64;
        Fri,  3 Jun 2022 06:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1654237038; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D4Fy+ccfX+IVUld0/Rtn9mB5L24kq32Jhd/enl6u9Nw=;
        b=M3hNJoRVJvd+Oi5+fCAHE5i2xlN+e30kY6UFX4sf/949/6aEboFtFhlxkOf+sziSOt4BCp
        XwbaCT0mcVVbmtORnyxy4lP8xoGhfeyEjRGz8VCqZ50md31kzwnV5l9G4n+hytByb9Af3H
        BZ3aMs1AZDO60HeQaZ2G3GRzxXXxhc4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1654237038;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D4Fy+ccfX+IVUld0/Rtn9mB5L24kq32Jhd/enl6u9Nw=;
        b=98cnD8wb6KBEpIz2SNmDHNdGH7Yz0bboNlv40plrQDoRcYW//rC/FBbi7okiTqT3KaJ6hs
        Rp5MqVGfY2qPcLBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B309313AA2;
        Fri,  3 Jun 2022 06:17:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id r5rhKW6nmWL8NAAAMHmgww
        (envelope-from <hare@suse.de>); Fri, 03 Jun 2022 06:17:18 +0000
Message-ID: <071542b5-2269-7c8a-a78c-0cd7299bca99@suse.de>
Date:   Fri, 3 Jun 2022 08:17:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Content-Language: en-US
To:     Tyler Erickson <tyler.erickson@seagate.com>,
        damien.lemoal@opensource.wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        muhammad.ahmad@seagate.com, stable@vger.kernel.org
References: <20220602225113.10218-1-tyler.erickson@seagate.com>
 <20220602225113.10218-2-tyler.erickson@seagate.com>
From:   Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 1/3] libata: fix reading concurrent positioning ranges
 log
In-Reply-To: <20220602225113.10218-2-tyler.erickson@seagate.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/3/22 00:51, Tyler Erickson wrote:
> The concurrent positioning ranges log is not a fixed size and may depend
> on how many ranges are supported by the device. This patch uses the size
> reported in the GPL directory to determine the number of pages supported
> by the device before attempting to read this log page.
> 
> This resolves this error from the dmesg output:
>      ata6.00: Read log 0x47 page 0x00 failed, Emask 0x1
> 
> Cc: stable@vger.kernel.org
> Fixes: fe22e1c2f705 ("libata: support concurrent positioning ranges log")
> Signed-off-by: Tyler Erickson <tyler.erickson@seagate.com>
> Reviewed-by: Muhammad Ahmad <muhammad.ahmad@seagate.com>
> Tested-by: Michael English <michael.english@seagate.com>
> ---
>   drivers/ata/libata-core.c | 21 +++++++++++++--------
>   1 file changed, 13 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index 40e816419f48..3ea10f72cb70 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -2010,16 +2010,16 @@ unsigned int ata_read_log_page(struct ata_device *dev, u8 log,
>   	return err_mask;
>   }
>   
> -static bool ata_log_supported(struct ata_device *dev, u8 log)
> +static int ata_log_supported(struct ata_device *dev, u8 log)
>   {
>   	struct ata_port *ap = dev->link->ap;
>   
>   	if (dev->horkage & ATA_HORKAGE_NO_LOG_DIR)
> -		return false;
> +		return 0;
>   
>   	if (ata_read_log_page(dev, ATA_LOG_DIRECTORY, 0, ap->sector_buf, 1))
> -		return false;
> -	return get_unaligned_le16(&ap->sector_buf[log * 2]) ? true : false;
> +		return 0;
> +	return get_unaligned_le16(&ap->sector_buf[log * 2]);
>   }
>   
Maybe we should change to name of the function here; 
'ata_log_supported()' suggests a bool return.

ata_check_log_page() ?

>   static bool ata_identify_page_supported(struct ata_device *dev, u8 page)
> @@ -2455,15 +2455,20 @@ static void ata_dev_config_cpr(struct ata_device *dev)
>   	struct ata_cpr_log *cpr_log = NULL;
>   	u8 *desc, *buf = NULL;
>   
> -	if (ata_id_major_version(dev->id) < 11 ||
> -	    !ata_log_supported(dev, ATA_LOG_CONCURRENT_POSITIONING_RANGES))
> +	if (ata_id_major_version(dev->id) < 11)
> +		goto out;
> +
> +	buf_len = ata_log_supported(dev, ATA_LOG_CONCURRENT_POSITIONING_RANGES);
> +	if (buf_len == 0)
>   		goto out;
>   
>   	/*
>   	 * Read the concurrent positioning ranges log (0x47). We can have at
> -	 * most 255 32B range descriptors plus a 64B header.
> +	 * most 255 32B range descriptors plus a 64B header. This log varies in
> +	 * size, so use the size reported in the GPL directory. Reading beyond
> +	 * the supported length will result in an error.
>   	 */
> -	buf_len = (64 + 255 * 32 + 511) & ~511;
> +	buf_len <<= 9;
>   	buf = kzalloc(buf_len, GFP_KERNEL);
>   	if (!buf)
>   		goto out;

I don't get it.
You just returned the actual length of the log page from the previous 
function. Why do you need to calculate the length here?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer

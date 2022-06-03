Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0475E53C4C7
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 08:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241367AbiFCGSo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 02:18:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiFCGSn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 02:18:43 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDABA1D0F1;
        Thu,  2 Jun 2022 23:18:42 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 7699D1F90D;
        Fri,  3 Jun 2022 06:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1654237121; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EDB7jYe/eREYzqsgeee74yP1wsa2+nOa8MnVZn+zwws=;
        b=vIy48MsKmGFLrbsKxHDnrH1z3Cv4rwmxKyqeCpDcmluxOQ9opkXzvsMbABN7fx19PY600r
        +pXaxkywliLrubk2nUyChFVQRkSekb0ZmxzPWkoEPBsdyjcZv62Dxu+RjCmja1Np56ln8A
        GFSkDDCchb+A+pL2Q4bHMxL7nM+pQrQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1654237121;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EDB7jYe/eREYzqsgeee74yP1wsa2+nOa8MnVZn+zwws=;
        b=lknC0K5oGVxwpH2P5IjnJCFVqSyGXNx61FIkvfChMETEeThorLAWX5pH0wP+3YH2i90FpO
        6s6ejSzF4Py22xAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 47A7613AA2;
        Fri,  3 Jun 2022 06:18:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id BFioEMGnmWJ/NQAAMHmgww
        (envelope-from <hare@suse.de>); Fri, 03 Jun 2022 06:18:41 +0000
Message-ID: <94c1c9ae-67cb-2491-0f00-477d78178616@suse.de>
Date:   Fri, 3 Jun 2022 08:18:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2 3/3] scsi: sd: Fix interpretation of VPD B9h length
Content-Language: en-US
To:     Tyler Erickson <tyler.erickson@seagate.com>,
        damien.lemoal@opensource.wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        muhammad.ahmad@seagate.com, stable@vger.kernel.org
References: <20220602225113.10218-1-tyler.erickson@seagate.com>
 <20220602225113.10218-4-tyler.erickson@seagate.com>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20220602225113.10218-4-tyler.erickson@seagate.com>
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
> Fixing the interpretation of the length of the B9h VPD page
> (concurrent positioning ranges). Adding 4 is necessary as
> the first 4 bytes of the page is the header with page number
> and length information. Adding 3 was likely a misinterpretation
> of the SBC-5 specification which sets all offsets starting at zero.
> 
> This fixes the error in dmesg:
> [ 9.014456] sd 1:0:0:0: [sda] Invalid Concurrent Positioning Ranges VPD page
> 
> Cc: stable@vger.kernel.org
> Fixes: e815d36548f0 ("scsi: sd: add concurrent positioning ranges support")
> Signed-off-by: Tyler Erickson <tyler.erickson@seagate.com>
> Reviewed-by: Muhammad Ahmad <muhammad.ahmad@seagate.com>
> Tested-by: Michael English <michael.english@seagate.com>
> ---
>   drivers/scsi/sd.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 749316462075..f25b0cc5dd21 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -3072,7 +3072,7 @@ static void sd_read_cpr(struct scsi_disk *sdkp)
>   		goto out;
>   
>   	/* We must have at least a 64B header and one 32B range descriptor */
> -	vpd_len = get_unaligned_be16(&buffer[2]) + 3;
> +	vpd_len = get_unaligned_be16(&buffer[2]) + 4;
>   	if (vpd_len > buf_len || vpd_len < 64 + 32 || (vpd_len & 31)) {
>   		sd_printk(KERN_ERR, sdkp,
>   			  "Invalid Concurrent Positioning Ranges VPD page\n");

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer

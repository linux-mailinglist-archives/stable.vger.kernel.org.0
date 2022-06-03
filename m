Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8041D53C4C5
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 08:18:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241360AbiFCGSY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 02:18:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiFCGSY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 02:18:24 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57E8514D07;
        Thu,  2 Jun 2022 23:18:23 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id F08E521C64;
        Fri,  3 Jun 2022 06:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1654237101; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dxxy0FmDNl+YCtdc6rBmDFAKgHsKId9gXVYnE8ESokE=;
        b=brkKL9A5V5/JEbHa0ts8NTze5zikrWhhbrKlZkLv7C93z1LTD7UCZ7d0FxS/bXv+Mj6+FZ
        uJHrsng1zx0LS3TASMiBX9S3T9ofFHJ8dNKftC8ZpI1baACGLWB6ilhXfo6PrQ+DuaW94r
        7MGuSqv7/sQqN1JFndYyMxAHfC8/mjc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1654237101;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dxxy0FmDNl+YCtdc6rBmDFAKgHsKId9gXVYnE8ESokE=;
        b=iFXr/roe9/za1nZTvdKThDW+XRe10oqZJW6PDZea5VZIqv7X8M+iHwmBEaOoukJMmQRYyR
        a1cCLv/2fIDP+1BA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D34D613AA2;
        Fri,  3 Jun 2022 06:18:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id qx4bMq2nmWJcNQAAMHmgww
        (envelope-from <hare@suse.de>); Fri, 03 Jun 2022 06:18:21 +0000
Message-ID: <d18c29a8-a992-06bb-a110-548e5b9a9e79@suse.de>
Date:   Fri, 3 Jun 2022 08:18:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2 2/3] libata: fix translation of concurrent positioning
 ranges
Content-Language: en-US
To:     Tyler Erickson <tyler.erickson@seagate.com>,
        damien.lemoal@opensource.wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        muhammad.ahmad@seagate.com, stable@vger.kernel.org
References: <20220602225113.10218-1-tyler.erickson@seagate.com>
 <20220602225113.10218-3-tyler.erickson@seagate.com>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20220602225113.10218-3-tyler.erickson@seagate.com>
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
> Fixing the page length in the SCSI translation for the concurrent
> positioning ranges VPD page. It was writing starting in offset 3
> rather than offset 2 where the MSB is supposed to start for
> the VPD page length.
> 
> Cc: stable@vger.kernel.org
> Fixes: fe22e1c2f705 ("libata: support concurrent positioning ranges log")
> Signed-off-by: Tyler Erickson <tyler.erickson@seagate.com>
> Reviewed-by: Muhammad Ahmad <muhammad.ahmad@seagate.com>
> Tested-by: Michael English <michael.english@seagate.com>
> ---
>   drivers/ata/libata-scsi.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index 42cecf95a4e5..86dbb1cdfabd 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -2125,7 +2125,7 @@ static unsigned int ata_scsiop_inq_b9(struct ata_scsi_args *args, u8 *rbuf)
>   
>   	/* SCSI Concurrent Positioning Ranges VPD page: SBC-5 rev 1 or later */
>   	rbuf[1] = 0xb9;
> -	put_unaligned_be16(64 + (int)cpr_log->nr_cpr * 32 - 4, &rbuf[3]);
> +	put_unaligned_be16(64 + (int)cpr_log->nr_cpr * 32 - 4, &rbuf[2]);
>   
>   	for (i = 0; i < cpr_log->nr_cpr; i++, desc += 32) {
>   		desc[0] = cpr_log->cpr[i].num;
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer

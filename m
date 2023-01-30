Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A10468186C
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 19:14:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236781AbjA3SO4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 13:14:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237212AbjA3SOs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 13:14:48 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5720252B9;
        Mon, 30 Jan 2023 10:14:47 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 78D04200E4;
        Mon, 30 Jan 2023 18:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1675102486; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wvlza5ZF2a/u7EihAbdu57rB3xtK+CD7iG7OrPrMz/w=;
        b=IfV7UP8MAczJcHyiViJn/P9ZjSymEaI3rnAOaUJ69T2/FJJ3biAVGknVVLC3NHml+8NXvE
        Sevv+C8/WMYuqA7vmIuUBKVdKMeLtAD8uDJG1joZqREnhNB2cxAkXpQyeh8HXWGQJ/82jC
        tIEmQep8tp5qxK7TcdbiQOb9XfDbBDM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1675102486;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wvlza5ZF2a/u7EihAbdu57rB3xtK+CD7iG7OrPrMz/w=;
        b=T5q5OdaVFku2f9ie6PCpnGaIozHlB8hH9oD8s643N6uq8PCPFpxsN8eR1tSbXVVB6rpZb1
        NcPeDFdoYFEO6lBg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 448C413A06;
        Mon, 30 Jan 2023 18:14:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id uGLbDxYJ2GNOYAAAMHmgww
        (envelope-from <hare@suse.de>); Mon, 30 Jan 2023 18:14:46 +0000
Message-ID: <d26d88b5-1e2e-bacf-90cc-73010a27c39c@suse.de>
Date:   Mon, 30 Jan 2023 19:14:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH] scsi: aacraid: Allocate cmd_priv with scsicmd
Content-Language: en-US
To:     Kees Cook <keescook@chromium.org>,
        Bart Van Assche <bvanassche@acm.org>
Cc:     Himanshu Madhani <himanshu.madhani@oracle.com>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
References: <20230128000409.never.976-kees@kernel.org>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20230128000409.never.976-kees@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/28/23 01:04, Kees Cook wrote:
> The aac_priv() helper assumes that the private cmd area immediately
> follows struct scsi_cmnd. Allocate this space as part of scsicmd,
> else there is a risk of heap overflow. Seen with GCC 13:
> 
> ../drivers/scsi/aacraid/aachba.c: In function 'aac_probe_container':
> ../drivers/scsi/aacraid/aachba.c:841:26: warning: array subscript 16 is outside array bounds of 'void[392]' [-Warray-bounds=]
>    841 |         status = cmd_priv->status;
>        |                          ^~
> In file included from ../include/linux/resource_ext.h:11,
>                   from ../include/linux/pci.h:40,
>                   from ../drivers/scsi/aacraid/aachba.c:22:
> In function 'kmalloc',
>      inlined from 'kzalloc' at ../include/linux/slab.h:720:9,
>      inlined from 'aac_probe_container' at ../drivers/scsi/aacraid/aachba.c:821:30:
> ../include/linux/slab.h:580:24: note: at offset 392 into object of size 392 allocated by 'kmalloc_trace'
>    580 |                 return kmalloc_trace(
>        |                        ^~~~~~~~~~~~~~
>    581 |                                 kmalloc_caches[kmalloc_type(flags)][index],
>        |                                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>    582 |                                 flags, size);
>        |                                 ~~~~~~~~~~~~
> 
> Fixes: 76a3451b64c6 ("scsi: aacraid: Move the SCSI pointer to private command data")
> Cc: Bart Van Assche <bvanassche@acm.org>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
> Cc: Adaptec OEM Raid Solutions <aacraid@microsemi.com>
> Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> Cc: linux-scsi@vger.kernel.org
> Cc: stable@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>   drivers/scsi/aacraid/aachba.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
> index 4d4cb47b3846..24c049eff157 100644
> --- a/drivers/scsi/aacraid/aachba.c
> +++ b/drivers/scsi/aacraid/aachba.c
> @@ -818,8 +818,8 @@ static void aac_probe_container_scsi_done(struct scsi_cmnd *scsi_cmnd)
>   
>   int aac_probe_container(struct aac_dev *dev, int cid)
>   {
> -	struct scsi_cmnd *scsicmd = kzalloc(sizeof(*scsicmd), GFP_KERNEL);
> -	struct aac_cmd_priv *cmd_priv = aac_priv(scsicmd);
> +	struct aac_cmd_priv *cmd_priv;
> +	struct scsi_cmnd *scsicmd = kzalloc(sizeof(*scsicmd) + sizeof(*cmd_priv), GFP_KERNEL);
>   	struct scsi_device *scsidev = kzalloc(sizeof(*scsidev), GFP_KERNEL);
>   	int status;
>   
> @@ -838,6 +838,7 @@ int aac_probe_container(struct aac_dev *dev, int cid)
>   		while (scsicmd->device == scsidev)
>   			schedule();
>   	kfree(scsidev);
> +	cmd_priv = aac_priv(scsicmd);
>   	status = cmd_priv->status;
>   	kfree(scsicmd);
>   	return status;
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Ivo Totev, Andrew
Myers, Andrew McDonald, Martje Boudien Moerman


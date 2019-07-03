Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6F125DD14
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 05:40:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727065AbfGCDkg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 23:40:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41506 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727025AbfGCDkg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 23:40:36 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 14DC913AA9;
        Wed,  3 Jul 2019 03:40:35 +0000 (UTC)
Received: from mchristi.msp.csb (unknown [10.64.242.49])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 458F75C1A1;
        Wed,  3 Jul 2019 03:40:31 +0000 (UTC)
Reply-To: mchristi@redhat.com
Subject: Re: [RESEND PATCH] scsi: target/iblock: Fix overrun in WRITE SAME
 emulation
To:     Roman Bolshakov <r.bolshakov@yadro.com>,
        target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        stable@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
References: <20190702191636.26481-1-r.bolshakov@yadro.com>
From:   Michael Christie <mchristi@redhat.com>
Organization: Red Hat
Message-ID: <a1c14025-cb00-7f64-a633-82019a3b6813@redhat.com>
Date:   Wed, 3 Jul 2019 12:40:29 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20190702191636.26481-1-r.bolshakov@yadro.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Wed, 03 Jul 2019 03:40:36 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 07/03/2019 04:16 AM, Roman Bolshakov wrote:
> WRITE SAME corrupts data on the block device behind iblock if the
> command is emulated. The emulation code issues (M - 1) * N times more
> bios than requested, where M is the number of 512 blocks per real block
> size and N is the NUMBER OF LOGICAL BLOCKS specified in WRITE SAME
> command. So, for a device with 4k blocks, 7 * N more LBAs gets written
> after the requested range.
> 
> The issue happens because the number of 512 byte sectors to be written
> is decreased one by one while the real bios are typically from 1 to 8
> 512 byte sectors per bio.
> 
> Fixes: c66ac9db8d4a ("[SCSI] target: Add LIO target core v4.0.0-rc6")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/target/target_core_iblock.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
> index f4a075303e9a..6949ea8bc387 100644
> --- a/drivers/target/target_core_iblock.c
> +++ b/drivers/target/target_core_iblock.c
> @@ -502,7 +502,7 @@ iblock_execute_write_same(struct se_cmd *cmd)
>  
>  		/* Always in 512 byte units for Linux/Block */
>  		block_lba += sg->length >> SECTOR_SHIFT;
> -		sectors -= 1;
> +		sectors -= sg->length >> SECTOR_SHIFT;
>  	}
>  
>  	iblock_submit_bios(&list);
> 

Roman,

The patch looks ok to me. Just one question. How did you hit this?

Did you by any chance export this disk to a ESX initiator and was it
doing WRITE SAME to zero out data. But, did the device being used by
iblock not support the zero out command (was
/sys/block/XYZ/queue/write_zeroes_max_bytes == 0)?

Or, did you just send a WRITE SAME command manually using some tools
like sg utils and it had a non zero'd buffer to write out?

Or, was it some other use case?


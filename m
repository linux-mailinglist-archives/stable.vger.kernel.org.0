Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4517B1D0707
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 08:20:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728913AbgEMGUB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 02:20:01 -0400
Received: from mx2.suse.de ([195.135.220.15]:35530 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728498AbgEMGUB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 02:20:01 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id BDAA1AE5A;
        Wed, 13 May 2020 06:20:01 +0000 (UTC)
Subject: Re: [PATCH 4/5] megaraid_sas: TM command refire leads to controller
 firmware crash
To:     Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        kiran-kumar.kasturi@broadcom.com, sankar.patra@broadcom.com,
        sasikumar.pc@broadcom.com, shivasharan.srikanteshwara@broadcom.com,
        anand.lodnoor@broadcom.com, stable@vger.kernel.org
References: <20200508085242.23406-1-chandrakanth.patil@broadcom.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <b007f7ae-0a9d-2bfd-6da8-e72576c40353@suse.de>
Date:   Wed, 13 May 2020 08:19:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200508085242.23406-1-chandrakanth.patil@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/8/20 10:52 AM, Chandrakanth Patil wrote:
> Issue: When TM command times-out driver invokes the controller
> reset. Post reset, driver re-fires pended TM commands which leads
> to firmware crash.
> 
> Fix: Post controller reset, return pended TM commands back to OS.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
> Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
> ---
>   drivers/scsi/megaraid/megaraid_sas_fusion.c | 7 ++++++-
>   1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> index 87f91a38..319f241 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> @@ -4180,6 +4180,7 @@ static void megasas_refire_mgmt_cmd(struct megasas_instance *instance,
>   	struct fusion_context *fusion;
>   	struct megasas_cmd *cmd_mfi;
>   	union MEGASAS_REQUEST_DESCRIPTOR_UNION *req_desc;
> +	struct MPI2_RAID_SCSI_IO_REQUEST *scsi_io_req;
>   	u16 smid;
>   	bool refire_cmd = false;
>   	u8 result;
> @@ -4247,6 +4248,11 @@ static void megasas_refire_mgmt_cmd(struct megasas_instance *instance,
>   			result = COMPLETE_CMD;
>   		}
>   
> +		scsi_io_req = (struct MPI2_RAID_SCSI_IO_REQUEST *)
> +				cmd_fusion->io_request;
> +		if (scsi_io_req->Function == MPI2_FUNCTION_SCSI_TASK_MGMT)
> +			result = RETURN_CMD;
> +
>   		switch (result) {
>   		case REFIRE_CMD:
>   			megasas_fire_cmd_fusion(instance, req_desc);
> @@ -4475,7 +4481,6 @@ megasas_issue_tm(struct megasas_instance *instance, u16 device_handle,
>   	if (!timeleft) {
>   		dev_err(&instance->pdev->dev,
>   			"task mgmt type 0x%x timed out\n", type);
> -		cmd_mfi->flags |= DRV_DCMD_SKIP_REFIRE;
>   		mutex_unlock(&instance->reset_mutex);
>   		rc = megasas_reset_fusion(instance->host, MFI_IO_TIMEOUT_OCR);
>   		mutex_lock(&instance->reset_mutex);
> 
Why didn't the 'DRV_DCMD_SKIP_REFIRE' work?
And if it doesn't work, can't it be removed completely?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer

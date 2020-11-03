Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B09D52A3F69
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 09:57:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727626AbgKCIzz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 03:55:55 -0500
Received: from verein.lst.de ([213.95.11.211]:36306 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727451AbgKCIzz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 03:55:55 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 50B4368C4E; Tue,  3 Nov 2020 09:55:49 +0100 (CET)
Date:   Tue, 3 Nov 2020 09:55:48 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>, stable@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Anand Lodnoor <anand.lodnoor@broadcom.com>,
        Hannes Reinecke <hare@suse.de>, megaraidlinux.pdl@broadcom.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/3] scsi: megaraid_sas: check user-provided offsets
Message-ID: <20201103085548.GB14092@lst.de>
References: <20201030164450.1253641-1-arnd@kernel.org> <20201030164450.1253641-2-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201030164450.1253641-2-arnd@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 30, 2020 at 05:44:20PM +0100, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> It sounds unwise to let user space pass an unchecked 32-bit
> offset into a kernel structure in an ioctl. This is an unsigned
> variable, so checking the upper bound for the size of the structure
> it points into is sufficient to avoid data corruption, but as
> the pointer might also be unaligned, it has to be written carefully
> as well.
> 
> While I stumbled over this problem by reading the code, I did not
> continue checking the function for further problems like it.
> 
> Cc: <stable@vger.kernel.org> # v2.6.15+
> Fixes: c4a3e0a529ab ("[SCSI] MegaRAID SAS RAID: new driver")
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/scsi/megaraid/megaraid_sas_base.c | 15 ++++++++++-----
>  1 file changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
> index 41cd66fc7d81..b1b9a8823c8c 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -8134,7 +8134,7 @@ megasas_mgmt_fw_ioctl(struct megasas_instance *instance,
>  	int error = 0, i;
>  	void *sense = NULL;
>  	dma_addr_t sense_handle;
> -	unsigned long *sense_ptr;
> +	void *sense_ptr;
>  	u32 opcode = 0;
>  	int ret = DCMD_SUCCESS;
>  
> @@ -8257,6 +8257,12 @@ megasas_mgmt_fw_ioctl(struct megasas_instance *instance,
>  	}
>  
>  	if (ioc->sense_len) {
> +		/* make sure the pointer is part of the frame */
> +		if (ioc->sense_off > (sizeof(union megasas_frame) - sizeof(__le64))) {
> +			error = -EINVAL;

This still has the overly long line.

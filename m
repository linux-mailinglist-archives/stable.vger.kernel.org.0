Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 892B54D0017
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 14:31:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237116AbiCGNcM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 08:32:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236126AbiCGNcM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 08:32:12 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11FA37F6E0;
        Mon,  7 Mar 2022 05:31:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646659878; x=1678195878;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=l9ZDDygtV9eTZlD+iB+RzUt4U861wykPbQbF0/vstGE=;
  b=FxnyhXbAfwnWiCtlZVXWOwphDm9MtqdN71iqvvIEgRpXyAuhegBAuohF
   S44++fj2LI99RSYsWwHdaLP+NE4EZklDbg4eGk4Sw1M00SVJdph8GLEPv
   xIn+UzNmMHeCw83OyNIQ+sBCgqGIwIcM0GTFT7N2Tt7qNhh5/jIN8+KNd
   AgdaF7wXNY9gf2I33f1+dVCA7vwO2yEAC3xa+BG1RtojNa21mHe2bLyga
   1hopUzy8H5633lrSr2VbR1vu01xsmP/yW/oyZr8rONcVUdDx5AmtIt/R0
   yKqTgbqw4V0mrwmq1ejjQUwes9ynhwIV7BW27vBR7XigVc5rKodjkcH52
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10278"; a="251962370"
X-IronPort-AV: E=Sophos;i="5.90,162,1643702400"; 
   d="scan'208";a="251962370"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2022 05:31:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,162,1643702400"; 
   d="scan'208";a="553152904"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.92]) ([10.237.72.92])
  by orsmga008.jf.intel.com with ESMTP; 07 Mar 2022 05:31:14 -0800
Message-ID: <74cade30-6dde-c5f7-e009-b34423d22c12@intel.com>
Date:   Mon, 7 Mar 2022 15:31:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.5.0
Subject: Re: [PATCH] scsi: ufs: move shutting_down back to ufshcd_shutdown
Content-Language: en-US
To:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>
Cc:     stable@vger.kernel.org
References: <20220224235629.3804227-1-jaegeuk@kernel.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <20220224235629.3804227-1-jaegeuk@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 25/02/2022 01:56, Jaegeuk Kim wrote:
> The commit b294ff3e3449 ("scsi: ufs: core: Enable power management for wlun")
> moved hba->shutting_down from ufshcd_shutdown to ufshcd_wl_shutdown, which
> introduced regression as belows.
> 
> ufshcd_err_handler started; HBA state eh_non_fatal; powered 1; shutting down 1; saved_err = 4; saved_uic_err = 64; force_reset = 0
> ...
> task:init            state:D stack:    0 pid:    1 ppid:     0 flags:0x04000008
> Call trace:
>  __switch_to+0x25c/0x5e0
>  __schedule+0x68c/0xaa8
>  schedule+0x12c/0x24c
>  schedule_timeout+0x98/0x138
>  wait_for_common_io+0x13c/0x30c
>  blk_execute_rq+0xb0/0x10c
>  __scsi_execute+0x100/0x27c
>  ufshcd_set_dev_pwr_mode+0x1c8/0x408
>  __ufshcd_wl_suspend+0x564/0x688
>  ufshcd_wl_shutdown+0xa8/0xc0
>  device_shutdown+0x234/0x578
>  kernel_restart+0x4c/0x140
>  __arm64_sys_reboot+0x3a0/0x414
>  el0_svc_common+0xd0/0x1e4
>  el0_svc+0x28/0x88
>  el0_sync_handler+0x8c/0xf0
>  el0_sync+0x1c0/0x200
> 
> The init for reboot was stuck, since ufshcd_err_hanlder was skipped when
> shutting down WLUN. This patch allows to run the error handler and let
> disable it during final ufshcd_shutdown only.

I do not understand why it is stuck?  If there was a non-fatal error, the
request should complete anyway, or at least timeout.

> 
> Cc: stable@vger.kernel.org
> Fixes: b294ff3e3449 ("scsi: ufs: core: Enable power management for wlun")
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> ---
>  drivers/scsi/ufs/ufshcd.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 460d2b440d2e..a37813b474d0 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -9178,10 +9178,6 @@ static void ufshcd_wl_shutdown(struct device *dev)
>  
>  	hba = shost_priv(sdev->host);
>  
> -	down(&hba->host_sem);
> -	hba->shutting_down = true;
> -	up(&hba->host_sem);
> -
>  	/* Turn on everything while shutting down */
>  	ufshcd_rpm_get_sync(hba);
>  	scsi_device_quiesce(sdev);
> @@ -9387,6 +9383,10 @@ EXPORT_SYMBOL(ufshcd_runtime_resume);
>   */
>  int ufshcd_shutdown(struct ufs_hba *hba)
>  {
> +	down(&hba->host_sem);
> +	hba->shutting_down = true;
> +	up(&hba->host_sem);

This does not seem right because the device is not accessible after
__ufshcd_wl_suspend(hba, UFS_SHUTDOWN_PM), so shutting_down needs to
be set before.


> +
>  	if (ufshcd_is_ufs_dev_poweroff(hba) && ufshcd_is_link_off(hba))
>  		goto out;
>  


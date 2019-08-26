Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EDC69CE95
	for <lists+stable@lfdr.de>; Mon, 26 Aug 2019 13:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731260AbfHZLvF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Aug 2019 07:51:05 -0400
Received: from mga07.intel.com ([134.134.136.100]:2495 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727182AbfHZLvF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Aug 2019 07:51:05 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Aug 2019 04:51:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,433,1559545200"; 
   d="scan'208";a="174184159"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.122]) ([10.237.72.122])
  by orsmga008.jf.intel.com with ESMTP; 26 Aug 2019 04:51:03 -0700
Subject: Re: FAILED: patch "[PATCH] scsi: ufs: Fix NULL pointer dereference
 in" failed to apply to 4.4-stable tree
To:     gregkh@linuxfoundation.org, martin.petersen@oracle.com
Cc:     stable@vger.kernel.org
References: <156680972724494@kroah.com>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <450beed5-281b-be41-029e-fb98d2ba36ba@intel.com>
Date:   Mon, 26 Aug 2019 14:49:49 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <156680972724494@kroah.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Seems to works for me:

$ git log | head -5
commit 5e9f4d704f8698b6d655afa7e9fac3509da253bc
Author: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date:   Sun Aug 25 10:53:06 2019 +0200

    Linux 4.4.190

$ git cherry-pick 7c7cfdcf7f1777c7376fc9a239980de04b6b5ea1
warning: inexact rename detection was skipped due to too many files.
warning: you may want to set your merge.renamelimit variable to at least 22729 and retry the command.
[linux-4.4.y 9558a3c05149] scsi: ufs: Fix NULL pointer dereference in ufshcd_config_vreg_hpm()
 Date: Wed Aug 14 15:59:50 2019 +0300
 1 file changed, 3 insertions(+)

$ git log | head -5
commit 9558a3c05149ded7136c24325dd3952276fcdaaa
Author: Adrian Hunter <adrian.hunter@intel.com>
Date:   Wed Aug 14 15:59:50 2019 +0300

    scsi: ufs: Fix NULL pointer dereference in ufshcd_config_vreg_hpm()



On 26/08/19 11:55 AM, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 
>>From 7c7cfdcf7f1777c7376fc9a239980de04b6b5ea1 Mon Sep 17 00:00:00 2001
> From: Adrian Hunter <adrian.hunter@intel.com>
> Date: Wed, 14 Aug 2019 15:59:50 +0300
> Subject: [PATCH] scsi: ufs: Fix NULL pointer dereference in
>  ufshcd_config_vreg_hpm()
> 
> Fix the following BUG:
> 
>   [ 187.065689] BUG: kernel NULL pointer dereference, address: 000000000000001c
>   [ 187.065790] RIP: 0010:ufshcd_vreg_set_hpm+0x3c/0x110 [ufshcd_core]
>   [ 187.065938] Call Trace:
>   [ 187.065959] ufshcd_resume+0x72/0x290 [ufshcd_core]
>   [ 187.065980] ufshcd_system_resume+0x54/0x140 [ufshcd_core]
>   [ 187.065993] ? pci_pm_restore+0xb0/0xb0
>   [ 187.066005] ufshcd_pci_resume+0x15/0x20 [ufshcd_pci]
>   [ 187.066017] pci_pm_thaw+0x4c/0x90
>   [ 187.066030] dpm_run_callback+0x5b/0x150
>   [ 187.066043] device_resume+0x11b/0x220
> 
> Voltage regulators are optional, so functions must check they exist
> before dereferencing.
> 
> Note this issue is hidden if CONFIG_REGULATORS is not set, because the
> offending code is optimised away.
> 
> Notes for stable:
> 
> The issue first appears in commit 57d104c153d3 ("ufs: add UFS power
> management support") but is inadvertently fixed in commit 60f0187031c0
> ("scsi: ufs: disable vccq if it's not needed by UFS device") which in
> turn was reverted by commit 730679817d83 ("Revert "scsi: ufs: disable vccq
> if it's not needed by UFS device""). So fix applies v3.18 to v4.5 and
> v5.1+
> 
> Fixes: 57d104c153d3 ("ufs: add UFS power management support")
> Fixes: 730679817d83 ("Revert "scsi: ufs: disable vccq if it's not needed by UFS device"")
> Cc: stable@vger.kernel.org
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index e274053109d0..029da74bb2f5 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -7062,6 +7062,9 @@ static inline int ufshcd_config_vreg_lpm(struct ufs_hba *hba,
>  static inline int ufshcd_config_vreg_hpm(struct ufs_hba *hba,
>  					 struct ufs_vreg *vreg)
>  {
> +	if (!vreg)
> +		return 0;
> +
>  	return ufshcd_config_vreg_load(hba->dev, vreg, vreg->max_uA);
>  }
>  
> 
> 


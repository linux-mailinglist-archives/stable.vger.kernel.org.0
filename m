Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 477E5646964
	for <lists+stable@lfdr.de>; Thu,  8 Dec 2022 07:42:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbiLHGmJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Dec 2022 01:42:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbiLHGmI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Dec 2022 01:42:08 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA15759FDE;
        Wed,  7 Dec 2022 22:42:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670481727; x=1702017727;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=NcHgDkS2iIPJsvHqQw6KgdKSkSodTvp+XCZTiPJlg70=;
  b=IprkRcxJcOMyb+r4f3FNjtAgn5quU0sXVgqKMIIXde2PgCaCAzcbgmos
   BPy0sPpCzClSnCzcpsEPOLHqVRD85mTsPjAvMVwOqLyyP2FZuXMPOQNme
   fK30k0tbSCpXnPFFRwVSN27lIMeYsd359T8zmGB5D4Uk/pGUK8wslQfDP
   LpVl8aUdWFQGamLJ8pi4/09yHV0AXOcesB3vPtF1zRVQPxd7HtW02bfCe
   yJeBYPMIbRb3SxBK5Fo8dPwVuaKHfde4ReDxja5SGJvPn05UqmHVH03FL
   TMynFbwzhjxBQss/a7jaBAuHlerXCLC6W8KCiXbuAEBLjdANWahs7PWaX
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="297447985"
X-IronPort-AV: E=Sophos;i="5.96,227,1665471600"; 
   d="scan'208";a="297447985"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2022 22:42:07 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="679416894"
X-IronPort-AV: E=Sophos;i="5.96,227,1665471600"; 
   d="scan'208";a="679416894"
Received: from rnichen-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.252.39.190])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2022 22:42:01 -0800
Message-ID: <ce72f874-f403-82cf-115e-55d08532bd66@intel.com>
Date:   Thu, 8 Dec 2022 08:41:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.5.1
Subject: Re: [PATCH v5] ufs: core: wlun suspend SSU/enter hibern8 fail
 recovery
To:     peter.wang@mediatek.com, stanley.chu@mediatek.com,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        avri.altman@wdc.com, alim.akhtar@samsung.com, jejb@linux.ibm.com
Cc:     wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
        chun-hung.wu@mediatek.com, alice.chao@mediatek.com,
        cc.chou@mediatek.com, chaotian.jing@mediatek.com,
        jiajie.hao@mediatek.com, powen.kao@mediatek.com,
        qilin.tan@mediatek.com, lin.gui@mediatek.com,
        tun-yu.yu@mediatek.com, eddie.huang@mediatek.com,
        naomi.chu@mediatek.com, stable@vger.kernel.org
References: <20221208061037.24313-1-peter.wang@mediatek.com>
Content-Language: en-US
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <20221208061037.24313-1-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/12/22 08:10, peter.wang@mediatek.com wrote:
> From: Peter Wang <peter.wang@mediatek.com>
> 
> When SSU/enter hibern8 fail in wlun suspend flow, trigger error
> handler and return busy to break the suspend.
> If not, wlun runtime pm status become error and the consumer will
> stuck in runtime suspend status.
> 
> Fixes: b294ff3e3449 ("scsi: ufs: core: Enable power management for wlun")
> Cc: stable@vger.kernel.org
> Signed-off-by: Peter Wang <peter.wang@mediatek.com>
> ---
>  drivers/ufs/core/ufshcd.c | 25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index b1f59a5fe632..c91d58d1486a 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -106,6 +106,13 @@
>  		       16, 4, buf, __len, false);                        \
>  } while (0)
>  
> +#define ufshcd_force_error_recovery(hba) do {                           \
> +	spin_lock_irq(hba->host->host_lock);                            \
> +	hba->force_reset = true;                                        \
> +	ufshcd_schedule_eh_work(hba);                                   \
> +	spin_unlock_irq(hba->host->host_lock);                          \
> +} while (0)

Thanks for separating it out, but there is no reason to make this
a macro, so it should be a function, because functions offer nicer
structure and less chance of surprises. It need not be an inline
function either because the compiler can determine that, and this
is not a hot path. i.e.

static void ufshcd_force_error_recovery(struct ufs_hba *hba)
{
	spin_lock_irq(hba->host->host_lock);
	hba->force_reset = true;
	ufshcd_schedule_eh_work(hba);
	spin_unlock_irq(hba->host->host_lock);
}

> +
>  int ufshcd_dump_regs(struct ufs_hba *hba, size_t offset, size_t len,
>  		     const char *prefix)
>  {
> @@ -9049,6 +9056,15 @@ static int __ufshcd_wl_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
>  
>  		if (!hba->dev_info.b_rpm_dev_flush_capable) {
>  			ret = ufshcd_set_dev_pwr_mode(hba, req_dev_pwr_mode);
> +			if (ret && pm_op != UFS_SHUTDOWN_PM) {
> +				/*
> +				 * If return err in suspend flow, IO will hang.
> +				 * Trigger error handler and break suspend for
> +				 * error recovery.
> +				 */
> +				ufshcd_force_error_recovery(hba);
> +				ret = -EBUSY;
> +			}
>  			if (ret)
>  				goto enable_scaling;
>  		}
> @@ -9060,6 +9076,15 @@ static int __ufshcd_wl_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
>  	 */
>  	check_for_bkops = !ufshcd_is_ufs_dev_deepsleep(hba);
>  	ret = ufshcd_link_state_transition(hba, req_link_state, check_for_bkops);
> +	if (ret && pm_op != UFS_SHUTDOWN_PM) {
> +		/*
> +		 * If return err in suspend flow, IO will hang.
> +		 * Trigger error handler and break suspend for
> +		 * error recovery.
> +		 */
> +		ufshcd_force_error_recovery(hba);
> +		ret = -EBUSY;
> +	}
>  	if (ret)
>  		goto set_dev_active;
>  


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E51B4CBE0
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 12:30:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731149AbfFTKal (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 06:30:41 -0400
Received: from mga03.intel.com ([134.134.136.65]:56112 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726081AbfFTKal (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 06:30:41 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Jun 2019 03:30:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,396,1557212400"; 
   d="scan'208";a="154076669"
Received: from rmsarwar-mobl1.amr.corp.intel.com ([10.252.22.191])
  by orsmga008.jf.intel.com with ESMTP; 20 Jun 2019 03:30:39 -0700
Message-ID: <26ffc4023329e2421e459837bdcb92672f26cb62.camel@intel.com>
Subject: Re: [PATCH] iwlwifi: add support for hr1 RF ID
From:   Luciano Coelho <luciano.coelho@intel.com>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, Oren Givon <oren.givon@intel.com>,
        stable@vger.kernel.org
Date:   Thu, 20 Jun 2019 13:30:38 +0300
In-Reply-To: <20190620084623.12014-1-luca@coelho.fi>
References: <20190620084623.12014-1-luca@coelho.fi>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Kalle,

Please take this to 5.1-rc* as well.

--
Cheers,
Luca.


On Thu, 2019-06-20 at 11:46 +0300, Luca Coelho wrote:
> From: Oren Givon <oren.givon@intel.com>
> 
> The 22000 series FW that was meant to be used with hr is
> also the FW that is used for hr1 and has a different RF ID.
> Add support to load the hr FW when hr1 RF ID is detected.
> 
> Cc: stable@vger.kernel.org # 5.1+
> Signed-off-by: Oren Givon <oren.givon@intel.com>
> Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
> ---
>  drivers/net/wireless/intel/iwlwifi/iwl-csr.h    | 1 +
>  drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 8 +++++---
>  2 files changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-csr.h b/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
> index 553554846009..93da96a7247c 100644
> --- a/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
> +++ b/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
> @@ -336,6 +336,7 @@ enum {
>  /* RF_ID value */
>  #define CSR_HW_RF_ID_TYPE_JF		(0x00105100)
>  #define CSR_HW_RF_ID_TYPE_HR		(0x0010A000)
> +#define CSR_HW_RF_ID_TYPE_HR1		(0x0010c100)
>  #define CSR_HW_RF_ID_TYPE_HRCDB		(0x00109F00)
>  #define CSR_HW_RF_ID_TYPE_GF		(0x0010D000)
>  #define CSR_HW_RF_ID_TYPE_GF4		(0x0010E000)
> diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
> index b93753233223..38ab24d96244 100644
> --- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
> +++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
> @@ -3575,9 +3575,11 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
>  			trans->cfg = &iwlax411_2ax_cfg_so_gf4_a0;
>  		}
>  	} else if (cfg == &iwl_ax101_cfg_qu_hr) {
> -		if (CSR_HW_RF_ID_TYPE_CHIP_ID(trans->hw_rf_id) ==
> -		    CSR_HW_RF_ID_TYPE_CHIP_ID(CSR_HW_RF_ID_TYPE_HR) &&
> -		    trans->hw_rev == CSR_HW_REV_TYPE_QNJ_B0) {
> +		if ((CSR_HW_RF_ID_TYPE_CHIP_ID(trans->hw_rf_id) ==
> +		     CSR_HW_RF_ID_TYPE_CHIP_ID(CSR_HW_RF_ID_TYPE_HR) &&
> +		     trans->hw_rev == CSR_HW_REV_TYPE_QNJ_B0) ||
> +		    (CSR_HW_RF_ID_TYPE_CHIP_ID(trans->hw_rf_id) ==
> +		     CSR_HW_RF_ID_TYPE_CHIP_ID(CSR_HW_RF_ID_TYPE_HR1))) {
>  			trans->cfg = &iwl22000_2ax_cfg_qnj_hr_b0;
>  		} else if (CSR_HW_RF_ID_TYPE_CHIP_ID(trans->hw_rf_id) ==
>  		    CSR_HW_RF_ID_TYPE_CHIP_ID(CSR_HW_RF_ID_TYPE_HR)) {


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D90E410FA5E
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 10:03:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725954AbfLCJDu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 04:03:50 -0500
Received: from a27-11.smtp-out.us-west-2.amazonses.com ([54.240.27.11]:37510
        "EHLO a27-11.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725773AbfLCJDt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Dec 2019 04:03:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1575363828;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:Message-ID:MIME-Version:Content-Type;
        bh=Xr92H1SFzLYwwHnu4N4ph7LN617EsfgrqywWwIwvq5g=;
        b=KZKyXJWu99cPHLmI9d2v8w7La6tHIU2D7xxYsSl1sovlTHqtaRYyEBmFRAmYi8V0
        WoG/xwLiAQ2xwUs0XiYdwChC6gsj6mz699wwOqY35sN2JiJhtTe2HGqHLoX9oDCCwhb
        dCdL9DCBmtG7LMdE94cr41h+tlJuAUWFi6g6KM9Y=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=gdwg2y3kokkkj5a55z2ilkup5wp5hhxx; d=amazonses.com; t=1575363828;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:Message-ID:MIME-Version:Content-Type:Feedback-ID;
        bh=Xr92H1SFzLYwwHnu4N4ph7LN617EsfgrqywWwIwvq5g=;
        b=N/Ff18KAligSRfrXuDM+tXN8ncbGeDcDnBF7FN2KGwpYSF+k48YZfdGBl1aLrB4n
        206I6vpcMM4cZoZojkrMJ4C0kfswx1o8ZEmo97gPFAkRDUMoCEiMOhzXS+Wk/415vib
        XfIbU9Qad0Fbu9ig+NXkyBwyNWJCVuJPXuuw06yQ=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.0
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0F355C433A2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc:     linux-wireless@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v4] iwlwifi: mvm: don't send the IWL_MVM_RXQ_NSSN_SYNC notif to Rx queues
References: <20191120132628.30731-1-emmanuel.grumbach@intel.com>
        <20191203080849.12013-1-emmanuel.grumbach@intel.com>
Date:   Tue, 3 Dec 2019 09:03:48 +0000
In-Reply-To: <20191203080849.12013-1-emmanuel.grumbach@intel.com> (Emmanuel
        Grumbach's message of "Tue, 3 Dec 2019 10:08:49 +0200")
Message-ID: <0101016ecb005b15-cd83cdda-61c0-46bd-86e5-ae4449c195ef-000000@us-west-2.amazonses.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-SES-Outgoing: 2019.12.03-54.240.27.11
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Emmanuel Grumbach <emmanuel.grumbach@intel.com> writes:

> The purpose of this was to keep all the queues updated with
> the Rx sequence numbers because unlikely yet possible
> situations where queues can't understand if a specific
> packet needs to be dropped or not.
>
> Unfortunately, it was reported that this caused issues in
> our DMA engine. We don't fully understand how this is related,
> but this is being currently debugged. For now, just don't send
> this notification to the Rx queues. This de-facto reverts my
> commit 3c514bf831ac12356b695ff054bef641b9e99593:
>
> iwlwifi: mvm: add a loose synchronization of the NSSN across Rx queues
>
> This issue was reported here:
> https://bugzilla.kernel.org/show_bug.cgi?id=204873
> https://bugzilla.kernel.org/show_bug.cgi?id=205001
> and others maybe.
>
> Fixes: 3c514bf831ac ("iwlwifi: mvm: add a loose synchronization of the NSSN across Rx queues")
> CC: <stable@vger.kernel.org> # 5.3+
> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> ---
> v2: fix an unused variable warning
> v3: don't comment out the code
> v4: fix checkpatch issues
> ---
>  .../wireless/intel/iwlwifi/mvm/constants.h    |  1 +
>  drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 19 +++++++++++--------
>  2 files changed, 12 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/constants.h b/drivers/net/wireless/intel/iwlwifi/mvm/constants.h
> index 60aff2ecec12..58df25e2fb32 100644
> --- a/drivers/net/wireless/intel/iwlwifi/mvm/constants.h
> +++ b/drivers/net/wireless/intel/iwlwifi/mvm/constants.h
> @@ -154,5 +154,6 @@
>  #define IWL_MVM_D3_DEBUG			false
>  #define IWL_MVM_USE_TWT				false
>  #define IWL_MVM_AMPDU_CONSEC_DROPS_DELBA	10
> +#define IWL_MVM_USE_NSSN_SYNC			0
>  

[...]

>  static void iwl_mvm_sync_nssn(struct iwl_mvm *mvm, u8 baid, u16 nssn)
>  {
> -	struct iwl_mvm_rss_sync_notif notif = {
> -		.metadata.type = IWL_MVM_RXQ_NSSN_SYNC,
> -		.metadata.sync = 0,
> -		.nssn_sync.baid = baid,
> -		.nssn_sync.nssn = nssn,
> -	};
> -
> -	iwl_mvm_sync_rx_queues_internal(mvm, (void *)&notif, sizeof(notif));
> +	if (IWL_MVM_USE_NSSN_SYNC) {
> +		struct iwl_mvm_rss_sync_notif notif = {
> +			.metadata.type = IWL_MVM_RXQ_NSSN_SYNC,
> +			.metadata.sync = 0,
> +			.nssn_sync.baid = baid,
> +			.nssn_sync.nssn = nssn,
> +		};
> +
> +		iwl_mvm_sync_rx_queues_internal(mvm, (void *)&notif,
> +						sizeof(notif));
> +	}

This is dead code, which is frowned upon and we most likely get cleanup
patches removing it in no time. Please just remove the code, and maybe
even the function. You can easily add it back with git-revert when you
want to fix it. Let's not leave dead code lying around.

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

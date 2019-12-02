Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CE7E10EBAE
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 15:43:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727406AbfLBOny (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 09:43:54 -0500
Received: from a27-185.smtp-out.us-west-2.amazonses.com ([54.240.27.185]:41624
        "EHLO a27-185.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727362AbfLBOny (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Dec 2019 09:43:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1575297833;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:Message-ID:MIME-Version:Content-Type;
        bh=k8Wup7nSmRIURO4EvCuG/wmi68K7xElFpr1WstQPgW0=;
        b=QWy9JQfKumvvDnOAWxwt8y6QZQY43HCVaGm/U6/5WEh6zJB9jcA6e26/RjnoG2c/
        IhIphWCjH5rOnKy7HtQigdfXdGZVjcMTyXe9vZfLMgrB3Xg9LRslN4pqeUgwwBRgytM
        1O3wUFYuWZqngLlW3MJwn9XvAmNPbjcQ2hdd1ijg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=gdwg2y3kokkkj5a55z2ilkup5wp5hhxx; d=amazonses.com; t=1575297833;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:Message-ID:MIME-Version:Content-Type:Feedback-ID;
        bh=k8Wup7nSmRIURO4EvCuG/wmi68K7xElFpr1WstQPgW0=;
        b=AUw2IPj2isXAXEQsGXEZSnctrWak4HYEBNJGFuQzxG6PwhPljHVx/U/DGiQsMsv4
        v5UmA8IQtd44Wc0Wq6IedHtCWAzXOTTOiRbtyQTT54a73R6Ygh/nIGgdQlV9+oDdgji
        25n6OQs4dGRtRG/BZuPFmP2rb3+liAdnlFkJLKl8=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E5585C433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc:     linux-wireless@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] iwlwifi: mvm: don't send the IWL_MVM_RXQ_NSSN_SYNC notif to Rx queues
References: <20191120132628.30731-1-emmanuel.grumbach@intel.com>
        <20191121184530.5393-1-emmanuel.grumbach@intel.com>
Date:   Mon, 2 Dec 2019 14:43:53 +0000
In-Reply-To: <20191121184530.5393-1-emmanuel.grumbach@intel.com> (Emmanuel
        Grumbach's message of "Thu, 21 Nov 2019 20:45:30 +0200")
Message-ID: <0101016ec711594b-f0e8e2cc-29f2-45ad-aa61-abd47dfc511c-000000@us-west-2.amazonses.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-SES-Outgoing: 2019.12.02-54.240.27.185
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
> v2: avoid the unused variable warning
> ---
>  drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 22 ++++++++++++-------
>  1 file changed, 14 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
> index 75a7af5ad7b2..392bfa4b496c 100644
> --- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
> +++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
> @@ -514,14 +514,20 @@ static bool iwl_mvm_is_sn_less(u16 sn1, u16 sn2, u16 buffer_size)
>  
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
> +	/*
> +	 * This allow to synchronize the queues, but it has been reported
> +	 * to cause FH issues. Don't send the notification for now.
> +	 *
> +	 * struct iwl_mvm_rss_sync_notif notif = {
> +	 *	.metadata.type = IWL_MVM_RXQ_NSSN_SYNC,
> +	 *	.metadata.sync = 0,
> +	 *	.nssn_sync.baid = baid,
> +	 *	.nssn_sync.nssn = nssn,
> +	 * };
> +	 *
> +	 *
> +	 * iwl_mvm_sync_rx_queues_internal(mvm, (void *)&notif, sizeof(notif));
> +	 */

Please don't comment out code, instead remove entirely. You can find the
old code from the git history anyway.

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

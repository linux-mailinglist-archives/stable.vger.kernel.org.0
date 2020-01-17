Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F6C0140C8D
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 15:32:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728775AbgAQOcp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jan 2020 09:32:45 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:31254 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726827AbgAQOco (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jan 2020 09:32:44 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1579271563; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=jYPUQjmrAtoPFy4R0WerM/UJvwYOKSyWJnvBdpSBCbQ=; b=OiFXmBWGihhl8rETBnLVuCVqOS2XEt6kDrtEzpa2OuUYjbmTYP7g29zeis8WevXcD/Vad8KY
 /dAjAcc1avDlqjda+rMn2Z9Teztkkvtfb5GgMcUpTcgLkaJB9iLWXav6WP2mmCmQx3xI5woG
 bJEch0HfoDDQqkVZFhMayzmpiRs=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e21c587.7f3805bd7880-smtp-out-n02;
 Fri, 17 Jan 2020 14:32:39 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id F00BBC447B6; Fri, 17 Jan 2020 14:32:37 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.0
Received: from tynnyri.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 1D340C447B0;
        Fri, 17 Jan 2020 14:32:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 1D340C447B0
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Luca Coelho <luca@coelho.fi>
Cc:     Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        linux-wireless@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v4] iwlwifi: mvm: don't send the IWL_MVM_RXQ_NSSN_SYNC notif to Rx queues
References: <20191120132628.30731-1-emmanuel.grumbach@intel.com>
        <20191203080849.12013-1-emmanuel.grumbach@intel.com>
        <0101016ecb005b15-cd83cdda-61c0-46bd-86e5-ae4449c195ef-000000@us-west-2.amazonses.com>
        <b9b21e355b1e9cc5c5d6d3eda978c47eddb16442.camel@coelho.fi>
Date:   Fri, 17 Jan 2020 16:32:33 +0200
In-Reply-To: <b9b21e355b1e9cc5c5d6d3eda978c47eddb16442.camel@coelho.fi> (Luca
        Coelho's message of "Tue, 03 Dec 2019 11:22:45 +0200")
Message-ID: <875zhaywzi.fsf@tynnyri.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Luca Coelho <luca@coelho.fi> writes:

> On Tue, 2019-12-03 at 09:03 +0000, Kalle Valo wrote:
>> Emmanuel Grumbach <emmanuel.grumbach@intel.com> writes:
>> 
>> > The purpose of this was to keep all the queues updated with
>> > the Rx sequence numbers because unlikely yet possible
>> > situations where queues can't understand if a specific
>> > packet needs to be dropped or not.
>> > 
>> > Unfortunately, it was reported that this caused issues in
>> > our DMA engine. We don't fully understand how this is related,
>> > but this is being currently debugged. For now, just don't send
>> > this notification to the Rx queues. This de-facto reverts my
>> > commit 3c514bf831ac12356b695ff054bef641b9e99593:
>> > 
>> > iwlwifi: mvm: add a loose synchronization of the NSSN across Rx queues
>> > 
>> > This issue was reported here:
>> > https://bugzilla.kernel.org/show_bug.cgi?id=204873
>> > https://bugzilla.kernel.org/show_bug.cgi?id=205001
>> > and others maybe.
>> > 
>> > Fixes: 3c514bf831ac ("iwlwifi: mvm: add a loose synchronization of the NSSN across Rx queues")
>> > CC: <stable@vger.kernel.org> # 5.3+
>> > Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
>> > ---
>> > v2: fix an unused variable warning
>> > v3: don't comment out the code
>> > v4: fix checkpatch issues
>> > ---
>> >  .../wireless/intel/iwlwifi/mvm/constants.h    |  1 +
>> >  drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 19 +++++++++++--------
>> >  2 files changed, 12 insertions(+), 8 deletions(-)
>> > 
>> > diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/constants.h
>> > b/drivers/net/wireless/intel/iwlwifi/mvm/constants.h
>> > index 60aff2ecec12..58df25e2fb32 100644
>> > --- a/drivers/net/wireless/intel/iwlwifi/mvm/constants.h
>> > +++ b/drivers/net/wireless/intel/iwlwifi/mvm/constants.h
>> > @@ -154,5 +154,6 @@
>> >  #define IWL_MVM_D3_DEBUG			false
>> >  #define IWL_MVM_USE_TWT				false
>> >  #define IWL_MVM_AMPDU_CONSEC_DROPS_DELBA	10
>> > +#define IWL_MVM_USE_NSSN_SYNC			0
>> >  
>> 
>> [...]
>> 
>> >  static void iwl_mvm_sync_nssn(struct iwl_mvm *mvm, u8 baid, u16 nssn)
>> >  {
>> > -	struct iwl_mvm_rss_sync_notif notif = {
>> > -		.metadata.type = IWL_MVM_RXQ_NSSN_SYNC,
>> > -		.metadata.sync = 0,
>> > -		.nssn_sync.baid = baid,
>> > -		.nssn_sync.nssn = nssn,
>> > -	};
>> > -
>> > -	iwl_mvm_sync_rx_queues_internal(mvm, (void *)&notif, sizeof(notif));
>> > +	if (IWL_MVM_USE_NSSN_SYNC) {
>> > +		struct iwl_mvm_rss_sync_notif notif = {
>> > +			.metadata.type = IWL_MVM_RXQ_NSSN_SYNC,
>> > +			.metadata.sync = 0,
>> > +			.nssn_sync.baid = baid,
>> > +			.nssn_sync.nssn = nssn,
>> > +		};
>> > +
>> > +		iwl_mvm_sync_rx_queues_internal(mvm, (void *)&notif,
>> > +						sizeof(notif));
>> > +	}
>> 
>> This is dead code, which is frowned upon and we most likely get cleanup
>> patches removing it in no time. Please just remove the code, and maybe
>> even the function. You can easily add it back with git-revert when you
>> want to fix it. Let's not leave dead code lying around.
>
> Hi Kalle,
>
> We already have a system like this where we have some constants to
> enable/disable things or hardcode certain parameters in our driver. 
> The main reason for having this is that we have a debugging/maturation
> system internally where we can enable and disable such options
> dynamically (actually with a specific .ini file we create).
>
> Some advantages of doing this are:
>
> 1. The code that goes upstream is not so different from our internal
> development trees;
>
> 2. By reducing the delta from the internal tree to upstream, we reduce
> the merge conflicts, rebase and merge damages etc.;
>
> 3. It's easy to enable and disable features that are not completely
> mature in the FW without having to diverge much (again) from the
> internal tree, because we need to support it internally while it's
> still under development in the driver;
>
> 4. It's easy to tell the community how to enable or disable a feature
> when we need help debugging;
>
> 5. All of this is to make it easier for us to have an upstream driver
> that is as close as possible to our internal development trees. :)
>
>
> I hope this makes sense.  If not, one of the alternatives would be to
> convert this macro into a Kconfig option, but I think that just
> clutters things and the code would still be dead until we tell people
> that it's stable enough to use it...

Yeah, Kconfig option is even worse.

> What do you think?

As long as I have been around here a clear rule has been that no dead
code should be left in kernel code. I understand your points but I'm not
sure if they justify leaving dead code around.

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

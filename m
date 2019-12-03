Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2274510FB2F
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 10:55:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726075AbfLCJzq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 04:55:46 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:50186 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725954AbfLCJzq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Dec 2019 04:55:46 -0500
X-Greylist: delayed 1972 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Dec 2019 04:55:45 EST
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa)
        by farmhouse.coelho.fi with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.2)
        (envelope-from <luca@coelho.fi>)
        id 1ic4ON-000597-Us; Tue, 03 Dec 2019 11:22:48 +0200
Message-ID: <b9b21e355b1e9cc5c5d6d3eda978c47eddb16442.camel@coelho.fi>
From:   Luca Coelho <luca@coelho.fi>
To:     Kalle Valo <kvalo@codeaurora.org>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc:     linux-wireless@vger.kernel.org, stable@vger.kernel.org
Date:   Tue, 03 Dec 2019 11:22:45 +0200
In-Reply-To: <0101016ecb005b15-cd83cdda-61c0-46bd-86e5-ae4449c195ef-000000@us-west-2.amazonses.com>
References: <20191120132628.30731-1-emmanuel.grumbach@intel.com>
         <20191203080849.12013-1-emmanuel.grumbach@intel.com>
         <0101016ecb005b15-cd83cdda-61c0-46bd-86e5-ae4449c195ef-000000@us-west-2.amazonses.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.1-2+b1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on farmhouse.coelho.fi
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        TVD_RCVD_IP,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.2
Subject: Re: [PATCH v4] iwlwifi: mvm: don't send the IWL_MVM_RXQ_NSSN_SYNC
 notif to Rx queues
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2019-12-03 at 09:03 +0000, Kalle Valo wrote:
> Emmanuel Grumbach <emmanuel.grumbach@intel.com> writes:
> 
> > The purpose of this was to keep all the queues updated with
> > the Rx sequence numbers because unlikely yet possible
> > situations where queues can't understand if a specific
> > packet needs to be dropped or not.
> > 
> > Unfortunately, it was reported that this caused issues in
> > our DMA engine. We don't fully understand how this is related,
> > but this is being currently debugged. For now, just don't send
> > this notification to the Rx queues. This de-facto reverts my
> > commit 3c514bf831ac12356b695ff054bef641b9e99593:
> > 
> > iwlwifi: mvm: add a loose synchronization of the NSSN across Rx queues
> > 
> > This issue was reported here:
> > https://bugzilla.kernel.org/show_bug.cgi?id=204873
> > https://bugzilla.kernel.org/show_bug.cgi?id=205001
> > and others maybe.
> > 
> > Fixes: 3c514bf831ac ("iwlwifi: mvm: add a loose synchronization of the NSSN across Rx queues")
> > CC: <stable@vger.kernel.org> # 5.3+
> > Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> > ---
> > v2: fix an unused variable warning
> > v3: don't comment out the code
> > v4: fix checkpatch issues
> > ---
> >  .../wireless/intel/iwlwifi/mvm/constants.h    |  1 +
> >  drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 19 +++++++++++--------
> >  2 files changed, 12 insertions(+), 8 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/constants.h b/drivers/net/wireless/intel/iwlwifi/mvm/constants.h
> > index 60aff2ecec12..58df25e2fb32 100644
> > --- a/drivers/net/wireless/intel/iwlwifi/mvm/constants.h
> > +++ b/drivers/net/wireless/intel/iwlwifi/mvm/constants.h
> > @@ -154,5 +154,6 @@
> >  #define IWL_MVM_D3_DEBUG			false
> >  #define IWL_MVM_USE_TWT				false
> >  #define IWL_MVM_AMPDU_CONSEC_DROPS_DELBA	10
> > +#define IWL_MVM_USE_NSSN_SYNC			0
> >  
> 
> [...]
> 
> >  static void iwl_mvm_sync_nssn(struct iwl_mvm *mvm, u8 baid, u16 nssn)
> >  {
> > -	struct iwl_mvm_rss_sync_notif notif = {
> > -		.metadata.type = IWL_MVM_RXQ_NSSN_SYNC,
> > -		.metadata.sync = 0,
> > -		.nssn_sync.baid = baid,
> > -		.nssn_sync.nssn = nssn,
> > -	};
> > -
> > -	iwl_mvm_sync_rx_queues_internal(mvm, (void *)&notif, sizeof(notif));
> > +	if (IWL_MVM_USE_NSSN_SYNC) {
> > +		struct iwl_mvm_rss_sync_notif notif = {
> > +			.metadata.type = IWL_MVM_RXQ_NSSN_SYNC,
> > +			.metadata.sync = 0,
> > +			.nssn_sync.baid = baid,
> > +			.nssn_sync.nssn = nssn,
> > +		};
> > +
> > +		iwl_mvm_sync_rx_queues_internal(mvm, (void *)&notif,
> > +						sizeof(notif));
> > +	}
> 
> This is dead code, which is frowned upon and we most likely get cleanup
> patches removing it in no time. Please just remove the code, and maybe
> even the function. You can easily add it back with git-revert when you
> want to fix it. Let's not leave dead code lying around.

Hi Kalle,

We already have a system like this where we have some constants to
enable/disable things or hardcode certain parameters in our driver. 
The main reason for having this is that we have a debugging/maturation
system internally where we can enable and disable such options
dynamically (actually with a specific .ini file we create).

Some advantages of doing this are:

1. The code that goes upstream is not so different from our internal
development trees;

2. By reducing the delta from the internal tree to upstream, we reduce
the merge conflicts, rebase and merge damages etc.;

3. It's easy to enable and disable features that are not completely
mature in the FW without having to diverge much (again) from the
internal tree, because we need to support it internally while it's
still under development in the driver;

4. It's easy to tell the community how to enable or disable a feature
when we need help debugging;

5. All of this is to make it easier for us to have an upstream driver
that is as close as possible to our internal development trees. :)


I hope this makes sense.  If not, one of the alternatives would be to
convert this macro into a Kconfig option, but I think that just
clutters things and the code would still be dead until we tell people
that it's stable enough to use it...

What do you think?

--
Cheers,
Luca.


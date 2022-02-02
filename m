Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B358B4A697B
	for <lists+stable@lfdr.de>; Wed,  2 Feb 2022 02:09:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243438AbiBBBJi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Feb 2022 20:09:38 -0500
Received: from mga03.intel.com ([134.134.136.65]:20659 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229994AbiBBBJh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Feb 2022 20:09:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643764177; x=1675300177;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=MncgW0s2mjle1dcrbBYq+e1VuG06s9XtGiZ5lRotZOE=;
  b=iyRf2SHeBXd844FiywVw216DLi7ygtRNAISw6TwyfoYQtfr4ZPBZ1qFW
   qNVhPW6JuEhak8Bc8HFG7+zObMgfGCZzCpXNbe51FCOSeH+q6zLMjZMRp
   MGZwYY1znSpa7H8IzlOIrJCLX9QLHsdbUEKK7/6Kum4KBPCnzZOJwca9t
   eCKBr8fuLrHTcrCWWoWWTCPyRCeSgMFUsF1RRVCxZTAd6kq3sle2pHDtj
   zunL0nvoA4mXFMQtkKsqWmIgpqhtS8oiOLCxUzoFtRHoY0eFpEPzgZs1G
   p4i+h3H7ArBSaA9rx/OORsY+Ek1fC4zwBuDQ0+BN8/7kYyaQnUWqwej29
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10245"; a="247779277"
X-IronPort-AV: E=Sophos;i="5.88,335,1635231600"; 
   d="scan'208";a="247779277"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2022 17:09:37 -0800
X-IronPort-AV: E=Sophos;i="5.88,335,1635231600"; 
   d="scan'208";a="676296027"
Received: from ekebedex-mobl1.amr.corp.intel.com ([10.251.14.93])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2022 17:09:37 -0800
Date:   Tue, 1 Feb 2022 17:09:36 -0800 (PST)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     mptcp@lists.linux.dev, pabeni@redhat.com
cc:     stable@vger.kernel.org
Subject: Re: [PATCH mptcp-stable] mptcp: fix msk traversal in
 mptcp_nl_cmd_set_flags()
In-Reply-To: <20220202004032.208848-1-mathew.j.martineau@linux.intel.com>
Message-ID: <366acfc7-cab7-8f9a-e1cc-3d7f57fecbf8@linux.intel.com>
References: <20220202004032.208848-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 1 Feb 2022, Mat Martineau wrote:

> commit 8e9eacad7ec7a9cbf262649ebf1fa6e6f6cc7d82 upstream.
>
> The upstream commit had to handle a lookup_by_id variable that is only
> present in 5.17. This version of the patch removes that variable, so the
> __lookup_addr() function only handles the lookup as it is implemented in
> 5.15 and 5.16. It also removes one 'const' keyword to prevent a warning
> due to differing const-ness in the 5.17 version of addresses_equal().
>
> The MPTCP endpoint list is under RCU protection, guarded by the
> pernet spinlock. mptcp_nl_cmd_set_flags() traverses the list
> without acquiring the spin-lock nor under the RCU critical section.
>
> This change addresses the issue performing the lookup and the endpoint
> update under the pernet spinlock.
>
> Fixes: 0f9f696a502e ("mptcp: add set_flags command in PM netlink")
> Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
> ---
>
> Paolo, can I add an ack or signoff tag from you?
>
> The upstream commit (8e9eacad7ec7) was queued for the 5.16 and 5.15
> stable trees, which brought along a few extra patches that didn't belong
> in stable. I asked Greg to drop those patches from his queue, and this
> particular commit required manual changes as described above (related to
> the lookup_by_id variable that's new in 5.16).
>
> This patch will not apply to the export branch. I confirmed that it
> applies, builds, and runs on both the 5.16.5 and 5.15.19 branches. Self
> tests succeed too.
>
> When I send to the stable list, I'll also include these tags:
> Cc: <stable@vger.kernel.org> # 5.15.x
> Cc: <stable@vger.kernel.org> # 5.16.x

So... this wasn't supposed to go to stable@vger.kernel.org yet. git 
send-email picked up the cc lines that I had moved out of the commit 
message. Sorry about that.

-Mat


>
>
> ---
> net/mptcp/pm_netlink.c | 34 +++++++++++++++++++++++++---------
> 1 file changed, 25 insertions(+), 9 deletions(-)
>
> diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
> index 65764c8171b3..5d305fafd0e9 100644
> --- a/net/mptcp/pm_netlink.c
> +++ b/net/mptcp/pm_netlink.c
> @@ -459,6 +459,18 @@ static unsigned int fill_remote_addresses_vec(struct mptcp_sock *msk, bool fullm
> 	return i;
> }
>
> +static struct mptcp_pm_addr_entry *
> +__lookup_addr(struct pm_nl_pernet *pernet, struct mptcp_addr_info *info)
> +{
> +	struct mptcp_pm_addr_entry *entry;
> +
> +	list_for_each_entry(entry, &pernet->local_addr_list, list) {
> +		if (addresses_equal(&entry->addr, info, true))
> +			return entry;
> +	}
> +	return NULL;
> +}
> +
> static void mptcp_pm_create_subflow_or_signal_addr(struct mptcp_sock *msk)
> {
> 	struct sock *sk = (struct sock *)msk;
> @@ -1725,17 +1737,21 @@ static int mptcp_nl_cmd_set_flags(struct sk_buff *skb, struct genl_info *info)
> 	if (addr.flags & MPTCP_PM_ADDR_FLAG_BACKUP)
> 		bkup = 1;
>
> -	list_for_each_entry(entry, &pernet->local_addr_list, list) {
> -		if (addresses_equal(&entry->addr, &addr.addr, true)) {
> -			mptcp_nl_addr_backup(net, &entry->addr, bkup);
> -
> -			if (bkup)
> -				entry->flags |= MPTCP_PM_ADDR_FLAG_BACKUP;
> -			else
> -				entry->flags &= ~MPTCP_PM_ADDR_FLAG_BACKUP;
> -		}
> +	spin_lock_bh(&pernet->lock);
> +	entry = __lookup_addr(pernet, &addr.addr);
> +	if (!entry) {
> +		spin_unlock_bh(&pernet->lock);
> +		return -EINVAL;
> 	}
>
> +	if (bkup)
> +		entry->flags |= MPTCP_PM_ADDR_FLAG_BACKUP;
> +	else
> +		entry->flags &= ~MPTCP_PM_ADDR_FLAG_BACKUP;
> +	addr = *entry;
> +	spin_unlock_bh(&pernet->lock);
> +
> +	mptcp_nl_addr_backup(net, &addr.addr, bkup);
> 	return 0;
> }
>
> -- 
> 2.35.1
>
>

--
Mat Martineau
Intel

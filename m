Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84DEE4A4F95
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 20:41:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244383AbiAaTlW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 14:41:22 -0500
Received: from mga03.intel.com ([134.134.136.65]:38143 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230238AbiAaTlT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 Jan 2022 14:41:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643658079; x=1675194079;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=NwGTMczbQMThAqZmfQgLYf4uDMg7Njphl/er97g7hpc=;
  b=FqOGa1+bEP9cNXpppS1XO6AyCFKidfl6rTWN4zgBeY6mekl1KaChtG/E
   utrG3b35deqnfaHYVsWrzgrxuPiSg9bKGfPkzOnYGJdSOhb1kVRBcy8u3
   j+fofAFTx8yuFGlH+iLJ5YsJjGBAOPYn7wPHcYpDHGRJ2oV4xnIntfYfD
   /Kunxp2+Qhc/zOBN/T7dEzZ572dxIrZViTgTSh0fkNEN03K1EquzumAj/
   ftbYks0FfA/dv24b6t0I/o04OZHWJjIsHhnn6gp3gmM/XV72sOimsJFYA
   YxfgQsdFMZ0mcoEWP2gH291QLLZr3x4UmcwxyuAo0cDvCXKdPUn9EZr+V
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10244"; a="247489399"
X-IronPort-AV: E=Sophos;i="5.88,331,1635231600"; 
   d="scan'208";a="247489399"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2022 11:41:19 -0800
X-IronPort-AV: E=Sophos;i="5.88,331,1635231600"; 
   d="scan'208";a="537446277"
Received: from abilal-mobl1.amr.corp.intel.com ([10.212.252.235])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2022 11:41:19 -0800
Date:   Mon, 31 Jan 2022 11:41:19 -0800 (PST)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Davide Caratti <dcaratti@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: Re: [PATCH 5.16 136/200] mptcp: allow changing the "backup" bit by
 endpoint id
In-Reply-To: <20220131105238.136417203@linuxfoundation.org>
Message-ID: <829f1665-31d7-af15-36f-c34ccfd31829@linux.intel.com>
References: <20220131105233.561926043@linuxfoundation.org> <20220131105238.136417203@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 31 Jan 2022, Greg Kroah-Hartman wrote:

> From: Davide Caratti <dcaratti@redhat.com>
>
> [ Upstream commit 602837e8479d20d49559b4b97b79d34c0efe7ecb ]
>

Please drop this from both the 5.15 and 5.16 queues. This patch adds a new 
feature (doesn't appear to meet the stable rules). It is fairly self 
contained and probably won't break anything, but it wasn't intended to be 
backported.


Thanks,
Mat


> a non-zero 'id' is sufficient to identify MPTCP endpoints: allow changing
> the value of 'backup' bit by simply specifying the endpoint id.
>
> Link: https://github.com/multipath-tcp/mptcp_net-next/issues/158
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>
> Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
> net/mptcp/pm_netlink.c | 14 ++++++++++----
> 1 file changed, 10 insertions(+), 4 deletions(-)
>
> diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
> index 65764c8171b37..d18b13e3e74c6 100644
> --- a/net/mptcp/pm_netlink.c
> +++ b/net/mptcp/pm_netlink.c
> @@ -1711,22 +1711,28 @@ next:
>
> static int mptcp_nl_cmd_set_flags(struct sk_buff *skb, struct genl_info *info)
> {
> +	struct mptcp_pm_addr_entry addr = { .addr = { .family = AF_UNSPEC }, }, *entry;
> 	struct nlattr *attr = info->attrs[MPTCP_PM_ATTR_ADDR];
> 	struct pm_nl_pernet *pernet = genl_info_pm_nl(info);
> -	struct mptcp_pm_addr_entry addr, *entry;
> 	struct net *net = sock_net(skb->sk);
> -	u8 bkup = 0;
> +	u8 bkup = 0, lookup_by_id = 0;
> 	int ret;
>
> -	ret = mptcp_pm_parse_addr(attr, info, true, &addr);
> +	ret = mptcp_pm_parse_addr(attr, info, false, &addr);
> 	if (ret < 0)
> 		return ret;
>
> 	if (addr.flags & MPTCP_PM_ADDR_FLAG_BACKUP)
> 		bkup = 1;
> +	if (addr.addr.family == AF_UNSPEC) {
> +		lookup_by_id = 1;
> +		if (!addr.addr.id)
> +			return -EOPNOTSUPP;
> +	}
>
> 	list_for_each_entry(entry, &pernet->local_addr_list, list) {
> -		if (addresses_equal(&entry->addr, &addr.addr, true)) {
> +		if ((!lookup_by_id && addresses_equal(&entry->addr, &addr.addr, true)) ||
> +		    (lookup_by_id && entry->addr.id == addr.addr.id)) {
> 			mptcp_nl_addr_backup(net, &entry->addr, bkup);
>
> 			if (bkup)
> -- 
> 2.34.1
>
>
>
>

--
Mat Martineau
Intel

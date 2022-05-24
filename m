Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56F265321C0
	for <lists+stable@lfdr.de>; Tue, 24 May 2022 05:52:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234058AbiEXDv7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 23:51:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234081AbiEXDv5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 23:51:57 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 008BA37AB6;
        Mon, 23 May 2022 20:51:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653364314; x=1684900314;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=9X7DrN1lEuucjb6wajZyNblT7a4IsVJl41aKORMvCwQ=;
  b=G5l6QtUYzBBhsDg1v7n9F1gnXgdgDYN1xQHP0M/7w78h94gaHGIlb+EX
   2oqi8zuKEeexspGQV2jrKf6m1i3N6bXgKj1o6z+YT00gDErcvX8Hy0kCp
   wL04sAujUBrv24r6+b3OCo5YzLpKcUI6g3qNs+rg1KubfXT3syjuw2eiA
   t0A9kTToc+r4tTQzAh9O2Vm+dZwZ/xGfuha4XdMTI+oYPUysHh9gfaX1m
   5UVCAQiSK8wsdoC3MxfA2mqDNoKwMQY7iiyYAj0kK6kinnsBV+atc6GRZ
   WGz0LHzo5ED38LX24UzIQX15wLy//Jmlgh3vbBvDNXYJYFYI9gxPhwTPX
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10356"; a="273147886"
X-IronPort-AV: E=Sophos;i="5.91,248,1647327600"; 
   d="scan'208";a="273147886"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2022 20:51:53 -0700
X-IronPort-AV: E=Sophos;i="5.91,248,1647327600"; 
   d="scan'208";a="577716050"
Received: from samuelal-mobl.amr.corp.intel.com ([10.212.199.128])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2022 20:51:52 -0700
Date:   Mon, 23 May 2022 20:51:52 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: Re: [PATCH 5.17 114/158] mptcp: strict local address ID selection
In-Reply-To: <20220523165849.851212488@linuxfoundation.org>
Message-ID: <fa953ec-288f-7715-c6fb-47a222e85270@linux.intel.com>
References: <20220523165830.581652127@linuxfoundation.org> <20220523165849.851212488@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 23 May 2022, Greg Kroah-Hartman wrote:

> From: Paolo Abeni <pabeni@redhat.com>
>
> [ Upstream commit 4cf86ae84c718333928fd2d43168a1e359a28329 ]
>
> The address ID selection for MPJ subflows created in response
> to incoming ADD_ADDR option is currently unreliable: it happens
> at MPJ socket creation time, when the local address could be
> unknown.
>
> Additionally, if the no local endpoint is available for the local
> address, a new dummy endpoint is created, confusing the user-land.
>
> This change refactor the code to move the address ID selection inside
> the rebuild_header() helper, when the local address eventually
> selected by the route lookup is finally known. If the address used
> is not mapped by any endpoint - and thus can't be advertised/removed
> pick the id 0 instead of allocate a new endpoint.
>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
> net/mptcp/pm_netlink.c | 13 --------
> net/mptcp/protocol.c   |  3 ++
> net/mptcp/protocol.h   |  3 +-
> net/mptcp/subflow.c    | 67 ++++++++++++++++++++++++++++++++++++------
> 4 files changed, 63 insertions(+), 23 deletions(-)
>

Greg, Sasha -

Is it possible to drop this one patch? It makes one of the mptcp 
selftests fail (mptcp_join.sh, "single address, backup").

Looks like this patch has been included in stable because of this single 
hunk that helps "mptcp: Do TCP fallback on early DSS checksum failure" 
apply cleanly:

> diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
> index aec767ee047a..e4413b3e50c2 100644
> --- a/net/mptcp/protocol.h
> +++ b/net/mptcp/protocol.h
> @@ -442,7 +442,8 @@ struct mptcp_subflow_context {
> 		rx_eof : 1,
> 		can_ack : 1,        /* only after processing the remote a key */
> 		disposable : 1,	    /* ctx can be free at ulp release time */
> -		stale : 1;	    /* unable to snd/rcv data, do not use for xmit */
> +		stale : 1,	    /* unable to snd/rcv data, do not use for xmit */
> +		local_id_valid : 1; /* local_id is correctly initialized */
> 	enum mptcp_data_avail data_avail;
> 	u32	remote_nonce;
> 	u64	thmac;

"mptcp: Do TCP fallback on early DSS checksum failure" also adds a bit to 
that bitfield, but there is no functional dependency between the patches.

If you need to drop the "mptcp: Do TCP fallback..." patch too, I can send 
a backported version tomorrow that accounts for that bitfield change.


Thanks!

--
Mat Martineau
Intel

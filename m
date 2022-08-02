Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8B69588337
	for <lists+stable@lfdr.de>; Tue,  2 Aug 2022 22:52:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230364AbiHBUwR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Aug 2022 16:52:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232295AbiHBUwQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Aug 2022 16:52:16 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B63242AD4;
        Tue,  2 Aug 2022 13:52:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659473536; x=1691009536;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=p0VOdjRh9r9HqXSZOFMrYLUcBpLYXCfms0fDdUozaZE=;
  b=NP1grALrf6hCPnZZ41/QaGaNbWlGBUFh57sZgDjXYv6jT27hLdHoQKoo
   eBJ5pq4IuKm9aB5TkgQX2+hfCU4+Hhha9wTF0O17/8PsAzS5tejHO0eE8
   0Fk/LaRf2JzVflh0bQlW+UTN7BeK2iJxJkn1RkTbFN4Ouq9oUTRBdXObX
   JJDV7VCToOVRFl8k+MGXphPJ7WpT3sgozfd4PF7cYXADznDNxd9hEw2Uh
   csyFim9u3h2O9um5zw3Kidpger/C4qMbPRCqbReudKwC/KNn1clPT+WTi
   JxxfknM1BDCkJ81Z5HSbNsiDdtVzb1wHYjlug6kAD/Hw+0gzUVEVPCLgp
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10427"; a="287077578"
X-IronPort-AV: E=Sophos;i="5.93,212,1654585200"; 
   d="scan'208";a="287077578"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2022 13:52:16 -0700
X-IronPort-AV: E=Sophos;i="5.93,212,1654585200"; 
   d="scan'208";a="778756653"
Received: from dnrajurk-mobl.amr.corp.intel.com ([10.209.121.166])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2022 13:52:15 -0700
Date:   Tue, 2 Aug 2022 13:52:15 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Geliang Tang <geliang.tang@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.18 72/88] mptcp: dont send RST for single subflow
In-Reply-To: <20220801114141.321741611@linuxfoundation.org>
Message-ID: <9ff367ab-bd52-3c3a-a62-2ade761b18f@linux.intel.com>
References: <20220801114138.041018499@linuxfoundation.org> <20220801114141.321741611@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 1 Aug 2022, Greg Kroah-Hartman wrote:

> From: Geliang Tang <geliang.tang@suse.com>
>
> [ Upstream commit 1761fed2567807f26fbd53032ff622f55978c7a9 ]
>
> When a bad checksum is detected and a single subflow is in use, don't
> send RST + MP_FAIL, send data_ack + MP_FAIL instead.
>
> So invoke tcp_send_active_reset() only when mptcp_has_another_subflow()
> is true.
>
> Signed-off-by: Geliang Tang <geliang.tang@suse.com>
> Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Hi Greg -

Please drop this patch from the 5.18-stable queue. It was the first of an 
8-patch series and doesn't really stand alone.

This commit message lacks the Fixes: tag and the magic commit message 
words that I've seen the scripts pick up, so I'm curious: was this patch 
selected by hand?


Thanks,

Mat


> ---
> net/mptcp/subflow.c | 10 +++++-----
> 1 file changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
> index 7919e259175d..ccae50eba664 100644
> --- a/net/mptcp/subflow.c
> +++ b/net/mptcp/subflow.c
> @@ -1221,14 +1221,14 @@ static bool subflow_check_data_avail(struct sock *ssk)
> 	/* RFC 8684 section 3.7. */
> 	if (subflow->send_mp_fail) {
> 		if (mptcp_has_another_subflow(ssk)) {
> +			ssk->sk_err = EBADMSG;
> +			tcp_set_state(ssk, TCP_CLOSE);
> +			subflow->reset_transient = 0;
> +			subflow->reset_reason = MPTCP_RST_EMIDDLEBOX;
> +			tcp_send_active_reset(ssk, GFP_ATOMIC);
> 			while ((skb = skb_peek(&ssk->sk_receive_queue)))
> 				sk_eat_skb(ssk, skb);
> 		}
> -		ssk->sk_err = EBADMSG;
> -		tcp_set_state(ssk, TCP_CLOSE);
> -		subflow->reset_transient = 0;
> -		subflow->reset_reason = MPTCP_RST_EMIDDLEBOX;
> -		tcp_send_active_reset(ssk, GFP_ATOMIC);
> 		WRITE_ONCE(subflow->data_avail, MPTCP_SUBFLOW_NODATA);
> 		return true;
> 	}
> -- 
> 2.35.1
>
>
>
>

--
Mat Martineau
Intel

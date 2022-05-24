Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 723DC5321CC
	for <lists+stable@lfdr.de>; Tue, 24 May 2022 05:56:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234011AbiEXD4e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 23:56:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233309AbiEXD4d (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 23:56:33 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D66AD12759;
        Mon, 23 May 2022 20:56:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653364589; x=1684900589;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=2GwRieErle2Ktjkp3bIWr28e79fAT0Lf3K9OF5ujohM=;
  b=NVnvoOxdc+XRNt/eSInxArVAGOAvHVTnpZimYRkDSPm5PHLFfvyUxuCm
   79hWMW5fRPcGf1bDiL5eOymigj6Zu5nL827hh2hvfZhZdjwsy2HhAe3fT
   ejqxuWB3tV7pwD5uUHPEuxuPvp8D86kcw6m6rfkNzIxK89Zc1SasSdayA
   C8N+5h8KBobyLKwaiSDQhmkU2oOUKCfPvEmAaldm6Ek8bz1bhRw9C5Znz
   yADceIxAz8fbBxbk4zv4sNK0jOezphOQWaZ7AgF/QBdvFOG+wjT0K6asV
   AJy88z6gfmwoqQBjqTP0aXUC8s59rsDshMQMEMH7+ZO0JTlifZmzNvenP
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10356"; a="336477891"
X-IronPort-AV: E=Sophos;i="5.91,248,1647327600"; 
   d="scan'208";a="336477891"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2022 20:56:29 -0700
X-IronPort-AV: E=Sophos;i="5.91,248,1647327600"; 
   d="scan'208";a="577717613"
Received: from samuelal-mobl.amr.corp.intel.com ([10.212.199.128])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2022 20:56:29 -0700
Date:   Mon, 23 May 2022 20:56:28 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: Re: [PATCH 5.15 098/132] mptcp: strict local address ID selection
In-Reply-To: <20220523165839.636049226@linuxfoundation.org>
Message-ID: <15cf37fd-22a7-37b-c211-abbde3aee8d@linux.intel.com>
References: <20220523165823.492309987@linuxfoundation.org> <20220523165839.636049226@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
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

Same issue with this patch as

[PATCH 5.17 114/158] mptcp: strict local address ID selection

so hopefully you can drop this one but keep "mptcp: Do TCP fallback on 
early DSS checksum failure".


Details on the 5.17.10-rc1 thread:

https://lore.kernel.org/stable/fa953ec-288f-7715-c6fb-47a222e85270@linux.intel.com/


Thanks,

--
Mat Martineau
Intel

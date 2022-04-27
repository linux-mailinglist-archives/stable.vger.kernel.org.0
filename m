Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2625511912
	for <lists+stable@lfdr.de>; Wed, 27 Apr 2022 16:54:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236730AbiD0N4k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Apr 2022 09:56:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236700AbiD0N4i (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Apr 2022 09:56:38 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B5872ACB;
        Wed, 27 Apr 2022 06:53:27 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 2D06321118;
        Wed, 27 Apr 2022 13:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1651067606; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z0VSn2vEXwWXMGAfap1HPPywpjqAc/nB4nW5xPcHwuA=;
        b=f/xNu/kDIRTMogOu0Uw02XT1TextwCqsKVU5GEime6fEx0GQmAShKNghzduSIpnAvkWvIl
        4XLpd3AXnkkx71Us1FiykJTL38kwzzkcISvSZKWwnE24AiQJotbu2LNxhs2RA6jAzmKmeI
        YWMQC29ImtGt9spIXjuzKoHdmIYLXW0=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id DF00713A39;
        Wed, 27 Apr 2022 13:53:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id ehVtNdVKaWJvZgAAMHmgww
        (envelope-from <mkoutny@suse.com>); Wed, 27 Apr 2022 13:53:25 +0000
Date:   Wed, 27 Apr 2022 15:53:24 +0200
From:   Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
To:     Waiman Long <longman@redhat.com>
Cc:     Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Feng Tang <feng.tang@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@kernel.org>,
        Dave Hansen <dave.hansen@intel.com>, ying.huang@intel.com,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] cgroup/cpuset: Remove cpus_allowed/mems_allowed setup
 in cpuset_init_smp()
Message-ID: <20220427135324.GB9823@blackbody.suse.cz>
References: <20220425155505.1292896-1-longman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220425155505.1292896-1-longman@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,TVD_SUBJ_WIPE_DEBT autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello.

On Mon, Apr 25, 2022 at 11:55:05AM -0400, Waiman Long <longman@redhat.com> wrote:
> smp_init() is called after the first two init functions.  So we don't
> have a complete list of active cpus and memory nodes until later in
> cpuset_init_smp() which is the right time to set up effective_cpus
> and effective_mems.

Yes.

	setup_arch
	  prefill_possible_map
	cpuset_init (1)
	cgroup_init
	  cpuset_bind (2a)
	...
	kernel_init
	  kernel_init_freeable
	    ...
	      cpuset_init_smp (3)
	...
	...
	cpuset_bind (2b)


> 
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 9390bfd9f1cd..6bd8f5ef40fe 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -3390,8 +3390,9 @@ static struct notifier_block cpuset_track_online_nodes_nb = {
>   */
>  void __init cpuset_init_smp(void)
>  {
> -	cpumask_copy(top_cpuset.cpus_allowed, cpu_active_mask);
> -	top_cpuset.mems_allowed = node_states[N_MEMORY];
> +	/*
> +	 * cpus_allowd/mems_allowed will be properly set up in cpuset_bind().
> +	 */

IIUC, the comment should say

> +	 * cpus_allowed/mems_allowed were (v2) or will be (v1) properly set up in cpuset_bind().

(nit)

Reviewed-by: Michal Koutný <mkoutny@suse.com>

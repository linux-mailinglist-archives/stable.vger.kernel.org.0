Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 870E9372F5D
	for <lists+stable@lfdr.de>; Tue,  4 May 2021 20:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232045AbhEDSIc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 May 2021 14:08:32 -0400
Received: from mga07.intel.com ([134.134.136.100]:41025 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230285AbhEDSIb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 May 2021 14:08:31 -0400
IronPort-SDR: BiIH4urrVSraUtXIsyspY5cgaxUtSyPJm6EpiWGNdvO/pq2lqOiaiYKOngQs76Mh1iAgP2fBaR
 5O/MDYJAupow==
X-IronPort-AV: E=McAfee;i="6200,9189,9974"; a="261993687"
X-IronPort-AV: E=Sophos;i="5.82,272,1613462400"; 
   d="scan'208";a="261993687"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2021 11:07:35 -0700
IronPort-SDR: H4xP5zq1wc0ooroGB2dP6HLOJTRL0VRaba5LoIV7loEKUV1hRVL3/f7ctBfkW8P2P+39RhIl0i
 6ayyVD7et48A==
X-IronPort-AV: E=Sophos;i="5.82,272,1613462400"; 
   d="scan'208";a="433399915"
Received: from agluck-desk2.sc.intel.com (HELO agluck-desk2.amr.corp.intel.com) ([10.3.52.146])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2021 11:07:35 -0700
Date:   Tue, 4 May 2021 11:07:34 -0700
From:   "Luck, Tony" <tony.luck@intel.com>
To:     Yazen Ghannam <Yazen.Ghannam@amd.com>
Cc:     linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, Smita.KoralahalliChannabasappa@amd.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 2/2] x86/MCE: Don't call kill_me_now() directly
Message-ID: <20210504180734.GA721714@agluck-desk2.amr.corp.intel.com>
References: <20210504174712.27675-1-Yazen.Ghannam@amd.com>
 <20210504174712.27675-3-Yazen.Ghannam@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210504174712.27675-3-Yazen.Ghannam@amd.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 04, 2021 at 05:47:12PM +0000, Yazen Ghannam wrote:
> From: Yazen Ghannam <yazen.ghannam@amd.com>
> 
> Always call kill_me_maybe() in order to attempt memory recovery. This
> ensures that any memory associated with the error is properly marked as
> poison.
> 
> This is needed for errors that occur on memory, but that do not have
> MCG_STATUS[RIPV] set. One example is data poison consumption through the
> instruction fetch units on AMD Zen-based systems.
> 
> The MF_MUST_KILL flag is passed to memory_failure() when
> MCG_STATUS[RIPV] is not set. So the associated process will still be
> killed.
> 
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Yazen Ghannam <yazen.ghannam@amd.com>
> ---
>  arch/x86/kernel/cpu/mce/core.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/mce/core.c b/arch/x86/kernel/cpu/mce/core.c
> index 308fb644b94a..9040d45ed997 100644
> --- a/arch/x86/kernel/cpu/mce/core.c
> +++ b/arch/x86/kernel/cpu/mce/core.c
> @@ -1285,10 +1285,7 @@ static void queue_task_work(struct mce *m, int kill_current_task)
>  	current->mce_ripv = !!(m->mcgstatus & MCG_STATUS_RIPV);
>  	current->mce_whole_page = whole_page(m);
>  
> -	if (kill_current_task)
> -		current->mce_kill_me.func = kill_me_now;
> -	else
> -		current->mce_kill_me.func = kill_me_maybe;
> +	current->mce_kill_me.func = kill_me_maybe;
>  
>  	task_work_add(current, &current->mce_kill_me, TWA_RESUME);
>  }

Could we just get rid of kill_me_now() at the same time? It's only
one line, and with this change only called in one place (from
kill_me_maybe()) ... just put the force_sig(SIGBUS); inline?

-Tony

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3146432B00F
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:41:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236279AbhCCAa6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:30:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:59400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350907AbhCBM7K (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 07:59:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 252BE64EDC;
        Tue,  2 Mar 2021 12:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614689830;
        bh=chU/pFshGfuplktWhF67GgUPM3U1LH6JdnwCilJwrbE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eH15Q4MRsXLeAbnJlno7lMhp9W77h+JGBhyHx3LTcbE+9W55hXWVhOHdsj+44nWFP
         Tn4oX7sl/7I66EleNj2+RuRAiiNsZ7AOvkP9npc28QNn2qv/ahe/Mh/wtxrFO2ruu0
         8ODihLBKqq0DKzbTMTq9BXnNjVXlfobxyyV5eq71FKuPetJTbiL77oeZXVpcMb5a7s
         FAup3Sgkitz6ULM9zsY2OByXJOO97jXpNETRX995eo5wl+TT25qL762f06FEzyKu6A
         SpbK5XDTpa8KjywUPzJtwcRNnDkVT5i4FmU2YTG1o9//7E8evc6KylEyiYb9/z3Baq
         PRxDVU+iEhFqg==
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id C67C040CD9; Tue,  2 Mar 2021 09:57:06 -0300 (-03)
Date:   Tue, 2 Mar 2021 09:57:06 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Antonio Terceiro <antonio.terceiro@linaro.org>
Cc:     linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        He Zhe <zhe.he@windriver.com>, stable@vger.kernel.org
Subject: Re: [PATCH] perf: fix ccache usage in $(CC) when generating arch
 errno table
Message-ID: <YD42IobxI3rym7N0@kernel.org>
References: <20210224130046.346977-1-antonio.terceiro@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210224130046.346977-1-antonio.terceiro@linaro.org>
X-Url:  http://acmel.wordpress.com
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Em Wed, Feb 24, 2021 at 10:00:46AM -0300, Antonio Terceiro escreveu:
> This was introduced by commit e4ffd066ff440a57097e9140fa9e16ceef905de8.
> 
> Assuming the first word of $(CC) is the actual compiler breaks usage
> like CC="ccache gcc": the script ends up calling ccache directly with
> gcc arguments, what fails. Instead of getting the first word, just
> remove from $(CC) any word that starts with a "-". This maintains the
> spirit of the original patch, while not breaking ccache users.

Thanks, tested, added:

Fixes: e4ffd066ff440a57 ("perf: Normalize gcc parameter when generating arch errno table")

And applied to perf/urgent.

- Arnaldo
 
> Signed-off-by: Antonio Terceiro <antonio.terceiro@linaro.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: He Zhe <zhe.he@windriver.com>
> CC: stable@vger.kernel.org
> ---
>  tools/perf/Makefile.perf | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
> index 5345ac70cd83..9bfc725db608 100644
> --- a/tools/perf/Makefile.perf
> +++ b/tools/perf/Makefile.perf
> @@ -607,7 +607,7 @@ arch_errno_hdr_dir := $(srctree)/tools
>  arch_errno_tbl := $(srctree)/tools/perf/trace/beauty/arch_errno_names.sh
>  
>  $(arch_errno_name_array): $(arch_errno_tbl)
> -	$(Q)$(SHELL) '$(arch_errno_tbl)' $(firstword $(CC)) $(arch_errno_hdr_dir) > $@
> +	$(Q)$(SHELL) '$(arch_errno_tbl)' '$(patsubst -%,,$(CC))' $(arch_errno_hdr_dir) > $@
>  
>  sync_file_range_arrays := $(beauty_outdir)/sync_file_range_arrays.c
>  sync_file_range_tbls := $(srctree)/tools/perf/trace/beauty/sync_file_range.sh
> -- 
> 2.30.1
> 

-- 

- Arnaldo

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E52DD6A0A87
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 14:32:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232906AbjBWNcE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 08:32:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232110AbjBWNcE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 08:32:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 793F9E8;
        Thu, 23 Feb 2023 05:32:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1E1E1B81A28;
        Thu, 23 Feb 2023 13:32:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3887C433D2;
        Thu, 23 Feb 2023 13:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677159120;
        bh=WizGadssOMJsBlPM+nkNoUJbC2hiZnrvUVo8oGskOAw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DiFfSzn7jfhXHrpH+EDxQTf6Q3WWh22aa02HTQUxt2IEhS9nG85jMWGchzaULfXNw
         YktfV4D8mSft0mm+3y/azR5g014dJjGO0CZq+hqHof8DkP4PdEejhXoiIo7zFkHsjn
         ESNuSAmVlJDJ1n6F3s/uWXVId/BWotq240RjoRCfJyFsvtzdv8vyozvXbKhYyWS1FT
         usQQlP72gslabLLiAigNUZ60yyruQxvQK2kkhJqI33h93Uqy5Nkq1Jya//D9a9Ro+g
         PrYxthhXOXNibM61mSWLFEGqB69S0IYxLTiX9Fgj7yT5Ne5626YVUkY2v9vw1iXr4V
         y5YDgJekfrRRQ==
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id C75114049F; Thu, 23 Feb 2023 10:31:57 -0300 (-03)
Date:   Thu, 23 Feb 2023 10:31:57 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Namhyung Kim <namhyung@kernel.org>
Cc:     Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-perf-users@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] perf inject: Fix --buildid-all not to eat up MMAP2
Message-ID: <Y/dqzbHTVWlWRZoJ@kernel.org>
References: <20230223070155.54251-1-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230223070155.54251-1-namhyung@kernel.org>
X-Url:  http://acmel.wordpress.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Em Wed, Feb 22, 2023 at 11:01:55PM -0800, Namhyung Kim escreveu:
> When MMAP2 has PERF_RECORD_MISC_MMAP_BUILD_ID flag, it means the record
> already has the build-id info.  So it marks the DSO as hit, to skip if
> the same DSO is not processed if it happens to miss the build-id later.
> 
> But it missed to copy the MMAP2 record itself so it'd fail to symbolize
> samples for those regions.

Thanks, applied.

- Arnaldo

 
> For example, the following generates 249 MMAP2 events.
> 
>   $ perf record --buildid-mmap -o- true | perf report --stat -i- | grep MMAP2
>            MMAP2 events:        249  (86.8%)
> 
> Adding perf inject should not change the number of events like this
> 
>   $ perf record --buildid-mmap -o- true | perf inject -b | \
>   > perf report --stat -i- | grep MMAP2
>            MMAP2 events:        249  (86.5%)
> 
> But when --buildid-all is used, it eats most of the MMAP2 events.
> 
>   $ perf record --buildid-mmap -o- true | perf inject -b --buildid-all | \
>   > perf report --stat -i- | grep MMAP2
>            MMAP2 events:          1  ( 2.5%)
> 
> With this patch, it shows the original number now.
> 
>   $ perf record --buildid-mmap -o- true | perf inject -b --buildid-all | \
>   > perf report --stat -i- | grep MMAP2
>            MMAP2 events:        249  (86.5%)
> 
> Cc: stable@vger.kernel.org
> Fixes: f7fc0d1c915a ("perf inject: Do not inject BUILD_ID record if MMAP2 has it")
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/builtin-inject.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
> index f8182417b734..10bb1d494258 100644
> --- a/tools/perf/builtin-inject.c
> +++ b/tools/perf/builtin-inject.c
> @@ -538,6 +538,7 @@ static int perf_event__repipe_buildid_mmap2(struct perf_tool *tool,
>  			dso->hit = 1;
>  		}
>  		dso__put(dso);
> +		perf_event__repipe(tool, event, sample, machine);
>  		return 0;
>  	}
>  
> -- 
> 2.39.2.637.g21b0678d19-goog
> 

-- 

- Arnaldo

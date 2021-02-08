Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8982A313F08
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 20:33:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236255AbhBHTbx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 14:31:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:40344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236327AbhBHT3q (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 14:29:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5511E64E8F;
        Mon,  8 Feb 2021 19:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612812544;
        bh=Cvo5fk94tAJuS0PSMjlJnRizZOjsCEwXtSadq5Inv48=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aUW6F0qpJgWDvCfAbGdDG72EDh45tJqA4GHIAMUm4I6MVAg3gRtMzHynpPcXHHHTP
         sG9MMkz4Ilt4FL/qZScOdi4hDvpihUjfWv3ZayW4JpDJ3IY7Vsx5Ox1Q3Tl/jUsU9c
         /qkUG7Ua49SHofwPrJvwK+UVRGmZLUiVwOwK/ZkSV1G4U8Uuw33EXo14405TXvWdya
         iSJjAuVggf0pQ+1ttS72bXHFDEr1b0xshVig3dEtRzyV6lYY7er5eTgFHJ7dKbsemD
         /Hd8DS8owl/bMw0Yck4NGLGOB0mquyo1H344tnuVu3ahAXD4ig6sv/KjZy+UU4RgMZ
         4Nzv/RIXFewng==
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 284CF40513; Mon,  8 Feb 2021 16:29:02 -0300 (-03)
Date:   Mon, 8 Feb 2021 16:29:02 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Paul Cercueil <paul@crapouillou.net>
Cc:     Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Namhyung Kim <namhyung@kernel.org>, od@zcrc.me,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] perf stat: Use nftw() instead of ftw()
Message-ID: <20210208192902.GR920417@kernel.org>
References: <20210208181157.1324550-1-paul@crapouillou.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210208181157.1324550-1-paul@crapouillou.net>
X-Url:  http://acmel.wordpress.com
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Em Mon, Feb 08, 2021 at 06:11:57PM +0000, Paul Cercueil escreveu:
> ftw() has been obsolete for about 12 years now.
> 
> Fixes: bb1c15b60b98 ("perf stat: Support regex pattern in --for-each-cgroup")
> CC: stable@vger.kernel.org
> Signed-off-by: Paul Cercueil <paul@crapouillou.net>
> ---
> 
> Notes:
>     NOTE: Not runtime-tested, I have no idea what I need to do in perf
>     to test this. But at least it compiles now with my uClibc-based
>     toolchain.

Seems safe from reading the nftw() man page, the only typeflag that this
code is using is FTW_D and that is present in both ftw() and nftw().

Applying,

- Arnaldo
 
>  tools/perf/util/cgroup.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/perf/util/cgroup.c b/tools/perf/util/cgroup.c
> index 5dff7e489921..f24ab4585553 100644
> --- a/tools/perf/util/cgroup.c
> +++ b/tools/perf/util/cgroup.c
> @@ -161,7 +161,7 @@ void evlist__set_default_cgroup(struct evlist *evlist, struct cgroup *cgroup)
>  
>  /* helper function for ftw() in match_cgroups and list_cgroups */
>  static int add_cgroup_name(const char *fpath, const struct stat *sb __maybe_unused,
> -			   int typeflag)
> +			   int typeflag, struct FTW *ftwbuf __maybe_unused)
>  {
>  	struct cgroup_name *cn;
>  
> @@ -209,12 +209,12 @@ static int list_cgroups(const char *str)
>  			if (!s)
>  				return -1;
>  			/* pretend if it's added by ftw() */
> -			ret = add_cgroup_name(s, NULL, FTW_D);
> +			ret = add_cgroup_name(s, NULL, FTW_D, NULL);
>  			free(s);
>  			if (ret)
>  				return -1;
>  		} else {
> -			if (add_cgroup_name("", NULL, FTW_D) < 0)
> +			if (add_cgroup_name("", NULL, FTW_D, NULL) < 0)
>  				return -1;
>  		}
>  
> @@ -247,7 +247,7 @@ static int match_cgroups(const char *str)
>  	prefix_len = strlen(mnt);
>  
>  	/* collect all cgroups in the cgroup_list */
> -	if (ftw(mnt, add_cgroup_name, 20) < 0)
> +	if (nftw(mnt, add_cgroup_name, 20, 0) < 0)
>  		return -1;
>  
>  	for (;;) {
> -- 
> 2.30.0
> 

-- 

- Arnal

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE97143C9DA
	for <lists+stable@lfdr.de>; Wed, 27 Oct 2021 14:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241934AbhJ0MmD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Oct 2021 08:42:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:45110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240237AbhJ0MmD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Oct 2021 08:42:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B304561052;
        Wed, 27 Oct 2021 12:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635338377;
        bh=Qt0jh0o6SaMbTSaV3+4wFbGetToVeiL/RlWAnp9etIg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AJZrIcNwgjxHUDKKBMTGoCxrAGa3dyGExtHtO3Q9e2nDWQLYRjkGNV6soboXK+v+6
         ma4Fk5R26Ru//1369lWqDfIM17TM4TEiVDdHjH/D1Y8qKjeWFKqZfgk65fltFnHtLV
         fa82x5nPLfT3HbH/UNHDxuI1Jv3+FJCm1nHr5gIUXXfahlNvmBEkYNFba+EKtv2ZSV
         wmYca/5MO36KHkSmxuA/YjaPtcaShp1L0SuH7Xjt15LSgMGDlBolpqbZr0LheyVYyy
         Xv6Nysf749noyHS1/b33kJINAZyEIKHiZLHadlE2P9DevFqCi2DISkSdJonFR2coob
         SV/MwdyyEsegQ==
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id D6FD5410A1; Wed, 27 Oct 2021 09:39:34 -0300 (-03)
Date:   Wed, 27 Oct 2021 09:39:34 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Song Liu <songliubraving@fb.com>
Cc:     linux-kernel@vger.kernel.org, kernel-team@fb.com,
        peterz@infradead.org, mingo@redhat.com, stable@vger.kernel.org
Subject: Re: [PATCH] perf-script: check session->header.env.arch before using
 it
Message-ID: <YXlIhneZVyihywLt@kernel.org>
References: <20211004053238.514936-1-songliubraving@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211004053238.514936-1-songliubraving@fb.com>
X-Url:  http://acmel.wordpress.com
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Em Sun, Oct 03, 2021 at 10:32:38PM -0700, Song Liu escreveu:
> When perf.data is not written cleanly, we would like to process existing
> data as much as possible (please see f_header.data.size == 0 condition
> in perf_session__read_header). However, perf.data with partial data may
> crash perf. Specifically, we see crash in perf-script for NULL
> session->header.env.arch.
> 
> Fix this by checking session->header.env.arch before using it to determine
> native_arch. Also split the if condition so it is easier to read.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>  tools/perf/builtin-script.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
> index 6211d0b84b7a6..7821f6740ac1d 100644
> --- a/tools/perf/builtin-script.c
> +++ b/tools/perf/builtin-script.c
> @@ -4039,12 +4039,17 @@ int cmd_script(int argc, const char **argv)
>  		goto out_delete;
>  
>  	uname(&uts);
> -	if (data.is_pipe ||  /* assume pipe_mode indicates native_arch */
> -	    !strcmp(uts.machine, session->header.env.arch) ||
> -	    (!strcmp(uts.machine, "x86_64") &&
> -	     !strcmp(session->header.env.arch, "i386")))
> +	if (data.is_pipe)  /* assume pipe_mode indicates native_arch */
>  		native_arch = true;
>  
> +	if (session->header.env.arch) {

Shouldn't the above be:

	else if (session->header.env.arch) {

?

> +		if (!strcmp(uts.machine, session->header.env.arch))
> +			native_arch = true;
> +		else if (!strcmp(uts.machine, "x86_64") &&
> +			 !strcmp(session->header.env.arch, "i386"))
> +			native_arch = true;
> +	}
> +
>  	script.session = session;
>  	script__setup_sample_type(&script);
>  
> -- 
> 2.30.2

-- 

- Arnaldo

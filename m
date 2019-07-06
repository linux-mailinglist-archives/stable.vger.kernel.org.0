Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E114361253
	for <lists+stable@lfdr.de>; Sat,  6 Jul 2019 19:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726800AbfGFRU3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Jul 2019 13:20:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38250 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726698AbfGFRU3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 6 Jul 2019 13:20:29 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4F539356F6;
        Sat,  6 Jul 2019 17:20:29 +0000 (UTC)
Received: from sandy.ghostprotocols.net (ovpn-112-18.phx2.redhat.com [10.3.112.18])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8D76C3844;
        Sat,  6 Jul 2019 17:20:28 +0000 (UTC)
Received: by sandy.ghostprotocols.net (Postfix, from userid 1000)
        id 3AD10115; Sat,  6 Jul 2019 14:17:36 -0300 (BRT)
Date:   Sat, 6 Jul 2019 14:17:36 -0300
From:   Arnaldo Carvalho de Melo <acme@redhat.com>
To:     Song Liu <songliubraving@fb.com>
Cc:     linux-kernel@vger.kernel.org, kernel-team@fb.com, davidca@fb.com,
        jolsa@kernel.org, namhyung@kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] perf: assign proper ff->ph in
 perf_event__synthesize_features()
Message-ID: <20190706171736.GD2093@redhat.com>
References: <20190620010453.4118689-1-songliubraving@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190620010453.4118689-1-songliubraving@fb.com>
X-Url:  http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Sat, 06 Jul 2019 17:20:29 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Em Wed, Jun 19, 2019 at 06:04:53PM -0700, Song Liu escreveu:
> bpf/btf  write_* functions need ff->ph->env.
> 
> With this missing, pipe-mode (perf record -o -)  would crash like:
> 
> Program terminated with signal SIGSEGV, Segmentation fault.
> 
> This patch assign proper ph value to ff.

Thanks, applied.

- Arnaldo
 
> Cc: stable@vger.kernel.org #v5.1+
> Fixes: 606f972b1361 ("perf bpf: Save bpf_prog_info information as headers to perf.data")
> Reported-by: David Carrillo Cisneros <davidca@fb.com>
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>  tools/perf/util/header.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
> index 06ddb6618ef3..5f1aa0284e1b 100644
> --- a/tools/perf/util/header.c
> +++ b/tools/perf/util/header.c
> @@ -3684,6 +3684,7 @@ int perf_event__synthesize_features(struct perf_tool *tool,
>  		return -ENOMEM;
>  
>  	ff.size = sz - sz_hdr;
> +	ff.ph = &session->header;
>  
>  	for_each_set_bit(feat, header->adds_features, HEADER_FEAT_BITS) {
>  		if (!feat_ops[feat].synthesize) {
> -- 
> 2.17.1

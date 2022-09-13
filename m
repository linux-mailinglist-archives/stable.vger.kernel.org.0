Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44B335B6C60
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 13:29:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230520AbiIML3Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 07:29:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230323AbiIML3X (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 07:29:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B2995B07C
        for <stable@vger.kernel.org>; Tue, 13 Sep 2022 04:29:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5A709B80E8B
        for <stable@vger.kernel.org>; Tue, 13 Sep 2022 11:29:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91349C433C1;
        Tue, 13 Sep 2022 11:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663068560;
        bh=w26lvGYEZ6/vKRsIb/jKHrPJwN2bxbOl0/f67fhSrSY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LhkCsKMeuzbTYPunYShq7oH3ZBqwSoOLGi7f6ECKNVaBbEby2t5ZdlKwakDHuIvXk
         vr/JD2xQeQ5m2TUgfFqW7/QTOicp3Mg/xoGBYg5IuzNMtAO+9KIlkqGaj08hNdFnDL
         n6hXWzh3lIj8tw9dvKvjRSs0KpCJXQ4ZcJsvip4g=
Date:   Tue, 13 Sep 2022 13:29:43 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jisheng Zhang <jszhang@kernel.org>
Cc:     stable@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ian Rogers <irogers@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH linux-5.15.y v3] perf machine: Use path__join() to
 compose a path instead of snprintf(dir, '/', filename)
Message-ID: <YyBppy/uUWNMpquv@kroah.com>
References: <20220913075430.2164-1-jszhang@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220913075430.2164-1-jszhang@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 13, 2022 at 03:54:30PM +0800, Jisheng Zhang wrote:
> From: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> commit 9d5f0c36438eeae7566ca383b2b673179e3cc613 upstream.
> 
> Its more intention revealing, and if we're interested in the odd cases
> where this may end up truncating we can do debug checks at one
> centralized place.
> 
> Motivation, of all the container builds, fedora rawhide started
> complaining of:
> 
>   util/machine.c: In function ‘machine__create_modules’:
>   util/machine.c:1419:50: error: ‘%s’ directive output may be truncated writing up to 255 bytes into a region of size between 0 and 4095 [-Werror=format-truncation=]
>    1419 |                 snprintf(path, sizeof(path), "%s/%s", dir_name, dent->d_name);
>         |                                                  ^~
>   In file included from /usr/include/stdio.h:894,
>                    from util/branch.h:9,
>                    from util/callchain.h:8,
>                    from util/machine.c:7:
>   In function ‘snprintf’,
>       inlined from ‘maps__set_modules_path_dir’ at util/machine.c:1419:3,
>       inlined from ‘machine__set_modules_path’ at util/machine.c:1473:9,
>       inlined from ‘machine__create_modules’ at util/machine.c:1519:7:
>   /usr/include/bits/stdio2.h:71:10: note: ‘__builtin___snprintf_chk’ output between 2 and 4352 bytes into a destination of size 4096
> 
> There are other places where we should use path__join(), but lets get rid of
> this one first.
> 
> Cc: Adrian Hunter <adrian.hunter@intel.com>
> Cc: Ian Rogers <irogers@google.com>
> Cc: Jiri Olsa <jolsa@kernel.org>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Acked-by: Ian Rogers <irogers@google.com>
> Link: Link: https://lore.kernel.org/r/YebZKjwgfdOz0lAs@kernel.org
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
> ---
> 
> Since v2:
>  - add necessary tag as pointed out by Greg.

Now queued up, thanks.

greg k-h

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6096C5B64E0
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 03:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229503AbiIMBCZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Sep 2022 21:02:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiIMBCY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Sep 2022 21:02:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65F1B3ECEF
        for <stable@vger.kernel.org>; Mon, 12 Sep 2022 18:02:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C79B9B80E03
        for <stable@vger.kernel.org>; Tue, 13 Sep 2022 01:02:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D273AC433D6;
        Tue, 13 Sep 2022 01:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663030940;
        bh=e4+c9nJ7mDTp+igpduXity/LV1lfU5gZHpQmJkAD44Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Fx527abNEwALmQi2O1QAJ3eJxpIwwz5L6idGY6AO5FyZ1f9+7fXXFlmoqqZamlHl4
         FmcHU+NuX7efW3LExcqWYgYb1Z1oLvGySidE9TNyXouHwBZWvR7gcBb1GPk5kUgZy6
         lXGdW49ZsvR0z/LlTMzKK3omwF4uCO1cldmXkuV+sRtcilw7xY6nJGOCijD/V41J1U
         R9bgXQEZZwaPx57olAeKqAZdd5BwhV4VWetkBdrhehCo9Y3GB28YAAnsDPbcY1W1Rc
         mTIksMcBsNBtYqw4a7pOaPaGkXDknagdXHlqiXqMWgtkQofPtxN+4nUY/DjeeLg3Ki
         +kIIwCjLvd9Lg==
Date:   Tue, 13 Sep 2022 08:52:59 +0800
From:   Jisheng Zhang <jszhang@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ian Rogers <irogers@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH linux-5.15.y v2] perf machine: Use path__join() to
 compose a path instead of snprintf(dir, '/', filename)
Message-ID: <Yx/Ua0GmUmKZMf5B@xhacker>
References: <20220912081522.4067-1-jszhang@kernel.org>
 <Yx9E1jONX0n20azE@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Yx9E1jONX0n20azE@kroah.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 12, 2022 at 04:40:22PM +0200, Greg Kroah-Hartman wrote:
> On Mon, Sep 12, 2022 at 04:15:22PM +0800, Jisheng Zhang wrote:
> > From: Arnaldo Carvalho de Melo <acme@redhat.com>
> > 
> > commit 9d5f0c36438eeae7566ca383b2b673179e3cc613 upstream.
> > 
> > Its more intention revealing, and if we're interested in the odd cases
> > where this may end up truncating we can do debug checks at one
> > centralized place.
> > 
> > Motivation, of all the container builds, fedora rawhide started
> > complaining of:
> > 
> >   util/machine.c: In function ‘machine__create_modules’:
> >   util/machine.c:1419:50: error: ‘%s’ directive output may be truncated writing up to 255 bytes into a region of size between 0 and 4095 [-Werror=format-truncation=]
> >    1419 |                 snprintf(path, sizeof(path), "%s/%s", dir_name, dent->d_name);
> >         |                                                  ^~
> >   In file included from /usr/include/stdio.h:894,
> >                    from util/branch.h:9,
> >                    from util/callchain.h:8,
> >                    from util/machine.c:7:
> >   In function ‘snprintf’,
> >       inlined from ‘maps__set_modules_path_dir’ at util/machine.c:1419:3,
> >       inlined from ‘machine__set_modules_path’ at util/machine.c:1473:9,
> >       inlined from ‘machine__create_modules’ at util/machine.c:1519:7:
> >   /usr/include/bits/stdio2.h:71:10: note: ‘__builtin___snprintf_chk’ output between 2 and 4352 bytes into a destination of size 4096
> > 
> > There are other places where we should use path__join(), but lets get rid of
> > this one first.
> > 
> > Cc: Adrian Hunter <adrian.hunter@intel.com>
> > Cc: Ian Rogers <irogers@google.com>
> > Cc: Jiri Olsa <jolsa@kernel.org>
> > Cc: Namhyung Kim <namhyung@kernel.org>
> > Acked-by: Ian Rogers <irogers@google.com>
> > Link: Link: https://lore.kernel.org/r/YebZKjwgfdOz0lAs@kernel.org
> > Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> As you are forwarding on this commit, you too need to sign-off on it.

Thanks for the information.

> 
> > ---
> > 
> > Since v1:
> >  - add commit id in upstream.
> >  - add linux-5.15.y, maybe we also need this for other long term stable
> >    tree.
> 
> Why is this needed in 5.15?

Building linux-5.15.y perf with gcc-12 will emit the same error as the
commit msg says.

Thanks

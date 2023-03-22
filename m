Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C075F6C54CF
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 20:22:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231157AbjCVTWT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 15:22:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231144AbjCVTWR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 15:22:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFEB9637E2
        for <stable@vger.kernel.org>; Wed, 22 Mar 2023 12:22:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5E110B81DDC
        for <stable@vger.kernel.org>; Wed, 22 Mar 2023 19:22:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFD0AC433EF;
        Wed, 22 Mar 2023 19:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679512934;
        bh=m5COP6l2uCdDdlYcJNVrwXWZeAyO3EijjM+yQnXJ+Tk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SwhfmE373NqsyZQXdzKMlxhGpCw1dbi7shlji4Jw4/SgZUN1LNmeDLm0CJJyBrFjR
         4vYT0uuMOKu6CNBDaAPouk+SVg6hLu8RotZBBqThp013r8LV+Mee1xJweOSorHr7OT
         NiW46wZL1/macA46n52rWlKVo33BAC6ZNqTF6Ygs=
Date:   Wed, 22 Mar 2023 20:22:04 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Maciej =?utf-8?Q?=C5=BBenczykowski?= <maze@google.com>
Cc:     Greg Kroah-Hartman <gregkh@google.com>,
        Sasha Levin <sashalevin@google.com>,
        Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        Stanislav Fomichev <sdf@google.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: 5.10 LTS - Request for inclusion of getsockopt(SO_NETNS_COOKIE)
Message-ID: <ZBtVXJVi/zKb8eAk@kroah.com>
References: <CANP3RGeiFUsO4X_qQszO5JRY7UDSQVxuC+57aCscL0p+dmjyKA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANP3RGeiFUsO4X_qQszO5JRY7UDSQVxuC+57aCscL0p+dmjyKA@mail.gmail.com>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 22, 2023 at 12:17:55PM -0700, Maciej Żenczykowski wrote:
> Could we please get:
>   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=e8b9eab99232c4e62ada9d7976c80fd5e8118289
>   'net: retrieve netns cookie via getsocketopt'
> 
> included in 5.10 LTS.
> 
> This is technically a feature, but it's absolutely trivial - it just
> adds a new getsockopt to fetch a u64.
> Using netns cookies from bpf without it is pretty annoying.

This really is a new feature, why not just move to a new kernel version
instead if you really need this?

> It doesn't cherrypick to 5.10 cleanly, due to trivial conflicts in
> header files (previous constants haven't yet been defined),
> and because of a post 5.10 change from atomic64_t to u64 - which
> requires adding in an atomic_read(&).
> 
> I've uploaded a compiling version to:
>   https://android-review.googlesource.com/c/kernel/common/+/2503056
> I think you should be able to cherrypick it via:
>   git fetch https://android.googlesource.com/kernel/common
> refs/changes/56/2503056/2 && git cherry-pick FETCH_HEAD

Please always submit a working backport here, we can't use random git
commands for this type of thing, sorry.  That way we can all properly
review it and verify that you sent what you want us to apply.

thanks,

greg k-h

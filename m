Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88C0F6B9ED9
	for <lists+stable@lfdr.de>; Tue, 14 Mar 2023 19:43:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbjCNSnr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Mar 2023 14:43:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230304AbjCNSno (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Mar 2023 14:43:44 -0400
Received: from ms.lwn.net (ms.lwn.net [IPv6:2600:3c01:e000:3a1::42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E0B92069C;
        Tue, 14 Mar 2023 11:43:23 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:281:8300:73::5f6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id AAAA144A;
        Tue, 14 Mar 2023 18:43:22 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net AAAA144A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
        t=1678819402; bh=vXcFQCSWg3zg+N5SvxjUYr1KPTEUQJWM2L2mMNEWz3U=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=FbCkW3/SaNc0c5JVowyjmJlGDiszCAEfx/pGMPIFckqWAEMQ+ZdUaQI0aIm4JuFuM
         SXyitb1L5kpwfn7Hx5n13ZnfoUmOpMV1oUz1+6B0NKkGPv9LLkIeC8sEOulAp3yDye
         QstqF4HH8hTgRoWYaDA92j/cRXGyiltMDjdfNy7Rm5l6NqHk4dxVGkZFROZ5IGVFJ7
         GsFkCoMA72mXqcCQ+fugn/1XKrTyfjcY2VZnhwhSP4QPtw8i6GWLQHezDn7Rxyukm6
         l8HsI1rDuRXwh//2IEyvyfJ/h+i9a559xNi4P8B6u5OpyEyMpXSJcLJJBJsDwhSyTr
         ELu6QvZaKeUng==
From:   Jonathan Corbet <corbet@lwn.net>
To:     Vegard Nossum <vegard.nossum@oracle.com>
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, backports@vger.kernel.org,
        Vegard Nossum <vegard.nossum@oracle.com>,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH] docs: add backporting and conflict resolution document
In-Reply-To: <20230303162553.17212-1-vegard.nossum@oracle.com>
References: <20230303162553.17212-1-vegard.nossum@oracle.com>
Date:   Tue, 14 Mar 2023 12:43:21 -0600
Message-ID: <875yb3rx6e.fsf@meer.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Vegard Nossum <vegard.nossum@oracle.com> writes:

> This is a new document based on my 2022 blog post:
>
>   https://blogs.oracle.com/linux/post/backporting-patches-using-git
>
> Although this is aimed at stable contributors and distro maintainers, it
> does also contain useful tips and tricks for anybody who needs to
> resolve merge conflicts.
>
> By adding this to the kernel as documentation we can more easily point
> to it e.g. from stable emails about failed backports, as well as allow
> the community to modify it over time if necessary.
>
> I've added this under process/ since it also has
> process/applying-patches.rst. Another interesting document is
> maintainer/rebasing-and-merging.rst which maybe should eventually refer
> to this one, but I'm leaving that as a future cleanup.
>
> Thanks to Harshit for helping with the original blog post as well as
> this updated document.
>
> Cc: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> Cc: Jason A. Donenfeld <Jason@zx2c4.com>
> Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
> ---
>  Documentation/process/backporting.rst | 488 ++++++++++++++++++++++++++
>  Documentation/process/index.rst       |   1 +
>  2 files changed, 489 insertions(+)
>  create mode 100644 Documentation/process/backporting.rst

So I'm not seeing a lot of discussion here; I guess it's almost perfect
:)  I would request, though, that you send me a version that conforms to
our conventions for heading markup, as described in

  Documentation/doc-guide/sphinx.rst
  https://www.kernel.org/doc/html/latest/doc-guide/sphinx.html#specific-guidelines-for-the-kernel-documentation

Thanks,

jon

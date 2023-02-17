Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98C7169AD4D
	for <lists+stable@lfdr.de>; Fri, 17 Feb 2023 15:05:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbjBQOFC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Feb 2023 09:05:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbjBQOFB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Feb 2023 09:05:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 188B7656B2
        for <stable@vger.kernel.org>; Fri, 17 Feb 2023 06:05:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C4565B82AFD
        for <stable@vger.kernel.org>; Fri, 17 Feb 2023 14:04:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19218C433D2;
        Fri, 17 Feb 2023 14:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676642697;
        bh=ILjl9B10TJkOGYsqjYXr3L6vthAQUqXYwxLKCquzzUs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DnObIZBqY9snv0c0tGxBbcDMdUq1k4rXE2zty3PfTt588AawjNULLrswbPhHBWWHn
         6cEXqNOTtkPgl5404QfOSfhzqLqk8j736GIIRQL+GdSqnRNU2xcH4XSbKVt94ubXsL
         YSA7kYTf1WWm3FbkEcnJ1viz0BFlNoBefo9+1E68=
Date:   Fri, 17 Feb 2023 15:04:54 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sumanth Korikkar <sumanthk@linux.ibm.com>
Cc:     stable@vger.kernel.org, debian-s390@lists.debian.org,
        debian-kernel@lists.debian.org, svens@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, Ulrich.Weigand@de.ibm.com,
        dipak.zope1@ibm.com
Subject: Re: [PATCH v2 1/1] s390/signal: fix endless loop in do_signal
Message-ID: <Y++JhmacN9qADFj7@kroah.com>
References: <20230215141324.1239245-1-sumanthk@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230215141324.1239245-1-sumanthk@linux.ibm.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 15, 2023 at 03:13:24PM +0100, Sumanth Korikkar wrote:
> No upstream commit exists: the problem addressed here is that 
> 'commit 75309018a24d ("s390: add support for TIF_NOTIFY_SIGNAL")' 
> was backported to 5.10. This commit is broken, but nobody noticed
> upstream, since shortly after s390 converted to generic entry with
> 'commit 75309018a24d ("s390: add support for TIF_NOTIFY_SIGNAL")', which
> implicitly fixed the problem outlined below.
> 
> Thread flag is set to TIF_NOTIFY_SIGNAL for io_uring work.  The io work
> user or syscall calls do_signal when either one of the TIF_SIGPENDING or
> TIF_NOTIFY_SIGNAL flag is set.  However, do_signal does consider only
> TIF_SIGPENDING signal and ignores TIF_NOTIFY_SIGNAL condition.  This
> means get_signal is never invoked  for TIF_NOTIFY_SIGNAL and hence the
> flag is not cleared, which results in an endless do_signal loop.
> 
> Reference: 'commit 788d0824269b ("io_uring: import 5.15-stable io_uring")'
> Fixes: 75309018a24d ("s390: add support for TIF_NOTIFY_SIGNAL")
> Cc: stable@vger.kernel.org  # 5.10.162
> Acked-by: Heiko Carstens <hca@linux.ibm.com>
> Acked-by: Sven Schnelle <svens@linux.ibm.com>
> Signed-off-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
> ---
>  arch/s390/kernel/signal.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Now queued up, thanks.

greg k-h

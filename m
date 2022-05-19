Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A16D752D5FE
	for <lists+stable@lfdr.de>; Thu, 19 May 2022 16:27:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239704AbiESO1M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 May 2022 10:27:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239688AbiESO1M (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 May 2022 10:27:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F26F66ACF
        for <stable@vger.kernel.org>; Thu, 19 May 2022 07:27:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F194DB82463
        for <stable@vger.kernel.org>; Thu, 19 May 2022 14:27:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4210FC385B8;
        Thu, 19 May 2022 14:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652970428;
        bh=R/a6DlD7YzeUlXVTQdYLFr4xpDkJJNoytbS4OgAIet4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RRWCp/fpUZBIylwXOsz9wk1AQeAeylyddS68Ag0DntMqclhY0nGaVmffJsocVBmU5
         lNsAkDb4zYD5kpSNjtfVEmEWzTdKpA4/+shk4cyLemV2LDeYeAPbliqNHv1xz0IKu7
         JHHLJNtxro7YOPmzAHj4JpCooDuw0YWB4jeXVi/8=
Date:   Thu, 19 May 2022 16:27:06 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Meena Shanmugam <meenashanmugam@google.com>
Cc:     stable@vger.kernel.org, trond.myklebust@hammerspace.com
Subject: Re: [PATCH 5.4 0/4] Request to cherry-pick f00432063db1 to 5.4.y
Message-ID: <YoZTutamdxFnMW7o@kroah.com>
References: <20220518184011.789699-1-meenashanmugam@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220518184011.789699-1-meenashanmugam@google.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 18, 2022 at 06:40:07PM +0000, Meena Shanmugam wrote:
> The commit f00432063db1a0db484e85193eccc6845435b80e (SUNRPC:
> Ensure we flush any closed sockets before xs_xprt_free()) upstream fixes
> CVE-2022-28893, hence good candidate for stable trees.
> The above commit depends on 3be232f11a3c (SUNRPC: Prevent immediate
> close+reconnect)  and  89f42494f92f (SUNRPC: Don't call connect() more than
> once on a TCP socket). Commit 3be232f11a3c depends on commit
> e26d9972720e (SUNRPC: Clean up scheduling of autoclose).
> 
> Commits e26d9972720e, 3be232f11a3c apply cleanly on 5.4
> kernel. commit 89f42494f92f and f00432063db1 didn't apply cleanly.
> This patch series includes all the commits required for back porting
> f00432063db1.
> 
> 
> Trond Myklebust (4):
>   SUNRPC: Clean up scheduling of autoclose
>   SUNRPC: Prevent immediate close+reconnect
>   SUNRPC: Don't call connect() more than once on a TCP socket
>   SUNRPC: Ensure we flush any closed sockets before xs_xprt_free()
> 
>  fs/file_table.c                 |  1 +
>  include/linux/sunrpc/xprtsock.h |  1 +
>  net/sunrpc/xprt.c               | 34 ++++++++++++++++---------------
>  net/sunrpc/xprtsock.c           | 36 ++++++++++++++++++++++-----------
>  4 files changed, 44 insertions(+), 28 deletions(-)
> 
> -- 
> 2.36.1.124.g0e6072fb45-goog
> 

All now queued up, thanks.

greg k-h

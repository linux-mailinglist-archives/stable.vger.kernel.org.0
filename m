Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 371814BBB8D
	for <lists+stable@lfdr.de>; Fri, 18 Feb 2022 16:00:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233680AbiBRO76 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Feb 2022 09:59:58 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236462AbiBRO7s (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Feb 2022 09:59:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9B808AE52
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 06:57:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1C4D8B82671
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 14:57:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E957C340E9;
        Fri, 18 Feb 2022 14:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645196264;
        bh=pnBLpiuxMyqVSoZ5mZt/i1sppKsoZerz2XDxQMohbKY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZEnyxf7vUqtiwp52DQxNscPQd28ES2m+iMM7+hPcKyuccNczihaOSuJHjrpLc6lq5
         UqgfS0o/JazpggyWQfmO7kYr8nN4ZUYhzC8+ibMiJsLcRSjnbXgjid3d4cQt38HPZT
         iWDnaSZ9H1ki6opFio20GxfwPNMX8Nt/BJJvSyq8=
Date:   Fri, 18 Feb 2022 15:56:31 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jens Wiklander <jens.wiklander@linaro.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        linux-stable <stable@vger.kernel.org>,
        Sumit Garg <sumit.garg@linaro.org>,
        Sasha Levin <sashal@kernel.org>, Lars Persson <larper@axis.com>
Subject: Re: stable-rc/queue: 5.15 5.16 arm64 builds failed
Message-ID: <Yg+zn6egFCxUZTFX@kroah.com>
References: <CA+G9fYuDLxwN97GdYhyQ2kz=WD1ASKE4HzDC1GKfrhPvk2xaXA@mail.gmail.com>
 <CAHUa44FAh89fRQMB7XgjDrwjv-7iye721CHi6jDe8VchLwZijg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHUa44FAh89fRQMB7XgjDrwjv-7iye721CHi6jDe8VchLwZijg@mail.gmail.com>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 18, 2022 at 03:49:49PM +0100, Jens Wiklander wrote:
> Hi Naresh,
> 
> On Fri, Feb 18, 2022 at 3:36 PM Naresh Kamboju
> <naresh.kamboju@linaro.org> wrote:
> >
> > While building stable rc queues for arch arm64 on queue/5.15 and
> > queue/5.16 the following build errors / warnings were noticed.
> >
> > ## Fails
> > * arm64, build
> >   - gcc-11-defconfig-5e73d44a
> >
> > Committing details,
> > optee: use driver internal tee_context for some rpc
> > commit aceeafefff736057e8f93f19bbfbef26abd94604 upstream.
> >
> >
> > build error / warning.
> > drivers/tee/optee/core.c: In function 'optee_remove':
> > drivers/tee/optee/core.c:591:9: error: implicit declaration of
> > function 'teedev_close_context'; did you mean
> > 'tee_client_close_context'? [-Werror=implicit-function-declaration]
> >   591 |         teedev_close_context(optee->ctx);
> >       |         ^~~~~~~~~~~~~~~~~~~~
> >       |         tee_client_close_context
> > drivers/tee/optee/core.c: In function 'optee_probe':
> > drivers/tee/optee/core.c:724:15: error: implicit declaration of
> > function 'teedev_open' [-Werror=implicit-function-declaration]
> >   724 |         ctx = teedev_open(optee->teedev);
> >       |               ^~~~~~~~~~~
> > drivers/tee/optee/core.c:724:13: warning: assignment to 'struct
> > tee_context *' from 'int' makes pointer from integer without a cast
> > [-Wint-conversion]
> >   724 |         ctx = teedev_open(optee->teedev);
> >       |             ^
> > drivers/tee/optee/core.c:726:20: warning: operation on 'rc' may be
> > undefined [-Wsequence-point]
> >   726 |                 rc = rc = PTR_ERR(ctx);
> >       |                 ~~~^~~~~~~~~~~~~~~~~~~
> > cc1: some warnings being treated as errors
> >
> >
> >
> 
> It looks like 1e2c3ef0496e ("tee: export teedev_open() and
> teedev_close_context()") is missing. I noted the dependency as:
>     Cc: stable@vger.kernel.org # 1e2c3ef0496e tee: export
> teedev_open() and teedev_close_context()
> in the commit. Perhaps I've misunderstood how this is supposed to be done.

When doing a backport like this, please be explicit as to what I need to
do if it is different than just taking the patch you sent me.

I'll try to fix this up later...

thanks,

greg k-h

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CAD24BC0EE
	for <lists+stable@lfdr.de>; Fri, 18 Feb 2022 20:59:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238974AbiBRT7S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Feb 2022 14:59:18 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239206AbiBRT7L (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Feb 2022 14:59:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C366A2E0B1
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 11:58:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 508C161BB9
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 19:58:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FC10C340E9;
        Fri, 18 Feb 2022 19:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645214318;
        bh=PYdKLQxTxQqtQ4VXttgvicYKkx3sNWO8mI47QbrnUB4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EDS0d27+GPLIHpNoAu0RCo7xa7rXjkmcWHOgDgao1MzfsWzyeolYjmu2stj8HWvbz
         yWFw8TtmhA4p0opWDOvlmVHrBgGF19bRFfLT3C2J1lMrmI55VucnNdQRqq3w8YYSmo
         J3QEHf6/OoztDucKprUyCqUill7lBNlr7uuWYn86tFvSlbWbBuu5vRvsjAYRLcE2A8
         BF1G1mAm+N2M1/L6wup+3mnGH1krwiL+RO51EGDyLmYdHfw9hS0rS0F8dGckSKOlNr
         L1eKX+JfjHrSouL4ZfnR2Wxu+ydClkTptd9P3NiS46vLlh7IXtiXq4/8NuvolrCl5x
         0QONNNUZeNy+A==
Date:   Fri, 18 Feb 2022 14:58:37 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Jens Wiklander <jens.wiklander@linaro.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        linux-stable <stable@vger.kernel.org>,
        Sumit Garg <sumit.garg@linaro.org>,
        Lars Persson <larper@axis.com>
Subject: Re: stable-rc/queue: 5.15 5.16 arm64 builds failed
Message-ID: <Yg/6bVfy5cOwpjWa@sashalap>
References: <CA+G9fYuDLxwN97GdYhyQ2kz=WD1ASKE4HzDC1GKfrhPvk2xaXA@mail.gmail.com>
 <CAHUa44FAh89fRQMB7XgjDrwjv-7iye721CHi6jDe8VchLwZijg@mail.gmail.com>
 <Yg+zn6egFCxUZTFX@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <Yg+zn6egFCxUZTFX@kroah.com>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 18, 2022 at 03:56:31PM +0100, Greg Kroah-Hartman wrote:
>On Fri, Feb 18, 2022 at 03:49:49PM +0100, Jens Wiklander wrote:
>> Hi Naresh,
>>
>> On Fri, Feb 18, 2022 at 3:36 PM Naresh Kamboju
>> <naresh.kamboju@linaro.org> wrote:
>> >
>> > While building stable rc queues for arch arm64 on queue/5.15 and
>> > queue/5.16 the following build errors / warnings were noticed.
>> >
>> > ## Fails
>> > * arm64, build
>> >   - gcc-11-defconfig-5e73d44a
>> >
>> > Committing details,
>> > optee: use driver internal tee_context for some rpc
>> > commit aceeafefff736057e8f93f19bbfbef26abd94604 upstream.
>> >
>> >
>> > build error / warning.
>> > drivers/tee/optee/core.c: In function 'optee_remove':
>> > drivers/tee/optee/core.c:591:9: error: implicit declaration of
>> > function 'teedev_close_context'; did you mean
>> > 'tee_client_close_context'? [-Werror=implicit-function-declaration]
>> >   591 |         teedev_close_context(optee->ctx);
>> >       |         ^~~~~~~~~~~~~~~~~~~~
>> >       |         tee_client_close_context
>> > drivers/tee/optee/core.c: In function 'optee_probe':
>> > drivers/tee/optee/core.c:724:15: error: implicit declaration of
>> > function 'teedev_open' [-Werror=implicit-function-declaration]
>> >   724 |         ctx = teedev_open(optee->teedev);
>> >       |               ^~~~~~~~~~~
>> > drivers/tee/optee/core.c:724:13: warning: assignment to 'struct
>> > tee_context *' from 'int' makes pointer from integer without a cast
>> > [-Wint-conversion]
>> >   724 |         ctx = teedev_open(optee->teedev);
>> >       |             ^
>> > drivers/tee/optee/core.c:726:20: warning: operation on 'rc' may be
>> > undefined [-Wsequence-point]
>> >   726 |                 rc = rc = PTR_ERR(ctx);
>> >       |                 ~~~^~~~~~~~~~~~~~~~~~~
>> > cc1: some warnings being treated as errors
>> >
>> >
>> >
>>
>> It looks like 1e2c3ef0496e ("tee: export teedev_open() and
>> teedev_close_context()") is missing. I noted the dependency as:
>>     Cc: stable@vger.kernel.org # 1e2c3ef0496e tee: export
>> teedev_open() and teedev_close_context()
>> in the commit. Perhaps I've misunderstood how this is supposed to be done.
>
>When doing a backport like this, please be explicit as to what I need to
>do if it is different than just taking the patch you sent me.
>
>I'll try to fix this up later...

I've added the missing commit to 5.15 and 5.16.

-- 
Thanks,
Sasha

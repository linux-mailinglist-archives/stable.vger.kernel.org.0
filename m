Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB58A68A8E6
	for <lists+stable@lfdr.de>; Sat,  4 Feb 2023 08:59:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbjBDH7T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Feb 2023 02:59:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229877AbjBDH7S (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Feb 2023 02:59:18 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDFBF241CA;
        Fri,  3 Feb 2023 23:59:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3F9F8CE312B;
        Sat,  4 Feb 2023 07:59:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7189C433EF;
        Sat,  4 Feb 2023 07:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675497553;
        bh=IBrKqhtT8Y2lqgiK4dQAA7Vm1qgG5EJ/NNEtzjci9dw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Pm1hxoiXSqLiRcdKZYboLO9Dv5T1h33nDdl/ylGUW7pNRZNiqyB0ZHqdCUXZWDdWW
         +uKf4IXAjpLqGtUGlwdEhD8/LFMY+HQQ1+UnDH9owlTNhwaPSYTUf09IsJV+vLHF9/
         8IiGv8BFkMp6tazRA4+yBbVorMWSdhE6ox0xVhe8=
Date:   Sat, 4 Feb 2023 08:59:09 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Guenter Roeck <linux@roeck-us.net>, stable@vger.kernel.org,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.4 000/134] 5.4.231-rc1 review
Message-ID: <Y94QTVUg2H68XnQ2@kroah.com>
References: <20230203101023.832083974@linuxfoundation.org>
 <20230203155619.GA3176223@roeck-us.net>
 <Y906Hz3UWYxoxYdD@kroah.com>
 <20230203171826.GA1500930@roeck-us.net>
 <Y91YWzopMMGF1Lgh@sol.localdomain>
 <Y91bjnIuQRvVqpO7@sol.localdomain>
 <705ab151-da1e-30e1-c232-c9860717267d@roeck-us.net>
 <Y91lXYN7zF8d/fek@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y91lXYN7zF8d/fek@sol.localdomain>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 03, 2023 at 11:49:49AM -0800, Eric Biggers wrote:
> On Fri, Feb 03, 2023 at 11:28:46AM -0800, Guenter Roeck wrote:
> > On 2/3/23 11:07, Eric Biggers wrote:
> > > On Fri, Feb 03, 2023 at 10:54:21AM -0800, Eric Biggers wrote:
> > > > On Fri, Feb 03, 2023 at 09:18:26AM -0800, Guenter Roeck wrote:
> > > > > On Fri, Feb 03, 2023 at 05:45:19PM +0100, Greg Kroah-Hartman wrote:
> > > > > > On Fri, Feb 03, 2023 at 07:56:19AM -0800, Guenter Roeck wrote:
> > > > > > > On Fri, Feb 03, 2023 at 11:11:45AM +0100, Greg Kroah-Hartman wrote:
> > > > > > > > This is the start of the stable review cycle for the 5.4.231 release.
> > > > > > > > There are 134 patches in this series, all will be posted as a response
> > > > > > > > to this one.  If anyone has any issues with these being applied, please
> > > > > > > > let me know.
> > > > > > > > 
> > > > > > > > Responses should be made by Sun, 05 Feb 2023 10:09:58 +0000.
> > > > > > > > Anything received after that time might be too late.
> > > > > > > > 
> > > > > > > 
> > > > > > > Building ia64:defconfig ... failed
> > > > > > > --------------
> > > > > > > Error log:
> > > > > > > <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]
> > > > > > > arch/ia64/kernel/mca_drv.c: In function 'mca_handler_bh':
> > > > > > > arch/ia64/kernel/mca_drv.c:179:9: error: implicit declaration of function 'make_task_dead'
> > > > > > > 
> > > > > > > Caused by "exit: Add and use make_task_dead.". Did that really have to be backported ?
> > > > > > 
> > > > > > Yup, it does!
> > > > > > 
> > > > > > Eric, any help with this?
> > > > > > 
> > > > > 
> > > > > Adding "#include <linux/sched/task.h>" to the affected file would probably
> > > > > be the easy fix. I did a quick check, and it works.
> > > > > 
> > > > > Note that the same problem is seen in v4.14.y and v4.19.y. Later
> > > > > kernels don't have the problem.
> > > > > 
> > > > 
> > > > This problem arises because <linux/mm.h> transitively includes
> > > > <linux/sched/task.h> in 5.10 and later, but not in 5.4 and earlier.
> > > > 
> > > > Greg, any preference for how to handle this situation?
> > > > 
> > > > Just add '#include <linux/sched/task.h>' to the affected .c file (and hope there
> > > > are no more affected .c files in the other arch directories) and call it a day?
> > > > 
> > > > Or should we backport the transitive inclusion (i.e., the #include added by
> > > > commit 80fbaf1c3f29)?  Or move the declaration of make_task_dead() into
> > > > <linux/kernel.h> so that it's next to do_exit()?
> > > 
> > > One question: do *all* the arches actually get built as part of the testing for
> > > each stable release?  If so, we can just add the #include to the .c files that
> > > need it.  If not, then it would be safer to take one of the other approaches.
> > > 
> > 
> > Yes, I do build all architectures for each stable release.
> > 
> > FWIW, I only noticed that one build failure due to this problem.
> 
> Okay, great.  In that case, Greg or Sasha, can you fold the needed #include into
> arch/ia64/kernel/mca_drv.c in exit-add-and-use-make_task_dead.patch on 4.14,
> 4.19, and 5.4?  Or should I just send the whole series again for each?

I'll fold it in later today when I get a chance, no need to resubmit the
whole thing, thanks!

greg k-h

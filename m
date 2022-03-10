Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D9524D5220
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 20:44:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245735AbiCJTGQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 14:06:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245746AbiCJTGP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 14:06:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65117155C07;
        Thu, 10 Mar 2022 11:05:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 07794B826EE;
        Thu, 10 Mar 2022 19:05:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D634C340E8;
        Thu, 10 Mar 2022 19:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646939108;
        bh=31CsDxuXQkxZdivfzKTGWRUE6cmFgAKs1nPr9jAdUds=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AswlffeEqkh7WnZl+Wrpa1vhu0pjNI05OnI4T8c41qjJWMBKYXQzbW92SI0dL9SNw
         J5KSCQlMm1LHkkqhhFrW+WNIOLe+jXKaQLErkzFksjqf28T1Rcj/Kw5PyY8drlwK9C
         BHFr6e25P4r6wfAOWAsy71tR3rNCsYusP/wE6a+k=
Date:   Thu, 10 Mar 2022 20:05:04 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "H. Nikolaus Schaller" <hns@goldelico.com>
Cc:     Huang Pei <huangpei@loongson.cn>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>,
        Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Discussions about the Letux Kernel 
        <letux-kernel@openphoenux.org>
Subject: Re: [BUG] new MIPS compile error on v5.15.27
Message-ID: <YipL4KYG0hXa0g2s@kroah.com>
References: <D148EFBD-55E0-449A-AD2A-12C80ABD4FC4@goldelico.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D148EFBD-55E0-449A-AD2A-12C80ABD4FC4@goldelico.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 10, 2022 at 05:25:07PM +0100, H. Nikolaus Schaller wrote:
> upstream commit 277c8cb3e8ac ("MIPS: fix local_{add,sub}_return on MIPS64")
> 
> was backported to v5.15.27 as
> 
> commit f98371d2ac83 ("MIPS: fix local_{add,sub}_return on MIPS64")
> 
> but breaks MIPS build:
> 
> In file included from ./arch/mips/include/asm/local.h:8:0,
>                  from ./include/linux/genhd.h:20,
>                  from ./include/linux/blkdev.h:8,
>                  from ./include/linux/blk-cgroup.h:23,
>                  from ./include/linux/writeback.h:14,
>                  from ./include/linux/memcontrol.h:22,
>                  from ./include/net/sock.h:53,
>                  from ./include/linux/tcp.h:19,
>                  from drivers/net/slip/slip.c:91:
> ./arch/mips/include/asm/asm.h:68:0: warning: "END" redefined
>  #define END(function)     \
>  
> In file included from drivers/net/slip/slip.c:88:0:
> drivers/net/slip/slip.h:44:0: note: this is the location of the previous definition
>  #define END             0300  /* indicates end of frame */
> 
> Analyses reveals that with the backported MIPS fix there is a new
> #include <asm/asm.h> introduced by ./arch/mips/include/asm/local.h
> which already defines some END macro.
> 
> But why does v5.16.x compile fine where
> 
> commit a0ecfd10d669c ("MIPS: fix local_{add,sub}_return on MIPS64")
> 
> is also present since v5.16.3?
> 
> Deeper analyses shows that there is another patch introduced
> in v5.16-rc1 which removed one #include in the above chain and
> therefore does not define END by asm/asm.h:
> 
> commit 348332e000697 ("mm: don't include <linux/blk-cgroup.h> in <linux/writeback.h>")
> 
> Hence, the MIPS fix should only be applied to branches where
> the mm fix is already present. Or the mm fix should be backported
> as well (if it has no side-effects).
> 
> Note: the MIPS fix was apparently not (yet?) applied to v5.10.y or earlier
> even tough the Fixes: 7232311ef14c ("local_t: mips extension")
> would be true.

Thanks for the report.  I'll work on resolving this for the next round
of stable releases _after_ the ones that are currently out for review
are released.

thanks,

greg k-h

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16C49678392
	for <lists+stable@lfdr.de>; Mon, 23 Jan 2023 18:48:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232508AbjAWRsy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Jan 2023 12:48:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232449AbjAWRsx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Jan 2023 12:48:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BA49301BB;
        Mon, 23 Jan 2023 09:48:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 41F2E60EA2;
        Mon, 23 Jan 2023 17:48:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96981C433EF;
        Mon, 23 Jan 2023 17:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674496124;
        bh=pqKppjlRuFBHGReaVkqpwFItO/Rhqh4/e9XJViYeCrU=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=SvM/6RhY8wmPpGeoK6IX2zqdsXIowSVRZIlcXTUW/yWYcro1MTJp/NTfelgJteqq+
         lFc+Ukw4MJnMvvwcHuYSxjQS7dyGEo84jD0ds7ff7uyHdHbzevWmcXBUV/IjRYA7fK
         D2cxRfoNgIgNvDe0nXsZks6+pmnQrUOJb4wItWWuQuAnXPwHGEyXzq1FhsTdLvB1lT
         bnpBSEUpByBWV6B72MLZ3X0Z6XNzmmfpxoe2SQ4ZwIt9F0FgronKPS6ykPdWOmhBxP
         UEGclqPStvhy63LjwsWjxoINCVQ/PdTdMBAtVAodLX3JxAp6TTkbjlS+YwA2Yfnlf4
         qETX+R/0zmfoQ==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id 384245C0510; Mon, 23 Jan 2023 09:48:44 -0800 (PST)
Date:   Mon, 23 Jan 2023 09:48:44 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Alan Stern <stern@rowland.harvard.edu>
Cc:     Hernan Ponce de Leon <hernan.poncedeleon@huaweicloud.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        peterz@infradead.org, mingo@redhat.com, will@kernel.org,
        longman@redhat.com, boqun.feng@gmail.com, akpm@osdl.org,
        tglx@linutronix.de, joel@joelfernandes.org,
        diogo.behrens@huawei.com, jonas.oberhauser@huawei.com,
        linux-kernel@vger.kernel.org,
        Hernan Ponce de Leon <hernanl.leon@huawei.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] Fix data race in mark_rt_mutex_waiters
Message-ID: <20230123174844.GV2948950@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <20230120135525.25561-1-hernan.poncedeleon@huaweicloud.com>
 <562c883b-b2c3-3a27-f045-97e7e3281e0b@linux.intel.com>
 <20230120155439.GI2948950@paulmck-ThinkPad-P17-Gen-1>
 <9a1c7959-4b8c-94df-a3e2-e69be72bfd7d@huaweicloud.com>
 <20230123164014.GN2948950@paulmck-ThinkPad-P17-Gen-1>
 <Y87FLV0dWSyQz3NZ@rowland.harvard.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y87FLV0dWSyQz3NZ@rowland.harvard.edu>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 23, 2023 at 12:34:37PM -0500, Alan Stern wrote:
> On Mon, Jan 23, 2023 at 08:40:14AM -0800, Paul E. McKenney wrote:
> > In the case, the value read is passed into cmpxchg_relaxed(), which
> > checks the value against memory.  In this case, as Arjan noted, the only
> > compiler-and-silicon difference between data_race() and READ_ONCE()
> > is that use of data_race() might allow the compiler to do things like
> > tear the load, thus forcing the occasional spurious cmpxchg_relaxed()
> > failure.
> 
> Is it possible in theory for a torn load to cause a spurious 
> cmpxchg_relaxed() success?  Or would that not matter here?

In this case, the new value is the old value with an additional bit set.
There is no check for that bit being clear, so I am having a hard time
seeing a difference.

Then again, much might depend on the ordering that Hernan is
referring to.

And Peter Zijlstra's suggestion of set_bit() is quite attractive,
give or take the casting issues called out by David Laight.

							Thanx, Paul

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 104FC6E65C4
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 15:24:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232401AbjDRNX6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 09:23:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232141AbjDRNXx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 09:23:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACA6D14479
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 06:23:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C2616153A
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 13:23:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DD08C433D2;
        Tue, 18 Apr 2023 13:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681824226;
        bh=yZdNqQ1V+VANx8jFVnYJmqdVxpJlDam/WzLyKVLrg7Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BshbenjZqafvZ5qW19rTUmjSH2uaNpEYhzgbfWzQaQiAX3hxSkuRFfjiITOkWTN3a
         nAvPSEhKWhEyUcBN5FUFfktbdB0TQjmbGvE3puPA9qD1jZsRV95ixubpc8cdPK4F/r
         efO370v6i0oJEt2ubjntxfGXW68GsPs0SF3J5xEw=
Date:   Tue, 18 Apr 2023 15:23:43 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Qais Yousef <qyousef@layalina.io>
Cc:     stable@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>
Subject: Re: [PATCH v2 00/10] Backport uclamp vs margin fixes into 5.10.y
Message-ID: <2023041815-quack-professed-6b2c@gregkh>
References: <20230318173943.3188213-1-qyousef@layalina.io>
 <20230418130309.rzk7sqy2dzvgcllx@airbuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230418130309.rzk7sqy2dzvgcllx@airbuntu>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 18, 2023 at 02:03:09PM +0100, Qais Yousef wrote:
> Hi
> 
> On 03/18/23 17:39, Qais Yousef wrote:
> > Changes in v2:
> > 	* Fix compilation error against patch 7 due to misiplace #endif to
> > 	  protect against CONFIG_SMP which doesn't contain the newly added
> > 	  field to struct rq.
> > 
> > Commit 2ff401441711 ("sched/uclamp: Fix relationship between uclamp and
> > migration margin") was cherry-picked into 5.10 kernels but missed the rest of
> > the series.
> > 
> > This ports the remainder of the fixes.
> > 
> > Based on 5.10.172.
> > 
> > NOTE:
> > 
> > a2e90611b9f4 ("sched/fair: Remove capacity inversion detection") is not
> > necessary to backport because it has a dependency on e5ed0550c04c ("sched/fair:
> > unlink misfit task from cpu overutilized") which is nice to have but not
> > strictly required. It improves the search for best CPU under adverse thermal
> > pressure to try harder. And the new search effectively replaces the capacity
> > inversion detection, so it is removed afterwards.
> > 
> > Build tested on (cross compile when necessary; x86_64 otherwise):
> > 
> > 	1. default ubuntu config which has uclamp + smp
> > 	2. default ubuntu config without uclamp + smp
> > 	3. default ubunto config without smp (which automatically disables
> > 	   uclamp)
> > 	4. reported riscv-allnoconfig, mips-randconfig, x86_64-randocnfigs
> > 
> > Tested on 5.10 Android GKI kernel and android device (with slight modifications
> > due to other conflicts on there).
> 
> Just checking if this has slipped through the cracks or it's on the queue just
> waiting for the right time to be picked up. There's a similar backport for 5.15
> too.

Did you miss my response a few hours ago:
	https://lore.kernel.org/r/2023041842-treachery-esophagus-7727@gregkh

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CEF86EBAA9
	for <lists+stable@lfdr.de>; Sat, 22 Apr 2023 19:29:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbjDVR3X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Apr 2023 13:29:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbjDVR3W (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Apr 2023 13:29:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A38801BF7
        for <stable@vger.kernel.org>; Sat, 22 Apr 2023 10:29:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F68660E8E
        for <stable@vger.kernel.org>; Sat, 22 Apr 2023 17:29:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32857C433D2;
        Sat, 22 Apr 2023 17:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682184560;
        bh=5X6qBegPBit+svMWmlXV2IxhVaVrpUVl8tijQ/AKs5U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GHfEIq+f6oQQUUBAiyhLblc60Reum3etD2yFwDKSA7SbpKyDLH8dhXTQIb4j3GY4y
         fZNrG+rKM2mQ6CWvziXgGTbwSBG4AP9koNkEYbNeOQNiAOnwXHDHz3cY1jfszN4Xhd
         VwKYKtDL5pa5z+yK0opmvm/i8YHlo4v6IXAHYhqs=
Date:   Sat, 22 Apr 2023 19:29:12 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Qais Yousef <qyousef@layalina.io>
Cc:     stable@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>
Subject: Re: [PATCH v2 RESEND 00/10] Backport uclamp vs margin fixes into
 5.10.y
Message-ID: <2023042250-threefold-clapping-26d2@gregkh>
References: <20230418140943.90621-1-qyousef@layalina.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230418140943.90621-1-qyousef@layalina.io>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 18, 2023 at 03:09:33PM +0100, Qais Yousef wrote:
> This is just a resend of
> 
> 	https://lore.kernel.org/stable/20230318173943.3188213-1-qyousef@layalina.io/
> 
> Changes in v2:
> 	* Fix compilation error against patch 7 due to misiplace #endif to
> 	  protect against CONFIG_SMP which doesn't contain the newly added
> 	  field to struct rq.
> 
> Commit 2ff401441711 ("sched/uclamp: Fix relationship between uclamp and
> migration margin") was cherry-picked into 5.10 kernels but missed the rest of
> the series.
> 
> This ports the remainder of the fixes.
> 
> Based on 5.10.172.
> 
> NOTE:
> 
> a2e90611b9f4 ("sched/fair: Remove capacity inversion detection") is not
> necessary to backport because it has a dependency on e5ed0550c04c ("sched/fair:
> unlink misfit task from cpu overutilized") which is nice to have but not
> strictly required. It improves the search for best CPU under adverse thermal
> pressure to try harder. And the new search effectively replaces the capacity
> inversion detection, so it is removed afterwards.
> 
> Build tested on (cross compile when necessary; x86_64 otherwise):
> 
> 	1. default ubuntu config which has uclamp + smp
> 	2. default ubuntu config without uclamp + smp
> 	3. default ubunto config without smp (which automatically disables
> 	   uclamp)
> 	4. reported riscv-allnoconfig, mips-randconfig, x86_64-randocnfigs
> 
> Tested on 5.10 Android GKI kernel and android device (with slight modifications
> due to other conflicts on there).

All now queued up, thanks!

greg k-h

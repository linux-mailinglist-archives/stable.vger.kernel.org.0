Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C58456BC784
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 08:44:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229488AbjCPHoH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 03:44:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbjCPHoF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 03:44:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31CBFE065
        for <stable@vger.kernel.org>; Thu, 16 Mar 2023 00:44:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E02A5B8200D
        for <stable@vger.kernel.org>; Thu, 16 Mar 2023 07:44:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3710FC433D2;
        Thu, 16 Mar 2023 07:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678952641;
        bh=2Fr71MH7lB71uDhyCfVwIZs2V45rfLUg/ksvQcrDbwQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LXW6Bc0paLV8n7ph6rCO7j9mdZ8XmmZUJub3yCOgwMMv5ZYXncLQ002mvkjfK+z2g
         5sz4vBBjOQtVaLlBJWTag63RxiDJcbQy1WdFBweM5PR2mx+pMzXBh6sgMaEt/lO//M
         5pI+J6nYV+SLq4L+if5cqL9/h+4mTKSNchrMlxPs=
Date:   Thu, 16 Mar 2023 08:43:58 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Qais Yousef <qyousef@layalina.io>
Cc:     stable@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>
Subject: Re: [PATCH 0/7] Backport uclamp vs margin fixes into 5.15.y
Message-ID: <ZBLIvuqi0LYWIPBN@kroah.com>
References: <20230308162207.2886641-1-qyousef@layalina.io>
 <ZBF74StdWaGP/KSP@kroah.com>
 <ZBGHpGccMmxHnUns@kroah.com>
 <20230315125304.g6yuhltvewnfneqs@airbuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230315125304.g6yuhltvewnfneqs@airbuntu>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 15, 2023 at 12:53:04PM +0000, Qais Yousef wrote:
> On 03/15/23 09:53, Greg KH wrote:
> > On Wed, Mar 15, 2023 at 09:03:45AM +0100, Greg KH wrote:
> > > On Wed, Mar 08, 2023 at 04:22:00PM +0000, Qais Yousef wrote:
> > > > Portion of the fixes were ported in 5.15 but missed some.
> > > > 
> > > > This ports the remainder of the fixes.
> > > > 
> > > > Based on 5.15.98.
> > > > 
> > > > Build tested on x86 with and without uclamp config enabled.
> > > 
> > > Now queued up, thanks.
> > 
> > Wait, should we also queue up a2e90611b9f4 ("sched/fair: Remove capacity
> > inversion detection") to 5.10 and 5.15 now as well?
> 
> It has a dependency on e5ed0550c04c ("sched/fair: unlink misfit task from cpu
> overutilized") which is nice to have but not strictly required. It improves the
> search for best CPU under adverse thermal pressure to try harder. And the new
> search effectively replaces the capacity inversion detection, so it is removed
> afterwards.
> 
> I'd like to have it but find_energy_efficient_cpu() looks a bit different for
> a straightforward backport and opted to avoid the risk.
> 
> Happy to reconsider though.

Ok, just wanting to verify as that commit looked like it was needed
after these.

But, as I've just now dropped both 5.10.y and 5.15.y sets of patches,
this is going to need to be redone anyway, so perhaps put that note in
the 00/XX email when you resubmit so that I don't get confused again.

thanks,

greg k-h

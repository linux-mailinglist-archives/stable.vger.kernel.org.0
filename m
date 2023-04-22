Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB1246EB9D8
	for <lists+stable@lfdr.de>; Sat, 22 Apr 2023 17:08:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbjDVPIJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Apr 2023 11:08:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbjDVPII (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Apr 2023 11:08:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DB991FD6
        for <stable@vger.kernel.org>; Sat, 22 Apr 2023 08:08:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA85660D2F
        for <stable@vger.kernel.org>; Sat, 22 Apr 2023 15:08:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAE6DC433D2;
        Sat, 22 Apr 2023 15:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682176085;
        bh=FMsPb91NC3ODlpiSEf0J5+FSiHAYV4on9U6bW9cKl/0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gmvxn2CK9LJ/8AOgX0ZsE4NDWna/h89yOsoebLmPCgn6WTis2ErN4RCQ1nNd4a4JL
         lJCJo7RxHXDsJ17pjdv+cBRzcQSItqgN5yAOdZBgZbz420XDTzIAXdxIY3AT3WSDc/
         TQmVjooW7wiGCLkOOXP+3P/cbslpJo7FpdLOYXzs=
Date:   Sat, 22 Apr 2023 17:07:56 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        stable@vger.kernel.org, Mel Gorman <mgorman@techsingularity.net>,
        Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] rtmutex: Add acquire semantics for rtmutex lock
 acquisition slow path
Message-ID: <2023042247-glandular-litigate-413e@gregkh>
References: <20230418154315.9PD52J2N@linutronix.de>
 <2023041854-cranium-prone-b9fa@gregkh>
 <20230419072546.gD_YO2-K@linutronix.de>
 <87pm7x3d8b.ffs@tglx>
 <ZEKFWx_68PX3pk3g@kroah.com>
 <87ildp2qy7.ffs@tglx>
 <20230421160947.Sh0eyEWC@linutronix.de>
 <87edod2o11.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87edod2o11.ffs@tglx>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 21, 2023 at 06:33:30PM +0200, Thomas Gleixner wrote:
> On Fri, Apr 21 2023 at 18:09, Sebastian Andrzej Siewior wrote:
> > On 2023-04-21 17:30:24 [+0200], Thomas Gleixner wrote:
> >> >> > The out-of-tree RT patches make extensive use of the code. Since it is
> >> >> > upstream code, I assumed it should go via the official stable trees.
> >> >> > Without RT, the code is limited the rt_mutex_lock() used by I2C and the
> >> >> > RCU booster-mutex.
> >> >> 
> >> >> Which is a reason to route it through the upstream stable trees, no?
> >> >
> >> > I do not understand.  Why would we take a patch in the stable tree
> >> > because an out-of-tree change requires it?
> >> 
> >> The change is to the rtmutex core which _IS_ used in tree by futex, RCU
> >> and some drivers.
> >
> > not back stab but to clarify: futex does not use the annotation (it does
> > not use the fastpath) but RCU-boosting _and_ I2C-bus code does use it.
> 
> Futex requires it too, really. The patch is about the slowpath, no?
> 
> 

Ok, sorry, I was confused, now queued up.

greg k-h

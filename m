Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BF146EAABA
	for <lists+stable@lfdr.de>; Fri, 21 Apr 2023 14:46:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232079AbjDUMqH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Apr 2023 08:46:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232132AbjDUMqG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Apr 2023 08:46:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 738CB974A
        for <stable@vger.kernel.org>; Fri, 21 Apr 2023 05:45:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 32B4465057
        for <stable@vger.kernel.org>; Fri, 21 Apr 2023 12:45:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C07FC4339B;
        Fri, 21 Apr 2023 12:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682081118;
        bh=IXDbzOL35JEEwbdX7JLiDIJ5K6SKObjSzTQe/kbPoK0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NpLWxmL++RZtxjLPH7Xak4RKgE+XXRJ8yJzJrvFS6Bi4F1JsjZIjfKsFPdMAlP/Rj
         ROTvtMPUfjgyEfoPkOX53E8aw/Dsz3EBveg1p0jVaqBDvIA+DxzPgizQdF4DVFuDM2
         hfu9MOr3PsjaFMHCK0shMs3ziz4MlZg42Of69G7o=
Date:   Fri, 21 Apr 2023 14:45:15 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        stable@vger.kernel.org, Mel Gorman <mgorman@techsingularity.net>,
        Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] rtmutex: Add acquire semantics for rtmutex lock
 acquisition slow path
Message-ID: <ZEKFWx_68PX3pk3g@kroah.com>
References: <20230418154315.9PD52J2N@linutronix.de>
 <2023041854-cranium-prone-b9fa@gregkh>
 <20230419072546.gD_YO2-K@linutronix.de>
 <87pm7x3d8b.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87pm7x3d8b.ffs@tglx>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 21, 2023 at 09:29:08AM +0200, Thomas Gleixner wrote:
> On Wed, Apr 19 2023 at 09:25, Sebastian Andrzej Siewior wrote:
> > On 2023-04-18 18:25:48 [+0200], Greg KH wrote:
> >> > Could this be please backported to 5.15 and earlier? It is already part
> >> > of the 6.X kernels. I asked about this by the end of January and I'm
> >> > kindly asking again ;)
> >> 
> >> I thought this was only an issues when using the out-of-tree RT patches
> >> with these kernels, right?  Or is it relevant for 5.15.y from kernel.org
> >> without anything else?
> >
> > The out-of-tree RT patches make extensive use of the code. Since it is
> > upstream code, I assumed it should go via the official stable trees.
> > Without RT, the code is limited the rt_mutex_lock() used by I2C and the
> > RCU booster-mutex.
> 
> Which is a reason to route it through the upstream stable trees, no?

I do not understand.  Why would we take a patch in the stable tree
because an out-of-tree change requires it?

confused,

greg k-h

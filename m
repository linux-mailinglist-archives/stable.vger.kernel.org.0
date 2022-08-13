Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27458591AC3
	for <lists+stable@lfdr.de>; Sat, 13 Aug 2022 15:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237657AbiHMNqO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Aug 2022 09:46:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239419AbiHMNqM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Aug 2022 09:46:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A73EDDF60
        for <stable@vger.kernel.org>; Sat, 13 Aug 2022 06:46:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 52309B800E2
        for <stable@vger.kernel.org>; Sat, 13 Aug 2022 13:46:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC893C433C1;
        Sat, 13 Aug 2022 13:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660398369;
        bh=CrJy2zOFe1vYzvnQBEfmy55j7tq2ov/LrSdQYvU2o90=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QWxbIDvOS/Uo5alTZVrNYJVTYz/BvhgkU51BSMPfxoxnGLE4ohLvKiTxRow4JTfoS
         nHvQjixDpOHUX/MRmzirCbg9inRggCOvohAAfVcyhI0QqbFCSRs4g2gSJYOpcr6Hh3
         IWrm0v1Ma1A5c40Y/PzfAAoYHOD1PoEz7uof00Ac=
Date:   Sat, 13 Aug 2022 15:46:06 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     aeasi@marvell.com, himanshu.madhani@oracle.com,
        martin.petersen@oracle.com, njavali@marvell.com
Cc:     stable@vger.kernel.org
Subject: Re: WTF: patch "[PATCH] scsi: qla2xxx: Fix response queue handler
 reading stale" was seriously submitted to be applied to the 5.19-stable
 tree?
Message-ID: <YverHtqNRmMLXmqb@kroah.com>
References: <166039743723771@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166039743723771@kroah.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Aug 13, 2022 at 03:30:37PM +0200, gregkh@linuxfoundation.org wrote:
> The patch below was submitted to be applied to the 5.19-stable tree.
> 
> I fail to see how this patch meets the stable kernel rules as found at
> Documentation/process/stable-kernel-rules.rst.
> 
> I could be totally wrong, and if so, please respond to 
> <stable@vger.kernel.org> and let me know why this patch should be
> applied.  Otherwise, it is now dropped from my patch queues, never to be
> seen again.
> 
> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 
> >From b1f707146923335849fb70237eec27d4d1ae7d62 Mon Sep 17 00:00:00 2001
> From: Arun Easi <aeasi@marvell.com>
> Date: Tue, 12 Jul 2022 22:20:39 -0700
> Subject: [PATCH] scsi: qla2xxx: Fix response queue handler reading stale
>  packets
> 
> On some platforms, the current logic of relying on finding new packet
> solely based on signature pattern can lead to driver reading stale
> packets. Though this is a bug in those platforms, reduce such exposures by
> limiting reading packets until the IN pointer.
> 
> Two module parameters are introduced:
> 
>   ql2xrspq_follow_inptr:
> 
>     When set, on newer adapters that has queue pointer shadowing, look for
>     response packets only until response queue in pointer.
> 
>     When reset, response packets are read based on a signature pattern
>     logic (old way).
> 
>   ql2xrspq_follow_inptr_legacy:
> 
>     Like ql2xrspq_follow_inptr, but for those adapters where there is no
>     queue pointer shadowing.

On a meta-note, this patch seems VERY wrong.  You are adding a
driver-wide module option for a device-specific action.  That should be
a device-specific functionality, not a module.

Again, as I say many times, this isn't the 1990's, please never add new
module parameters.  Use the other interfaces we have in the kernel to
configure individual devices properly, module parameters are not to be
used for that at all for anything new.

So, can you revert this commit and do it properly please?

thanks,

greg k-h

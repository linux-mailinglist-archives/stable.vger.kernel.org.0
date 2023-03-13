Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B00586B774B
	for <lists+stable@lfdr.de>; Mon, 13 Mar 2023 13:16:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbjCMMQG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Mar 2023 08:16:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbjCMMQE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Mar 2023 08:16:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60EA8E386
        for <stable@vger.kernel.org>; Mon, 13 Mar 2023 05:16:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EEB5C6123A
        for <stable@vger.kernel.org>; Mon, 13 Mar 2023 12:16:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C604C433D2;
        Mon, 13 Mar 2023 12:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678709762;
        bh=TzmdC8VCF8u/7772YcxZsvRBn69gncItdTwT5BtaOLs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Sa7aHjAPWw+wRbgnfFraOXBH5WrRGVC7xl0/Q8oa+86QeJjzDG2lyoT4Gd/gPxvXz
         PmBVrdXVaXU0+Fi8tuTeHK2fqTKoyuFGy6oPlFAhB/IROdnxoK/sEc/SDzlHdtDqMJ
         wFOpCbdW3KeCmvaePTWteNcHgaMc72Sy6fijG2EI=
Date:   Mon, 13 Mar 2023 13:15:59 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     johan+linaro@kernel.org, hsinyi@chromium.org,
        mark-pk.tsai@mediatek.com, maz@kernel.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] irqdomain: Look for existing mapping only
 once" failed to apply to 5.15-stable tree
Message-ID: <ZA8T/1qYqzmxeInU@kroah.com>
References: <167812847919116@kroah.com>
 <ZA8GliA5EyxBGSif@hovoldconsulting.com>
 <ZA8IEdjBoHXi/sQY@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZA8IEdjBoHXi/sQY@kroah.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 13, 2023 at 12:25:05PM +0100, Greg KH wrote:
> On Mon, Mar 13, 2023 at 12:18:46PM +0100, Johan Hovold wrote:
> > On Mon, Mar 06, 2023 at 07:47:59PM +0100, Greg Kroah-Hartman wrote:
> > > 
> > > The patch below does not apply to the 5.15-stable tree.
> > > If someone wants it applied there, or to any other stable or longterm
> > > tree, then please email the backport, including the original git commit
> > > id to <stable@vger.kernel.org>.
> > > 
> > > To reproduce the conflict and resubmit, you may use the following commands:
> > > 
> > > git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.15.y
> > > git checkout FETCH_HEAD
> > > git cherry-pick -x 6e6f75c9c98d2d246d90411ff2b6f0cd271f4cba
> > > # <resolve conflicts, build, test, etc.>
> > > git commit -s
> > > git send-email --to '<stable@vger.kernel.org>' --in-reply-to '167812847919116@kroah.com' --subject-prefix 'PATCH 5.15.y' HEAD^..
> > > 
> > > Possible dependencies:
> > > 
> > > 6e6f75c9c98d ("irqdomain: Look for existing mapping only once")
> > 
> > Both the below commit and the dependency were ultimately included in
> > 5.15.y, but the initial failure to add them appears to have prevented
> > the subsequent fixes from being applied.
> > 
> > Specifically, 5.15.y is now missing
> > 
> > 	d55f7f4c58c0 ("irqdomain: Refactor __irq_domain_alloc_irqs()")
> 
> THis commit does not apply to 5.15.y, even with:
> 
> > 	601363cc08da ("irqdomain: Fix mapping-creation race")
> 
> This one applied.
> 
> I've applied this one to 5.15.y only, it doesn't apply to 5.10.y or
> older.

Oops, I applied it and it broke the build, so I've now dropped it :(

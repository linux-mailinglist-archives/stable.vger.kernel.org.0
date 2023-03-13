Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 882A56B7627
	for <lists+stable@lfdr.de>; Mon, 13 Mar 2023 12:40:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230371AbjCMLkm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Mar 2023 07:40:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230242AbjCMLkl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Mar 2023 07:40:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 962495D8A2
        for <stable@vger.kernel.org>; Mon, 13 Mar 2023 04:40:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3C2FB611DB
        for <stable@vger.kernel.org>; Mon, 13 Mar 2023 11:40:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97E41C433EF;
        Mon, 13 Mar 2023 11:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678707639;
        bh=QcpXY4WGi5EsJ4RaacDpdH9L3HonJiGUxtVZpm3TIlo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bgiVXaOVG9kKjlqyUm935VLeSxI8n3Tl1+dHQ5NMN2JN5w3bLRz9/EKEOqpLyQ39x
         4k84e18j42zt05aYMgYf8p3tIqBU9r7pUQXRJIBK5SGBCOWj9PvRA/jgoR5Fm8mZWu
         NTf2UU+ATYTrgXyQlysjujtqIGGO9iBb7942nflxX2Tkr0bzQFbwe6YmCuOz1/z8+K
         Yhsu90+s2BGyviii5QwInXpl0NEkLk5B2yk1AjXC2CHT4VFws1KvZWgmDZSwefDfii
         UU8nCZRPofby0/lYCFDiBIBBeLim7I1zWPxfp2M18KsI5Ntvsk7fwrufXWBJz1w3Ud
         TJXLsUFHtjS/Q==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1pbgYe-0006FP-HS; Mon, 13 Mar 2023 12:41:40 +0100
Date:   Mon, 13 Mar 2023 12:41:40 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     johan+linaro@kernel.org, hsinyi@chromium.org,
        mark-pk.tsai@mediatek.com, maz@kernel.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] irqdomain: Look for existing mapping only
 once" failed to apply to 5.15-stable tree
Message-ID: <ZA8L9MjUVjrPnqCi@hovoldconsulting.com>
References: <167812847919116@kroah.com>
 <ZA8GliA5EyxBGSif@hovoldconsulting.com>
 <ZA8IEdjBoHXi/sQY@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZA8IEdjBoHXi/sQY@kroah.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 13, 2023 at 12:25:05PM +0100, Greg Kroah-Hartman wrote:
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

They need to be applied in order. Let me post backports then. Cherry
picking them worked just fine, but I did not try git am which may be
more picky.

Johan

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 290A060128B
	for <lists+stable@lfdr.de>; Mon, 17 Oct 2022 17:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbiJQPMg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 11:12:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230259AbiJQPMf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 11:12:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BE532A728;
        Mon, 17 Oct 2022 08:12:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F03E5611C3;
        Mon, 17 Oct 2022 14:57:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B22E7C433D7;
        Mon, 17 Oct 2022 14:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666018647;
        bh=VJTE+2hp8fGyRxB0IEGDftCi/XVK1bxYcq7vcLg9Iko=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NchuVzu6vD+1pn9aAjCRUEmSnbOA1iORJCncsGjYky9RFcFuvrw+8x7EIjrMNWk2f
         ch1x+qqTLDDjBbkVOrCeRkZ1dY3cvb7Q6TQobs8Tt8V/SBq0noKxulQA/UL356S634
         zVzRMJlaUQUrslrK/vSE1btDohHNBiiUvDxkFmbA=
Date:   Mon, 17 Oct 2022 16:57:23 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, sunghwan jung <onenowy@gmail.com>,
        stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
        usb-storage@lists.one-eyed-alien.net
Subject: Re: [PATCH AUTOSEL 4.9 08/10] Revert "usb: storage: Add quirk for
 Samsung Fit flash"
Message-ID: <Y01tU0BLnON2zfRz@kroah.com>
References: <20221013002802.1896096-1-sashal@kernel.org>
 <20221013002802.1896096-8-sashal@kernel.org>
 <20221017124632.GA13227@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221017124632.GA13227@duo.ucw.cz>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 17, 2022 at 02:46:32PM +0200, Pavel Machek wrote:
> Hi!
> 
> > From: sunghwan jung <onenowy@gmail.com>
> > 
> > [ Upstream commit ad5dbfc123e6ffbbde194e2a4603323e09f741ee ]
> > 
> > This reverts commit 86d92f5465958752481269348d474414dccb1552,
> > which fix the timeout issue for "Samsung Fit Flash".
> > 
> > But the commit affects not only "Samsung Fit Flash" but also other usb
> > storages that use the same controller and causes severe performance
> > regression.
> > 
> >  # hdparm -t /dev/sda (without the quirk)
> >  Timing buffered disk reads: 622 MB in  3.01 seconds = 206.66 MB/sec
> > 
> >  # hdparm -t /dev/sda (with the quirk)
> >  Timing buffered disk reads: 220 MB in  3.00 seconds =  73.32 MB/sec
> > 
> > The commit author mentioned that "Issue was reproduced after device has
> > bad block", so this quirk should be applied when we have the timeout
> > issue with a device that has bad blocks.
> > 
> > We revert the commit so that we apply this quirk by adding kernel
> > paramters using a bootloader or other ways when we really need it,
> > without the performance regression with devices that don't have the
> > issue.
> 
> Re-introducing timeouts for users in middle of stable series... may
> not be nice. Is there better fix in a follow up to this that was not
> backported?

No.

thanks,

greg k-h

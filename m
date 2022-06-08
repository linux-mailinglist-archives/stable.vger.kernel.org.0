Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 060EE542F60
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 13:41:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231358AbiFHLkl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jun 2022 07:40:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238070AbiFHLkh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jun 2022 07:40:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5CE61DAF20;
        Wed,  8 Jun 2022 04:40:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A771617C9;
        Wed,  8 Jun 2022 11:40:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54458C34116;
        Wed,  8 Jun 2022 11:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654688434;
        bh=n5D9XtXzmQZHIoE+5WdbAl2UV0ec7Cnd3ASb4yhRwrY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jRN5gjHOgOZKPkmXRAZdvmYaxW/KrF2EgunPbQDl8pR9KUEHzHlB73EWKPqUfdHOa
         f791wemac3OA1Cu+D/0uNa1YP7ATeD6j6FpOwsxql4Y4O2gH5DrXkVGfP6UAb0J32V
         5EXpzjxAY/3OPp7vviievzvQZT38WFwxLfva5qQ8=
Date:   Wed, 8 Jun 2022 13:40:32 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Brian Norris <briannorris@chromium.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Sebastian Fricke <sebastian.fricke@collabora.com>,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.17 404/772] media: rkvdec: Stop overclocking the decoder
Message-ID: <YqCKsApEEwx3qeGp@kroah.com>
References: <20220607164948.980838585@linuxfoundation.org>
 <20220607165000.914511779@linuxfoundation.org>
 <Yp/BMw3niNfLjBVI@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yp/BMw3niNfLjBVI@google.com>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 07, 2022 at 02:20:51PM -0700, Brian Norris wrote:
> Hi,
> 
> On Tue, Jun 07, 2022 at 06:59:56PM +0200, Greg Kroah-Hartman wrote:
> > From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
> > 
> > [ Upstream commit 9998943f6dfc5d5472bfab2e38527fb6ba5e9da7 ]
> > 
> > While this overclock hack seems to work on some implementations
> > (some ChromeBooks, RockPi4) it also causes instability on other
> > implementations (notably LibreComputer Renegade, but there were more
> > reports in the LibreELEC project, where this has been removed). While
> > performance is indeed affected (tested with GStreamer), 4K playback
> > still works as long as you don't operate in lock step and keep at
> > least 1 frame ahead of time in the decode queue.
> > 
> > After discussion with ChromeOS members, it would seem that their
> > implementation indeed used to synchronously decode each frame, so
> > this hack was simply compensating for their code being less
> > efficient. In my opinion, this hack should not have been included
> > upstream.
> > 
> > Fixes: cd33c830448ba ("media: rkvdec: Add the rkvdec driver")
> > Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
> > Reviewed-by: Sebastian Fricke <sebastian.fricke@collabora.com>
> > Reviewed-by: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
> > Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> FWIW, I've noticed a problem that is uncovered by this patch, because
> the default clock rate is not currently acceptable all the time. See my
> fix here:
> 
> https://lore.kernel.org/all/20220607141535.1.Idafe043ffc94756a69426ec68872db0645c5d6e2@changeid/
> [PATCH] arm64: dts: rockchip: Assign RK3399 VDU clock rate
> 
> It might be nice if $subject patch could be delayed until the fix is in
> too. The 5.19 cycle is only in -rc1, after all.
> 
> (The same seems to apply for the 5.{18,15,10}.y series too.)

Thanks, will go drop this from all branches now.

greg k-h

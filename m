Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79E1560CA02
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 12:27:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbiJYK1F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 06:27:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232255AbiJYK0o (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 06:26:44 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0687F6D84C
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 03:24:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id AA7A1CE1D0B
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 10:24:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11D3FC433C1;
        Tue, 25 Oct 2022 10:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666693490;
        bh=aWhab37o0d58jbf51v4tfoUAve0ajDV+KieMDKAFO2k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=q0rc2kn+fdPBHOu8J9QheTBoaJ0A70wU65V7xvNXbWX9m5c/eTeCpyCBXyGcRlhua
         YlYmH+qZorvQ0RHD9MvDSJviJXj7QPrgrvwx2484CMg/jFHDLGvNvM+2SpMlSDtBPM
         Qxh8ISjiVi1oWd1N4tUUsplRf3Z0sDRcqb3OVnIo=
Date:   Tue, 25 Oct 2022 12:25:42 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Thomas Zimmermann <tzimmermann@suse.de>
Cc:     andreas.thalhammer@linux.com,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        Sasha Levin <sashal@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        ML dri-devel <dri-devel@lists.freedesktop.org>,
        Javier Martinez Canillas <javierm@redhat.com>
Subject: Re: [Regression] CPU stalls and eventually causes a complete system
 freeze with 6.0.3 due to "video/aperture: Disable and unregister sysfb
 devices via aperture helpers"
Message-ID: <Y1e5pondOG/ljf7M@kroah.com>
References: <bbf7afe7-6ed2-6708-d302-4ba657444c45@leemhuis.info>
 <668a8ffd-ffc7-e1cc-28b4-1caca1bcc3d6@suse.de>
 <958fd763-01b6-0167-ba6b-97cbd3bddcb6@leemhuis.info>
 <Y1Z2sq9RyEnIdixD@kroah.com>
 <51651c2e-3706-37d7-01e7-5d473a412850@suse.de>
 <70e16994-6f5b-d648-0848-2eb7e3ad641a@gmx.net>
 <ef862938-3e1a-5138-2bda-d10e9188f920@suse.de>
 <95953ffd-32db-62be-bbba-8d4a88cb1ca6@gmx.net>
 <2603b160-32cf-d2ae-d218-01e86d3d7ede@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2603b160-32cf-d2ae-d218-01e86d3d7ede@suse.de>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 25, 2022 at 11:21:57AM +0200, Thomas Zimmermann wrote:
> Hi
> 
> Am 25.10.22 um 10:45 schrieb Andreas Thalhammer:
> [...]
> > > Yeah, it's also part of a larger changeset. But I wouldn't want to
> > > backport all those changes either.
> > > 
> > > Attached is a simple patch for linux-stable that adds the necessary fix.
> > > If this still doesn't work, we should probably revert the problematic
> > > patch.
> > > 
> > > Please test the patch and let me know if it works.
> > 
> > 
> > Yes, this fixed the problem. I'm running 6.0.3 with your patch now, all
> > fine.
> 
> Thanks a lot for testing. If Greg doesn't already pick up the patch from
> this discussion, I'll send it to stable soonish; adding your Tested-by tag.

Please send it as a real patch.

thanks,

greg k-h

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79D7952FD63
	for <lists+stable@lfdr.de>; Sat, 21 May 2022 16:40:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355280AbiEUOkw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 May 2022 10:40:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231202AbiEUOkv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 21 May 2022 10:40:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F65BC5D;
        Sat, 21 May 2022 07:40:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F1BF9B80022;
        Sat, 21 May 2022 14:40:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 133D3C385A5;
        Sat, 21 May 2022 14:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653144047;
        bh=Z+EJAEeWaRR0EPfhpiHD0bZq+LhpCrhD3EDm2tLhqfU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qV+MaZslsub/l1lnAjC2Gmm56x00oPFkmue0Q4RO1P36ZRxT07FMsq81dk2+hFbeA
         KvlA4/A4NWwLuoYwmfD2OwB6tM6KUZf8uMbqLgaboXUlz9Wu6us6HXWjsBUhgDDaye
         zQs0YBoC0zEiLgjGWz6xt2I1CfTJB36bQSXLeYnw=
Date:   Sat, 21 May 2022 16:40:44 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     stable@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        Nishad Kamdar <nishadkamdar@gmail.com>,
        Christian =?iso-8859-1?Q?L=F6hle?= <CLoehle@hyperstone.com>,
        "open list:MULTIMEDIA CARD (MMC), SECURE DIGITAL (SD) AND..." 
        <linux-mmc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>, alcooperx@gmail.com,
        kdasu.kdev@gmail.com
Subject: Re: [PATCH stable 4.19 0/3] MMC timeout back ports
Message-ID: <Yoj57NDDiQblR5aT@kroah.com>
References: <20220517182211.249775-1-f.fainelli@gmail.com>
 <1392eba8-d869-aa1a-b154-cec870017115@gmail.com>
 <1892af53-5d83-ac8a-1180-970bf07e8889@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1892af53-5d83-ac8a-1180-970bf07e8889@gmail.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 19, 2022 at 12:04:59PM -0700, Florian Fainelli wrote:
> 
> 
> On 5/19/2022 10:38 AM, Florian Fainelli wrote:
> > 
> > 
> > On 5/17/2022 11:22 AM, Florian Fainelli wrote:
> > > These 3 commits from upstream allow us to have more fine grained control
> > > over the MMC command timeouts and this solves the following timeouts
> > > that we have seen on our systems across suspend/resume cycles:
> > > 
> > > [   14.907496] usb usb2: root hub lost power or was reset
> > > [   15.216232] usb 1-1: reset high-speed USB device number 2 using
> > > xhci-hcd
> > > [   15.485812] bcmgenet 8f00000.ethernet eth0: Link is Down
> > > [   15.525328] mmc1: error -110 doing runtime resume
> > > [   15.531864] OOM killer enabled.
> > > 
> > > Thanks!
> > 
> > Looks like I managed to introduce a build warning due to the unused
> > timeout variable, let me submit a fresher version for 4.19, 4.14 and
> > 4.9.
> 
> Only v4.19 and v4.14 required a v2, you can find both here:
> 
> https://lore.kernel.org/lkml/20220519184536.370540-1-f.fainelli@gmail.com/T/#t
> 
> https://lore.kernel.org/lkml/20220519190030.377695-1-f.fainelli@gmail.com/T/#t
> 
> Sorry about that, I will build with W=1 in the future to notice those set
> but unused variable warnings.

I've queued up the updates now, thanks.

greg k-h

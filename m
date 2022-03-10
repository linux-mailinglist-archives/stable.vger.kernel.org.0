Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE8044D4855
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 14:46:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242526AbiCJNq4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 08:46:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234363AbiCJNqz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 08:46:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B5F814EF72;
        Thu, 10 Mar 2022 05:45:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C8D5861AEA;
        Thu, 10 Mar 2022 13:45:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86F0AC340E8;
        Thu, 10 Mar 2022 13:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646919954;
        bh=ON3EKOjCzN7S0LPwoCmafxvqt4NOQsB1i5denEPJ74c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UNa0hWTV/aql92FGFyQ3YVazJmQ/6dKBErtPG4K4Ku6FcNOSKxfEPMtembehKGnd+
         7IThWHCu+5ibJARTp8Df3CAn09Zuw4Xc27wqGmWv5w4lTqc0dlt23IYiVua3oEBliY
         3/xJ+FTL6fmd2Av+3IY0wpCfsdNMUvVGlq6dzIZw=
Date:   Thu, 10 Mar 2022 14:45:50 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     Sasha Levin <sashal@kernel.org>, Stable <stable@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        "Thorsten Leemhuis (regressions address)" <regressions@leemhuis.info>
Subject: Re: Please revert commit 4287509b4d21e34dc492 from 5.16.y
Message-ID: <YioBDqqTjLc+XT19@kroah.com>
References: <CAJZ5v0gE52NT=4kN4MkhV3Gx=M5CeMGVHOF0jgTXDb5WwAMs_Q@mail.gmail.com>
 <YinyzxnSsty8BDKn@kroah.com>
 <CAJZ5v0ghFyFG3aDRawoVFDvhXLkvjZqiaPeqbtFnRQvhd9T_rA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJZ5v0ghFyFG3aDRawoVFDvhXLkvjZqiaPeqbtFnRQvhd9T_rA@mail.gmail.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 10, 2022 at 02:01:04PM +0100, Rafael J. Wysocki wrote:
> On Thu, Mar 10, 2022 at 1:45 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Thu, Mar 10, 2022 at 01:26:16PM +0100, Rafael J. Wysocki wrote:
> > > Hi Greg & Sasha,
> > >
> > > Commit 4287509b4d21e34dc492 that went into 5.16.y as a backport of
> > > mainline commit dc0075ba7f38 ("ACPI: PM: s2idle: Cancel wakeup before
> > > dispatching EC GPE") is causing trouble in 5.16.y, but 5.17-rc7
> > > including the original commit is fine.
> > >
> > > This is most likely due to some other changes that commit dc0075ba7f38
> > > turns out to depend on which have not been backported, but because it
> > > is not an essential fix (and it was backported, because it carried a
> > > Fixes tag and not because it was marked for backporting), IMV it is
> > > better to revert it from 5.16.y than to try to pull all of the
> > > dependencies in (and risk missing any of them), so please do that.
> > >
> > > Please see this thread:
> > >
> > > https://lore.kernel.org/linux-pm/31b9d1cd-6a67-218b-4ada-12f72e6f00dc@redhat.com/
> >
> > Odd that this is only showing up in 5.16 as this commit also is in 5.4
> > and 5.10 and 5.15.  Should I drop it from there as well?
> 
> It's better to do so, because these series are also likely to be
> missing the mainline commits it depends on.

Ok, will go do that now, thanks!

greg k-h

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5C4465360D
	for <lists+stable@lfdr.de>; Wed, 21 Dec 2022 19:21:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233664AbiLUSVU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Dec 2022 13:21:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbiLUSVT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Dec 2022 13:21:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E6873B2;
        Wed, 21 Dec 2022 10:21:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D042661865;
        Wed, 21 Dec 2022 18:21:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA442C433D2;
        Wed, 21 Dec 2022 18:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671646878;
        bh=udjfPL11jXrQj9nM0neEWSo/2zqyl2x/05MYY3HwOtE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BOTMrkqdWXzVeme80PEvYt6+KioA7zwIBMGfOwmdWb1bpZwqAJ2uArN34B6ozdfko
         hn9XS56erx3oqtJnmxZ6iIL23eZ1br9wiAQl6QuA901pVhiVCAIdXJR3rKPs4jgKcm
         XW9GGdpEbEvS9UA87B85WcbZdb6Xg+es3MQsSAWY=
Date:   Wed, 21 Dec 2022 19:21:15 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mathieu Chouquet-Stringer <me@mathieu.digital>
Cc:     stable@vger.kernel.org, rafael.j.wysocki@intel.com,
        linux-rtc@vger.kernel.org, linux-acpi@vger.kernel.org,
        rafael@kernel.org, mgorman@techsingularity.net,
        alexandre.belloni@bootlin.com
Subject: Re: Fix for rtc driver boot breakage in 6.0.y
Message-ID: <Y6NOm7CE03isRJiW@kroah.com>
References: <Y6D958DeurSuoCuY@paranoid-android>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y6D958DeurSuoCuY@paranoid-android>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 20, 2022 at 01:12:23AM +0100, Mathieu Chouquet-Stringer wrote:
> 	Hello stable team and Greg,
> 
> There are 3 commits in Linus' tree for the rtc driver which should be
> merged against stable 6.0.y (they're already in 6.1 / 6.1.y).
> 
> Without the first two, a x86-64 machine might panic during boot (Mel saw
> a 50% chance of panic at boot - 5 out of 10 tries - and my experience
> was identical).
> https://lore.kernel.org/linux-acpi/20221010141630.zfzi7mk7zvnmclzy@techsingularity.net/
> 
> And after applying the first two, the kernel will not compile anymore
> on non ACPI platform, so you need a third one.
> 
> The first two commits:
> 
> commit 4919d3eb2ec0ee364f7e3cf2d99646c1b224fae8
> Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Date:   Wed Oct 12 20:07:01 2022 +0200
> 
>     rtc: cmos: Fix event handler registration ordering issue
> 
> commit 0782b66ed2fbb035dda76111df0954515e417b24
> Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Date:   Tue Oct 18 18:09:31 2022 +0200
> 
>     rtc: cmos: Fix wake alarm breakage
> 
> And the third one:
> 
> commit db4e955ae333567dea02822624106c0b96a2f84f
> Author: Alexandre Belloni <alexandre.belloni@bootlin.com>
> Date:   Tue Oct 18 22:35:11 2022 +0200
> 
>     rtc: cmos: fix build on non-ACPI platforms

All of these are in 6.0.14, can you test that to verify it all is
working properly for you?

thanks,

greg k-h

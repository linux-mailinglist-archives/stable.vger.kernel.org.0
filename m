Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1B6B64A70B
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 19:25:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232753AbiLLSZO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 13:25:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232670AbiLLSY4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 13:24:56 -0500
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::228])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ECE11181C;
        Mon, 12 Dec 2022 10:24:54 -0800 (PST)
Received: (Authenticated sender: m@thi.eu.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 424E31BF208;
        Mon, 12 Dec 2022 18:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mathieu.digital;
        s=gm1; t=1670869493;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=V0ZgHua4dC/bgmtoYbtA31MvvXVVR4TJMj2l4TZnxys=;
        b=QWaaXatkqAJJXDt6Icf6xIhnJueAOXWemY5s7Qk3OAetyIxgM3msSMNxdASzRdlzbeBSTA
        mPPcpoQFddvUJpnaYEb5agoBdvJGDy32TI0SoswkE7pJA61TRsKMTnGxSUp0tZGjqcatPc
        ZHCXE0Lwh5vWKa4CZpJitN3zW2GGjdrkK7qsmA2tQYQzH6jC34cPOVjLmtnUq2q/tyLRpj
        S6n6ICHaFZpzeA7w0TdrasG+mcJZLSFzDs39ugUbAlXLphg8fZ7Xw6Fk77nozPwtfboVoK
        5e+wjflGNWoF/gNPzXxCRlUFgSzXUof31qP0DVzRx9yS/ZrYtog8W8vTJsWatA==
Received: by paranoid-android.localdomain (Postfix, from userid 1000)
        id 6FBFB40090F40; Mon, 12 Dec 2022 19:24:50 +0100 (CET)
Date:   Mon, 12 Dec 2022 19:24:50 +0100
From:   Mathieu Chouquet-Stringer <me@mathieu.digital>
To:     "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     Mel Gorman <mgorman@techsingularity.net>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-rtc@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        gregkh@linuxfoundation.org
Subject: Re: Intermittent boot failure after 6492fed7d8c9 (v6.0-rc1)
Message-ID: <Y5dx8pskqpaQU8kk@paranoid-android>
Mail-Followup-To: Mathieu Chouquet-Stringer <me@mathieu.digital>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-rtc@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        gregkh@linuxfoundation.org
References: <20221010141630.zfzi7mk7zvnmclzy@techsingularity.net>
 <CAJZ5v0j9JyDZupNnQUsTUVv0WapGjK7b5S-4ewZ8-b=HOret2Q@mail.gmail.com>
 <20221010174526.3yi7nziokwwpr63s@techsingularity.net>
 <CAJZ5v0je1dS4xSG46r64s8G5sJHjiziX92GBaKXaxueTim3wJA@mail.gmail.com>
 <20221011092050.gnh3dr5iqdvvrgs5@techsingularity.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221011092050.gnh3dr5iqdvvrgs5@techsingularity.net>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

	Hello Rafael,

On Tue, Oct 11, 2022 at 10:20:50AM +0100, Mel Gorman wrote:
> On Mon, Oct 10, 2022 at 08:29:05PM +0200, Rafael J. Wysocki wrote:
> > > That's less than the previous 5/10 failures but I
> > > cannot be certain it helped without running a lot more boot tests. The
> > > failure happens in the same function as before.
> > 
> > I've overlooked the fact that acpi_install_fixed_event_handler()
> > enables the event on success, so it is a bug to call it when the
> > handler is not ready.
> > 
> > It should help to only enable the event after running cmos_do_probe()
> > where the driver data pointer is set, so please try the attached
> > patch.

I'm hitting this issue on the 6.0 stable releases (aka 6.0.y) and
looking at the stable tree I see this hasn't been merged... I just got
bitten by this on 6.0.12.

Greg, if Rafael agrees, I think you should apply 4919d3eb2ec0 and
0782b66ed2fb to the 6.0.y tree.

Thank you in advance.

Cheers,

-- 
Mathieu Chouquet-Stringer                             me@mathieu.digital
            The sun itself sees not till heaven clears.
	             -- William Shakespeare --

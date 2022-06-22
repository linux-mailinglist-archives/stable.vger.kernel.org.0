Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C4D55550E3
	for <lists+stable@lfdr.de>; Wed, 22 Jun 2022 18:09:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359020AbiFVQJv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jun 2022 12:09:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359360AbiFVQJu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Jun 2022 12:09:50 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC1843EBB7;
        Wed, 22 Jun 2022 09:09:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2BEF7CE219B;
        Wed, 22 Jun 2022 16:09:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86B46C34114;
        Wed, 22 Jun 2022 16:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655914183;
        bh=kAJUQKppEoIEuCXZJo6Lx6630wsRWLVL8eIiaSTHZSo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EffYdwa+rzEC/Wcbnpd6pkinzaYOX8SuAocySolWYRb9OiFoIRBU+uKwWNUJv4FaA
         2UFnsTC0Xh4nbBcdee7hh62JF0bDThqC7Gv2gQFZOq57adJL0dWUwd6lV5lFOjUZju
         EtPpXXhFiDXSuCslNj/dsQ7bxxJMb4a24Znru2GY=
Date:   Wed, 22 Jun 2022 18:09:39 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Julian Haller <julian.haller@philips.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 1/2] hwmon: Introduce
 hwmon_device_register_for_thermal
Message-ID: <YrM+wxRWV+RFTfjY@kroah.com>
References: <20220622150234.GC1861763@roeck-us.net>
 <20220622153950.3001449-1-jhaller@bbl.ms.philips.com>
 <20220622154454.GA1864037@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220622154454.GA1864037@roeck-us.net>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 22, 2022 at 08:44:54AM -0700, Guenter Roeck wrote:
> On Wed, Jun 22, 2022 at 05:39:50PM +0200, Julian Haller wrote:
> > > On Wed, Jun 22, 2022 at 04:49:01PM +0200, Julian Haller wrote:
> > > > From: Guenter Roeck <linux@roeck-us.net>
> > > > 
> > > > [ upstream commit e5d21072054fbadf41cd56062a3a14e447e8c22b ]
> > > > 
> > > > The thermal subsystem registers a hwmon driver without providing
> > > > chip or sysfs group information. This is for legacy reasons and
> > > > would be difficult to change. At the same time, we want to enforce
> > > > that chip information is provided when registering a hwmon device
> > > > using hwmon_device_register_with_info(). To enable this, introduce
> > > > a special API for use only by the thermal subsystem.
> > > > 
> > > > Acked-by: Rafael J . Wysocki <rafael@kernel.org>
> > > > Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> > > 
> > > What is the point of applying those patches to the 5.4 kernel ?
> > > This was intended for use with new code, not for stable releases.
> > > 
> > > Guenter
> > 
> > The upstream commit ddaefa209c4ac791c1262e97c9b2d0440c8ef1d5 ("hwmon: Make chip
> > parameter for with_info API mandatory") was backported to the 5.4 kernel as
> > part of v5.4.198, see commit 1ec0bc72f5dab3ab367ae5230cf6f212d805a225. This
> > breaks the hwmon device registration in the thermal drivers as these two
> > patches here have been left out. We either need to include them as well or
> > revert the original commit.
> > 
> > I'm also not sure why the original commit found its way into the 5.4 stable
> > branch.
> > 
> 
> I had complained about this backport to other branches before. That patch
> was not a bug fix, it was neither intended nor marked for stable releases,
> and it should be reverted from all stable branches.

Yes, that's not right, let me go revert that.  Odd that it only went
into 4.19 and 5.4, I think Sasha's scripts went wonky there...

thanks,

greg k-h

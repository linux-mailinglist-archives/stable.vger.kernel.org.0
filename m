Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B89F07784F
	for <lists+stable@lfdr.de>; Sat, 27 Jul 2019 12:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728832AbfG0KvY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 27 Jul 2019 06:51:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:38308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725875AbfG0KvY (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 27 Jul 2019 06:51:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8313F2075C;
        Sat, 27 Jul 2019 10:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564224684;
        bh=DzM4H3u7OLbCY6a0MB4TM5xKh/mEPchjAjLVVKcHTuk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aCmqiLu0NnvrbRdYRHctT9VUChrEtsQBVv4w6xXulx7x5LfsVfLufF/6vbxB/LnNn
         Xjvjo4kkEJPtJjng50DvHYSEsjr3eVX1pUq+borYdaj4T/uLqsVul8HJbs6+DCMrEA
         9rG0hISS1Yri28IKQd/qX9f8TZ1Vx7i9LXoUrwUI=
Date:   Sat, 27 Jul 2019 12:51:21 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Furquan Shaikh <furquan@google.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 085/271] ACPICA: Clear status of GPEs on first
 direct enable
Message-ID: <20190727105121.GC32555@kroah.com>
References: <20190724191655.268628197@linuxfoundation.org>
 <20190724191702.469790760@linuxfoundation.org>
 <20190726175706.GB5945@xo-6d-61-c0.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190726175706.GB5945@xo-6d-61-c0.localdomain>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 26, 2019 at 07:57:06PM +0200, Pavel Machek wrote:
> On Wed 2019-07-24 21:19:14, Greg Kroah-Hartman wrote:
> > [ Upstream commit 44758bafa53602f2581a6857bb20b55d4d8ad5b2 ]
> > 
> > ACPI GPEs (other than the EC one) can be enabled in two situations.
> > First, the GPEs with existing _Lxx and _Exx methods are enabled
> > implicitly by ACPICA during system initialization.  Second, the
> > GPEs without these methods (like GPEs listed by _PRW objects for
> > wakeup devices) need to be enabled directly by the code that is
> > going to use them (e.g. ACPI power management or device drivers).
> > 
> > In the former case, if the status of a given GPE is set to start
> > with, its handler method (either _Lxx or _Exx) needs to be invoked
> > to take care of the events (possibly) signaled before the GPE was
> > enabled.  In the latter case, however, the first caller of
> > acpi_enable_gpe() for a given GPE should not be expected to care
> > about any events that might be signaled through it earlier.  In
> > that case, it is better to clear the status of the GPE before
> > enabling it, to prevent stale events from triggering unwanted
> > actions (like spurious system resume, for example).
> 
> Given the complexity of ACPI and number of implementations, I don't
> think this is safe for stable.

So it's better to have a regression later rather than sooner?

> Notebooks are not part of automated test farms, so it did not get
> nearly enough testing...

But by finding problems with a patch when it is closer to having been
created is always better than waiting 6+ months to find the issue then.

And if this patch does cause problems, we can easily revert it.

thanks,

greg k-h

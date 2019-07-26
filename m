Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7354E770B5
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 19:57:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727991AbfGZR5N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 13:57:13 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38160 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727516AbfGZR5M (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Jul 2019 13:57:12 -0400
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
        id B0A7980240; Fri, 26 Jul 2019 19:56:56 +0200 (CEST)
Date:   Fri, 26 Jul 2019 19:57:06 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Furquan Shaikh <furquan@google.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 085/271] ACPICA: Clear status of GPEs on first
 direct enable
Message-ID: <20190726175706.GB5945@xo-6d-61-c0.localdomain>
References: <20190724191655.268628197@linuxfoundation.org>
 <20190724191702.469790760@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190724191702.469790760@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed 2019-07-24 21:19:14, Greg Kroah-Hartman wrote:
> [ Upstream commit 44758bafa53602f2581a6857bb20b55d4d8ad5b2 ]
> 
> ACPI GPEs (other than the EC one) can be enabled in two situations.
> First, the GPEs with existing _Lxx and _Exx methods are enabled
> implicitly by ACPICA during system initialization.  Second, the
> GPEs without these methods (like GPEs listed by _PRW objects for
> wakeup devices) need to be enabled directly by the code that is
> going to use them (e.g. ACPI power management or device drivers).
> 
> In the former case, if the status of a given GPE is set to start
> with, its handler method (either _Lxx or _Exx) needs to be invoked
> to take care of the events (possibly) signaled before the GPE was
> enabled.  In the latter case, however, the first caller of
> acpi_enable_gpe() for a given GPE should not be expected to care
> about any events that might be signaled through it earlier.  In
> that case, it is better to clear the status of the GPE before
> enabling it, to prevent stale events from triggering unwanted
> actions (like spurious system resume, for example).

Given the complexity of ACPI and number of implementations, I don't
think this is safe for stable.

Notebooks are not part of automated test farms, so it did not get
nearly enough testing...

								Pavel

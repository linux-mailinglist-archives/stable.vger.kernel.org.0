Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 927AA314E80
	for <lists+stable@lfdr.de>; Tue,  9 Feb 2021 12:59:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbhBIL6V convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 9 Feb 2021 06:58:21 -0500
Received: from mail.fireflyinternet.com ([77.68.26.236]:52307 "EHLO
        fireflyinternet.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S229862AbhBIL4T (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Feb 2021 06:56:19 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.69.177;
Received: from localhost (unverified [78.156.69.177]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP (TLS) id 23821190-1500050 
        for multiple; Tue, 09 Feb 2021 11:55:16 +0000
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <f1070486-891a-8ec0-0390-b9aeb03178ce@redhat.com>
References: <fe6040b5-72a0-9882-439e-ea7fc0b3935d@redhat.com> <161282685855.9448.10484374241892252440@build.alporthouse.com> <f1070486-891a-8ec0-0390-b9aeb03178ce@redhat.com>
Subject: Re: [Intel-gfx] [5.10.y regression] i915 clear-residuals mitigation is causing gfx issues
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans de Goede <hdegoede@redhat.com>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        stable@vger.kernel.org
Date:   Tue, 09 Feb 2021 11:55:17 +0000
Message-ID: <161287171749.16732.2362289545256428747@build.alporthouse.com>
User-Agent: alot/0.9
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Hans de Goede (2021-02-09 11:46:46)
> Hi,
> 
> On 2/9/21 12:27 AM, Chris Wilson wrote:
> > Quoting Hans de Goede (2021-02-08 20:38:58)
> >> Hi All,
> >>
> >> We (Fedora) have been receiving reports from multiple users about gfx issues / glitches
> >> stating with 5.10.9. All reporters are users of Ivy Bridge / Haswell iGPUs and all
> >> reporters report that adding i915.mitigations=off to the cmdline fixes things, see:
> > 
> > I tried to reproduce this on the w/e on hsw-gt1, to no avail; and piglit
> > did not report any differences with and without mitigations. I have yet
> > to test other platforms. So I don't yet have an alternative.
> 
> Note the original / first reporter of:
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=1925346
> 
> Is using hsw-gt2, so it seems that the problem is not just the enabling of
> the mitigations on ivy-bridge / bay-trail but that there actually is
> a regression on devices where the WA worked fine before...
> 
> If you have access to a hsw-gt2 device then testing there might help?

The current one is headless, I'm trying to get a laptop with gt2 setup
again so that I can do more than test with piglit.

> Also note that this reproduces more easily on 5.10.10, which does not have:
> 
> 520d05a77b2866eb ("drm/i915/gt: Clear CACHE_MODE prior to clearing residuals")
> 
> Not sure if that helps though.

It gives a clue that it's still a problem with the pipe state. (Which is
believable as there can't be much else!)
-Chris

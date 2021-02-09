Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39D0C315A1C
	for <lists+stable@lfdr.de>; Wed, 10 Feb 2021 00:36:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234474AbhBIXdv convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 9 Feb 2021 18:33:51 -0500
Received: from mail.fireflyinternet.com ([77.68.26.236]:51115 "EHLO
        fireflyinternet.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S234775AbhBIXI7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Feb 2021 18:08:59 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.69.177;
Received: from localhost (unverified [78.156.69.177]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP (TLS) id 23827327-1500050 
        for multiple; Tue, 09 Feb 2021 23:07:34 +0000
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
Date:   Tue, 09 Feb 2021 23:07:36 +0000
Message-ID: <161291205642.6673.10994709665368036431@build.alporthouse.com>
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

There have been 3 crashes uploaded related to v5.10.9, and in all 3
cases the ACTHD has been in the first page. This strongly suggests that
the w/a is scribbling over address 0. And there's then a very good
chance that

commit 29d35b73ead4e41aa0d1a954c9bfbdce659ec5d6
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Mon Jan 25 12:50:33 2021 +0000

    drm/i915/gt: Always try to reserve GGTT address 0x0
    
    commit 489140b5ba2e7cc4b853c29e0591895ddb462a82 upstream.

in v5.10.14 is sufficient to hide the issue.
-Chris

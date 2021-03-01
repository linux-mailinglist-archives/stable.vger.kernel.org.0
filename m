Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8ABC328066
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 15:12:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236255AbhCAOLy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 09:11:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:50182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236253AbhCAOLG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 09:11:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6528D64D99;
        Mon,  1 Mar 2021 14:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614607816;
        bh=MpORY1LSS6duWPJ6gsbDFWyR60Ty4kPP2cIOqbGO5xE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EhiRmv9XuCYUsjCgHNTx9OZEKlrYso8t1YBo2T+GSndID3VDaP4GpDbIp+Rn1gi+o
         R+HUWULG4kDTQKcddGOAyx6U++EZpjGoxncBeFS7iDqr2aaKx+sW3tMNubFjFkcbvY
         GqoGg2FylKbs0OSHYauax4haOf2rbvpXrrxwwiQs=
Date:   Mon, 1 Mar 2021 15:10:13 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        stable@vger.kernel.org
Subject: Re: [Intel-gfx] [5.10.y regression] i915 clear-residuals mitigation
 is causing gfx issues
Message-ID: <YDz1xcbN050kIR6P@kroah.com>
References: <161282685855.9448.10484374241892252440@build.alporthouse.com>
 <f1070486-891a-8ec0-0390-b9aeb03178ce@redhat.com>
 <161291205642.6673.10994709665368036431@build.alporthouse.com>
 <02fd493c-957f-890d-d0ad-ebd4119f55f2@redhat.com>
 <161296131275.7731.862746142230006325@build.alporthouse.com>
 <8f550b67-2c7c-c726-09d1-dc8842152974@redhat.com>
 <161304059194.7731.17263409378570191651@build.alporthouse.com>
 <e00f5813-37c6-52e7-4fd3-691be9d062d9@redhat.com>
 <96614fc1-c92d-1532-fd92-beb19e490075@redhat.com>
 <YCqEs8FaSBukRcaZ@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YCqEs8FaSBukRcaZ@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 15, 2021 at 03:26:59PM +0100, Greg Kroah-Hartman wrote:
> On Sun, Feb 14, 2021 at 05:00:44PM +0100, Hans de Goede wrote:
> > Hi,
> > 
> > On 2/11/21 1:26 PM, Hans de Goede wrote:
> > > Hi,
> > > 
> > > On 2/11/21 11:49 AM, Chris Wilson wrote:
> > >> Quoting Hans de Goede (2021-02-11 10:36:13)
> > >>> Hi,
> > >>>
> > >>> On 2/10/21 1:48 PM, Chris Wilson wrote:
> > >>>> Quoting Hans de Goede (2021-02-10 10:37:19)
> > >>>>> Hi,
> > >>>>>
> > >>>>> On 2/10/21 12:07 AM, Chris Wilson wrote:
> > >>>>>> Quoting Hans de Goede (2021-02-09 11:46:46)
> > >>>>>>> Hi,
> > >>>>>>>
> > >>>>>>> On 2/9/21 12:27 AM, Chris Wilson wrote:
> > >>>>>>>> Quoting Hans de Goede (2021-02-08 20:38:58)
> > >>>>>>>>> Hi All,
> > >>>>>>>>>
> > >>>>>>>>> We (Fedora) have been receiving reports from multiple users about gfx issues / glitches
> > >>>>>>>>> stating with 5.10.9. All reporters are users of Ivy Bridge / Haswell iGPUs and all
> > >>>>>>>>> reporters report that adding i915.mitigations=off to the cmdline fixes things, see:
> > >>>>>>>>
> > >>>>>>>> I tried to reproduce this on the w/e on hsw-gt1, to no avail; and piglit
> > >>>>>>>> did not report any differences with and without mitigations. I have yet
> > >>>>>>>> to test other platforms. So I don't yet have an alternative.
> > >>>>>>>
> > >>>>>>> Note the original / first reporter of:
> > >>>>>>>
> > >>>>>>> https://bugzilla.redhat.com/show_bug.cgi?id=1925346
> > >>>>>>>
> > >>>>>>> Is using hsw-gt2, so it seems that the problem is not just the enabling of
> > >>>>>>> the mitigations on ivy-bridge / bay-trail but that there actually is
> > >>>>>>> a regression on devices where the WA worked fine before...
> > >>>>>>
> > >>>>>> There have been 3 crashes uploaded related to v5.10.9, and in all 3
> > >>>>>> cases the ACTHD has been in the first page. This strongly suggests that
> > >>>>>> the w/a is scribbling over address 0. And there's then a very good
> > >>>>>> chance that
> > >>>>>>
> > >>>>>> commit 29d35b73ead4e41aa0d1a954c9bfbdce659ec5d6
> > >>>>>> Author: Chris Wilson <chris@chris-wilson.co.uk>
> > >>>>>> Date:   Mon Jan 25 12:50:33 2021 +0000
> > >>>>>>
> > >>>>>>     drm/i915/gt: Always try to reserve GGTT address 0x0
> > >>>>>>     
> > >>>>>>     commit 489140b5ba2e7cc4b853c29e0591895ddb462a82 upstream.
> > >>>>>>
> > >>>>>> in v5.10.14 is sufficient to hide the issue.
> > >>>>>
> > >>>>> That one actually is already in v5.10.13 and the various reportes of these
> > >>>>> issues have already tested 5.10.13. They did mention that it took longer
> > >>>>> to reproduce with 5.10.13 then with 5.10.10, but that could also be due to:
> > >>>>>
> > >>>>> "drm/i915/gt: Clear CACHE_MODE prior to clearing residuals"
> > >>>>> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-5.10.y&id=520d05a77b2866eb4cb9e548e1d8c8abcfe60ec5
> > >>>>
> > >>>> Started looking for scratch page overwrites, and found this little gem:
> > >>>> https://patchwork.freedesktop.org/patch/420436/?series=86947&rev=1
> > >>>>
> > >>>> Looks promising wrt the cause of overwriting random addresses -- and
> > >>>> I hope that is the explanation for the glitches/hangs. I have a hsw gt2
> > >>>> with gnome shell, piglit is happy, but I suspect it is all due to
> > >>>> placement and so will only occur at random.
> > >>>
> > >>> If you can give me a list of commits to cherry-pick then I can prepare
> > >>> a Fedora 5.10.y kernel which those added for the group of Fedora users
> > >>> who are hitting this to test.
> > >>
> > >> e627d5923cae ("drm/i915/gt: One more flush for Baytrail clear residuals")
> > >> d30bbd62b1bf ("drm/i915/gt: Flush before changing register state")
> > >> 1914911f4aa0 ("drm/i915/gt: Correct surface base address for renderclear")
> > > 
> > > Thanks, the test-kernel is building now. I will let you know when I have
> > > heard back from the Fedora users (this will likely take 1-2 days).
> > 
> > I've heard back from 2 of the reporters who were seeing issues with 5.10.9+
> > 
> > And I'm happy to report 5.10.15 + the 3 commits mentioned above cherry-picked
> > on top fixes the graphics glitches for them.
> > 
> > So if we can get these 3 commits into 5.10.y and 5.11.y then this should be
> > resolved.
> 
> Great!
> 
> Hopefully these will show up in Linus's tree soon...

I think I have the needed 3 commits now.

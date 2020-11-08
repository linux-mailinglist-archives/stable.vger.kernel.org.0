Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E07C92AAB2C
	for <lists+stable@lfdr.de>; Sun,  8 Nov 2020 14:29:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728191AbgKHN3Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Nov 2020 08:29:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:53694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727570AbgKHN3Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Nov 2020 08:29:24 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7DD38206E3;
        Sun,  8 Nov 2020 13:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604842163;
        bh=2fuNWnZFhMYHn+mlUoDgFRyhbhGTH2+3c8D/L6OqfjQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JMVF6L28za6IHy+3j8AV02LS2sGiR6mFtBYBiC41kIK6tmFZWZ9bK9YJ3HzpOr0Pa
         ZV3Bn96MumHmCCxe/fRlYwOQupSjuA7U97gLipL231QNf1ybA2M9CAB3kaKkcmV7hf
         JtND4gck+tynudvPPG9BXGBeBqDZR1qvo93a7EPU=
Date:   Sun, 8 Nov 2020 08:29:22 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linu Cherian <lcherian@marvell.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: Re: Please consider reverting commit bb1860efc817 ("coresight: Make
 sysfs functional...") from v5.4.y
Message-ID: <20201108132922.GR2092@sasha-vm>
References: <5500643d-5813-d731-0181-bc57e6d33e5a@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <5500643d-5813-d731-0181-bc57e6d33e5a@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Nov 07, 2020 at 07:05:11PM -0800, Guenter Roeck wrote:
>Hi,
>
>I get the following build warning in v5.4.75.
>
>drivers/hwtracing/coresight/coresight-etm-perf.c: In function 'etm_setup_aux':
>drivers/hwtracing/coresight/coresight-etm-perf.c:226:37: warning:
>			passing argument 1 of 'coresight_get_enabled_sink' makes pointer from integer without a cast
>
>Actually, the warning is fatal, since the call is
>	sink = coresight_get_enabled_sink(true);
>However, the argument to coresight_get_enabled_sink() is now a pointer.
>The parameter change was introduced with commit 8fd52a21ab57
>("coresight: Make sysfs functional on topologies with per core sink").
>
>In the upstream kernel, the call is removed with commit bb1860efc817
>("coresight: etm: perf: Sink selection using sysfs is deprecated").
>That commit alone would, however, likely not solve the problem.
>It looks like at least two more commits would be needed.
>
>716f5652a131 coresight: etm: perf: Fix warning caused by etm_setup_aux failure
>8e264c52e1da coresight: core: Allow the coresight core driver to be built as a module
>39a7661dcf65 coresight: Fix uninitialised pointer bug in etm_setup_aux()
>
>Looking into the coresight code, I see several additional commits affecting
>the sysfs interface since v5.4. I have no idea what would actually be needed
>for stable code in v5.4.y, short of applying them all.
>
>With all this in mind, I would suggest to revert commit 8fd52a21ab57
>("coresight: Make sysfs functional on topologies with per core sink")
>from v5.4.y, especially since it is not marked as bug fix or for stable.

I'll revert it, thanks!

-- 
Thanks,
Sasha

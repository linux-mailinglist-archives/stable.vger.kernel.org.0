Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE20D5EF53
	for <lists+stable@lfdr.de>; Thu,  4 Jul 2019 00:58:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727021AbfGCW6h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jul 2019 18:58:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:34460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726902AbfGCW6h (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Jul 2019 18:58:37 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 621C021852;
        Wed,  3 Jul 2019 22:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562194715;
        bh=1hp6cqHg6/+eEOnsGalmXc7FaMl1emsGZU5kfEwo8Eg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KXx9MjjOeVtTQJbCYLUzCqj1nUXRRCiLRhO/ziDEv13/1+0VTlglf491so0DUU2ot
         LcLiC3sMQQjSpbljqIm1I/QxnBPfI63KIPCj7x+sWTGcYyPf/OTpNqPwSdb07nsuqi
         KlTk3VFhfiGTcovqyRbQEVJPVXDLva+NSJzv3HxM=
Date:   Wed, 3 Jul 2019 18:58:34 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Lucas De Marchi <lucas.demarchi@intel.com>
Cc:     Greg KH <greg@kroah.com>, stable@vger.kernel.org,
        intel-gfx@lists.freedesktop.org
Subject: Re: [PATCH stable-4.9+] drm/i915/dmc: protect against reading random
 memory
Message-ID: <20190703225834.GD10104@sasha-vm>
References: <20190702192304.31955-1-lucas.demarchi@intel.com>
 <20190703121416.GD7784@kroah.com>
 <20190703162403.yyejmv6al3f6bvn7@ldmartin-desk1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190703162403.yyejmv6al3f6bvn7@ldmartin-desk1>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 03, 2019 at 09:24:03AM -0700, Lucas De Marchi wrote:
>On Wed, Jul 03, 2019 at 02:14:16PM +0200, Greg KH wrote:
>>On Tue, Jul 02, 2019 at 12:23:04PM -0700, Lucas De Marchi wrote:
>>>commit bc7b488b1d1c71dc4c5182206911127bc6c410d6 upstream.
>>>
>>>While loading the DMC firmware we were double checking the headers made
>>>sense, but in no place we checked that we were actually reading memory
>>>we were supposed to. This could be wrong in case the firmware file is
>>>truncated or malformed.
>>>
>>>Before this patch:
>>>	# ls -l /lib/firmware/i915/icl_dmc_ver1_07.bin
>>>	-rw-r--r-- 1 root root  25716 Feb  1 12:26 icl_dmc_ver1_07.bin
>>>	# truncate -s 25700 /lib/firmware/i915/icl_dmc_ver1_07.bin
>>>	# modprobe i915
>>>	# dmesg| grep -i dmc
>>>	[drm:intel_csr_ucode_init [i915]] Loading i915/icl_dmc_ver1_07.bin
>>>	[drm] Finished loading DMC firmware i915/icl_dmc_ver1_07.bin (v1.7)
>>>
>>>i.e. it loads random data. Now it fails like below:
>>>	[drm:intel_csr_ucode_init [i915]] Loading i915/icl_dmc_ver1_07.bin
>>>	[drm:csr_load_work_fn [i915]] *ERROR* Truncated DMC firmware, rejecting.
>>>	i915 0000:00:02.0: Failed to load DMC firmware i915/icl_dmc_ver1_07.bin. Disabling runtime power management.
>>>	i915 0000:00:02.0: DMC firmware homepage: https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/tree/i915
>>>
>>>Before reading any part of the firmware file, validate the input first.
>>>
>>>Fixes: eb805623d8b1 ("drm/i915/skl: Add support to load SKL CSR firmware.")
>>>Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
>>>Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
>>>Link: https://patchwork.freedesktop.org/patch/msgid/20190605235535.17791-1-lucas.demarchi@intel.com
>>>(cherry picked from commit bc7b488b1d1c71dc4c5182206911127bc6c410d6)
>>>Signed-off-by: Jani Nikula <jani.nikula@intel.com>
>>>[ Lucas: backported to 4.9+ adjusting the context ]
>>>Cc: stable@vger.kernel.org # v4.9+
>>
>>What about a 4.14.y and 4.19.y backport as well?   I can't take this
>>without those as we do not want people to upgrade and have a regression.
>
>The documentation about stable process explicitely says the meaning of
>the tag is 'For each "-stable" tree starting with the specified
>version.'. I tried to make it clear by using the '+' suffix as I saw in
>other commits in stable tree.
>
>This patch applies cleanly to 4.9, 4.14 and 4.19. This commit is already
>applied in 5.1 as it didn't need any backport. That was the intention, let me
>know if that is not the proper way.
>
>The only missing stable is 4.4, but that needs more changes to the
>patch.

This works, I've queued it up for 4.9-4.19, thank you!

--
Thanks,
Sasha

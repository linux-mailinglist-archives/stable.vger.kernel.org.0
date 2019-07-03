Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD2505E8AE
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 18:24:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbfGCQYE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jul 2019 12:24:04 -0400
Received: from mga17.intel.com ([192.55.52.151]:33421 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726490AbfGCQYE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Jul 2019 12:24:04 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Jul 2019 09:24:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,446,1557212400"; 
   d="scan'208";a="174993022"
Received: from unknown (HELO ldmartin-desk1) ([10.24.8.246])
  by orsmga002.jf.intel.com with ESMTP; 03 Jul 2019 09:24:03 -0700
Date:   Wed, 3 Jul 2019 09:24:03 -0700
From:   Lucas De Marchi <lucas.demarchi@intel.com>
To:     Greg KH <greg@kroah.com>
Cc:     stable@vger.kernel.org, intel-gfx@lists.freedesktop.org
Subject: Re: [PATCH stable-4.9+] drm/i915/dmc: protect against reading random
 memory
Message-ID: <20190703162403.yyejmv6al3f6bvn7@ldmartin-desk1>
References: <20190702192304.31955-1-lucas.demarchi@intel.com>
 <20190703121416.GD7784@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190703121416.GD7784@kroah.com>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 03, 2019 at 02:14:16PM +0200, Greg KH wrote:
>On Tue, Jul 02, 2019 at 12:23:04PM -0700, Lucas De Marchi wrote:
>> commit bc7b488b1d1c71dc4c5182206911127bc6c410d6 upstream.
>>
>> While loading the DMC firmware we were double checking the headers made
>> sense, but in no place we checked that we were actually reading memory
>> we were supposed to. This could be wrong in case the firmware file is
>> truncated or malformed.
>>
>> Before this patch:
>> 	# ls -l /lib/firmware/i915/icl_dmc_ver1_07.bin
>> 	-rw-r--r-- 1 root root  25716 Feb  1 12:26 icl_dmc_ver1_07.bin
>> 	# truncate -s 25700 /lib/firmware/i915/icl_dmc_ver1_07.bin
>> 	# modprobe i915
>> 	# dmesg| grep -i dmc
>> 	[drm:intel_csr_ucode_init [i915]] Loading i915/icl_dmc_ver1_07.bin
>> 	[drm] Finished loading DMC firmware i915/icl_dmc_ver1_07.bin (v1.7)
>>
>> i.e. it loads random data. Now it fails like below:
>> 	[drm:intel_csr_ucode_init [i915]] Loading i915/icl_dmc_ver1_07.bin
>> 	[drm:csr_load_work_fn [i915]] *ERROR* Truncated DMC firmware, rejecting.
>> 	i915 0000:00:02.0: Failed to load DMC firmware i915/icl_dmc_ver1_07.bin. Disabling runtime power management.
>> 	i915 0000:00:02.0: DMC firmware homepage: https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/tree/i915
>>
>> Before reading any part of the firmware file, validate the input first.
>>
>> Fixes: eb805623d8b1 ("drm/i915/skl: Add support to load SKL CSR firmware.")
>> Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
>> Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
>> Link: https://patchwork.freedesktop.org/patch/msgid/20190605235535.17791-1-lucas.demarchi@intel.com
>> (cherry picked from commit bc7b488b1d1c71dc4c5182206911127bc6c410d6)
>> Signed-off-by: Jani Nikula <jani.nikula@intel.com>
>> [ Lucas: backported to 4.9+ adjusting the context ]
>> Cc: stable@vger.kernel.org # v4.9+
>
>What about a 4.14.y and 4.19.y backport as well?   I can't take this
>without those as we do not want people to upgrade and have a regression.

The documentation about stable process explicitely says the meaning of
the tag is 'For each "-stable" tree starting with the specified
version.'. I tried to make it clear by using the '+' suffix as I saw in
other commits in stable tree.

This patch applies cleanly to 4.9, 4.14 and 4.19. This commit is already
applied in 5.1 as it didn't need any backport. That was the intention, let me
know if that is not the proper way.

The only missing stable is 4.4, but that needs more changes to the
patch.

Lucas De Marchi

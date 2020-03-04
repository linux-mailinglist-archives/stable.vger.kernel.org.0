Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E54CF179687
	for <lists+stable@lfdr.de>; Wed,  4 Mar 2020 18:17:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726764AbgCDRRn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Mar 2020 12:17:43 -0500
Received: from mga07.intel.com ([134.134.136.100]:53019 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726561AbgCDRRn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Mar 2020 12:17:43 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Mar 2020 09:17:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,514,1574150400"; 
   d="scan'208";a="387225105"
Received: from hhartana-mobl3.amr.corp.intel.com (HELO [10.251.140.18]) ([10.251.140.18])
  by orsmga004.jf.intel.com with ESMTP; 04 Mar 2020 09:17:41 -0800
Subject: Re: 5.5.y - apply "ASoC: intel/skl/hda - export number of digital
 microphones via control components"
To:     Mark Brown <broonie@kernel.org>, Jaroslav Kysela <perex@perex.cz>
Cc:     Sasha Levin <sashal@kernel.org>, Takashi Iwai <tiwai@suse.de>,
        ALSA development <alsa-devel@alsa-project.org>,
        stable@vger.kernel.org
References: <147efa37-eb57-7f17-b9eb-84a9fe5ad475@perex.cz>
 <20200304154450.GB5646@sirena.org.uk>
 <a6d57c14-0794-77d0-5c6f-c0c897d254b5@perex.cz>
 <20200304160916.GC5646@sirena.org.uk>
From:   Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Message-ID: <44cf4ff8-120f-79fd-8801-47807b03f912@linux.intel.com>
Date:   Wed, 4 Mar 2020 11:17:41 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200304160916.GC5646@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


>>> This looks more like a new feature than a bug fix and I've been trying
>>> to get the stable people to calm down with the backports, there's been
>>> *far* too many regressions introduced recently in just the x86 stuff
>>> found after the fact.  Does this fix systems that used to work?
> 
>> The released ALSA UCM does not work correctly for some platforms without
>> this information (the number of digital microphones is not identified
>> correctly).
> 
> That's not the question I asked - have these platforms ever worked with
> older kernel versions?

Yes in that digital microphones have been enabled for a very long time 
(5.2 if I am not mistaken).

No in that the automatic selection of the SOF driver was only enabled 
for v5.5. In other words before 5.5 the user or distro needed to 
blacklist the legacy snd-hda-intel HDAudio driver to get DMICs to work.

This patch also removes the need for userspace configuration, pulseaudio 
now directly receives the information on the number of microphones. It 
was provided days after the merge window was opened, but the intent was 
that v5.5 was the first release where users don't need to muck with 
configuration files.

>> The regression probability is really low for this one and we're using it in
>> Fedora kernels for months without issues (in this code).
> 
> It's partly the principle of the thing, if it were just patches that
> had individually been identified as being good for stable by someone
> with some understanding of the code (like this one :/ ) that were being
> backported I'd be a lot less concerned but the automated selections are
> missing dependencies or other context and people are reporting problems
> with them so I'm inclined to push back on things.

You are correct that the process can appear confusing, mainly since the 
initial patch was contributed after the merge window on November 26.

Looking back at the emails, I didn't see any objections but somehow the 
patch never landed in 5.5 updates. Jaroslav's intentions and work are 
not without merit, we really appreciate his ucm2 work, and I support 
this integration on v5.5-y to make the life of downstream distros simpler.

Would it help if we provide a Tested-by tag with 5.5-y + this patch applied?

Thanks
-Pierre

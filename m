Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0558D63EBF0
	for <lists+stable@lfdr.de>; Thu,  1 Dec 2022 10:05:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbiLAJF1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Dec 2022 04:05:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230052AbiLAJFK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Dec 2022 04:05:10 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D38BE950DC;
        Thu,  1 Dec 2022 01:04:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669885444; x=1701421444;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=v7Pv5GvsnRCoGfNqd6OZfahTWZAr3UlME0JbK+tDt9s=;
  b=DA08p0n9uVxZMCkESGFwwRe2HY6LAJ6JhhDyYO9i5wnfrQSJuNNgbCDX
   CS5ZNeJp4tlPMQoHjiCLQV9LHnLILr5UsS4AXD9GaMRnmDOkbH9VLIEBt
   Zp9R2/xDJCUCvqSGgb7XdL6NV5kH+st9Lva7IZxtyigqUL84OGKJTVsBa
   mT4d4oyn3VlVCj9C6n1VEZCdwL8yBjPR3woUvLQadEuonrYn4ByPgYezy
   PzADqv1GaAVg7r2yxQbJ15IGO/i7OiwnWeqV7/4oAfo87hRYXO9YZgD4E
   Ugw5TU0Kn8ACI3THh97uegQ0EDR3HhBmbHWVvZ7wQ9WTDiWWeDTtFKNwB
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="317492464"
X-IronPort-AV: E=Sophos;i="5.96,209,1665471600"; 
   d="scan'208";a="317492464"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 01:04:04 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="750716088"
X-IronPort-AV: E=Sophos;i="5.96,209,1665471600"; 
   d="scan'208";a="750716088"
Received: from eliteleevi.tm.intel.com ([10.237.54.20])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 01:03:59 -0800
Date:   Thu, 1 Dec 2022 11:03:46 +0200 (EET)
From:   Kai Vehmanen <kai.vehmanen@linux.intel.com>
X-X-Sender: kvehmane@eliteleevi.tm.intel.com
To:     Ricardo Ribalda <ribalda@chromium.org>
cc:     Steven Rostedt <rostedt@goodmis.org>,
        Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Chromeos Kdump <chromeos-kdump@google.com>,
        Mark Brown <broonie@kernel.org>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Eric Biederman <ebiederm@xmission.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Daniel Baluta <daniel.baluta@nxp.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Takashi Iwai <tiwai@suse.com>,
        Alsa-devel <alsa-devel@alsa-project.org>,
        sound-open-firmware@alsa-project.org, kexec@lists.infradead.org,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 2/2] ASoC: SOF: Fix deadlock when shutdown a frozen
 userspace
In-Reply-To: <20221127-snd-freeze-v7-2-127c582f1ca4@chromium.org>
Message-ID: <alpine.DEB.2.22.394.2212011053540.3532114@eliteleevi.tm.intel.com>
References: <20221127-snd-freeze-v7-0-127c582f1ca4@chromium.org> <20221127-snd-freeze-v7-2-127c582f1ca4@chromium.org>
User-Agent: Alpine 2.22 (DEB 394 2020-01-19)
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7 02160 Espoo
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Wed, 30 Nov 2022, Ricardo Ribalda wrote:

> During kexec(), the userspace might frozen. Therefore we cannot wait
> for it to complete.
[...]
> --- a/sound/soc/sof/core.c
> +++ b/sound/soc/sof/core.c
> @@ -9,6 +9,7 @@
>  //
>  
>  #include <linux/firmware.h>
> +#include <linux/kexec.h>
>  #include <linux/module.h>
>  #include <sound/soc.h>
>  #include <sound/sof.h>
> @@ -484,7 +485,8 @@ int snd_sof_device_shutdown(struct device *dev)
>  	 * make sure clients and machine driver(s) are unregistered to force
>  	 * all userspace devices to be closed prior to the DSP shutdown sequence
>  	 */
> -	sof_unregister_clients(sdev);
> +	if (!kexec_with_frozen_processes())
> +		sof_unregister_clients(sdev);
>  
>  	snd_sof_machine_unregister(sdev, pdata);

I think the case you hit was specifically snd_card_disconnect_sync() that 
gets called via snd_sof_machine_unregister(), right, so you'd have to skip 
both sof_unregister_clients() and the machine_unregister().

Skipping ok might be an ok solution here. There's clearly a problem and we 
cannot just drop these calls in the general case (when we are going to 
S5), but in the specific case of kexec, this is probably safe. And I agree 
one way or another this needs to be fixed. Pierre and others what do you 
think?

Br, Kai

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 534DD63D9F7
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 16:54:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbiK3PyV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 10:54:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbiK3PyU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 10:54:20 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D75DA2A72C;
        Wed, 30 Nov 2022 07:54:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669823658; x=1701359658;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=DepN27OpZlgbeuoWYTFKVyj3/uCClQNbsv2Ccqz0OMY=;
  b=OfkKdhxwp/ckCGTp+r1d6/HaY142BY09V3qmHGM+wlO1fwJgmgfaqmnO
   uEHi4BVhG7UqdzqtPiKk8XuLYLik4Y1gUOtlngzl8t/EqaVtWFvxHeR8W
   +tW3VtR3yiFR1DACYOpiDaDsu52h0qZYbUz1bx9M/FmVGnf3rX39pJXBG
   2u+0uzK9hucjwpK+zdmE5yMTlGcA7TfdUEQ4USD+2rNuN2WcR9hSGXd+C
   ajw296e0haL2WnMQgIT2GMVXWr3FG3nIfLMt3y1R2lm4/Lemg7B2+El0p
   dqK3RFBIDWWUk3LwroAiKpG+vqPIqwbEp8j+dMNzu+8gOCpYc+70w1jN4
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="295126301"
X-IronPort-AV: E=Sophos;i="5.96,206,1665471600"; 
   d="scan'208";a="295126301"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 07:54:14 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="707693261"
X-IronPort-AV: E=Sophos;i="5.96,206,1665471600"; 
   d="scan'208";a="707693261"
Received: from schaud2-mobl1.amr.corp.intel.com (HELO [10.209.164.68]) ([10.209.164.68])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 07:54:12 -0800
Message-ID: <62a3dbbd-3144-d560-17de-cada6a34502b@linux.intel.com>
Date:   Wed, 30 Nov 2022 09:54:11 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.4.2
Subject: Re: [PATCH v6 2/2] ASoC: SOF: Fix deadlock when shutdown a frozen
 userspace
Content-Language: en-US
To:     Ricardo Ribalda <ribalda@chromium.org>,
        Chromeos Kdump <chromeos-kdump@google.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Eric Biederman <ebiederm@xmission.com>,
        Daniel Baluta <daniel.baluta@nxp.com>,
        Mark Brown <broonie@kernel.org>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
        Takashi Iwai <tiwai@suse.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, kexec@lists.infradead.org,
        sound-open-firmware@alsa-project.org
References: <20221127-snd-freeze-v6-0-3e90553f64a5@chromium.org>
 <20221127-snd-freeze-v6-2-3e90553f64a5@chromium.org>
From:   Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
In-Reply-To: <20221127-snd-freeze-v6-2-3e90553f64a5@chromium.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 11/30/22 09:47, Ricardo Ribalda wrote:
> During kexec(), the userspace is frozen. Therefore we cannot wait for it
> to complete.
> 
> Avoid running snd_sof_machine_unregister during shutdown.

That's not what you are doing below - you only unregister clients
conditionally.

I don't know if that's a stale commit message and can't reconcile it
either with the initial discussions in this thread where we were
referring to snd_card_disconnect(), etc?

Confused.

> @@ -484,7 +485,8 @@ int snd_sof_device_shutdown(struct device *dev)
>  	 * make sure clients and machine driver(s) are unregistered to force
>  	 * all userspace devices to be closed prior to the DSP shutdown sequence
>  	 */
> -	sof_unregister_clients(sdev);
> +	if (!kexec_with_frozen_processes())
> +		sof_unregister_clients(sdev);
>  
>  	snd_sof_machine_unregister(sdev, pdata);
>  
> 

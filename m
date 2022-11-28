Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 224F063AB4C
	for <lists+stable@lfdr.de>; Mon, 28 Nov 2022 15:42:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231975AbiK1Ol7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Nov 2022 09:41:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232636AbiK1Olx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Nov 2022 09:41:53 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F0541B7A0;
        Mon, 28 Nov 2022 06:41:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669646512; x=1701182512;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=yns+R2HE+8EQwUjsmVT40C2yEbZABretYQlqqfAW/0c=;
  b=Se/4FnUonha0Ujk70F8pZdiJLqT3UNDmFVQ1jBSaF9dKYeRk6Iz5Msy4
   XcnMdvXphj1VjQVzP3bPd0g+rp0haDjUlA2EPvg74h5cW1e2jv1+zgruw
   Q0zuEhYoiYPwhC3xR3WKRkPtSuDBFoIlt8x9sWyqt4rVYbp/b19MWQeKv
   hkK8/yQJr0VNn6SZPe+0Q4c4Hna6xPdU5LxCJE2dylxC1JVMQ3tjPxnMw
   bqZNvhdwCMt1SGuN6adRH0j8JoVcggUxwkZxSui/kk9/PHRhwbZ1yv/GE
   cQUZ3J0pHPJzYPJ4IxpKQ/RpKy/hyKuKSEuNK7elnpA9XsG3UqRbhOUTU
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="295232811"
X-IronPort-AV: E=Sophos;i="5.96,200,1665471600"; 
   d="scan'208";a="295232811"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 06:41:52 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="972284888"
X-IronPort-AV: E=Sophos;i="5.96,200,1665471600"; 
   d="scan'208";a="972284888"
Received: from eliteleevi.tm.intel.com ([10.237.54.20])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 06:41:49 -0800
Date:   Mon, 28 Nov 2022 16:41:33 +0200 (EET)
From:   Kai Vehmanen <kai.vehmanen@linux.intel.com>
X-X-Sender: kvehmane@eliteleevi.tm.intel.com
To:     Ricardo Ribalda <ribalda@chromium.org>
cc:     Liam Girdwood <lgirdwood@gmail.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Daniel Baluta <daniel.baluta@nxp.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Alsa-devel <alsa-devel@alsa-project.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        sound-open-firmware@alsa-project.org
Subject: Re: [PATCH v5] ASoC: SOF: Fix deadlock when shutdown a frozen
 userspace
In-Reply-To: <20221127-snd-freeze-v5-0-4ededeb08ba0@chromium.org>
Message-ID: <alpine.DEB.2.22.394.2211281629120.3532114@eliteleevi.tm.intel.com>
References: <20221127-snd-freeze-v5-0-4ededeb08ba0@chromium.org>
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

On Mon, 28 Nov 2022, Ricardo Ribalda wrote:

> During kexec(), the userspace is frozen. Therefore we cannot wait for it
> to complete.
> 
> Avoid running snd_sof_machine_unregister during shutdown.
[...]
>  	/*
> -	 * make sure clients and machine driver(s) are unregistered to force
> -	 * all userspace devices to be closed prior to the DSP shutdown sequence
> +	 * make sure clients are unregistered prior to the DSP shutdown
> +	 * sequence.
>  	 */
>  	sof_unregister_clients(sdev);
>  
> -	snd_sof_machine_unregister(sdev, pdata);
> -
>  	if (sdev->fw_state == SOF_FW_BOOT_COMPLETE)

this is problematic as removing that machine_unregister() call will (at 
least) bring back an issue on Intel platforms (rare problem hitting S5 on 
Chromebooks).

Not sure how to solve this, but if that call needs to be removed 
(unsafe to call at shutdown), then we need to rework how SOF 
does the cleanup.

Br, Kai

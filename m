Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22AEF63BFCD
	for <lists+stable@lfdr.de>; Tue, 29 Nov 2022 13:12:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230364AbiK2MMQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Nov 2022 07:12:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232401AbiK2MMN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Nov 2022 07:12:13 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBDD6CC2;
        Tue, 29 Nov 2022 04:12:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669723932; x=1701259932;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=syqkRepxkIQCwrzgin/klTRI4EpfJPD3DQtz+X7x25E=;
  b=bHjzGPLPuuE102pEZ/tMGMhL0TWBaY83o6s+GfGLYVhA3mOuZ0p6aq8Y
   0/CvnLGxcMOQCnGPBtBuqdmoRTfTkmkXUQSfLamSy+a2KxLxrl/xfWOWT
   HsaHhg2cg9q14I5OM4LK41s/JMkhnJ4dkB+rUXf5YLMaQhkY4UZxEymPV
   Wz2L/EzICr/3zE4i/l0Q2qhCGNiCZ34CO5+7Y/D16qTkJ8NyKTwlebR+V
   KHJB95I4mRTIfS9TAU825tZe0jpV9EIvcTFvaiXRIFelzkrxz4tOzK0xA
   1PEfVjaeFUvdQ6BiV1wROozLTjmWmfmFRPNHoHMv5/VzyDt2UYV0IkPwh
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="313794974"
X-IronPort-AV: E=Sophos;i="5.96,203,1665471600"; 
   d="scan'208";a="313794974"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Nov 2022 04:11:52 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="712349561"
X-IronPort-AV: E=Sophos;i="5.96,203,1665471600"; 
   d="scan'208";a="712349561"
Received: from eliteleevi.tm.intel.com ([10.237.54.20])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Nov 2022 04:11:49 -0800
Date:   Tue, 29 Nov 2022 14:11:34 +0200 (EET)
From:   Kai Vehmanen <kai.vehmanen@linux.intel.com>
X-X-Sender: kvehmane@eliteleevi.tm.intel.com
To:     Takashi Iwai <tiwai@suse.de>
cc:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        alsa-devel@alsa-project.org,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
        Takashi Iwai <tiwai@suse.com>, stable@vger.kernel.org,
        Mark Brown <broonie@kernel.org>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Ricardo Ribalda <ribalda@chromium.org>,
        Daniel Baluta <daniel.baluta@nxp.com>,
        linux-kernel@vger.kernel.org, sound-open-firmware@alsa-project.org
Subject: Re: [PATCH v4] ALSA: core: Fix deadlock when shutdown a frozen
 userspace
In-Reply-To: <87edtmqjtd.wl-tiwai@suse.de>
Message-ID: <alpine.DEB.2.22.394.2211291355350.3532114@eliteleevi.tm.intel.com>
References: <20221127-snd-freeze-v4-0-51ca64b7f2ab@chromium.org> <5171929e-b750-d2f1-fec9-b34d76c18dcb@linux.intel.com> <87mt8bqaca.wl-tiwai@suse.de> <16ddcbb9-8afa-ff18-05f9-2e9e01baf3ea@linux.intel.com> <87edtmqjtd.wl-tiwai@suse.de>
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

Hi

On Tue, 29 Nov 2022, Takashi Iwai wrote:

> On Mon, 28 Nov 2022 18:26:03 +0100, Pierre-Louis Bossart wrote:
> > As Kai mentioned it, this step helped with a S5 issue earlier in 2022.
> > Removing this will mechanically bring the issue back and break other
> > Chromebooks.
> 
> Yeah I don't mean that this fix is right, either.  But the earlier fix
> has apparently a problem and needs another fix.
> 
> Though, it's not clear why the full unregister of clients is needed at
> the first place; judging only from the patch description of commit
> 83bfc7e793b5, what we want is only to shut up the further user space
> action?  If so, just call snd_card_disconnect() would suffice?

I think the snd_card_disconnect() is what we are looking after here, but 
it's just easiest to do via unregister in SOF as that will trigger will 
look up the platform device, unregister it, and it eventually the driver 
owning the card will do the disconnect. Possibility for sure to do a more
direct implementation and not run the full unregister.

On the other end of the solution spectrum, we had this alternative to let 
user-space stay connected and just have the DSP implementations handle 
any pending work in their respective shutdown handlers. I.e. we had
"ASoC: SOF: Intel: pci-tgl: unblock S5 entry if DMA stop has failed"
https://github.com/thesofproject/linux/pull/3388

This was eventually dropped (and never sent upstream) as 83bfc7e793b5 got 
the same result, and covered all SOF platforms with a single code path.
Bringing this back is of course one option, but then this might suprise 
other platforms (which might have got used to user-space getting 
disconnected at shutdown via 83bfc7e793b5).

Br, Kai

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED6F965D2CD
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 13:35:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234944AbjADMft (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 07:35:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239191AbjADMfo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 07:35:44 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98ED21AD90;
        Wed,  4 Jan 2023 04:35:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672835741; x=1704371741;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=rkt4l1r96Awe0yuVnI/8AUblpAdT+5P6KOwt66+7u6c=;
  b=jkh+gXfOAF3MwivD5vCCy8STVKUuJpI+1GiEneh487zqJLxwMMZ9XL0I
   Jku4Hu0mpTtKBaRhTLuIhyJGVUGZdkBkuGgof4s5g4PK1ghSqrhmAoc9+
   5h8BUKJcPMTCrc0eZ3XzSpBGXkTZC1JRZQE21B90yk6R0xxcvOTp+irtA
   Gsazsu/gciplF3Y1VyoJ6yaPL+Wpvu7yleF2YyPH+jVwXY7ewmyNdle1b
   LTh/tGUYBFAL3nYzOALqq5eh+gEtoQh6j5j5hx3tKoxvEf8UNTH9P3nio
   6MOGIJls+VId6T4QYvvAbtzLggqao8p8r3nw8aSaz651RAy/q0lVkroW2
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10579"; a="384214959"
X-IronPort-AV: E=Sophos;i="5.96,299,1665471600"; 
   d="scan'208";a="384214959"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2023 04:35:41 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10579"; a="779195620"
X-IronPort-AV: E=Sophos;i="5.96,299,1665471600"; 
   d="scan'208";a="779195620"
Received: from eliteleevi.tm.intel.com ([10.237.54.20])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2023 04:35:37 -0800
Date:   Wed, 4 Jan 2023 14:34:55 +0200 (EET)
From:   Kai Vehmanen <kai.vehmanen@linux.intel.com>
X-X-Sender: kvehmane@eliteleevi.tm.intel.com
To:     Sasha Levin <sashal@kernel.org>
cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Ricardo Ribalda <ribalda@chromium.org>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        =?ISO-8859-15?Q?P=E9ter_Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Mark Brown <broonie@kernel.org>, lgirdwood@gmail.com,
        yung-chuan.liao@linux.intel.com, daniel.baluta@nxp.com,
        Jaroslav Kysela <perex@perex.cz>, tiwai@suse.com,
        sound-open-firmware@alsa-project.org,
        Alsa-devel <alsa-devel@alsa-project.org>
Subject: Re: [PATCH AUTOSEL 6.1 1/7] ASoC: SOF: Revert: "core: unregister
 clients and machine drivers in .shutdown"
In-Reply-To: <20221231200439.1748686-1-sashal@kernel.org>
Message-ID: <alpine.DEB.2.22.394.2301041427580.3532114@eliteleevi.tm.intel.com>
References: <20221231200439.1748686-1-sashal@kernel.org>
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

On Sat, 31 Dec 2022, Sasha Levin wrote:

> From: Kai Vehmanen <kai.vehmanen@linux.intel.com>
> 
> [ Upstream commit 44fda61d2bcfb74a942df93959e083a4e8eff75f ]
> 
> The unregister machine drivers call is not safe to do when
> kexec is used. Kexec-lite gets blocked with following backtrace:

this should be picked together with commit 2aa2a5ead0e ("ASoC: SOF: Intel: 
pci-tgl: unblock S5 entry if DMA stop has failed"), to not bring back old 
bugs (system failures to enter S5 on shutdown). The revert patch 
unfortunately fails to mention this dependency.

If I'm too late with my reply, I can send the second patch separately to 
stable.

Br, Kai

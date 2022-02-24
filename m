Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EF2B4C344D
	for <lists+stable@lfdr.de>; Thu, 24 Feb 2022 19:06:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231608AbiBXSGN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Feb 2022 13:06:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbiBXSGM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Feb 2022 13:06:12 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66C49270252;
        Thu, 24 Feb 2022 10:05:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645725942; x=1677261942;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=hxBAdTR0owOoMKt0GpG1ZgSex/03IjMwvi0Jz7GXfd8=;
  b=EGOnyT8tOl/v9zJVaF1UoHGTHd5I5TdNF0SO4VVeG7Nv6aL52l4z1Mxt
   rpS5wvqV2FO5z2sRL6Zt8MO1hG3IzbU2upacbE9EyKMWxs5uiYdQ/flN4
   lKROVaO9iSNt3LLr7nBpOCriTax2dnCogiYgqq91w5XxsEvbADVKlJuk6
   Lw0yB6VrAWknR95AG6JimIt1p9UlqzvdIhNQDqxUrBF/C3s5DIaGETbXu
   k9ojEFXcIAEO/+cZla5qMqzAXrpLYSW9z/MbLVJUi27V6vNvh+8DdustJ
   UpnEQE94C2Q0FykwrDCQTc2d2ZCvZ1clzelV5dPSHp7tmCkZfFIUn/OPV
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10268"; a="252039190"
X-IronPort-AV: E=Sophos;i="5.90,134,1643702400"; 
   d="scan'208";a="252039190"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2022 10:05:42 -0800
X-IronPort-AV: E=Sophos;i="5.90,134,1643702400"; 
   d="scan'208";a="533236249"
Received: from ronakmeh-mobl1.amr.corp.intel.com (HELO [10.212.97.131]) ([10.212.97.131])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2022 10:05:40 -0800
Message-ID: <04e79b9c-ccb1-119a-c2e2-34c8ca336215@linux.intel.com>
Date:   Thu, 24 Feb 2022 12:05:30 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.5.0
Subject: Re: [PATCH] ASoC: SOF: Intel: Fix NULL ptr dereference when ENOMEM
Content-Language: en-US
To:     =?UTF-8?Q?P=c3=a9ter_Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Mark Brown <broonie@kernel.org>
Cc:     alsa-devel@alsa-project.org,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Rander Wang <rander.wang@intel.com>,
        linux-kernel@vger.kernel.org, Takashi Iwai <tiwai@suse.com>,
        Keyon Jie <yang.jie@linux.intel.com>, stable@vger.kernel.org,
        Liam Girdwood <lgirdwood@gmail.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Daniel Baluta <daniel.baluta@nxp.com>,
        sound-open-firmware@alsa-project.org
References: <20220224145124.15985-1-ammarfaizi2@gnuweeb.org>
 <cfe9e583-e20a-f1d6-2a81-2538ca3ca054@linux.intel.com>
From:   Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
In-Reply-To: <cfe9e583-e20a-f1d6-2a81-2538ca3ca054@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


>> From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
>>
>> Do not call snd_dma_free_pages() when snd_dma_alloc_pages() returns
>> -ENOMEM because it leads to a NULL pointer dereference bug.
> 
> Reviewed-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

Thanks for this patch. looks good and tested by our CI, so

Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>



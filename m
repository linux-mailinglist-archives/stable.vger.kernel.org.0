Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC0D66C8594
	for <lists+stable@lfdr.de>; Fri, 24 Mar 2023 20:06:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230196AbjCXTGK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Mar 2023 15:06:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230079AbjCXTGJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Mar 2023 15:06:09 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5224E1A642
        for <stable@vger.kernel.org>; Fri, 24 Mar 2023 12:05:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679684729; x=1711220729;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=X9n+yet3Mi5pd0MngLxWhEELp+DUWqRTDu9B5UBwZKc=;
  b=TvKD7vlV4WRV/a+qz4dACLIATghGdGEFyR0g7YKe0hTjWZqx/x4N5zLO
   VuCOPLES14AYPXhlkFkVd7J9uMm6fwltEx5XslPZT2wUrU0zgJOJBGQ0F
   AlFWzotTukQwIQRpbTVHgrIYUfBfKcb77aSjV0Q8LEK6VjZ+zhec+0xad
   qMueR2zr7ZI/EAzhamDk6zY4+0BuZH1DSK0rb6m3uZ98HLJqYmvEg7hXP
   qj2mRAw2beYEMdeCLjOP3XTKWhTycK/ORa9zn/yFZSDdI+HuH++IMFHpj
   Lr5RIICjPQ7Y3V6rr+x6KQ+Zx7Z+lpNiMJumM6UsIdWt6irhWUIsMIVSF
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10659"; a="338585083"
X-IronPort-AV: E=Sophos;i="5.98,288,1673942400"; 
   d="scan'208";a="338585083"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2023 12:05:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10659"; a="632936329"
X-IronPort-AV: E=Sophos;i="5.98,288,1673942400"; 
   d="scan'208";a="632936329"
Received: from kvnguye3-mobl1.amr.corp.intel.com (HELO [10.212.145.31]) ([10.212.145.31])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2023 12:05:26 -0700
Message-ID: <060ebffd-6ecd-f2f7-6fdf-5e7b8c544d0a@linux.intel.com>
Date:   Fri, 24 Mar 2023 14:05:25 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.8.0
Subject: Re: [PATCH] ASoC: hdac_hdmi: use set_stream() instead of
 set_tdm_slots()
To:     Jason Montleon <jmontleo@redhat.com>, alsa-devel@alsa-project.org,
        regressions@lists.linux.dev, yung-chuan.liao@linux.intel.com,
        broonie@kernel.org, tiwai@suse.com, bagasdotme@gmail.com
Cc:     stable@vger.kernel.org
References: <20230324170711.2526-1-jmontleo@redhat.com>
Content-Language: en-US
From:   Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
In-Reply-To: <20230324170711.2526-1-jmontleo@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 3/24/23 12:07, Jason Montleon wrote:
> hdac_hdmi was not updated to use set_stream() instead of set_tdm_slots()
> in the original commit so HDMI no longer produces audio.
> 
> Cc: stable@vger.kernel.org
> Link: https://lore.kernel.org/regressions/CAJD_bPKQdtaExvVEKxhQ47G-ZXDA=k+gzhMJRHLBe=mysPnuKA@mail.gmail.com/
> Fixes: 636110411ca7 ("ASoC: Intel/SOF: use set_stream() instead of set_tdm_slots() for HDAudio")
> Signed-off-by: Jason Montleon <jmontleo@redhat.com>

Good catch indeed. Thanks Jason!

Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C3CD5801D0
	for <lists+stable@lfdr.de>; Mon, 25 Jul 2022 17:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235935AbiGYPZL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jul 2022 11:25:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235910AbiGYPZL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jul 2022 11:25:11 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88FF7EBD
        for <stable@vger.kernel.org>; Mon, 25 Jul 2022 08:25:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658762709; x=1690298709;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=zcAlaBU309G4nnqXFfV9NfvRK3B71QC0vLEfu7VaOQk=;
  b=SlLJkT29Vr9hWN75OZ47J0aXPYgGKXzrG3YOUvUquPO8n9mnK8Ap0sS/
   G8EGE3BWlcYHkevS39H7LfHtytj82EhTLbwXWV/+dgPI2tSyXQF8UtheR
   Z15jOHW9XYPWZJuXhW8i5xJZTVtLS5yrBI6bxwTQZfL5D/UukhMmIeWZV
   uOJX0CYs4DmSDxGrHo5K/ASB4LwaqpcM2KV03u7UROyVeL1khhVw314/F
   vfkCyf3sD294rj9HqwxPrrsUHWPLQaepFFlvQzW/lE+gacwPorx26YpYy
   fbAMcS2tIa0WNyYTm0memWt1rtnsz8wF9i1BDTQSyA+eaASmJvGc/RpFG
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10419"; a="288482209"
X-IronPort-AV: E=Sophos;i="5.93,193,1654585200"; 
   d="scan'208";a="288482209"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2022 08:25:09 -0700
X-IronPort-AV: E=Sophos;i="5.93,193,1654585200"; 
   d="scan'208";a="550025894"
Received: from jxzhao-mobl.amr.corp.intel.com (HELO [10.212.0.178]) ([10.212.0.178])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2022 08:25:08 -0700
Message-ID: <56549c69-39a1-56cf-fb48-e2af6eeadef5@linux.intel.com>
Date:   Mon, 25 Jul 2022 10:25:07 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [PATCH 3/3] ASoC: SOF: Intel: disable IMR boot when resuming from
 ACPI S4 and S5 states
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, broonie@kernel.org,
        peter.ujfalusi@linux.intel.com, ranjani.sridharan@linux.intel.com
References: <20220711155719.104952-1-pierre-louis.bossart@linux.intel.com>
 <20220711155719.104952-4-pierre-louis.bossart@linux.intel.com>
 <Ytv9JKlEOXctrFee@kroah.com>
From:   Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
In-Reply-To: <Ytv9JKlEOXctrFee@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 7/23/22 08:52, Greg KH wrote:
> On Mon, Jul 11, 2022 at 10:57:19AM -0500, Pierre-Louis Bossart wrote:
>> commit 58ecb11eab44dd5d64e35664ac4d62fecb6328f4 upstream.
> 
> Again, not a valid commit :(
> 
> Where did these come from?
> 
> confused,

There are on Mark Brown's for-next branch, I must have looked at the IDs
after a rebase or something. We always report the SHA IDs from that
for-next branch, and linux-next check those values. I didn't realize
they could be different in Linus' tree.

I am still a bit confused since our Fixes tag could be right at the
moment we submit the patches to Mark but wrong long-term after merge by
Linus. Either I need more coffee, or I am missing a key concept, or both.

The commit IDs on Linus' tree should be:

a933084558c6 ASoC: SOF: pm: add explicit behavior for ACPI S1 and S2

9d2d46271338 ASoC: SOF: pm: add definitions for S4 and S5 states

391153522d18 ASoC: SOF: Intel: disable IMR boot when resuming from ACPI
S4 and S5 states


Do you want me to resend?
Thanks
-Pierre


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 638D14C8530
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 08:29:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232958AbiCAHa0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 02:30:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232975AbiCAHaT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 02:30:19 -0500
X-Greylist: delayed 314 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 28 Feb 2022 23:29:39 PST
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65C547D00E;
        Mon, 28 Feb 2022 23:29:39 -0800 (PST)
Received: from [192.168.43.69] (unknown [182.2.70.248])
        by gnuweeb.org (Postfix) with ESMTPSA id 0A45A7ED9F;
        Tue,  1 Mar 2022 07:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1646119778;
        bh=8s9Mj+A6B3FILjAYviQGESwu+WeXMhXUAePBwg/J5UQ=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=iAliG35kWk4dZJhVOVX85hGFZ6yNOXW+3UINLhvIhKtmNTOtglr5kSevGIYJmayMW
         0hNQgY9ncGa3CLj8AehgaTN5faTlPG9Kyo+CJw3SbWnrs0ecVp7wJAOaVDc/zZwcYK
         Al3C+2D3vbx/Ex+L3pv0WqMj8+zz9Y7S9WaFJHOyUt98yYofWboCt8oSuwXJBZn55a
         NAmHsmVyQ6H4Miqy83WLJ/A8MXmkfSyWseWE3xL4WY3QwXAA7sqiUDV4EAiPkQI1dy
         gNc+mASnNoMubwBoafEvISJVvcO7XqF3tNDJ2M5U+c4l949eAQoJ8ilFGpHQx7sAya
         ZZ76rEMlzexqA==
Message-ID: <5253b448-8fd9-6426-4918-0f13becd9b3b@gnuweeb.org>
Date:   Tue, 1 Mar 2022 14:29:30 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 0/2] Two x86 fixes
Content-Language: en-US
To:     Borislav Petkov <bp@alien8.de>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tony Luck <tony.luck@intel.com>, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org, gwml@vger.gnuweeb.org,
        x86@kernel.org, stable@vger.kernel.org
References: <20220301072353.95749-1-ammarfaizi2@gnuweeb.org>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
In-Reply-To: <20220301072353.95749-1-ammarfaizi2@gnuweeb.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/1/22 2:23 PM, Ammar Faizi wrote:
> [PATCH 1/2] x86/delay: Fix the wrong asm constraint in `delay_loop()`
> 
> @bp is a local variable, calling mce_threshold_remove_device() when
> threshold_create_bank() fails will not free the @bp. Note that
> mce_threshold_remove_device() frees the @bp only if it's already
> stored in the @threshold_banks per-CPU variable.
> 
> At that point, the @threshold_banks per-CPU variable is still NULL,
> so the mce_threshold_remove_device() will just be a no-op and the
> @bp is leaked.
> 
> Fix this by calling kfree() and early returning when we fail.
> 
> This bug is introduced by commit 6458de97fc15530b544 ("x86/mce/amd:
> Straighten CPU hotplug path") [1].
> 
> Link: https://lore.kernel.org/all/20200403161943.1458-6-bp@alien8.de [1]

Uhh... Wrong cover letter... Sorry... Re-sending now...

-- 
Ammar Faizi

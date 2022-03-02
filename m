Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24EB24CB339
	for <lists+stable@lfdr.de>; Thu,  3 Mar 2022 01:34:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbiCBX7i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Mar 2022 18:59:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbiCBX7i (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Mar 2022 18:59:38 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90F32AE73;
        Wed,  2 Mar 2022 15:58:53 -0800 (PST)
Received: from [192.168.43.69] (unknown [182.2.41.243])
        by gnuweeb.org (Postfix) with ESMTPSA id 129EC7E245;
        Wed,  2 Mar 2022 23:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1646263219;
        bh=5bGlzJLdBkS0s/8eCPQY/1VF/vxcLCuznCGM29opc6k=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=W+PKSiy4sQMg8AB3zmI4CC8KjCEDgOfXLzi14enl7mT5F/qloWJkRGyqi23pQoVxb
         whxvILmeTXP2pi+q7IG11yU8YDTGHz4um1Il+92Bq+Vp/DlzJOJa1wutiX0Mz73ejG
         5uqGLSerp6LzOygMwO8ViKymzTmARAbiB7k8Baz36Snqi6IHu97i6VyZnv8srp1RlW
         g/EQug7jQNxQE1jWQ6QAZstmaFdJLxDsZe8UjBcJOmwu6qcZQtIBMH+xz9OD+jTR1r
         0uTxP/1vfrwTVc8tc77gsi+ES/BXvVKkekHgtzNHRuV7BtVgS109H1VzduYDz21KSt
         ogciKlIRVtgHA==
Message-ID: <4371a592-6686-c535-4daf-993dedb43cd4@gnuweeb.org>
Date:   Thu, 3 Mar 2022 06:20:09 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v4 2/2] x86/mce/amd: Fix memory leak when
 `threshold_create_bank()` fails
Content-Language: en-US
To:     Yazen Ghannam <yazen.ghannam@amd.com>
Cc:     Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tony Luck <tony.luck@intel.com>, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org, gwml@vger.gnuweeb.org,
        x86@kernel.org, stable@vger.kernel.org,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Jiri Hladky <hladky.jiri@googlemail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20220301094608.118879-1-ammarfaizi2@gnuweeb.org>
 <20220301094608.118879-3-ammarfaizi2@gnuweeb.org>
 <Yh+oyD/5M3TW5ZMM@yaz-ubuntu>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
In-Reply-To: <Yh+oyD/5M3TW5ZMM@yaz-ubuntu>
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

On 3/3/22 12:26 AM, Yazen Ghannam wrote:
> Hi Ammar,

Hi Yazen,

> ...
> The threshold interrupt handler uses this pointer. I think the goal here is to
> set this pointer when the list is fully formed and clear this pointer before
> making any changes to the list. Otherwise, the interrupt handler will operate
> on incomplete data if an interrupt comes in the middle of these updates.
> 
> The changes below should deal with memory leak issue while avoiding a race
> with the threshold interrupt. What do you think?

Thanks for taking a look into this. I didn't notice that before. The
changes look good to me, extra improvements:

1) _mce_threshold_remove_device() should be static as we don't use it
    in another translation unit.
2) Minor cleanup, we don't need "goto out_err", just early return
    directly.

I will fold them in...

-- 
Ammar Faizi

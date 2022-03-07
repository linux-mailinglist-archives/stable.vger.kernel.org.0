Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 454B84CEEF2
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 01:27:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234006AbiCGA2s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Mar 2022 19:28:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231548AbiCGA2s (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Mar 2022 19:28:48 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7116A1CB31;
        Sun,  6 Mar 2022 16:27:54 -0800 (PST)
Received: from [192.168.43.69] (unknown [182.2.38.152])
        by gnuweeb.org (Postfix) with ESMTPSA id ACDC47E6B0;
        Mon,  7 Mar 2022 00:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1646612873;
        bh=6EwZV+kp79HnWRono9OuMB+/b/YqdJWhwy0MRnJZHtY=;
        h=Date:From:To:Cc:References:Subject:In-Reply-To:From;
        b=OTuJ6ILo75TBX/uZWnLWFfWoG8Cigsi04UWES0JH2WMsuoWeC548ndDlhZjMiyhhu
         W6x5ojLiZ/CVxJEi+MEtziuaxgysHmiuI8yL13nOL2HFg5bPTzsBWf6Zr5mIN2Ourq
         qqZ2FZ58goycAu63b6QJxFuhmoZ2BCg3RW6Nhd2uOWytgIZ3iOY7DmEVmTESIopmaj
         /yO70vGKO/NmYR4YBmDcveIhNUvDUfvEmXxT+lvuA/fNQnkh1fkOdKUjoYvjgbGux9
         /QJvwFp1+VZaCjvKU9qmf6KOFTf+KdBJGWRgvIaEOcApwFQvNJhSAwnlUeyeYq9+rp
         i9cr+nVpPOzyA==
Message-ID: <b18bac61-a27f-8de5-8aa5-10bda9309ac5@gnuweeb.org>
Date:   Mon, 7 Mar 2022 07:27:44 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-Language: en-US
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Yazen Ghannam <yazen.ghannam@amd.com>
Cc:     Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tony Luck <tony.luck@intel.com>, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org, gwml@vger.gnuweeb.org,
        x86@kernel.org, stable@vger.kernel.org,
        Alviro Iskandar Setiawan <alviro.iskandar@gmail.com>,
        Jiri Hladky <hladky.jiri@googlemail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
References: <20220301094608.118879-1-ammarfaizi2@gnuweeb.org>
 <20220301094608.118879-3-ammarfaizi2@gnuweeb.org>
 <Yh+oyD/5M3TW5ZMM@yaz-ubuntu>
 <4371a592-6686-c535-4daf-993dedb43cd4@gnuweeb.org>
 <109a10da-d1d1-c47a-2f04-31796457f6ff@gnuweeb.org>
 <20220303015826.4176416-1-alviro.iskandar@gnuweeb.org>
 <49313736-61f8-d001-0fe4-b6166c859585@gnuweeb.org>
 <9dfe087a-f941-1bc4-657d-7e7c198888ff@gnuweeb.org>
Subject: Re: [PATCH v4 2/2] x86/mce/amd: Fix memory leak when
 `threshold_create_bank()` fails
In-Reply-To: <9dfe087a-f941-1bc4-657d-7e7c198888ff@gnuweeb.org>
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

On 3/3/22 9:32 AM, Ammar Faizi wrote:
> It looks like this now. Yazen, Alviro, please review the
> following patch. If you think it looks good, I will submit
> it for the v5.
> 
>  From 91a447f837d502b7a040cd68f333fb98f4b941d9 Mon Sep 17 00:00:00 2001
> From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
> Date: Thu, 3 Mar 2022 09:22:17 +0700
> Subject: [PATCH v5 2/2] x86/MCE/AMD: Fix memory leak when `threshold_create_bank()` fails
> 
> In mce_threshold_create_device(), if threshold_create_bank() fails, the
> @bp will be leaked, because mce_threshold_remove_device() will not free
> the @bp. It only frees the @bp when we've already written the @bp to
> the @threshold_banks per-CPU variable, but at the point, we haven't.
> 
> Fix this by extracting the cleanup part into a new static function
> _mce_threshold_remove_device(), then use it from create/remove device
> function. Also, eliminate the "goto out_err". Just early return inside
> the loop if we fail.
> 
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: stable@vger.kernel.org # v5.8+
> Fixes: 6458de97fc15 ("x86/mce/amd: Straighten CPU hotplug path")
> Co-authored-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
> Signed-off-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
> Co-authored-by: Yazen Ghannam <yazen.ghannam@amd.com>
> Signed-off-by: Yazen Ghannam <yazen.ghannam@amd.com>
> Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>


Hi,

It's Monday morning...

Friendly ping for Yazen from AMD. What do you think of this patch? If
it looks good, I will submit it for the v5 revision. See the ref below
if you lost track of the full message.

Ref: https://lore.kernel.org/lkml/9dfe087a-f941-1bc4-657d-7e7c198888ff@gnuweeb.org/

Thanks!

-- 
Ammar Faizi


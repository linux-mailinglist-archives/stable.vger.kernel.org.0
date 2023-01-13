Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59CCB669B23
	for <lists+stable@lfdr.de>; Fri, 13 Jan 2023 15:58:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229449AbjAMO6q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Jan 2023 09:58:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229707AbjAMO6H (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Jan 2023 09:58:07 -0500
Received: from mail1.perex.cz (mail1.perex.cz [77.48.224.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28F7E97494;
        Fri, 13 Jan 2023 06:45:36 -0800 (PST)
Received: from mail1.perex.cz (localhost [127.0.0.1])
        by smtp1.perex.cz (Perex's E-mail Delivery System) with ESMTP id DFB59A003F;
        Fri, 13 Jan 2023 15:45:33 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.11.0 smtp1.perex.cz DFB59A003F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=perex.cz; s=default;
        t=1673621133; bh=MW4KMXeombVYSD+Suet8+ydrU5cpb02IsctRgeT+eMA=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=oxH4hwuc4P4vB1QHOPlx0Symvo9vUeVn2Zed7vI37rm2lL7CL/HD369fKXjHIgMWr
         yVA4MViHGOVut/XK6y9GVLfPontWlCgUgyjsTk2nV3jWZcCla7HuhFsdBwkBVkLepW
         KfgvYm7JmculfAW4owmsjYLE2wq1KVBGY1O5zLok=
Received: from [192.168.100.98] (unknown [192.168.100.98])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: perex)
        by mail1.perex.cz (Perex's E-mail Delivery System) with ESMTPSA;
        Fri, 13 Jan 2023 15:45:27 +0100 (CET)
Message-ID: <e0dae3a0-4176-0bc7-42e4-65cf58f265ad@perex.cz>
Date:   Fri, 13 Jan 2023 15:45:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH 5.10.y] ALSA: pcm: Properly take rwsem lock in
 ctl_elem_read_user/ctl_elem_write_user to prevent UAF
Content-Language: en-US
To:     Takashi Iwai <tiwai@suse.de>, Greg KH <gregkh@linuxfoundation.org>
Cc:     alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Clement Lecigne <clecigne@google.com>
References: <20230113142639.4420-1-tiwai@suse.de>
From:   Jaroslav Kysela <perex@perex.cz>
In-Reply-To: <20230113142639.4420-1-tiwai@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 13. 01. 23 15:26, Takashi Iwai wrote:
> From: Clement Lecigne <clecigne@google.com>
> 
> [ Note: this is a fix that works around the bug equivalently as the
>    two upstream commits:
>     1fa4445f9adf ("ALSA: control - introduce snd_ctl_notify_one() helper")
>     56b88b50565c ("ALSA: pcm: Move rwsem lock inside snd_ctl_elem_read to prevent UAF")
>    but in a simpler way to fit with older stable trees -- tiwai ]
> 
> Add missing locking in ctl_elem_read_user/ctl_elem_write_user which can be
> easily triggered and turned into an use-after-free.
> 
> Example code paths with SNDRV_CTL_IOCTL_ELEM_READ:
> 
> 64-bits:
> snd_ctl_ioctl
>    snd_ctl_elem_read_user
>      [takes controls_rwsem]
>      snd_ctl_elem_read [lock properly held, all good]
>      [drops controls_rwsem]
> 
> 32-bits (compat):
> snd_ctl_ioctl_compat
>    snd_ctl_elem_write_read_compat
>      ctl_elem_write_read
>        snd_ctl_elem_read [missing lock, not good]
> 
> CVE-2023-0266 was assigned for this issue.
> 
> Signed-off-by: Clement Lecigne <clecigne@google.com>
> Cc: stable@kernel.org # 5.12 and older
> Signed-off-by: Takashi Iwai <tiwai@suse.de>

Reviewed-by: Jaroslav Kysela <perex@perex.cz>

-- 
Jaroslav Kysela <perex@perex.cz>
Linux Sound Maintainer; ALSA Project; Red Hat, Inc.

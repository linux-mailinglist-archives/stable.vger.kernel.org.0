Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C7102E1D50
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 15:19:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728872AbgLWOPo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Dec 2020 09:15:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:56278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728850AbgLWOPn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 23 Dec 2020 09:15:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A78552313C;
        Wed, 23 Dec 2020 14:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608732902;
        bh=EaQ7NKNOQ1DqYf56a04HtUOpjoqnLtP5t+pq9/dWO1k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qLhu2AfYQGq3FN+00ITeXrwmDQ3EBqD/yyBe//V4wy7TvoKr+MvCGLlKdIrXuXAF7
         dgJWEn8nBbDY/aFCUu//qH0O99HDCmlbrLkRqGxAH6AhUnAlhwNpPs7wriwRK1Y3hS
         gUKJYI19WvQVl8qhjxBeQtybwkyesn15YCl9JsZz4KfOiQiN52Ir2ZIBKznJF2JKdR
         gl8RULyaEM2aHUoqNQBR5IHJYdM9asfZCtuOffha0CZGON20QdXRTY4oqcY5nxyHYl
         TPp/yXmKSjUlBNkXmQDvlgLgT3uG2ueJhpVgIAWeS2VYAfO9/x1y0/iv26lGaSLfVf
         DCOK9UAh30UGQ==
Date:   Wed, 23 Dec 2020 09:15:01 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Takashi Iwai <tiwai@suse.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Dylan Robinson <dylan_robinson@motu.com>,
        Keith Milner <kamilner@superlative.org>,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH AUTOSEL 5.4 057/130] ALSA: usb-audio: Check valid
 altsetting at parsing rates for UAC2/3
Message-ID: <20201223141501.GC2790422@sasha-vm>
References: <20201223021813.2791612-1-sashal@kernel.org>
 <20201223021813.2791612-57-sashal@kernel.org>
 <s5h4kkddmmi.wl-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <s5h4kkddmmi.wl-tiwai@suse.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 23, 2020 at 08:09:41AM +0100, Takashi Iwai wrote:
>On Wed, 23 Dec 2020 03:17:00 +0100,
>Sasha Levin wrote:
>>
>> From: Takashi Iwai <tiwai@suse.de>
>>
>> [ Upstream commit 93db51d06b32227319dae2ac289029ccf1b33181 ]
>>
>> The current driver code assumes blindly that all found sample rates for
>> the same endpoint from the UAC2 and UAC3 descriptors can be used no
>> matter which altsetting, but actually this was wrong: some devices
>> accept only limited sample rates in each altsetting.  For determining
>> which altsetting supports which rate, we need to verify each sample rate
>> and check the validity via UAC2_AS_VAL_ALT_SETTINGS.  This control
>> reports back the available altsettings as a bitmap.
>>
>> This patch implements the missing piece above, the verification and
>> reconstructs the sample rate tables based on the result.
>>
>> An open question is how to deal with the altsettings that ended up
>> with no valid sample rates after verification.  At least, there is a
>> device that showed this problem although the sample rates did work in
>> the later usage (see bug link).  For now, we accept such an altset as
>> is, assuming that it's a firmware bug.
>>
>> Reported-by: Dylan Robinson <dylan_robinson@motu.com>
>> Tested-by: Keith Milner <kamilner@superlative.org>
>> Tested-by: Dylan Robinson <dylan_robinson@motu.com>
>> BugLink: https://bugzilla.suse.com/show_bug.cgi?id=1178203
>> Link: https://lore.kernel.org/r/20201123085347.19667-4-tiwai@suse.de
>> Signed-off-by: Takashi Iwai <tiwai@suse.de>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>Please drop this for 5.4 or older.  At least this caused some problem
>on 5.3 kernel that confused USB core by some reason while it works
>fine with the recent upstream.

Will do, thanks.

-- 
Thanks,
Sasha

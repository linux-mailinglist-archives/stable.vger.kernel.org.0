Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B56613F1A55
	for <lists+stable@lfdr.de>; Thu, 19 Aug 2021 15:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238469AbhHSN1M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Aug 2021 09:27:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:60192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230136AbhHSN1L (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Aug 2021 09:27:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6259E60C40;
        Thu, 19 Aug 2021 13:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629379595;
        bh=PQKS7ifiKL5AQ+28N4ttww+q8yDryty2pNVgBMcPytM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tycrSuyOSNYl1aTSKDaJEM7Mq5BYIH3GS8sAOKgYCNSQLxbpEvRzzholgpUhN6vmj
         vgt7YP9sgB8H49kOHC9V+ANMjbMvJHcPHJrlSr9Ex2ADGopBwhbuUUMZrcfkG0gMDH
         ISEUc8/ZdqBVyN232BucS+SxFLLUJTBQOek8uAIwhyIvYS3ztxCcHOxO6Yldq94EHF
         5uueggVbebDyajNm4f42tNzlSXCLguWsAW3Gbc5c76Le8r9mcf11CB/HbkQmaof6jS
         PvIybP/IT3rJ6nk5Dd8iWBLi21jz70AnZM5EV0ZLiXxF8f2+oDG4qb49vgkHwyXMnN
         Erbk1h2KWub/w==
Date:   Thu, 19 Aug 2021 09:26:34 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Charles Keepax <ckeepax@opensource.cirrus.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Lucas Tanure <tanureal@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>, patches@opensource.cirrus.com,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH AUTOSEL 5.13 03/12] ASoC: wm_adsp: Let
 soc_cleanup_component_debugfs remove debugfs
Message-ID: <YR5cCqyVQRnDjuo3@sashalap>
References: <20210817003536.83063-1-sashal@kernel.org>
 <20210817003536.83063-3-sashal@kernel.org>
 <20210818131544.GL9223@ediswmail.ad.cirrus.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210818131544.GL9223@ediswmail.ad.cirrus.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 18, 2021 at 01:15:44PM +0000, Charles Keepax wrote:
>On Mon, Aug 16, 2021 at 08:35:27PM -0400, Sasha Levin wrote:
>> From: Lucas Tanure <tanureal@opensource.cirrus.com>
>>
>> [ Upstream commit acbf58e530416e167c3b323111f4013d9f2b0a7d ]
>>
>> soc_cleanup_component_debugfs will debugfs_remove_recursive
>> the component->debugfs_root, so adsp doesn't need to also
>> remove the same entry.
>> By doing that adsp also creates a race with core component,
>> which causes a NULL pointer dereference
>>
>> Signed-off-by: Lucas Tanure <tanureal@opensource.cirrus.com>
>> Link: https://lore.kernel.org/r/20210728104416.636591-1-tanureal@opensource.cirrus.com
>> Signed-off-by: Mark Brown <broonie@kernel.org>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>  sound/soc/codecs/wm_adsp.c | 1 -
>>  1 file changed, 1 deletion(-)
>>
>> diff --git a/sound/soc/codecs/wm_adsp.c b/sound/soc/codecs/wm_adsp.c
>> index cef05d81c39b..6698b5343974 100644
>> --- a/sound/soc/codecs/wm_adsp.c
>> +++ b/sound/soc/codecs/wm_adsp.c
>> @@ -746,7 +746,6 @@ static void wm_adsp2_init_debugfs(struct wm_adsp *dsp,
>>  static void wm_adsp2_cleanup_debugfs(struct wm_adsp *dsp)
>>  {
>>  	wm_adsp_debugfs_clear(dsp);
>> -	debugfs_remove_recursive(dsp->debugfs_root);
>>  }
>
>It might be better not to backport this patch to the stable
>kernels. The issue has only been seen on one out of tree driver
>and the patch looks a little off to me. This
>debugfs_remove_recursive should run before the
>soc_cleanup_component_debugfs one, and as such it's hard to see
>what is actually going on. We are currently investigating internally
>but we might end up reverting the change, and it only seems to be
>causing issues on the one not upstreamed part.
>
>Apologies for missing the review of this one when it went up
>Mark, I was on holiday at the time.

I'll drop it, it didn't go anywhere yet :) Thanks!

-- 
Thanks,
Sasha

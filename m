Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E0702922C2
	for <lists+stable@lfdr.de>; Mon, 19 Oct 2020 09:03:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727238AbgJSHDG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Oct 2020 03:03:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726242AbgJSHDG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Oct 2020 03:03:06 -0400
Received: from manul.sfritsch.de (manul.sfritsch.de [IPv6:2a01:4f8:172:195f:112::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6AC8C061755
        for <stable@vger.kernel.org>; Mon, 19 Oct 2020 00:03:05 -0700 (PDT)
Subject: Re: [PATCH] drm/i915: Rate limit 'Fault errors' message
To:     Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        intel-gfx@lists.freedesktop.org,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>
Cc:     Jani Nikula <jani.nikula@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>, stable@vger.kernel.org
References: <20201016152340.15906-1-sf@sfritsch.de>
 <160308979457.4267.13628612734509793218@jlahtine-mobl.ger.corp.intel.com>
From:   Stefan Fritsch <sf@sfritsch.de>
Message-ID: <6402f498-ed07-6b0c-eeed-df9db086b14c@sfritsch.de>
Date:   Mon, 19 Oct 2020 09:03:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.2
MIME-Version: 1.0
In-Reply-To: <160308979457.4267.13628612734509793218@jlahtine-mobl.ger.corp.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: de-DE
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I think we should do both. Any log message that can be triggered 50 
times per second in practice should be rate limited. Also, the rate 
limiting is probably a candidate for backporting to stable kernels while 
the real fix may be not.

PS: See also my other mail about "drm/i915: Detecting Vt-d when running 
as guest os"

On 19.10.20 08:43, Joonas Lahtinen wrote:
> + Zhenyu & Zhi,
> 
> Should not we instead fix the reason why the errors happen instead of
> rate-limiting them?
> 
> Regards, Joonas
> 
> Quoting Stefan Fritsch (2020-10-16 18:23:40)
>> If linux is running as a guest and the host is doing igd pass-through
>> with VT-d enabled, this message is logged dozens of times per second.
>>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Stefan Fritsch <sf@sfritsch.de>
>> ---
>>
>> The i915 driver should also detect VT-d in this case, but that is a
>> different issue.  I have sent a separate mail with subject 'Detecting
>> Vt-d when running as guest os'.
>>
>>
>>   drivers/gpu/drm/i915/i915_irq.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/gpu/drm/i915/i915_irq.c b/drivers/gpu/drm/i915/i915_irq.c
>> index 759f523c6a6b..29096634e697 100644
>> --- a/drivers/gpu/drm/i915/i915_irq.c
>> +++ b/drivers/gpu/drm/i915/i915_irq.c
>> @@ -2337,7 +2337,7 @@ gen8_de_irq_handler(struct drm_i915_private *dev_priv, u32 master_ctl)
>>   
>>                  fault_errors = iir & gen8_de_pipe_fault_mask(dev_priv);
>>                  if (fault_errors)
>> -                       drm_err(&dev_priv->drm,
>> +                       drm_err_ratelimited(&dev_priv->drm,
>>                                  "Fault errors on pipe %c: 0x%08x\n",
>>                                  pipe_name(pipe),
>>                                  fault_errors);
>> -- 
>> 2.28.0
>>

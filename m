Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1E516C3155
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 13:16:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbjCUMQq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Mar 2023 08:16:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbjCUMQp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 08:16:45 -0400
X-Greylist: delayed 40671 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 21 Mar 2023 05:16:43 PDT
Received: from mail.manjaro.org (mail.manjaro.org [IPv6:2a01:4f8:c0c:51f3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01F4D3A4F1
        for <stable@vger.kernel.org>; Tue, 21 Mar 2023 05:16:43 -0700 (PDT)
Message-ID: <800904b0-c34d-b420-9799-6cf314e95446@manjaro.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manjaro.org; s=2021;
        t=1679401002;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=X+Sf8Zbn2FsABr4BjJGXOQV00kiljQcs8mgntYLLAlw=;
        b=fsra6hZLZhwgkxZgyijXWxmKyhbq8qy1RNTvrqwZklkedEom3phnizX3kFOBN6WlfgzjDN
        uXIknd95woY+fPTdFMjRC6ga3eSCWm5d4htKFGL/VA57bZdg6MiPliQ7M4Uf+2/kZ5ldi0
        YK6OzbeX3Bw/MR6YCi8kI6PgTctHTkToI459wij0gtKTAGKhN/zzD7svWNQJ2Ap7LCqXZL
        glzoAXbgZBI9LnrGhaFeTnAsSeMrtYYceXeo4rniXIWgPMvMz2xHT2TNqwo9z0SiBxExux
        XZy0GfcSGoGe0PUyDiWgBksEZ1iJMPHn3hKhE/b/m838F3ivwXE1+kfdcvK5GQ==
Date:   Tue, 21 Mar 2023 19:16:32 +0700
MIME-Version: 1.0
Subject: Re: [Regression] drm/i915: Don't use BAR mappings for ring buffers
 with LLC alone creates issues in stable kernels
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     John Harrison <John.C.Harrison@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        intel-gfx@lists.freedesktop.org, stable@vger.kernel.org
References: <8a1bbe56-4463-d18d-d5a9-d249171a569d@manjaro.org>
 <a0be2b31-9e72-1254-978e-570b27abb364@manjaro.org>
 <ZBhfhJ0ylxqXPHee@kroah.com>
 <efc7e85a-a170-ba1b-8746-b00784e81e39@manjaro.org>
 <ZBlY0yzJsT4k7bRL@kroah.com>
Content-Language: en-US
From:   =?UTF-8?Q?Philip_M=c3=bcller?= <philm@manjaro.org>
Organization: Manjaro Community
In-Reply-To: <ZBlY0yzJsT4k7bRL@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Authentication-Results: ORIGINATING;
        auth=pass smtp.auth=philm@manjaro.org smtp.mailfrom=philm@manjaro.org
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 21.03.23 14:12, Greg Kroah-Hartman wrote:
> On Tue, Mar 21, 2023 at 07:58:44AM +0700, Philip Müller wrote:
>> On 20.03.23 20:28, Greg Kroah-Hartman wrote:
>>> On Sun, Mar 19, 2023 at 10:01:01AM +0700, Philip Müller wrote:
>>>> Have to correct the affected kernels to these: 4.14.310, 4.19.278, 5.4.237,
>>>> 5.10.175
>>>
>>> Please don't top-post :(
>>>
>>> Anyway, should be fixed in the next round of releases in a few days, if
>>> not, please let us know.
>>>
>>> greg k-h
>>
>> Hi Greg,
>>
>> seems the RCs work out. 4.19.279-rc1 and 5.10.176-rc1 were tested by a user
>> who had the issue on i915. In 5.15 series the drm patch got reverted. I only
>> see "drm/i915: Don't use stolen memory for ring buffers with LLC" there as
>> "drm/i915: Don't use BAR mappings for ring buffers with LLC" was reverted
>> with 5.15.101.
> 
> So is 5.15.y ok or not?  Sorry, I could not parse your response here.
> 
> thanks,
> 
> greg k-h

Hi Greg,

yes, 5.15.y seems to work. You could even re-add the reverted patch from 
5.15.101 as we also have tested with it applied on top of 5.15.104-rc1.
-- 
Best, Philip


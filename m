Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B109533759
	for <lists+stable@lfdr.de>; Wed, 25 May 2022 09:29:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243317AbiEYH33 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 May 2022 03:29:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242414AbiEYH32 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 May 2022 03:29:28 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A331344CE
        for <stable@vger.kernel.org>; Wed, 25 May 2022 00:29:26 -0700 (PDT)
Received: from [2a02:8108:963f:de38:eca4:7d19:f9a2:22c5]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1ntlSM-00057l-W7; Wed, 25 May 2022 09:29:23 +0200
Message-ID: <ff1191fa-1cc9-24ab-4c7d-b3d41c442670@leemhuis.info>
Date:   Wed, 25 May 2022 09:29:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [REGRESSION] Laptop with Ryzen 4600H fails to resume video since
 5.17.4 (works 5.17.3)
Content-Language: en-US
To:     Christian Casteyde <casteyde.christian@free.fr>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     stable@vger.kernel.org, regressions@lists.linux.dev,
        alexander deucher <alexander.deucher@amd.com>,
        gregkh@linuxfoundation.org,
        Mario Limonciello <mario.limonciello@amd.com>
References: <941867856.547807110.1652809066335.JavaMail.root@zimbra40-e7.priv.proxad.net>
 <2585440.lGaqSPkdTl@geek500.localdomain>
 <2408578.XAFRqVoOGU@geek500.localdomain>
 <2175827.vFx2qVVIhK@geek500.localdomain>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
In-Reply-To: <2175827.vFx2qVVIhK@geek500.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1653463767;0dfa3258;
X-HE-SMSGID: 1ntlSM-00057l-W7
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 24.05.22 22:54, Christian Casteyde wrote:
> Conclusion from gitlab discussion

Christian, Mario, thx for the updates. I'll remove the issue from the
list of tracked regressions then:

#regzbot invalid: tricky situation with other problems; the issue thus
not really qualifies as regression

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)

P.S.: As the Linux kernel's regression tracker I deal with a lot of
reports and sometimes miss something important when writing mails like
this. If that's the case here, don't hesitate to tell me in a public
reply, it's in everyone's interest to set the public record straight.


> There are three different problems at stake here:
> 
> 1. First suspend failure after boot is due to TAD driver.
> When it is loaded, first suspend deep fails.
> This is the root cause of the following sequence.
> TAD seems to be not completely functionnal on my laptop, sysfs returns IO 
> errors (missing handlers in dmesg).
> After the first failure, every "deep" attempt work.
> 
> 2.  When suspend deep fails, elogind (used by Slackware 15) falls back to 
> s2idle.
> This behaviour is documented in logind.conf man page, and normaly can be 
> configured (side note: I didn't manage to do so, it ignores my configuration 
> file).
> 
> 3. When suspend to s2idle, the GPU fails to suspend and need a reset.
> This reset must be done in pm_suspend (not totally ok if reset at resume).
> However, the laptop indeed goes into s2idle.
> In this state, the power button awakes it: this part is handled by the BIOS 
> and not the distribution (which shut downs if not suspended).
> This is what doesn't work anymore un 5.17.4 and 5.18.
> 
> The root cause is therefore the ACPI TAD preventing the first deep suspend to 
> complete, then elogind asking for a s2idle in fallback, then s2idle leaving 
> the APU in inconsistent state, that can only be fixed by a reset in 
> pm_suspend, and not pm_suspend_noirq or pm_suspend_late.
> 
> I will open a separate bug for the ACPI TAD problem. For now I will run 
> without this driver, as deep suspend works fine in this case and s2idle is 
> therefore useless for me.
> 
> CC
> 
> 
> Le lundi 23 mai 2022, 19:03:27 CEST Christian Casteyde a écrit :
>> I've opened the gitlab entry for this discussion:
>> https://gitlab.freedesktop.org/drm/amd/-/issues/2023
>>
>> I confirm I 'm not receiving mails anymore from the mailing list but I'll
>> follow gitlab.
>>
>> In reply to the patch proposed by Mario:
>> https://patchwork.freedesktop.org/patch/486836/
>> With this patch applied on vanilla 5.18 kernel:
>> - suspend still fails;
>> - after suspend attempt, the screen comes back with only the cursor;
>> - switching to a console let me get the following dmesg file.
>>
>> CC
>>
>> Le lundi 23 mai 2022, 15:02:53 CEST Christian Casteyde a écrit :
>>> Hello
>>>
>>> I've checked with 5.18 the problem is still there.
>>> Interestingly, I tried to revert the commit but it was rejected because of
>>>
>>> the change in the test from:
>>>         if (!adev->in_s0ix)
>>>
>>> to:
>>>       if (amdgpu_acpi_should_gpu_reset(adev))
>>>
>>> in amdgpu_pmops_suspend.
>>>
>>> I fixed the rejection, keeping shoud_gpu_reset, but it still fails.
>>> Then I changed to restore test of in_s0ix as it was in 5.17, and it works.
>>> I tried with a call to amd_gpu_asic_reset without testing at all in_s0ix,
>>> it works.
>>>
>>> Therefore, my APU wants a reset in amdgpu_pmops_suspend.
>>>
>>> By curiosity, I tried to do the reset in amdgpu_pmops_suspend_noirq as was
>>> intended in 5.18 original code, commenting out the test of
>>> amdgpu_acpi_should_gpu_reset(adev) (since this APU wants a reset).
>>> This does not work, I got the Fence timeout errors or freezes.
>>>
>>> If I leave  noirq function unchanged (original 5.18 code), and just add a
>>> reset in suspend() as was done in 5.17, it works.
>>>
>>> Therefore, my GPU does NOT want to be reset in noirq, the reset must be in
>>> suspend.
>>>
>>> In other words, I modified amdgpu_pmops_suspend (partial revert) like this
>>> and this works on my laptop:
>>>
>>> static int amdgpu_pmops_suspend(struct device *dev)
>>> {
>>>
>>> 	struct drm_device *drm_dev = dev_get_drvdata(dev);
>>> 	struct amdgpu_device *adev = drm_to_adev(drm_dev);
>>>
>>> +	int r;
>>>
>>> 	if (amdgpu_acpi_is_s0ix_active(adev))
>>> 	
>>> 		adev->in_s0ix = true;
>>> 	
>>> 	else
>>> 	
>>> 		adev->in_s3 = true;
>>>
>>> -	return amdgpu_device_suspend(drm_dev, true);
>>> +	r = amdgpu_device_suspend(drm_dev, true);
>>> +	if (r)
>>> +		return r;
>>> +	if (!adev->in_s0ix)
>>> +		return amdgpu_asic_reset(adev);
>>>
>>> 	return 0;
>>>
>>> }
>>>
>>> static int amdgpu_pmops_suspend_noirq(struct device *dev)
>>> {
>>>
>>> 	struct drm_device *drm_dev = dev_get_drvdata(dev);
>>> 	struct amdgpu_device *adev = drm_to_adev(drm_dev);
>>> 	
>>> 	if (amdgpu_acpi_should_gpu_reset(adev))
>>> 	
>>> 		return amdgpu_asic_reset(adev);
>>> 	
>>> 	return 0;
>>>
>>> }
>>>
>>> I don't know if other APU want a reset, in the same context, and how to
>>> differentiate all the cases, so I cannot go further, but I can test
>>> patches
>>> if needed.
>>>
>>> CC
>>>
>>> Le mercredi 18 mai 2022, 08:37:27 CEST Thorsten Leemhuis a écrit :
>>>> On 18.05.22 07:54, Kai-Heng Feng wrote:
>>>>> On Wed, May 18, 2022 at 1:52 PM Thorsten Leemhuis
>>>>>
>>>>> <regressions@leemhuis.info> wrote:
>>>>>> On 17.05.22 19:37, casteyde.christian@free.fr wrote:
>>>>>>> I've tryied to revert the offending commit on 5.18-rc7 (887f75cfd0da
>>>>>>> ("drm/amdgpu: Ensure HDA function is suspended before ASIC reset"),
>>>>>>> and
>>>>>>> the problem disappears so it's really this commit that breaks.
>>>>>>
>>>>>> In that case I'll update the regzbot status to make sure it's visible
>>>>>> as
>>>>>> regression introduced in the 5.18 cycle:
>>>>>>
>>>>>> #regzbot introduced: 887f75cfd0da
>>>>>>
>>>>>> BTW: obviously would be nice to get this fixed before 5.18 is
>>>>>> released
>>>>>> (which might already happen on Sunday), especially as the culprit
>>>>>> apparently was already backported to stable, but I guess that won't
>>>>>> be
>>>>>> easy...
>>>>>>
>>>>>> Which made me wondering: is reverting the culprit temporarily in
>>>>>> mainline (and reapplying it later with a fix) a option here?
>>>>>
>>>>> It's too soon to call it's the culprit.
>>>>
>>>> Well, sure, the root-cause might be somewhere else. But from the point
>>>> of kernel regressions (and tracking them) it's the culprit, as that's
>>>> the change that triggers the misbehavior. And that's how Linus
>>>> approaches these things as well when it comes to reverting to fix
>>>> regressions -- and he even might...
>>>>
>>>>> The suspend on the system
>>>>> doesn't work properly at the first place.
>>>>
>>>> ...ignore things like this, as long as a revert is unlikely to cause
>>>> more damage than good.
>>>>
>>>> Ciao. Thorsten
>>>>
>>>>>> Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker'
>>>>>> hat)
>>>>>>
>>>>>> P.S.: As the Linux kernel's regression tracker I deal with a lot of
>>>>>> reports and sometimes miss something important when writing mails
>>>>>> like
>>>>>> this. If that's the case here, don't hesitate to tell me in a public
>>>>>> reply, it's in everyone's interest to set the public record straight.
> 
> 
> 
> 
> 

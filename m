Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C44F2337C32
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 19:13:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229965AbhCKSNL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 13:13:11 -0500
Received: from mga04.intel.com ([192.55.52.120]:10827 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229821AbhCKSNB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Mar 2021 13:13:01 -0500
IronPort-SDR: OpiFBjhQoLX+JGsPmI7sn8Vd4nzPG9jin6RCfVwD9gg4odyDk/7Dw9I4Mmrh6sVAWOPCQN8gBm
 m+uIYLmwgSKA==
X-IronPort-AV: E=McAfee;i="6000,8403,9920"; a="186337918"
X-IronPort-AV: E=Sophos;i="5.81,241,1610438400"; 
   d="scan'208";a="186337918"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2021 10:13:00 -0800
IronPort-SDR: 6w8YfludFvMAiU+tUMs+3QLK8/xbc9BefDU0SHtDqUhiVEkjV4Wjk7EMZ1ps9AVkLFsoyAj55u
 EeikkH9+vQ1w==
X-IronPort-AV: E=Sophos;i="5.81,241,1610438400"; 
   d="scan'208";a="603628357"
Received: from prcarril-mobl2.amr.corp.intel.com (HELO [10.213.187.142]) ([10.213.187.142])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2021 10:13:00 -0800
Subject: Re: [PATCH 1/2] ASoC: intel: atom: Stop advertising non working S24LE
 support
To:     Hans de Goede <hdegoede@redhat.com>,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Jie Yang <yang.jie@linux.intel.com>,
        Mark Brown <broonie@kernel.org>
Cc:     alsa-devel@alsa-project.org, stable@vger.kernel.org
References: <20210309105520.9185-1-hdegoede@redhat.com>
 <e1af1b57-d384-0dce-6362-c39197cf2063@linux.intel.com>
 <1c6f6608-5da3-1d57-1673-97ea22930ff9@redhat.com>
From:   Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Message-ID: <d1a1a110-dc41-17e3-5b53-6c8921bf49a3@linux.intel.com>
Date:   Thu, 11 Mar 2021 12:12:59 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <1c6f6608-5da3-1d57-1673-97ea22930ff9@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 3/11/21 10:44 AM, Hans de Goede wrote:
> Hi,
> 
> On 3/9/21 4:42 PM, Pierre-Louis Bossart wrote:
>>
>>
>> On 3/9/21 4:55 AM, Hans de Goede wrote:
>>> The SST firmware's media and deep-buffer inputs are hardcoded to
>>> S16LE, the corresponding DAIs don't have a hw_params callback and
>>> their prepare callback also does not take the format into account.
>>>
>>> So far the advertising of non working S24LE support has not caused
>>> issues because pulseaudio defaults to S16LE, but changing pulse-audio's
>>> config to use S24LE will result in broken sound.
>>>
>>> Pipewire is replacing pulse now and pipewire prefers S24LE over S16LE
>>> when available, causing the problem of the broken S24LE support to
>>> come to the surface now.
>>>
>>> Cc: stable@vger.kernel.org
>>> BugLink: https://gitlab.freedesktop.org/pipewire/pipewire/-/issues/866
>>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>>
>> Humm, that is strange.
>> I can't recall such limitations in the firmware, and the SSP support does make use of 24 bits.
>> Please give me a couple of days to double-check what's missing.
> 
> Note this is not about the format between the DSP (the DSP's SSP) and the codec,
> this is the format between userspace and the DSP.
> 
> As is mentioned by the reporter of this issue:
> https://github.com/thesofproject/sof/issues/3868#issuecomment-796809535
> Both in that issue but also here:
> https://gitlab.freedesktop.org/pipewire/pipewire/-/issues/530#note_791736
> 
> And independently reproduced by my here:
> https://gitlab.freedesktop.org/pipewire/pipewire/-/issues/866#note_830336
> 
> The S24LE format ATM does not work when passed from userspace, this is
> supposed to take 24 bits sampled packed into 32 bits ints (so padded
> with 1 0 byte to make 32 bits per sample), but to actually get working
> playback with the SST driver, the following commands are necessary:
> 
> ffmpeg -i /usr/share/sounds/alsa/Side_Left.wav -ar 96000 -f s32le -ac 2 test.raw
> aplay --dump-hw-params -D"hw:1,0" -r48000 -c2 -fS24_LE test.raw
> 
> Note how the ffmpeg command to generate a working set of raw samples
> is set to convert to full 32 bit samples, rather then 0 padded 24 bit
> samples. Generating a .raw file with the same -f s32le argument to
> ffmpeg and then playing it with aplay -fS24_LE while using the SOF
> driver results in static. Where as with the SST driver it results
> in working sound. This shows that the 2 clearly interpret the format
> differently and it looks like the SST driver is interpreting it wrong.
> 
> Maybe the SST driver should advertise S32_LE support instead, SOF
> advertised both S24_LE and S32_LE and the S32_LE format is the
> one which works with .raw files generated with ffmpeg's -f s32le
> option when using the SOF drv.
> 
> Note the format is not the only issue though, to get normal speed / pitch
> playback, the file needs to be converted to a sample rate of 96KHz
> and then played back at 48 KHz, hence the "-ar 96000" argument to
> ffmpeg to get normal playback when using aplay -fS24_LE with the SST driver.
> 
> Because of both these fmt and playback speed issues I decided to just
> drop the SNDRV_PCM_FMTBIT_S24_LE support in my patch. I guess we could
> try to fix it, but since the plan is the phase out the SST support for
> these devices this year I believe that we should not spend too much
> time on trying to fix the SST driver here.  Dropping the SNDRV_PCM_FMTBIT_S24_LE
> is a simple workaround to bridge the time until we complete drop the
> SST support.

ok, I agree. I added this capability back in 2015 in the upstream code 
based on the Android versions, and I *think* it was tested, but since 
there's overwhelming evidence of multiple issues let's revert this.

Fixes: 098c2cd281409 ("ASoC  ASoC: Intel: Atom: add 24-bit support for 
media playback and capture")
Acked-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>




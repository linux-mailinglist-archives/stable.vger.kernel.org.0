Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77DD411D930
	for <lists+stable@lfdr.de>; Thu, 12 Dec 2019 23:18:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730942AbfLLWSP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Dec 2019 17:18:15 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:44637 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730896AbfLLWSP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Dec 2019 17:18:15 -0500
Received: by mail-lj1-f193.google.com with SMTP id c19so373478lji.11;
        Thu, 12 Dec 2019 14:18:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+XD2YJXA7ZufzS9uIPo90GBKSTjiLqm8CiBX+lsDlIA=;
        b=W+Vqr2bSf/ekx6RYypheSPdTHMmXh+i0Zm/wkXo+ZdjoxrWQh1r5CITjoFHsTLrf6i
         x9a81qOSV+C7tZat6qngJ+h3QtTmnLoge1Bfc3ZhuTCMigjO63vX8yv4UfJVIotxTj1j
         iZjIYZ1WmJ4mKP30UXIDqBFUJ8K5u2v1lB6OmDFcRkMH7lMWFUgT8j8Qbhw6LftpRCC+
         sawUX5P5FL3WPLmGQmDtIWB/epHF94hLmfbkM4aOxWxJukEmWl0Dyvv0Ziofs+WyR1rg
         LkUDHk6eKI/TWjvG5V4/MAIbi/d9YEFMG9LnaCe1Gh464qUgCePRRvohJdm21vR+pvvs
         wn2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+XD2YJXA7ZufzS9uIPo90GBKSTjiLqm8CiBX+lsDlIA=;
        b=f0i/B6bBqaxgmSjzDvOHuSdoAdLZ3oxq6Ab9ZAOzLp6x+a4YyH7KlFfMhVwcW/dFuq
         QfPSwZyaRrm4sPbsA91JgX9pCenfIyoV53gr4dqI8LEyIMrYgX9OzXyfQKYPd9cxXi5f
         W0ulH7zeVRPnzEPpiPZ6Z4ugfzIcPm/nlvkgTt5JP8WWgGIKfVgKohNoQ1iBZLJ+DKCK
         km2V63v2WONFms72ITnQ04z+3Gedq4Y2uvl0fLVXuDsKXYf4r4XgwmpYW1WBIsS4ghPQ
         u3K1oe7nlZiPzB92xLlV8zRYkcXjmYE6v5OAc0Hl0F3EppzVcTdCrQ79nVpnm6bZGUcP
         bozA==
X-Gm-Message-State: APjAAAXmHgbbIN3BIH4MaeJQhqsvz2CPErN1JArTzcHm7YxKIo/F7+QQ
        fE+FGzKmBX2OLGJ5rswZaMr+SR/D
X-Google-Smtp-Source: APXvYqyoqLQrADAtdeclQnySLqArLCxK1fwquekZF6UdGDo9yxFqAnEXdQE+naQF4PTlDXetcqZSnQ==
X-Received: by 2002:a2e:9b8f:: with SMTP id z15mr7595279lji.20.1576189092618;
        Thu, 12 Dec 2019 14:18:12 -0800 (PST)
Received: from [192.168.2.145] (79-139-233-37.dynamic.spd-mgts.ru. [79.139.233.37])
        by smtp.googlemail.com with ESMTPSA id 22sm4147820ljw.9.2019.12.12.14.18.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Dec 2019 14:18:12 -0800 (PST)
Subject: Re: [PATCH] ARM: tegra: Fix restoration of PLLM when exiting suspend
To:     Peter De Schrijver <pdeschrijver@nvidia.com>
Cc:     Jon Hunter <jonathanh@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        stable@vger.kernel.org
References: <20191210103708.7023-1-jonathanh@nvidia.com>
 <1f2a4f23-5be5-aa7e-6eb4-2aeb4058481d@gmail.com>
 <1fe9cd2d-50a2-aae5-95fa-0329acce4c4c@gmail.com>
 <20191211085016.GW28289@pdeschrijver-desktop.Nvidia.com>
From:   Dmitry Osipenko <digetx@gmail.com>
Message-ID: <5ac5de2a-e43f-5332-8453-b73f6fdd64b7@gmail.com>
Date:   Fri, 13 Dec 2019 01:18:11 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20191211085016.GW28289@pdeschrijver-desktop.Nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

11.12.2019 11:50, Peter De Schrijver пишет:
> On Tue, Dec 10, 2019 at 11:29:42PM +0300, Dmitry Osipenko wrote:
>> External email: Use caution opening links or attachments
>>
>>
>> 10.12.2019 22:28, Dmitry Osipenko пишет:
>>> Hello Jon,
>>>
>>> PLLM's enable-status could be defined either by PMC or CaR. Thus at
>>> first you need to check whether PMC overrides CaR's enable and then
>>> judge the enable state based on PMC or CaR state respectively.
>>>
>>
>> Actually, now I think that it doesn't make sense to check PMC WB0 state
>> at all. IIUC, PLLM's state of the WB0 register defines whether Boot ROM
>> should enable PLLM on resume from suspend. Thus it will be correct to
>> check only the CaR's enable-state of PLLM.
>>
>> I'm not sure what's the idea of WB0 overriding, maybe to resume faster.
>> Peter, could you please clarify that?
> 
> I don't know why these overriding bits exist. The code for them was in
> the downstream driver so I implemented the same in the upstream driver
> :)

Okay, I'll try to figure out how to clean up it properly.

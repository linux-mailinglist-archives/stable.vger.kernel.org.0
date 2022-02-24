Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2E4A4C341D
	for <lists+stable@lfdr.de>; Thu, 24 Feb 2022 18:56:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232486AbiBXR4r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Feb 2022 12:56:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232481AbiBXR4m (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Feb 2022 12:56:42 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDDA3279469;
        Thu, 24 Feb 2022 09:56:11 -0800 (PST)
Received: from [192.168.88.87] (unknown [36.78.50.60])
        by gnuweeb.org (Postfix) with ESMTPSA id 5107C7E2A3;
        Thu, 24 Feb 2022 17:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1645725371;
        bh=7y0qBUn+4Mr6bFU20/TGub2HSOx+UgE/hIlmL27DAVc=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=D7aZtVyLlCng7VVCYtJk2rzO6vsimwfxamI03avJnlQmAyFkNPTTJvxRG/Jg4tl2j
         5kpRJDZD/gyCBx4UAGS2cJcv8MDcy4kUXgdLKzLClwG429hsY2UFpZdVVzeUPepMQK
         INoaznkuuMgo01rQR2SB2xknWIZXiTNtbEDJXCq1KhUMNil0//085azpQLy/txcx6U
         L/91ntrOD5KGFdQYd6JErvSfH71zayGAoklWMSA7Qnv/VSqfKxK5n7+uF3sc1NEiG3
         +PBfs1ansVMY3NUFhUiz2zYBPhLkV7FF/oOL8Wlkqgj4uGSOntQvG73n2+YnhRhNcJ
         Hak+Nrgofj+EQ==
Message-ID: <5188759c-fd7a-4dbb-0f56-db74200603a8@gnuweeb.org>
Date:   Fri, 25 Feb 2022 00:56:02 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] ASoC: SOF: Intel: Fix NULL ptr dereference when ENOMEM
Content-Language: en-US
To:     Mark Brown <broonie@kernel.org>
Cc:     Daniel Baluta <daniel.baluta@nxp.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Keyon Jie <yang.jie@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Rander Wang <rander.wang@intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Takashi Iwai <tiwai@suse.com>, stable@vger.kernel.org,
        sound-open-firmware@alsa-project.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
References: <20220224145124.15985-1-ammarfaizi2@gnuweeb.org>
 <Yhe/3rELNfFOdU4L@sirena.org.uk>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
In-Reply-To: <Yhe/3rELNfFOdU4L@sirena.org.uk>
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

On 2/25/22 12:26 AM, Mark Brown wrote:
> On Thu, Feb 24, 2022 at 09:51:24PM +0700, Ammar Faizi wrote:
>> From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
>>
>> Do not call snd_dma_free_pages() when snd_dma_alloc_pages() returns
>> -ENOMEM because it leads to a NULL pointer dereference bug.
>>
>> The dmesg says:
>>
>>    <6>[109482.497835][T138537] usb 1-2: Manufacturer: SIGMACHIP
>>    <6>[109482.502506][T138537] input: SIGMACHIP USB Keyboard as /devices/pci0000:00/0000:00:14.0/usb1/1-2/1-2:1.0/0003:1C4F:0002.000D/input/input34
>>    <6>[109482.558976][T138537] hid-generic 0003:1C4F:0002.000D: input,hidraw1: USB HID v1.10 Keyboard [SIGMACHIP USB Keyboard] on usb-0000:00:14.0-2/input0
>>    <6>[109482.561653][T138537] input: SIGMACHIP USB Keyboard Consumer Control as /devices/pci0000:00/0000:00:14.0/usb1/1-2/1-2:1.1/0003:1C4F:0002.000E/input/input35
> 
> Please think hard before including complete backtraces in upstream
> reports, they are very large and contain almost no useful information
> relative to their size so often obscure the relevant content in your
> message. If part of the backtrace is usefully illustrative (it often is
> for search engines if nothing else) then it's usually better to pull out
> the relevant sections.

I will strip the irrelevant information in the v2.

-- 
Ammar Faizi

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F4402A6280
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 11:49:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729637AbgKDKtV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Nov 2020 05:49:21 -0500
Received: from smtp106.ord1d.emailsrvr.com ([184.106.54.106]:55775 "EHLO
        smtp106.ord1d.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727923AbgKDKtV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Nov 2020 05:49:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mev.co.uk;
        s=20190130-41we5z8j; t=1604486959;
        bh=nM3HMBm0LDHyS3BTjAs00IhVNoULUtyWP5a5SFL0J4A=;
        h=Subject:From:To:Date:From;
        b=c2UZups3mhpbRhyUtnZ3F8N93t9A6q8u+LMwkpQ4ft68Pn/cRiN8vTH84sV+wdEXk
         D0tjQz9PBha6iUHd1KbtzJY365tNuzpvCx+G3B/zTcf1bCH1QPPtD4RLl8GeZAVe6V
         sZKUYwpuIXzkZw4arcGdHRfR9E+xypnZeoK0TP7Y=
X-Auth-ID: abbotti@mev.co.uk
Received: by smtp22.relay.ord1d.emailsrvr.com (Authenticated sender: abbotti-AT-mev.co.uk) with ESMTPSA id 53450E01B0;
        Wed,  4 Nov 2020 05:49:19 -0500 (EST)
Subject: Re: [PATCH] staging: comedi: cb_pcidas: reinstate delay removed from
 trimpot setting
From:   Ian Abbott <abbotti@mev.co.uk>
To:     devel@driverdev.osuosl.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        stable@vger.kernel.org
References: <20201029141833.126856-1-abbotti@mev.co.uk>
 <3d7cf15a-c389-ec2c-5e29-8838e8466790@mev.co.uk>
 <f28af317-08a7-8218-d2a6-0cdd9e681873@mev.co.uk>
Organization: MEV Ltd.
Message-ID: <975358e2-6a08-211a-d232-3cd0ce628e8e@mev.co.uk>
Date:   Wed, 4 Nov 2020 10:49:18 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <f28af317-08a7-8218-d2a6-0cdd9e681873@mev.co.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
X-Classification-ID: c38d9511-2862-475a-af9e-afdf1fc6240b-1-1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 02/11/2020 11:16, Ian Abbott wrote:
> On 02/11/2020 10:25, Ian Abbott wrote:
>> On 29/10/2020 14:18, Ian Abbott wrote:
>>> Commit eddd2a4c675c ("staging: comedi: cb_pcidas: refactor
>>> write_calibration_bitstream()") inadvertently removed one of the
>>> `udelay(1)` calls when writing to the calibration register in
>>> `cb_pcidas_calib_write()`.  Reinstate the delay.  It may seem strange
>>> that the delay is placed before the register write, but this function is
>>> called in a loop so the extra delay can make a difference.
>>>
>>> This _might_ solve reported issues reading analog inputs on a
>>> PCIe-DAS1602/16 card where the analog input values "were scaled in a
>>> strange way that didn't make sense".  On the same hardware running a
>>> system with a 3.13 kernel, and then a system with a 4.4 kernel, but with
>>> the same application software, the system with the 3.13 kernel was fine,
>>> but the one with the 4.4 kernel exhibited the problem.  Of the 90
>>> changes to the driver between those kernel versions, this change looked
>>> like the most likely culprit.
>>
>> Actually, I've realized that this patch will have no effect on the 
>> PCIe-DAS1602/16 card because it uses a different driver - cb_pcimdas, 
>> not cb_pcidas.
> 
> But that's also confusing because PCIe-DAS1602/16 was not supported 
> until the 3.19 kernel!  I know the reported has both PCI-DAS1602/16 and 
> PCIe-DAS1602/16 cards (supported by cb_pcidas and cb_pcimdas 
> respectively), so there could have been some mix-up in the reporting.

Mystery solved.  The reporter had a mixture of PCIe-DAS1602/16 and 
PCIM-DAS1602/16 cards (not PCI-DAS1602/16).  Both of those are supported 
by the "cb_pcimdas" driver (not "cb_pcidas"), although the PCIe card was 
not supported until the 3.19 kernel (by commit 4e3d14af1286).  Testing 
with the 3.13 kernel was done with the PCIM card.

The "strange scaling" was due to a change in the ranges reported for the 
analog input subdevice in the 4.1 kernel (by commit c7549d770a27). 
Before then, it just reported a single dummy range [0, 1000000] with no 
units (converted to [0.0, 1.0] with no units by comedilib).  Afterwards, 
it reported four different voltage ranges (either unipolar or bipolar, 
depending in a status bit tied to a physical switch).  The reporter's 
application code was using the reported range to scale the raw values to 
a voltage (using comedilib functions), but because the reported range 
was bogus, the application code was performing additional scaling 
(outside of comedilib).  The application code can be changed to check 
whether the device is reporting a proper voltage range or the old, bogus 
range, and behave accordingly.

>> Greg, you might as well drop this patch if you haven't already applied 
>> it, since it was only a hunch that it fixed a problem.

That's still the case, although it won't do any harm if applied (apart 
from the incorrect patch description).

-- 
-=( Ian Abbott <abbotti@mev.co.uk> || MEV Ltd. is a company  )=-
-=( registered in England & Wales.  Regd. number: 02862268.  )=-
-=( Regd. addr.: S11 & 12 Building 67, Europa Business Park, )=-
-=( Bird Hall Lane, STOCKPORT, SK3 0XA, UK. || www.mev.co.uk )=-

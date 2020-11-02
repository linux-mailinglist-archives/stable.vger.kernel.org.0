Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C4DA2A28F1
	for <lists+stable@lfdr.de>; Mon,  2 Nov 2020 12:21:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728297AbgKBLVN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 06:21:13 -0500
Received: from smtp65.ord1c.emailsrvr.com ([108.166.43.65]:43381 "EHLO
        smtp65.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728444AbgKBLVN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Nov 2020 06:21:13 -0500
X-Greylist: delayed 305 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Nov 2020 06:21:12 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mev.co.uk;
        s=20190130-41we5z8j; t=1604315767;
        bh=Tqv+WVAfnjUdwhKNPWC+9CN5pYHyP1K9/lY6oNs3Zyg=;
        h=Subject:From:To:Date:From;
        b=j8n7s7YYBCr6NLP294i9dLoTXZWsKeRhZ4dLtn8+htOcqCdl+KInmxaXbvOXvqmt/
         PNBEtvc2jJ9r8buqdbiz1sRkKAOSoQT4fqiLiNLxW9Swsn+tb4ICCf7ZX4ZtNKWIEc
         XhVEU2M+Ga45dYXMu3Yq8pFVNqVcdRkHYlPQ+VZY=
X-Auth-ID: abbotti@mev.co.uk
Received: by smtp25.relay.ord1c.emailsrvr.com (Authenticated sender: abbotti-AT-mev.co.uk) with ESMTPSA id CA354201A8;
        Mon,  2 Nov 2020 06:16:06 -0500 (EST)
Subject: Re: [PATCH] staging: comedi: cb_pcidas: reinstate delay removed from
 trimpot setting
From:   Ian Abbott <abbotti@mev.co.uk>
To:     devel@driverdev.osuosl.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        stable@vger.kernel.org
References: <20201029141833.126856-1-abbotti@mev.co.uk>
 <3d7cf15a-c389-ec2c-5e29-8838e8466790@mev.co.uk>
Organization: MEV Ltd.
Message-ID: <f28af317-08a7-8218-d2a6-0cdd9e681873@mev.co.uk>
Date:   Mon, 2 Nov 2020 11:16:05 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <3d7cf15a-c389-ec2c-5e29-8838e8466790@mev.co.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
X-Classification-ID: c7816c9c-6293-4188-b215-3375f81bf324-1-1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 02/11/2020 10:25, Ian Abbott wrote:
> On 29/10/2020 14:18, Ian Abbott wrote:
>> Commit eddd2a4c675c ("staging: comedi: cb_pcidas: refactor
>> write_calibration_bitstream()") inadvertently removed one of the
>> `udelay(1)` calls when writing to the calibration register in
>> `cb_pcidas_calib_write()`.  Reinstate the delay.  It may seem strange
>> that the delay is placed before the register write, but this function is
>> called in a loop so the extra delay can make a difference.
>>
>> This _might_ solve reported issues reading analog inputs on a
>> PCIe-DAS1602/16 card where the analog input values "were scaled in a
>> strange way that didn't make sense".  On the same hardware running a
>> system with a 3.13 kernel, and then a system with a 4.4 kernel, but with
>> the same application software, the system with the 3.13 kernel was fine,
>> but the one with the 4.4 kernel exhibited the problem.  Of the 90
>> changes to the driver between those kernel versions, this change looked
>> like the most likely culprit.
> 
> Actually, I've realized that this patch will have no effect on the 
> PCIe-DAS1602/16 card because it uses a different driver - cb_pcimdas, 
> not cb_pcidas.

But that's also confusing because PCIe-DAS1602/16 was not supported 
until the 3.19 kernel!  I know the reported has both PCI-DAS1602/16 and 
PCIe-DAS1602/16 cards (supported by cb_pcidas and cb_pcimdas 
respectively), so there could have been some mix-up in the reporting.

> 
> Greg, you might as well drop this patch if you haven't already applied 
> it, since it was only a hunch that it fixed a problem.
> 


-- 
-=( Ian Abbott <abbotti@mev.co.uk> || MEV Ltd. is a company  )=-
-=( registered in England & Wales.  Regd. number: 02862268.  )=-
-=( Regd. addr.: S11 & 12 Building 67, Europa Business Park, )=-
-=( Bird Hall Lane, STOCKPORT, SK3 0XA, UK. || www.mev.co.uk )=-

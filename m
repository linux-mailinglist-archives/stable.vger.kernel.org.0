Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F94D3A2EB3
	for <lists+stable@lfdr.de>; Thu, 10 Jun 2021 16:55:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230304AbhFJO50 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Jun 2021 10:57:26 -0400
Received: from mail.palosanto.com ([181.39.87.190]:35762 "EHLO palosanto.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230298AbhFJO5Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Jun 2021 10:57:25 -0400
Received: from localhost (mail.palosanto.com [127.0.0.1])
        by palosanto.com (Postfix) with ESMTP id 83CD313C248E;
        Thu, 10 Jun 2021 09:55:23 -0500 (-05)
X-Virus-Scanned: Debian amavisd-new at mail.palosanto.com
Received: from palosanto.com ([127.0.0.1])
        by localhost (mail.palosanto.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id iIGQVPJSTKfT; Thu, 10 Jun 2021 09:55:21 -0500 (-05)
Received: from [192.168.0.2] (unknown [191.99.4.100])
        by palosanto.com (Postfix) with ESMTPSA id EBFBB13C2439;
        Thu, 10 Jun 2021 09:55:20 -0500 (-05)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=palosanto.com;
        s=mail; t=1623336921;
        bh=OTFcSkjqBOSPqEr4jPF2tyefPn+62ZuUn3qckFwwmos=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=A43UdQTezO/6jtQiIZr1u2XNwnHXh2WQ0Or/2H9rAT3GT71NNrVdIUn3tgpPI2hfH
         iNW+E9PbO4u/oMThryaUy8HfrEz1U6/armqJ46cCGuAcuBQzOkKiFy1f4wScxzJLpg
         Z6wRLTScDXRP1+RC11OmCUZQO5KritwTXR+x4/88=
Subject: Re: [PATCH] USB: serial: cp210x: fix CP2102N-A01 modem control
To:     Johan Hovold <johan@kernel.org>
Cc:     David Frey <dpfrey@gmail.com>, linux-usb@vger.kernel.org,
        Pho Tran <pho.tran@silabs.com>,
        Tung Pham <tung.pham@silabs.com>, Hung.Nguyen@silabs.com,
        stable@vger.kernel.org
References: <YL87Na0MycRA6/fW@hovoldconsulting.com>
 <20210609161509.9459-1-johan@kernel.org>
 <22113673-a359-f783-166f-acbe5dbc9298@palosanto.com>
 <YMG+Be220/sZ4QIC@hovoldconsulting.com>
From:   =?UTF-8?Q?Alex_Villac=c3=ads_Lasso?= <a_villacis@palosanto.com>
Message-ID: <06b6ecb6-9ea9-ae91-1ba0-78a924bbd543@palosanto.com>
Date:   Thu, 10 Jun 2021 09:55:23 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YMG+Be220/sZ4QIC@hovoldconsulting.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

El 10/6/21 a las 02:23, Johan Hovold escribió:
> On Wed, Jun 09, 2021 at 12:00:36PM -0500, Alex Villacís Lasso wrote:
>> El 9/6/21 a las 11:15, Johan Hovold escribió:
>>> CP2102N revision A01 (firmware version <= 1.0.4) has a buggy
>>> flow-control implementation that uses the ulXonLimit instead of
>>> ulFlowReplace field of the flow-control settings structure (erratum
>>> CP2102N_E104).
>>>
>>> A recent change that set the input software flow-control limits
>>> incidentally broke RTS control for these devices when CRTSCTS is not set
>>> as the new limits would always enable hardware flow control.
>>>
>>> Fix this by explicitly disabling flow control for the buggy firmware
>>> versions and only updating the input software flow-control limits when
>>> IXOFF is requested. This makes sure that the terminal settings matches
>>> the default zero ulXonLimit (ulFlowReplace) for these devices.
>>>
>>> Reported-by: David Frey <dpfrey@gmail.com>
>>> Reported-by: Alex Villacís Lasso <a_villacis@palosanto.com>
>>> Fixes: f61309d9c96a ("USB: serial: cp210x: set IXOFF thresholds")
>>> Cc: stable@vger.kernel.org      # 5.12
>>> Signed-off-by: Johan Hovold <johan@kernel.org>
>>> ---
>>>    drivers/usb/serial/cp210x.c | 64 ++++++++++++++++++++++++++++++++++---
>>>    1 file changed, 59 insertions(+), 5 deletions(-)
>>>
>>> David and Alex,
>>>
>>> Would you mind testing this one with your CP2108N-A01? I've verified it
>>> against a CP2108N-A02 (fw 1.0.8) here.
> I meant CP2102N here of course. It had been a long day...
>
>> Applied patch and tested with ESP32 board under kernel 5.12.9:
>> jun 09 11:56:00 karlalex-asus kernel: cp210x 1-9:1.0:
>> cp210x_get_fw_version - 1.0.4
>> $ miniterm.py /dev/ttyUSB0 115200
>> <successful connect>
>>
>> jun 09 11:56:50 karlalex-asus kernel: cp210x ttyUSB0:
>> cp210x_change_speed - setting baud rate to 9600
>> jun 09 11:56:50 karlalex-asus kernel: cp210x ttyUSB0:
>> cp210x_set_flow_control - ctrl = 0x00, flow = 0x00
>> jun 09 11:56:50 karlalex-asus kernel: cp210x ttyUSB0:
>> cp210x_tiocmset_port - control = 0x0303
>> jun 09 11:56:50 karlalex-asus kernel: cp210x ttyUSB0:
>> cp210x_change_speed - setting baud rate to 115384
>> jun 09 11:56:50 karlalex-asus kernel: cp210x ttyUSB0:
>> cp210x_tiocmset_port - control = 0x0101
>> jun 09 11:56:50 karlalex-asus kernel: cp210x ttyUSB0:
>> cp210x_tiocmset_port - control = 0x0202
>>
>> At least in my case, this patch fixes the regression for my workflow.
> Thanks for confirming. Can I add a "Tested-by" tag for you as well?
>
> And again, thanks for the detailed report, bisection and thorough
> testing throughout.
>
> Johan

Yes, go ahead. You can put the Tested-by on my behalf.


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50A9726D940
	for <lists+stable@lfdr.de>; Thu, 17 Sep 2020 12:40:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbgIQKjo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 06:39:44 -0400
Received: from aibo.runbox.com ([91.220.196.211]:60906 "EHLO aibo.runbox.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726362AbgIQKjl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 06:39:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=runbox.com;
         s=selector2; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject;
        bh=xeeG8LF2Ei7v4OozjD1VrjBXnrhuWeaTIa4poH0upSw=; b=TsuCNN5KPRhj/QzMNMjCn4YIxW
        ywSTn1cqxF2sPuDrVlJUz/yW6ERbFVq4dUu7pRDIbl+4JH7miO3oIGSYkhAD8RcBE5qm69T80dVyS
        hFzc4KB6ZSsWayIox2p4AlBwlpeedUXrBdLuPetLjH7UuDgJZMwu0nzBAi6ZT/6jqYyf1iLCzVTba
        /NOs+c6PMcp4nSQi7kgAiDp+Lq87a2pYISQKRhWeTWHfPRH2IAwxBK7DASmn3p/uUL2feFeu/TTYS
        k/Q1rkSfawIWgXJaIiUrE5OppgUiKAMcCIvXB6NqKRT2NNyVRSdReS7+/TqzJghCs8L/IKm12v2lv
        y70x8r3w==;
Received: from [10.9.9.72] (helo=submission01.runbox)
        by mailtransmit03.runbox with esmtp (Exim 4.86_2)
        (envelope-from <m.v.b@runbox.com>)
        id 1kIrK8-0000Vy-0H; Thu, 17 Sep 2020 12:39:32 +0200
Received: by submission01.runbox with esmtpsa  [Authenticated alias (536975)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1kIrK6-0001Ta-Ms; Thu, 17 Sep 2020 12:39:30 +0200
Subject: Re: [PATCH 1/2] usbcore/driver: Fix specific driver selection
To:     Bastien Nocera <hadess@hadess.net>, linux-usb@vger.kernel.org
Cc:     Andrey Konovalov <andreyknvl@google.com>, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        syzkaller@googlegroups.com
References: <359d080c-5cbb-250a-0ebd-aaba5f5c530d@runbox.com>
 <20200917095959.174378-1-m.v.b@runbox.com>
 <2ee0f3922f54888acf3e0cafa47c3829a9b0de8f.camel@hadess.net>
From:   "M. Vefa Bicakci" <m.v.b@runbox.com>
Message-ID: <0ce9fcb5-8684-cf5c-e8ad-02217848cbe7@runbox.com>
Date:   Thu, 17 Sep 2020 13:39:26 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <2ee0f3922f54888acf3e0cafa47c3829a9b0de8f.camel@hadess.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 17/09/2020 13.23, Bastien Nocera wrote:
> On Thu, 2020-09-17 at 12:59 +0300, M. Vefa Bicakci wrote:
>> This commit resolves two minor bugs in the selection/discovery of
>> more
>> specific USB device drivers for devices that are currently bound to
>> generic USB device drivers.
>>
>> The first bug is related to the way a candidate USB device driver is
>> compared against the generic USB device driver. The code in
>> is_dev_usb_generic_driver() used to unconditionally use
>> to_usb_device_driver() on each device driver, without verifying that
>> the device driver in question is a USB device driver (as opposed to a
>> USB interface driver).
> 
> You could also return early if is_usb_device() fails in
> __usb_bus_reprobe_drivers(). Each of the interface and the device
> itself is a separate "struct device", and "non-interface" devices won't
> have interface devices assigned to them.

Will do! If I understand you correctly, you mean something like the
following:

static int __usb_bus_reprobe_drivers(struct device *dev, void *data)
{
         struct usb_device_driver *new_udriver = data;
         struct usb_device *udev;
         int ret;

	/* Proposed addition begins */

	if (!is_usb_device(dev))
		return 0;

	/* Proposed addition ends */

         if (!is_dev_usb_generic_driver(dev))
                 return 0;


>> The second bug is related to the logic that determines whether a
>> device
>> currently bound to a generic USB device driver should be re-probed by
>> a
>> more specific USB device driver or not. The code in
>> __usb_bus_reprobe_drivers() used to have the following lines:
>>
>>    if (usb_device_match_id(udev, new_udriver->id_table) == NULL &&
>>        (!new_udriver->match || new_udriver->match(udev) != 0))
>>   		return 0;
>>
>>    ret = device_reprobe(dev);
>>
>> As the reader will notice, the code checks whether the USB device in
>> consideration matches the identifier table (id_table) of a specific
>> USB device_driver (new_udriver), followed by a similar check, but
>> this
>> time with the USB device driver's match function. However, the match
>> function's return value is not checked correctly. When match()
>> returns
>> zero, it means that the specific USB device driver is *not*
>> applicable
>> to the USB device in question, but the code then goes on to reprobe
>> the
>> device with the new USB device driver under consideration. All this
>> to
>> say, the logic is inverted.
> 
> Could you split that change as the first commit in your patchset?

Of course!

> I'll test your patches locally once you've respun them. Thanks for
> working on this.
> 
> Cheers

Thank you for reviewing the patches! I intend to address your comments,
test the patches and publish them soon (i.e., likely within a few hours).

Thank you,

Vefa

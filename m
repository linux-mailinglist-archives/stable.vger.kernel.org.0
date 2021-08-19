Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8245F3F182A
	for <lists+stable@lfdr.de>; Thu, 19 Aug 2021 13:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238612AbhHSLZd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Aug 2021 07:25:33 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:45088 "EHLO smtp.gentoo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238210AbhHSLZd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Aug 2021 07:25:33 -0400
Subject: Re: Bluetooth: btusb: check conditions before enabling USB ALT 3 for
 WBS
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, pav@iki.fi
References: <a680e819-74da-0c40-9812-9f4e748dc20b@gentoo.org>
 <YR3vxtQuhyPG/SHW@kroah.com>
From:   Mike Pagano <mpagano@gentoo.org>
Message-ID: <f76dfa0e-b604-46fa-80da-403b061b9274@gentoo.org>
Date:   Thu, 19 Aug 2021 07:24:53 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YR3vxtQuhyPG/SHW@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 8/19/21 1:44 AM, Greg KH wrote:
> On Wed, Aug 18, 2021 at 07:04:47PM -0400, Mike wrote:
>> From: Pauli Virtanen <pav@iki.fi>
>> Kernel Version 5.13
>>
>> commit 55981d3541812234e687062926ff199c83f79a39 upstream.
> 
> There is no such commit in Linus's tree :(
> 
> 
>> - new_alts = btusb_find_altsetting(data, 6) ? 6 : 1;
>> - /* Because mSBC frames do not need to be aligned to the
>> - * SCO packet boundary. If support the Alt 3, use the
>> - * Alt 3 for HCI payload >= 60 Bytes let air packet
>> - * data satisfy 60 bytes.
>> - */
>> - if (new_alts == 1 && btusb_find_altsetting(data, 3))
>> + if (btusb_find_altsetting(data, 6))
>> + new_alts = 6;
>> + else if (btusb_find_altsetting(data, 3) &&
>> + hdev->sco_mtu >= 72 &&
>> + test_bit(BTUSB_USE_ALT3_FOR_WBS, &data->flags))
>> new_alts = 3;
> 
> 
> Your patch is also corrupted and could not be applied :(
> 

You're totally right, Greg. My apologies. Never work when you're tired.
I'll resubmit when it makes Linus' tree unless the author does.


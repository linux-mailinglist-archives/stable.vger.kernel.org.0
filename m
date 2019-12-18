Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0607124183
	for <lists+stable@lfdr.de>; Wed, 18 Dec 2019 09:21:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725785AbfLRIVo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Dec 2019 03:21:44 -0500
Received: from mo-csw1115.securemx.jp ([210.130.202.157]:51392 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726638AbfLRIVo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Dec 2019 03:21:44 -0500
Received: by mo-csw.securemx.jp (mx-mo-csw1115) id xBI8LT9L030770; Wed, 18 Dec 2019 17:21:29 +0900
X-Iguazu-Qid: 2wGrCZT71n0I4PWvZJ
X-Iguazu-QSIG: v=2; s=0; t=1576657289; q=2wGrCZT71n0I4PWvZJ; m=+8h1qAjsTLGXPM1968VgWfNcrs/nspPGKBlrzzdL4tU=
Received: from imx12.toshiba.co.jp (imx12.toshiba.co.jp [61.202.160.132])
        by relay.securemx.jp (mx-mr1112) id xBI8LR5w017160;
        Wed, 18 Dec 2019 17:21:28 +0900
Received: from enc02.toshiba.co.jp ([61.202.160.51])
        by imx12.toshiba.co.jp  with ESMTP id xBI8LRd5008097;
        Wed, 18 Dec 2019 17:21:27 +0900 (JST)
Received: from hop101.toshiba.co.jp ([133.199.85.107])
        by enc02.toshiba.co.jp  with ESMTP id xBI8LQ0A008269;
        Wed, 18 Dec 2019 17:21:26 +0900
From:   Punit Agrawal <punit1.agrawal@toshiba.co.jp>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-serial@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, nobuhiro1.iwamatsu@toshiba.co.jp,
        shrirang.bagul@canonical.com, stable@vger.kernel.org,
        Rob Herring <robh@kernel.org>, Johan Hovold <johan@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH] serdev: Don't claim unsupported serial devices
References: <20191218065646.817493-1-punit1.agrawal@toshiba.co.jp>
        <20191218081022.GA1553073@kroah.com>
Date:   Wed, 18 Dec 2019 17:22:17 +0900
In-Reply-To: <20191218081022.GA1553073@kroah.com> (Greg Kroah-Hartman's
        message of "Wed, 18 Dec 2019 09:10:22 +0100")
X-TSB-HOP: ON
Message-ID: <87tv5yniva.fsf@kokedama.swc.toshiba.co.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:

> On Wed, Dec 18, 2019 at 03:56:46PM +0900, Punit Agrawal wrote:
>> Serdev sub-system claims all serial devices that are not already
>> enumerated.
>
> All ACPI serial devices, right?  Surely not all other types of serial
> devices in the system.

That's right - I'll tighten the wording in the commit log and the patch
below to be ACPI specific.

>
> And what do you mean by "not already enumerated"?

This is referring to check using "acpi_device_enumerated()" when walking
ACPI devices. But the intention was to convey uninitialised serial
devices exposed via ACPI.

I'll update this as well.

Thanks for the review.

Punit

>
>> As a result, no device node is created for serial port on
>> certain boards such as the Apollo Lake based UP2. This has the
>> unintended consequence of not being able to raise the login prompt via
>> serial connection.
>> 
>> Introduce a blacklist to reject devices that should not be treated as
>
> "reject ACPI serial devices"
>
>> a serdev device. Add the Intel HS UART peripheral ids to the blacklist
>> to bring back serial port on SoCs carrying them.
>> 
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Punit Agrawal <punit1.agrawal@toshiba.co.jp>
>> Cc: Rob Herring <robh@kernel.org>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Cc: Johan Hovold <johan@kernel.org>
>> Cc: Hans de Goede <hdegoede@redhat.com>
>> ---
>> 
>> Hi,
>> 
>> The patch has been updated based on feedback recieved on the RFC[0].
>> 
>> Please consider merging if there are no objections.
>> 
>> Thanks,
>> Punit
>> 
>> [0] https://www.spinics.net/lists/linux-serial/msg36646.html
>> 
>>  drivers/tty/serdev/core.c | 10 ++++++++++
>>  1 file changed, 10 insertions(+)
>> 
>> diff --git a/drivers/tty/serdev/core.c b/drivers/tty/serdev/core.c
>> index 226adeec2aed..0d64fb7d4f36 100644
>> --- a/drivers/tty/serdev/core.c
>> +++ b/drivers/tty/serdev/core.c
>> @@ -663,6 +663,12 @@ static acpi_status acpi_serdev_register_device(struct serdev_controller *ctrl,
>>  	return AE_OK;
>>  }
>>  
>> +static const struct acpi_device_id serdev_blacklist_devices[] = {
>
> s/serdev_blacklist_devices/serdev_blacklist/acpi_devices/  ?
>
> This is an acpi-specific thing, not a generic tty thing.
>
> thanks,
>
> greg k-h

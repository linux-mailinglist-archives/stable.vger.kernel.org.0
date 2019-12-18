Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07EEB124269
	for <lists+stable@lfdr.de>; Wed, 18 Dec 2019 10:09:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbfLRJJT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Dec 2019 04:09:19 -0500
Received: from mo-csw1116.securemx.jp ([210.130.202.158]:47962 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725785AbfLRJJT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Dec 2019 04:09:19 -0500
Received: by mo-csw.securemx.jp (mx-mo-csw1116) id xBI990ER002408; Wed, 18 Dec 2019 18:09:01 +0900
X-Iguazu-Qid: 2wGrCZT71n3leK8dLF
X-Iguazu-QSIG: v=2; s=0; t=1576660140; q=2wGrCZT71n3leK8dLF; m=rfco90UILSOimrXwMALgZjlVnrVDPA16sFrMM/sRqFE=
Received: from imx2.toshiba.co.jp (imx2.toshiba.co.jp [106.186.93.51])
        by relay.securemx.jp (mx-mr1110) id xBI98x1j006356;
        Wed, 18 Dec 2019 18:08:59 +0900
Received: from enc01.localdomain ([106.186.93.100])
        by imx2.toshiba.co.jp  with ESMTP id xBI98xjd009356;
        Wed, 18 Dec 2019 18:08:59 +0900 (JST)
Received: from hop001.toshiba.co.jp ([133.199.164.63])
        by enc01.localdomain  with ESMTP id xBI98wb0028044;
        Wed, 18 Dec 2019 18:08:58 +0900
From:   Punit Agrawal <punit1.agrawal@toshiba.co.jp>
To:     Johan Hovold <johan@kernel.org>
Cc:     "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        <linux-serial@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <nobuhiro1.iwamatsu@toshiba.co.jp>,
        <shrirang.bagul@canonical.com>, <stable@vger.kernel.org>,
        Rob Herring <robh@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH] serdev: Don't claim unsupported serial devices
References: <20191218065646.817493-1-punit1.agrawal@toshiba.co.jp>
        <20191218085648.GI22665@localhost>
Date:   Wed, 18 Dec 2019 18:09:46 +0900
In-Reply-To: <20191218085648.GI22665@localhost> (Johan Hovold's message of
        "Wed, 18 Dec 2019 09:56:48 +0100")
X-TSB-HOP: ON
Message-ID: <87o8w6ngo5.fsf@kokedama.swc.toshiba.co.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Johan,

Johan Hovold <johan@kernel.org> writes:

> On Wed, Dec 18, 2019 at 03:56:46PM +0900, Punit Agrawal wrote:
>> Serdev sub-system claims all serial devices that are not already
>> enumerated. As a result, no device node is created for serial port on
>> certain boards such as the Apollo Lake based UP2. This has the
>> unintended consequence of not being able to raise the login prompt via
>> serial connection.
>> 
>> Introduce a blacklist to reject devices that should not be treated as
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
>
> Rafael, I vaguely remember you arguing for a white list when we
> discussed this at some conference. Do you have any objections to the
> blacklist approach taken here?
>
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
>> +	{"INT3511", 0},
>> +	{"INT3512", 0},
>
> Nit: Would you mind adding a space after { and before }?

Sure - no problem. I'll include it in the next posting.

Thanks for having a look.

>
>> +	{ },
>> +};
>
> Johan

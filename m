Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 728941C3DA8
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 16:55:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728367AbgEDOzQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 10:55:16 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:40509 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727819AbgEDOzP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 May 2020 10:55:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588604113;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3AdIoxC25r7jO/Pdtv3nZcFN5tMrEVw7Ox5wknWjVNE=;
        b=gZn6RF7LuyR2tdhk2i3tMKrNA+Y7RV6k24K3xpXDW42LMF6MNRYW8JgRyIUtuqaNxusIeA
        qq0SvtztLHj+zlqnxX48gb38gItILuJLpVD1B8McyhMMbmFJL/XxXfHYYAqLIpFg46A/VS
        213xFNiodcpdlsQt9mdgApin3xmLx+E=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-103-yYK2rI9ENkmjvdrCxk6_og-1; Mon, 04 May 2020 10:55:11 -0400
X-MC-Unique: yYK2rI9ENkmjvdrCxk6_og-1
Received: by mail-wr1-f69.google.com with SMTP id p8so92284wrj.5
        for <stable@vger.kernel.org>; Mon, 04 May 2020 07:55:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3AdIoxC25r7jO/Pdtv3nZcFN5tMrEVw7Ox5wknWjVNE=;
        b=IAkHRch7mqKxNTbqFARu5p3xUb1tPMQOBBvdBPvhil0lvwpygb3ZslzYp66obAl3ex
         Wd1pM58WZrrj47nE87UQXq4SzoVJS2j7g7WPM6xOAhfLfyE9+TbvZfD7LwGwdsFpUQf1
         cRwXQvpoI7Do9a8b/cjp/KdUWy9OvIjdGTWvglzULPpyzBHuGz6JhoDm6hQZFT2n/cp7
         06dJepeRxqR/xGY2w9pOSzT9W+zMwxfIgNJ3XzcAEmpudOIUrhCJNhYI6fAidTdeBir/
         1i7HzFFyvp4NXlaYqAh/k/7iOixCSP0rBdFWQVd9cQnDgJFC7Bwjvc/xHS3ZAVQ7xi8+
         5WPA==
X-Gm-Message-State: AGi0PuYHL8g9MtwkhqxdPS+qZgZuBTKapbzpGXeZpmJBuKjw6ZZpBRIY
        wLvAC7noSG21VIBRjDUolW0QCXD9ym0tzbmLQQUQr8Ee4017A6mnS1BiWecy9ebGEYm9DDIY4OB
        H75aMKBZIs6/xW+29
X-Received: by 2002:a5d:6584:: with SMTP id q4mr21448535wru.403.1588604109874;
        Mon, 04 May 2020 07:55:09 -0700 (PDT)
X-Google-Smtp-Source: APiQypJtCDadA0Me7xawY37NL+GzfwqqIbbwQSm4VPOWLLN2eI0jrq/ItNfvETO74HKCEfeCJH03kw==
X-Received: by 2002:a5d:6584:: with SMTP id q4mr21448446wru.403.1588604109110;
        Mon, 04 May 2020 07:55:09 -0700 (PDT)
Received: from x1.localdomain (2001-1c00-0c0c-fe00-d2ea-f29d-118b-24dc.cable.dynamic.v6.ziggo.nl. [2001:1c00:c0c:fe00:d2ea:f29d:118b:24dc])
        by smtp.gmail.com with ESMTPSA id k14sm19162025wrp.53.2020.05.04.07.55.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2020 07:55:08 -0700 (PDT)
Subject: Re: [PATCH] pinctrl: cherryview: Ensure _REG(ACPI_ADR_SPACE_GPIO, 1)
 gets called
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-gpio@vger.kernel.org, linux-acpi@vger.kernel.org,
        stable@vger.kernel.org
References: <20200429104651.63643-1-hdegoede@redhat.com>
 <20200429142159.GJ185537@smile.fi.intel.com>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <413bfc53-e3cb-aac1-2e3d-3eec9ed5a304@redhat.com>
Date:   Mon, 4 May 2020 16:55:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200429142159.GJ185537@smile.fi.intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 4/29/20 4:21 PM, Andy Shevchenko wrote:
> On Wed, Apr 29, 2020 at 12:46:51PM +0200, Hans de Goede wrote:
>> On Cherry Trail devices there are 2 possible ACPI OpRegions for
>> accessing GPIOs. The standard GeneralPurposeIo OpRegion and the Cherry
>> Trail specific UserDefined 0x9X OpRegions.
>>
>> Having 2 different types of OpRegions leads to potential issues with
>> checks for OpRegion availability, or in other words checks if _REG has
>> been called for the OpRegion which the ACPI code wants to use.
>>
>> The ACPICA core does not call _REG on an ACPI node which does not
>> define an OpRegion matching the type being registered; and the reference
>> design DSDT, from which most Cherry Trail DSDTs are derived, does not
>> define GeneralPurposeIo, nor UserDefined(0x93) OpRegions for the GPO2
>> (UID 3) device, because no pins were assigned ACPI controlled functions
>> in the reference design.
>>
>> Together this leads to the perfect storm, at least on the Cherry Trail
>> based Medion Akayo E1239T. This design does use a GPO2 pin from its ACPI
>> code and has added the Cherry Trail specific UserDefined(0x93) opregion
>> to its GPO2 ACPI node to access this pin.
>>
>> But it uses a has _REG been called availability check for the standard
>> GeneralPurposeIo OpRegion. This clearly is a bug in the DSDT, but this
>> does work under Windows. This issue leads to the intel_vbtn driver
>> reporting the device always being in tablet-mode at boot, even if it
>> is in laptop mode. Which in turn causes userspace to ignore touchpad
>> events. So iow this issues causes the touchpad to not work at boot.
>>
>> Since the bug in the DSDT stems from the confusion of having 2 different
>> OpRegion types for accessing GPIOs on Cherry Trail devices, I believe
>> that this is best fixed inside the cherryview pinctrl driver.
>>
>> This commit adds a workaround to the cherryview pinctrl driver so
>> that the DSDT's expectations of _REG always getting called for the
>> GeneralPurposeIo OpRegion are met.
> 
> s/cherryview/Cherryview/g

Fixed for v2.

> 
> ...
> 
>> +	if (acpi_has_method(adev->handle, "_REG")) {
> 
> And this check si redundant, you may call it as is (you didn't check for error
> anyway), see also below.

Good point, also dropped for v2.

>> +		struct acpi_object_list input;
>> +		union acpi_object params[2];
>> +
>> +		input.count = 2;
>> +		input.pointer = params;
>> +		params[0].type = ACPI_TYPE_INTEGER;
>> +		params[0].integer.value = ACPI_ADR_SPACE_GPIO;
>> +		params[1].type = ACPI_TYPE_INTEGER;
>> +		params[1].integer.value = 1;
>> +		acpi_evaluate_object(adev->handle, "_REG", &input, NULL);
>> +	}
> 
> Can you consider to unify this with one in drivers/pci/hotplug/acpiphp_glue.c,
> so we will have some helper function at the end? (perhaps as separate changes
> to make less burden on backporting this one)

I think that for backporting it is best to keep this patch as is
(with your other comments addresed). Also this way this can hopefully
be merged for a 5.7-rc# candidate.

I will do a follow up series adding a helper and moving both cases
over to the helper.

Regards,

Hans


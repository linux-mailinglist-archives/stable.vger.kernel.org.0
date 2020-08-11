Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3F30241B9F
	for <lists+stable@lfdr.de>; Tue, 11 Aug 2020 15:39:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728532AbgHKNjq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Aug 2020 09:39:46 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:47886 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728619AbgHKNjp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Aug 2020 09:39:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597153183;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aHM0Va84olzQtItpi4Mouml7v3hy76P4eZwlXG/YIo4=;
        b=jC7OpU13DxQLn7VgtAOeWH62JeK1DKzRvvjPV/k7sR/inyU8Pz88atPfwQZju4Gt65gYfz
        dfvZuDyy/BTMilC/CFsVGhmCbps804Kqi+ymMHg/ntzaXKnywWqYAKjYQp07v8XE0TD07G
        c+x3OV8uocZp66iV4mjs4ABSlV3bVW4=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-219-hfUyphWMNoiDqqZZ_d1A1g-1; Tue, 11 Aug 2020 09:39:41 -0400
X-MC-Unique: hfUyphWMNoiDqqZZ_d1A1g-1
Received: by mail-ed1-f71.google.com with SMTP id b11so4586913edy.17
        for <stable@vger.kernel.org>; Tue, 11 Aug 2020 06:39:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aHM0Va84olzQtItpi4Mouml7v3hy76P4eZwlXG/YIo4=;
        b=a1RdSLsJYzc6wF20Z3+QJQON84Nzf/QBEIU9tO9AOpqEUFyoTz41Agmz0l+pQa/Pn5
         IA2k1kMRapjJnDDPlQreE7/JnqrG8Ugesk+fE0p7X3rD7VaCAl24VLqm2kJttCczpGmB
         KFPuG0NpEl/+EAcUcj0LcSUOAqJj4U6wM0rRuBsNBOEjPiKL7hw50uV7DYpxKmkuFa9C
         c0fqhvT1j2xE91ydx6DN5pPK4BfhX81aoJZOAFPbsNTAxo97OGJjVdCpbiZXeVHzcC3K
         0wtYS1jognwQ3dxJ6nrPAzyvho3f1UnUc/QVMJXps4TZzhlhwrSwMU+jBonJL9sPMQgw
         V9yA==
X-Gm-Message-State: AOAM5321KNU7EkRPXRMUM0laVCgvjmtWa3lYhJLuL9wJHShT1VzPMamV
        h5OuoahcLTJ4OgD2zIlDsxS68/lPCkcc3avpKXpIwADD5iZUeDF1GM1OKg9yg/MmHWg7aLkseJn
        lQExnTalTmMzlABck
X-Received: by 2002:a17:906:a253:: with SMTP id bi19mr25855247ejb.338.1597153180604;
        Tue, 11 Aug 2020 06:39:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzYhnPHwAvoRQlImmNvp7f7mXCFUm3mKzXz5bM3s2r6WlOuHN9bZbCxRMx1tme6QiERKBahOw==
X-Received: by 2002:a17:906:a253:: with SMTP id bi19mr25855225ejb.338.1597153180339;
        Tue, 11 Aug 2020 06:39:40 -0700 (PDT)
Received: from x1.localdomain (2001-1c00-0c0c-fe00-d2ea-f29d-118b-24dc.cable.dynamic.v6.ziggo.nl. [2001:1c00:c0c:fe00:d2ea:f29d:118b:24dc])
        by smtp.gmail.com with ESMTPSA id s2sm14864654ejh.95.2020.08.11.06.39.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Aug 2020 06:39:39 -0700 (PDT)
Subject: Re: [PATCH v2] HID: i2c-hid: Always sleep 1ms after I2C_HID_PWR_ON
 commands
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        linux-input@vger.kernel.org, stable@vger.kernel.org,
        Andrea Borgia <andrea@borgia.bo.it>
References: <20200811125900.338705-1-hdegoede@redhat.com>
 <141CAECB-B76A-41D0-9D2D-4955DAAEBF77@canonical.com>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <47427dd7-1146-11d8-21f4-058f3753a91d@redhat.com>
Date:   Tue, 11 Aug 2020 15:39:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <141CAECB-B76A-41D0-9D2D-4955DAAEBF77@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 8/11/20 3:37 PM, Kai-Heng Feng wrote:
> Hi Hans,
> 
>> On Aug 11, 2020, at 20:59, Hans de Goede <hdegoede@redhat.com> wrote:
>>
>> Before this commit i2c_hid_parse() consists of the following steps:
>>
>> 1. Send power on cmd
>> 2. usleep_range(1000, 5000)
>> 3. Send reset cmd
>> 4. Wait for reset to complete (device interrupt, or msleep(100))
>> 5. Send power on cmd
>> 6. Try to read HID descriptor
>>
>> Notice how there is an usleep_range(1000, 5000) after the first power-on
>> command, but not after the second power-on command.
>>
>> Testing has shown that at least on the BMAX Y13 laptop's i2c-hid touchpad,
>> not having a delay after the second power-on command causes the HID
>> descriptor to read as all zeros.
>>
>> In case we hit this on other devices too, the descriptor being all zeros
>> can be recognized by the following message being logged many, many times:
>>
>> hid-generic 0018:0911:5288.0002: unknown main item tag 0x0
>>
>> At the same time as the BMAX Y13's touchpad issue was debugged,
>> Kai-Heng was working on debugging some issues with Goodix i2c-hid
>> touchpads. It turns out that these need a delay after a PWR_ON command
>> too, otherwise they stop working after a suspend/resume cycle.
>> According to Goodix a delay of minimal 60ms is needed.
>>
>> Having multiple cases where we need a delay after sending the power-on
>> command, seems to indicate that we should always sleep after the power-on
>> command.
>>
>> This commit fixes the mentioned issues by moving the existing 1ms sleep to
>> the i2c_hid_set_power() function and changing it to a 60ms sleep.
> 
> Thanks for your patch.
> 
> The subject is still "1ms" instead of "60ms".

Oops, v3 with this fixed coming up.

Regards,

Hans




>> Cc: stable@vger.kernel.org
>> BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=208247
>> Reported-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
>> Reported-and-tested-by: Andrea Borgia <andrea@borgia.bo.it>
>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>> ---
>> Changes in v2:
>> - Add Kai-Heng's case, with Goodix touchpads needing a delay after PWR_ON too,
>>   to the commit message
>> - Add a Reported-by tag for Kai-Heng
>> - Increase the delay to 60ms
>> ---
>> drivers/hid/i2c-hid/i2c-hid-core.c | 22 +++++++++++++---------
>> 1 file changed, 13 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/hid/i2c-hid/i2c-hid-core.c b/drivers/hid/i2c-hid/i2c-hid-core.c
>> index 294c84e136d7..dbd04492825d 100644
>> --- a/drivers/hid/i2c-hid/i2c-hid-core.c
>> +++ b/drivers/hid/i2c-hid/i2c-hid-core.c
>> @@ -420,6 +420,19 @@ static int i2c_hid_set_power(struct i2c_client *client, int power_state)
>> 		dev_err(&client->dev, "failed to change power setting.\n");
>>
>> set_pwr_exit:
>> +
>> +	/*
>> +	 * The HID over I2C specification states that if a DEVICE needs time
>> +	 * after the PWR_ON request, it should utilise CLOCK stretching.
>> +	 * However, it has been observered that the Windows driver provides a
>> +	 * 1ms sleep between the PWR_ON and RESET requests.
>> +	 * According to Goodix Windows even waits 60 ms after (other?)
>> +	 * PWR_ON requests. Testing has confirmed that several devices
>> +	 * will not work properly without a delay after a PWR_ON request.
>> +	 */
>> +	if (!ret && power_state == I2C_HID_PWR_ON)
>> +		msleep(60);
>> +
>> 	return ret;
>> }
>>
>> @@ -441,15 +454,6 @@ static int i2c_hid_hwreset(struct i2c_client *client)
>> 	if (ret)
>> 		goto out_unlock;
>>
>> -	/*
>> -	 * The HID over I2C specification states that if a DEVICE needs time
>> -	 * after the PWR_ON request, it should utilise CLOCK stretching.
>> -	 * However, it has been observered that the Windows driver provides a
>> -	 * 1ms sleep between the PWR_ON and RESET requests and that some devices
>> -	 * rely on this.
>> -	 */
>> -	usleep_range(1000, 5000);
>> -
>> 	i2c_hid_dbg(ihid, "resetting...\n");
>>
>> 	ret = i2c_hid_command(client, &hid_reset_cmd, NULL, 0);
>> -- 
>> 2.28.0
>>
> 


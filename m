Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B17E241B99
	for <lists+stable@lfdr.de>; Tue, 11 Aug 2020 15:37:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728550AbgHKNhg convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 11 Aug 2020 09:37:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43238 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728516AbgHKNhg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Aug 2020 09:37:36 -0400
Received: from mail-pl1-f200.google.com ([209.85.214.200])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1k5UT7-0008SG-Mz
        for stable@vger.kernel.org; Tue, 11 Aug 2020 13:37:33 +0000
Received: by mail-pl1-f200.google.com with SMTP id d2so5734600plo.2
        for <stable@vger.kernel.org>; Tue, 11 Aug 2020 06:37:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=agF91uPxkI85KxuPLWs+qcpOYVX+83uXg176lLmnz+E=;
        b=rba//yjiGJmwtBbkkBLaxBJFjweOhH671/MrCvMw90u/tdNoNmbo3+RBt5O7OZAPiy
         jQ21LoUFUpI61WCqH59UyacYnCgpw3bYZZDMQBjrkK83y0l4wWMqSJk5hDv39DCtVDVE
         NiZuPgGmfAz5no7e5DadP0qCVVm/GEoqrSappv/LlNmyiG86sOcrq5wfbHJwBzxIeaF8
         a3woVVyuTaoBXyAxyIgmzOwlQZHS4k8Iwb/BJOBBX1+J6RBzegQEJtjBA6k5dXCDa/Q2
         +g+yBUkoMmS+4Vkjn3JXPPxQqMi3Lf11tZJLr4M4R3ulWJ5ns45+h5/9jqTByN4aLcS3
         QYTg==
X-Gm-Message-State: AOAM532leleUi4uMT7db5G6kyiIohTYrU9ww6gOhukxlvSRFSxLtwpaU
        zCjnujP89YwvuqRSA6/OIYpKqPxANn5hCB1VGHOCFtYKCVs51lk6OHCNrqM1Vk3fglw54ubc1sX
        H2cf4lAwI6BqKLL+fKaYV29f5BnnU2YLbiw==
X-Received: by 2002:a62:3583:: with SMTP id c125mr6518660pfa.1.1597153052071;
        Tue, 11 Aug 2020 06:37:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwiX4u6AakcFd2PZAL2henPGnVpR5m1dyEdLYoNJc98JtYYu4TErVex4B4iOfbD/epnpuh2Hg==
X-Received: by 2002:a62:3583:: with SMTP id c125mr6518628pfa.1.1597153051646;
        Tue, 11 Aug 2020 06:37:31 -0700 (PDT)
Received: from [192.168.1.208] (220-133-187-190.HINET-IP.hinet.net. [220.133.187.190])
        by smtp.gmail.com with ESMTPSA id u65sm10579783pfb.102.2020.08.11.06.37.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 11 Aug 2020 06:37:31 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.1\))
Subject: Re: [PATCH v2] HID: i2c-hid: Always sleep 1ms after I2C_HID_PWR_ON
 commands
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
In-Reply-To: <20200811125900.338705-1-hdegoede@redhat.com>
Date:   Tue, 11 Aug 2020 21:37:28 +0800
Cc:     Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        linux-input@vger.kernel.org, stable@vger.kernel.org,
        Andrea Borgia <andrea@borgia.bo.it>
Content-Transfer-Encoding: 8BIT
Message-Id: <141CAECB-B76A-41D0-9D2D-4955DAAEBF77@canonical.com>
References: <20200811125900.338705-1-hdegoede@redhat.com>
To:     Hans de Goede <hdegoede@redhat.com>
X-Mailer: Apple Mail (2.3608.120.23.2.1)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Hans,

> On Aug 11, 2020, at 20:59, Hans de Goede <hdegoede@redhat.com> wrote:
> 
> Before this commit i2c_hid_parse() consists of the following steps:
> 
> 1. Send power on cmd
> 2. usleep_range(1000, 5000)
> 3. Send reset cmd
> 4. Wait for reset to complete (device interrupt, or msleep(100))
> 5. Send power on cmd
> 6. Try to read HID descriptor
> 
> Notice how there is an usleep_range(1000, 5000) after the first power-on
> command, but not after the second power-on command.
> 
> Testing has shown that at least on the BMAX Y13 laptop's i2c-hid touchpad,
> not having a delay after the second power-on command causes the HID
> descriptor to read as all zeros.
> 
> In case we hit this on other devices too, the descriptor being all zeros
> can be recognized by the following message being logged many, many times:
> 
> hid-generic 0018:0911:5288.0002: unknown main item tag 0x0
> 
> At the same time as the BMAX Y13's touchpad issue was debugged,
> Kai-Heng was working on debugging some issues with Goodix i2c-hid
> touchpads. It turns out that these need a delay after a PWR_ON command
> too, otherwise they stop working after a suspend/resume cycle.
> According to Goodix a delay of minimal 60ms is needed.
> 
> Having multiple cases where we need a delay after sending the power-on
> command, seems to indicate that we should always sleep after the power-on
> command.
> 
> This commit fixes the mentioned issues by moving the existing 1ms sleep to
> the i2c_hid_set_power() function and changing it to a 60ms sleep.

Thanks for your patch.

The subject is still "1ms" instead of "60ms".

Kai-Heng

> 
> Cc: stable@vger.kernel.org
> BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=208247
> Reported-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> Reported-and-tested-by: Andrea Borgia <andrea@borgia.bo.it>
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
> Changes in v2:
> - Add Kai-Heng's case, with Goodix touchpads needing a delay after PWR_ON too,
>  to the commit message
> - Add a Reported-by tag for Kai-Heng
> - Increase the delay to 60ms
> ---
> drivers/hid/i2c-hid/i2c-hid-core.c | 22 +++++++++++++---------
> 1 file changed, 13 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/hid/i2c-hid/i2c-hid-core.c b/drivers/hid/i2c-hid/i2c-hid-core.c
> index 294c84e136d7..dbd04492825d 100644
> --- a/drivers/hid/i2c-hid/i2c-hid-core.c
> +++ b/drivers/hid/i2c-hid/i2c-hid-core.c
> @@ -420,6 +420,19 @@ static int i2c_hid_set_power(struct i2c_client *client, int power_state)
> 		dev_err(&client->dev, "failed to change power setting.\n");
> 
> set_pwr_exit:
> +
> +	/*
> +	 * The HID over I2C specification states that if a DEVICE needs time
> +	 * after the PWR_ON request, it should utilise CLOCK stretching.
> +	 * However, it has been observered that the Windows driver provides a
> +	 * 1ms sleep between the PWR_ON and RESET requests.
> +	 * According to Goodix Windows even waits 60 ms after (other?)
> +	 * PWR_ON requests. Testing has confirmed that several devices
> +	 * will not work properly without a delay after a PWR_ON request.
> +	 */
> +	if (!ret && power_state == I2C_HID_PWR_ON)
> +		msleep(60);
> +
> 	return ret;
> }
> 
> @@ -441,15 +454,6 @@ static int i2c_hid_hwreset(struct i2c_client *client)
> 	if (ret)
> 		goto out_unlock;
> 
> -	/*
> -	 * The HID over I2C specification states that if a DEVICE needs time
> -	 * after the PWR_ON request, it should utilise CLOCK stretching.
> -	 * However, it has been observered that the Windows driver provides a
> -	 * 1ms sleep between the PWR_ON and RESET requests and that some devices
> -	 * rely on this.
> -	 */
> -	usleep_range(1000, 5000);
> -
> 	i2c_hid_dbg(ihid, "resetting...\n");
> 
> 	ret = i2c_hid_command(client, &hid_reset_cmd, NULL, 0);
> -- 
> 2.28.0
> 


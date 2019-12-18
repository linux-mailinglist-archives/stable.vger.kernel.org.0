Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8C77124247
	for <lists+stable@lfdr.de>; Wed, 18 Dec 2019 09:56:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726141AbfLRI4z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Dec 2019 03:56:55 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:44836 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725930AbfLRI4z (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Dec 2019 03:56:55 -0500
Received: by mail-lj1-f194.google.com with SMTP id u71so1205370lje.11;
        Wed, 18 Dec 2019 00:56:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2pvUrPAon17LRPsjtdMoeMiHaoRDmKh4/5W2a/apsGU=;
        b=f29jRmrcnP+fYOKhJTXp3WgBB5qbL0yhXbAhNL+pFSpafaDKm1XkNR6IU2ILG+vuJw
         z6mOe6i10II8eL4hcAF5aUyOxKNuHsyUwGLDBxPykcEMHnWvnRNUuHfvOGex1lZPAoU7
         xbJqP03YF8J82Cajaqr3Tk+Bf+QZjOMqmiVgQ92PtniUAusz6Ka8upmAazhA1BztWw5i
         IE+HLVvCPM+h2Wookx/l9dHYfTG/d7UNbLXck1RJm2T7benGN8oeAkveJOln/ZhiRP8l
         kErB9izqlTndOfcICTX7+gukpS/EbPYS/+iEJ4WX07VoSBwZg7ZPkydV+UUjrYATYMD5
         W51Q==
X-Gm-Message-State: APjAAAWFDM+j+4MLqGV4PQUB02X9ttSdS5kkxZ3mv8Eexk3xTltEzaYu
        qIyp01zhH7KYT3MKj2Hj3p8=
X-Google-Smtp-Source: APXvYqyTroQMW+oB0GI2s10lXnPaksPy7LUqHc6ZWfbi7h6PFY5jQDh6YGryHRQyWC+mfyG3bpB9+w==
X-Received: by 2002:a2e:95c4:: with SMTP id y4mr937300ljh.38.1576659412861;
        Wed, 18 Dec 2019 00:56:52 -0800 (PST)
Received: from xi.terra (c-14b8e655.07-184-6d6c6d4.bbcust.telenor.se. [85.230.184.20])
        by smtp.gmail.com with ESMTPSA id 30sm929294ljv.99.2019.12.18.00.56.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 00:56:52 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@kernel.org>)
        id 1ihV8S-0002sL-6e; Wed, 18 Dec 2019 09:56:48 +0100
Date:   Wed, 18 Dec 2019 09:56:48 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Punit Agrawal <punit1.agrawal@toshiba.co.jp>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc:     linux-serial@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, nobuhiro1.iwamatsu@toshiba.co.jp,
        shrirang.bagul@canonical.com, stable@vger.kernel.org,
        Rob Herring <robh@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Johan Hovold <johan@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH] serdev: Don't claim unsupported serial devices
Message-ID: <20191218085648.GI22665@localhost>
References: <20191218065646.817493-1-punit1.agrawal@toshiba.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191218065646.817493-1-punit1.agrawal@toshiba.co.jp>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 18, 2019 at 03:56:46PM +0900, Punit Agrawal wrote:
> Serdev sub-system claims all serial devices that are not already
> enumerated. As a result, no device node is created for serial port on
> certain boards such as the Apollo Lake based UP2. This has the
> unintended consequence of not being able to raise the login prompt via
> serial connection.
> 
> Introduce a blacklist to reject devices that should not be treated as
> a serdev device. Add the Intel HS UART peripheral ids to the blacklist
> to bring back serial port on SoCs carrying them.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Punit Agrawal <punit1.agrawal@toshiba.co.jp>
> Cc: Rob Herring <robh@kernel.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Johan Hovold <johan@kernel.org>
> Cc: Hans de Goede <hdegoede@redhat.com>
> ---
> 
> Hi,
> 
> The patch has been updated based on feedback recieved on the RFC[0].
> 
> Please consider merging if there are no objections.

Rafael, I vaguely remember you arguing for a white list when we
discussed this at some conference. Do you have any objections to the
blacklist approach taken here?

> [0] https://www.spinics.net/lists/linux-serial/msg36646.html
> 
>  drivers/tty/serdev/core.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/tty/serdev/core.c b/drivers/tty/serdev/core.c
> index 226adeec2aed..0d64fb7d4f36 100644
> --- a/drivers/tty/serdev/core.c
> +++ b/drivers/tty/serdev/core.c
> @@ -663,6 +663,12 @@ static acpi_status acpi_serdev_register_device(struct serdev_controller *ctrl,
>  	return AE_OK;
>  }
>  
> +static const struct acpi_device_id serdev_blacklist_devices[] = {
> +	{"INT3511", 0},
> +	{"INT3512", 0},

Nit: Would you mind adding a space after { and before }?

> +	{ },
> +};

Johan

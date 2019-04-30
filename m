Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6CCDFD1A
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 17:43:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726155AbfD3PnF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 11:43:05 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:46424 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbfD3PnE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Apr 2019 11:43:04 -0400
Received: by mail-oi1-f196.google.com with SMTP id d62so5748041oib.13;
        Tue, 30 Apr 2019 08:43:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AoX+I432QQxxlKFEhrHPIkG45LFW4z5n+eTjo4qg/pg=;
        b=fuQlWpUcKOwVjnkw1I7fqFtB4+4QWdMXNYNGuJLFLXbUTNC+zKnz8+hyV44Z2miymA
         wtgdhpC1tFVjb6vFncu/zDK5IwEq2Jo0PafsGW/DNhkx/eyY7FPZVIS/Tch48F3GRVdo
         xL5NFcS8Wj0xaH14QOtQs154Fc1WtMMiBot7cwzkxNeuvXrX1ddvbMQOmhk0JD2vdPFm
         /fJMC4/ZrZY/HJAle0yiqckyDqYHbJ9bI64ttw+MDiUVmeRJqvn2ypMsfbYF3kRpGJYm
         5tLatS7Be9xqaUU3teBmQsPjNV7z784JJ6W3MzVklPt3uLLbZ55ANWdtesKgwj2Hl7Xo
         G0Og==
X-Gm-Message-State: APjAAAVgDo9RO76avV6GKC97LkVAIejI7sOrfPOWQXEg07eP+TGvXSit
        X26Ga+3o6M/ISzmEvy8sUcaGXq4yqTIzxCEQEprJLQ==
X-Google-Smtp-Source: APXvYqyAYo6r1DdXN/rjG4yyp08YAtg4XguUpxKXTiDi5AD26pkuacjSGcDFehoH3aH3n+s2HRH0dnE9n4mfkzWrbMU=
X-Received: by 2002:aca:b841:: with SMTP id i62mr3675255oif.103.1556638983470;
 Tue, 30 Apr 2019 08:43:03 -0700 (PDT)
MIME-Version: 1.0
References: <20190430142322.15013-1-jarkko.nikula@linux.intel.com>
In-Reply-To: <20190430142322.15013-1-jarkko.nikula@linux.intel.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Tue, 30 Apr 2019 17:42:52 +0200
Message-ID: <CAJZ5v0gimPdVY8FbzNPZQK=pMGzynpxJqUR_ypSh9OTAsObfrw@mail.gmail.com>
Subject: Re: [PATCH] i2c: Prevent runtime suspend of adapter when Host Notify
 is required
To:     Jarkko Nikula <jarkko.nikula@linux.intel.com>
Cc:     linux-i2c <linux-i2c@vger.kernel.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Keijo Vaara <ferdasyn@rocketmail.com>,
        linux-input@vger.kernel.org, Bjorn Helgaas <helgaas@kernel.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 30, 2019 at 4:23 PM Jarkko Nikula
<jarkko.nikula@linux.intel.com> wrote:
>
> Multiple users have reported their Synaptics touchpad has stopped
> working between v4.20.1 and v4.20.2 when using SMBus interface.
>
> The culprit for this appeared to be commit c5eb1190074c ("PCI / PM: Allow
> runtime PM without callback functions") that fixed the runtime PM for
> i2c-i801 SMBus adapter. Those Synaptics touchpad are using i2c-i801
> for SMBus communication and testing showed they are able to get back
> working by preventing the runtime suspend of adapter.
>
> Normally when i2c-i801 SMBus adapter transmits with the client it resumes
> before operation and autosuspends after.
>
> However, if client requires SMBus Host Notify protocol, what those
> Synaptics touchpads do, then the host adapter must not go to runtime
> suspend since then it cannot process incoming SMBus Host Notify commands
> the client may send.
>
> Fix this by keeping I2C/SMBus adapter active in case client requires
> Host Notify.
>
> Reported-by: Keijo Vaara <ferdasyn@rocketmail.com>
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=203297
> Fixes: c5eb1190074c ("PCI / PM: Allow runtime PM without callback functions")
> Cc: stable@vger.kernel.org # v4.20+
> Signed-off-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>

Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Or please let me know if you want me to take this.

> ---
> Keijo: could you test this does it fix the issue you reported? This is
> practically the same diff I sent earlier what you probably haven't tested yet.
> I wanted to send a commitable fix in case it works since I'll be out of
> office in a few coming days.
> ---
>  drivers/i2c/i2c-core-base.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/drivers/i2c/i2c-core-base.c b/drivers/i2c/i2c-core-base.c
> index 38af18645133..8149c9e32b69 100644
> --- a/drivers/i2c/i2c-core-base.c
> +++ b/drivers/i2c/i2c-core-base.c
> @@ -327,6 +327,8 @@ static int i2c_device_probe(struct device *dev)
>
>                 if (client->flags & I2C_CLIENT_HOST_NOTIFY) {
>                         dev_dbg(dev, "Using Host Notify IRQ\n");
> +                       /* Keep adapter active when Host Notify is required */
> +                       pm_runtime_get_sync(&client->adapter->dev);
>                         irq = i2c_smbus_host_notify_to_irq(client);
>                 } else if (dev->of_node) {
>                         irq = of_irq_get_byname(dev->of_node, "irq");
> @@ -431,6 +433,8 @@ static int i2c_device_remove(struct device *dev)
>         device_init_wakeup(&client->dev, false);
>
>         client->irq = client->init_irq;
> +       if (client->flags & I2C_CLIENT_HOST_NOTIFY)
> +               pm_runtime_put(&client->adapter->dev);
>
>         return status;
>  }
> --
> 2.20.1
>

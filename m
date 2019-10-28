Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54E9AE735B
	for <lists+stable@lfdr.de>; Mon, 28 Oct 2019 15:08:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729026AbfJ1OIB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Oct 2019 10:08:01 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38989 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728994AbfJ1OIB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Oct 2019 10:08:01 -0400
Received: by mail-wr1-f68.google.com with SMTP id a11so10033760wra.6
        for <stable@vger.kernel.org>; Mon, 28 Oct 2019 07:08:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=d/47im9brVsJSTkMNILhiZRSBCNfo+zwZlKSgFnsmGs=;
        b=DES0NVXXyc1jwo4feKDitsOYMf089nFp8uRQsS9h55Ob/Y8Wr5Qv1vWwZG2ozqcJWG
         hG9yXunShV2fEDREybw2fhcRFjoYK2ZPofnlP2+D9hElaa8Q8priLJpU2tggW4tKujDe
         c4M9ryHKMiFAMO2w/y4LRVQTknjzUeEmL6B7rBQ6wRS9DVyKVfQvwSKOK3aG6oUfjJYH
         cE9To10KIO7p/7G+IwM653KsrpZHgEp7PP8wi7vh5fRzLV8xaRH9bqteFbq3BlOtAUjx
         spLW3iOkMOXm2NsiFRcwxaFanKJDltufbGXAQXa9ytt+pm2K8s1eJW3z5k+K8OOM7Dzx
         NUBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d/47im9brVsJSTkMNILhiZRSBCNfo+zwZlKSgFnsmGs=;
        b=ROFkdkaHmIczpI6KyZcBHuNJyVORFVIXqJnCqpmQ0nlkx0zhQRDg+bXZKmolgDmUY/
         YYolE8fW8LcYgJJgPFRT831GYNpQq1dyducpkxHO4UW/k7eLt2Y42WdSQekZ8k7Ibqj/
         ulu+MgnoM8f2H6ThJ7r/t0pjBg2JtVgC5OlKMuPlO3MYmCS3j+EieUXwWZksIMxAvY4n
         YyRGFfNyvXPjFYXQBlbgLzmOoo0r7k7cyfqEYnYbN2UuHZDZ6sUeo2KJVT+iBC4bVu46
         +Cte2NnuFeiBc5kvAJaWdUpEVjMUSgkcb0ouxsCT2n6AS9HPy+XKrJpy8/7b+xUYa/1k
         01cQ==
X-Gm-Message-State: APjAAAUlWOMToh0VEGznEaIVz281yPumL/tWBuzaDASPsptO7QgdF8gB
        r3hYrUIbSYr3eLJtjsZJ4vaGSYfnht6U0EnEzeTVgw==
X-Google-Smtp-Source: APXvYqz4rOIvSdNKPGhhOzTx+kL8Bk0ytJVzgnAvIbIIvMJqbEsbhkQB2tK2ydYBjlczSIdAjvKw8xeM6QiEVHZRRe8=
X-Received: by 2002:adf:fb0b:: with SMTP id c11mr15791854wrr.50.1572271679494;
 Mon, 28 Oct 2019 07:07:59 -0700 (PDT)
MIME-Version: 1.0
References: <1572036050-18945-1-git-send-email-kmahlkuc@linux.vnet.ibm.com>
In-Reply-To: <1572036050-18945-1-git-send-email-kmahlkuc@linux.vnet.ibm.com>
From:   Alex Deucher <alexdeucher@gmail.com>
Date:   Mon, 28 Oct 2019 10:07:47 -0400
Message-ID: <CADnq5_Mky3rf8x2f1VJinDO02fQ8UBEW-iDL5nUHrAsSXQKHVg@mail.gmail.com>
Subject: Re: [PATCH v3] drm/radeon: Fix EEH during kexec
To:     KyleMahlkuch <kmahlkuc@linux.vnet.ibm.com>
Cc:     "Deucher, Alexander" <alexander.deucher@amd.com>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        "for 3.8" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 25, 2019 at 4:44 PM KyleMahlkuch
<kmahlkuc@linux.vnet.ibm.com> wrote:
>
> From: Kyle Mahlkuch <kmahlkuc@linux.vnet.ibm.com>
>
> During kexec some adapters hit an EEH since they are not properly
> shut down in the radeon_pci_shutdown() function. Adding
> radeon_suspend_kms() fixes this issue.
> Enabled only on PPC because this patch causes issues on some other
> boards.
>
> Signed-off-by: Kyle Mahlkuch <kmahlkuc@linux.vnet.ibm.com>

Applied.  Thanks!

Alex

> ---
>  drivers/gpu/drm/radeon/radeon_drv.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
>
> diff --git a/drivers/gpu/drm/radeon/radeon_drv.c b/drivers/gpu/drm/radeon/radeon_drv.c
> index 9e55076..4528f4d 100644
> --- a/drivers/gpu/drm/radeon/radeon_drv.c
> +++ b/drivers/gpu/drm/radeon/radeon_drv.c
> @@ -379,11 +379,25 @@ static int radeon_pci_probe(struct pci_dev *pdev,
>  static void
>  radeon_pci_shutdown(struct pci_dev *pdev)
>  {
> +#ifdef CONFIG_PPC64
> +       struct drm_device *ddev = pci_get_drvdata(pdev);
> +#endif
> +
>         /* if we are running in a VM, make sure the device
>          * torn down properly on reboot/shutdown
>          */
>         if (radeon_device_is_virtual())
>                 radeon_pci_remove(pdev);
> +
> +#ifdef CONFIG_PPC64
> +       /* Some adapters need to be suspended before a
> +        * shutdown occurs in order to prevent an error
> +        * during kexec.
> +        * Make this power specific becauase it breaks
> +        * some non-power boards.
> +        */
> +       radeon_suspend_kms(ddev, true, true, false);
> +#endif
>  }
>
>  static int radeon_pmops_suspend(struct device *dev)
> --
> 1.8.3.1
>
> _______________________________________________
> amd-gfx mailing list
> amd-gfx@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/amd-gfx

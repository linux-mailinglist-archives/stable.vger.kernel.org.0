Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 744902D5C96
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 14:59:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732007AbgLJN6j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 08:58:39 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:46824 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389790AbgLJN6H (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Dec 2020 08:58:07 -0500
Received: by mail-ot1-f67.google.com with SMTP id w3so4889612otp.13;
        Thu, 10 Dec 2020 05:57:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9zvGhB9hn6gJaMimBWyOTiNQbEgukBwg3qTljKV1OI4=;
        b=f+OYKMTt2vSBY821hrTEYi4z5D4UzkcZDrj36vcGJADQKiJaO2y+/7ncMxJstA9L79
         ro0m5UjLgjCu2QQpwZs2o5nortDxWKkpOBZ5unKJSOXxIVkah9uLVtV4BNwvv902Twcn
         NuNKEBfk67ngIoZRoNwlFC4A0Im6AGAuAOL0gxM68hwt0iS0xaB0jEWmO3x7vb1pzIHI
         y8GqqEJvKMcLYtCgSdGxiNx1Jv9HT+ChX0hkEWdED1llpCr31AsTEmHh61vRn9w0Agx/
         2412v7kKVVxNeTHdHvEVQ54+QlK8+dA87kaGlNFTwY8Gh/2ip86oqXykD11eBEHGnouR
         MZ1g==
X-Gm-Message-State: AOAM532n3gPKSfq7FvX0y2bHCsjil5A+PtaqarsAFzGxlRtnIaHLrVM1
        ZYOC3BYv6Ph201UPVKGBCv4JAN60rNRtckR17H6MlX3K
X-Google-Smtp-Source: ABdhPJzMl+1wLpRe+fR7dVsOCN2UkcDWPPuvAmcjByX4eEKJh7x5W83PE/j16hLiP5QNCwvCEkuqkSgnu+bp3VehpJ0=
X-Received: by 2002:a9d:208a:: with SMTP id x10mr4182012ota.260.1607608646023;
 Thu, 10 Dec 2020 05:57:26 -0800 (PST)
MIME-Version: 1.0
References: <20201210012539.5747-1-hui.wang@canonical.com>
In-Reply-To: <20201210012539.5747-1-hui.wang@canonical.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Thu, 10 Dec 2020 14:57:13 +0100
Message-ID: <CAJZ5v0jDHka2mxHiUBd41N5QV0ePS9O-EbFz46DXTYPKbDv-Ug@mail.gmail.com>
Subject: Re: [PATCH v2] ACPI / PNP: check the string length of pnp device id
 in matching_id
To:     Hui Wang <hui.wang@canonical.com>
Cc:     ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Len Brown <lenb@kernel.org>, Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 10, 2020 at 2:27 AM Hui Wang <hui.wang@canonical.com> wrote:
>
> Recently we met a touchscreen problem on some Thinkpad machines, the
> touchscreen driver (i2c-hid) is not loaded and the touchscreen can't
> work.
>
> An i2c ACPI device with the name WACF2200 is defined in the BIOS, with
> the current ACPI PNP matching rule, this device will be regarded as
> a PNP device since there is WACFXXX in the acpi_pnp_device_ids[] and
> this PNP device is attached to the acpi device as the 1st
> physical_node, this will make the i2c bus match fail when i2c bus
> calls acpi_companion_match() to match the acpi_id_table in the i2c-hid
> driver.
>
> An ACPI PNP device's id has fixed format and its string length equals
> 7, after adding this check in the matching_id, the touchscreen could
> work.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Hui Wang <hui.wang@canonical.com>
> ---
>  drivers/acpi/acpi_pnp.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/drivers/acpi/acpi_pnp.c b/drivers/acpi/acpi_pnp.c
> index 4ed755a963aa..5ce711b9b070 100644
> --- a/drivers/acpi/acpi_pnp.c
> +++ b/drivers/acpi/acpi_pnp.c
> @@ -319,6 +319,10 @@ static bool matching_id(const char *idstr, const char *list_id)
>  {
>         int i;
>
> +       /* a pnp device id has CCCdddd format (C character, d digit), strlen should be 7 */
> +       if (strlen(idstr) != 7)
> +               return false;

What I meant was comparing the length of the arg strings and return
false if they don't match.  Wouldn't that work?

> +
>         if (memcmp(idstr, list_id, 3))
>                 return false;
>
> --
> 2.25.1
>

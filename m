Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CD7813256F
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 12:58:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727834AbgAGL6E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 06:58:04 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:41437 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728019AbgAGL6E (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jan 2020 06:58:04 -0500
Received: by mail-lf1-f68.google.com with SMTP id m30so38659871lfp.8
        for <stable@vger.kernel.org>; Tue, 07 Jan 2020 03:58:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xDan+NrzXoxR0IPHrL1TDLZarGAclLuRifX+nstdyLs=;
        b=ZPMn1nE42pxSFIb1/Jg5EmMBDBWfpJQgc8kIHzd/wnsIg2z055kAeJe7IZ2lGrc4VL
         5iOir8/YoGZBNkqMWNXaOcbg+N/r6+fBoQT6km2FvUpMk7pcIVvr8jxVeX0JbAzzGCZN
         iI49xWxMtMPuXPX0jJ2HosEiAOgGCEvLEVp4WJzyqu0yjdtWOLNiu7F8F7TIV++LYAZr
         uOhFfo5Xoefp+qWIgsAz4DVWy6WFyiBlgFZ5gTi7lZacYbdFEhKD6rb0esbk/bVgt7Kh
         ds63EIcLrBWwiztHDjS82JL3nJTbkG9Wgjt4BDhKFhlUtUkb1ZapxVFO3gsFt5mE4e6D
         w8sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xDan+NrzXoxR0IPHrL1TDLZarGAclLuRifX+nstdyLs=;
        b=IEDWqWiKFYAaSkO1le952OeDUqpGzW2a+ychYCuT1n72GpmILHpU1Aimkdd1dmLTTx
         Lbr18saE6StyJfUpTgHoWG3/qftyTyTLa6qXkoq3UTgexEJDI+bRLKO1uQYBJ51LqdDd
         OOiapVba/+OL8Kw+NsIlO9M2TjBxQrNcL/UVHV32tlYCT9OQRxvGU9Y4MG24orhEaeJU
         UdDsW14lfwW++pUebCzHVRIdT4sfz72Xet/76y3KFvzLca43K4/zNlrHRm1hBjSAlxHz
         qsPkK2zxkBFLDOGhylNuPhFDl7SOukT3DcxPM0EnASHR7QcmTYz4CrApuLqgWmXYg+bz
         ks0w==
X-Gm-Message-State: APjAAAWGEy3455I0IgodRmTCrF9l5yyaf4NwbSradT5fHAM2/ie24sGF
        gH6AnIt/E6dXf14I9OwjaHalwnUIatJiUozOPmqwYw==
X-Google-Smtp-Source: APXvYqwBV7Ee1u2/FkNJ0D4MbpRQIHVF3KeTSLqGk3g7UjA/Un7cz14I6dnnOSlGcQuSrKdeuZpBbnhTEHw44fEXAz0=
X-Received: by 2002:a19:8a41:: with SMTP id m62mr59154614lfd.5.1578398282446;
 Tue, 07 Jan 2020 03:58:02 -0800 (PST)
MIME-Version: 1.0
References: <20200105160357.97154-1-hdegoede@redhat.com> <20200105160357.97154-2-hdegoede@redhat.com>
In-Reply-To: <20200105160357.97154-2-hdegoede@redhat.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Tue, 7 Jan 2020 12:57:51 +0100
Message-ID: <CACRpkdYx864UEo9-Bpiian4evJMrrCN-kp61s+Y1gc7BZ88KZA@mail.gmail.com>
Subject: Re: [PATCH resend v2 1/2] gpiolib: acpi: Turn dmi_system_id table
 into a generic quirk table
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 5, 2020 at 5:04 PM Hans de Goede <hdegoede@redhat.com> wrote:

> Turn the existing run_edge_events_on_boot_blacklist dmi_system_id table
> into a generic quirk table, storing the quirks in the driver_data ptr.
>
> This is a preparation patch for adding other types of (DMI based) quirks.
>
> Cc: stable@vger.kernel.org
> Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>

Patch applied for fixes.

Yours,
Linus Walleij

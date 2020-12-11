Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEC482D7C78
	for <lists+stable@lfdr.de>; Fri, 11 Dec 2020 18:11:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731905AbgLKRIZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Dec 2020 12:08:25 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:45846 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391969AbgLKRHx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Dec 2020 12:07:53 -0500
Received: by mail-ot1-f65.google.com with SMTP id h18so8826590otq.12;
        Fri, 11 Dec 2020 09:07:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=F/h29HAC558Bg8Qs8tEOs2uZIdpDVtZwMm4bchCbIDc=;
        b=HqdvpSjkkc+zMXntXu/N30Qy24ZR/UHnCRIWQ0YqBwMmlpcxjjY0Ieo+vO4WKkxhNs
         L9PI4K+q1WgaeiM77soR939CozDQDVLPLo7dDZ2C/yAfhpmcrAXGvQXZoP2USNRoE+Zn
         RelIesFqmLTTYEIUEIljttECrKQ441xnQ9wkdGpOMKhdkGwacX/ixu7ImctN0qTZeeTj
         hpkfaUTPHsey024JdO0K8RghDtx4S7MwzxAT7+40wmjvZIyKF+YsqBR3Ww3mgSdbD1UA
         8aml/xwiaJysvkhVCsrdISeoqZcp4gR/2j4dRNEuOvD2qb6awpnIt9NIz5EL4ISrQhKQ
         c3ZQ==
X-Gm-Message-State: AOAM531xWhSg4z5LNqozOip7FwLzS2R+T1Isij5HUcTZpcYVsZbyX/av
        djWDE8mStvaxAVLEuqx+/+tbl16sN7GHFa9LbV8=
X-Google-Smtp-Source: ABdhPJxEMIjH8BhKVtsFNTjbKycBJ5a1wpXT30fvx3K1VAsmB741arryrnX61sajOMku7+attcY9Dx4mucEeObAkVmc=
X-Received: by 2002:a9d:208a:: with SMTP id x10mr8813912ota.260.1607706432927;
 Fri, 11 Dec 2020 09:07:12 -0800 (PST)
MIME-Version: 1.0
References: <20201210012539.5747-1-hui.wang@canonical.com> <X9HklmczekRvwKTE@kroah.com>
 <b99ea4e8-8bc2-6533-b78d-8a729c9400f7@canonical.com>
In-Reply-To: <b99ea4e8-8bc2-6533-b78d-8a729c9400f7@canonical.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Fri, 11 Dec 2020 18:07:01 +0100
Message-ID: <CAJZ5v0iv6LvNu5nkGOARpJ7vhBjHvafFeTO_bMA3SBi-k-sFBA@mail.gmail.com>
Subject: Re: [PATCH v2] ACPI / PNP: check the string length of pnp device id
 in matching_id
To:     Hui Wang <hui.wang@canonical.com>
Cc:     Greg KH <greg@kroah.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Len Brown <lenb@kernel.org>, Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 11, 2020 at 1:43 AM Hui Wang <hui.wang@canonical.com> wrote:
>
> On 12/10/20 5:04 PM, Greg KH wrote:
> > On Thu, Dec 10, 2020 at 09:25:39AM +0800, Hui Wang wrote:
> >> Recently we met a touchscreen problem on some Thinkpad machines, the
> >> touchscreen driver (i2c-hid) is not loaded and the touchscreen can't
> >> work.
> >>
> >> An i2c ACPI device with the name WACF2200 is defined in the BIOS, with
> >> the current ACPI PNP matching rule, this device will be regarded as
> >> a PNP device since there is WACFXXX in the acpi_pnp_device_ids[] and
> >> this PNP device is attached to the acpi device as the 1st
> >> physical_node, this will make the i2c bus match fail when i2c bus
> >> calls acpi_companion_match() to match the acpi_id_table in the i2c-hid
> >> driver.
> >>
> >> An ACPI PNP device's id has fixed format and its string length equals
> >> 7, after adding this check in the matching_id, the touchscreen could
> >> work.
> >>
> >> Cc: stable@vger.kernel.org
> >> Signed-off-by: Hui Wang <hui.wang@canonical.com>
> >> ---
> >>   drivers/acpi/acpi_pnp.c | 4 ++++
> >>   1 file changed, 4 insertions(+)
> >>
> >> diff --git a/drivers/acpi/acpi_pnp.c b/drivers/acpi/acpi_pnp.c
> >> index 4ed755a963aa..5ce711b9b070 100644
> >> --- a/drivers/acpi/acpi_pnp.c
> >> +++ b/drivers/acpi/acpi_pnp.c
> >> @@ -319,6 +319,10 @@ static bool matching_id(const char *idstr, const char *list_id)
> >>   {
> >>      int i;
> >>
> >> +    /* a pnp device id has CCCdddd format (C character, d digit), strlen should be 7 */
> >> +    if (strlen(idstr) != 7)
> >> +            return false;
> > Shouldn't you verify that the format is correct as well?
>
> I thought the rest code in this function will verify the format, just
> missing the length checking. But I was wrong, "a pnp device id has
> CCCdddd format" is not correct since WACFXXX is a valid id,

In fact, the "F" may be regarded as a hex digit and so this follows
the CCCdddd format too.

The problem with the current code is that it matches ACPI device IDs
in the WACFdddd format against the WACFXXX string, which is incorrect.

> I will follow Rafael's advice:  compare two string's length.

Please do.

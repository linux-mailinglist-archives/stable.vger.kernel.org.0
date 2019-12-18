Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D104124419
	for <lists+stable@lfdr.de>; Wed, 18 Dec 2019 11:17:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725785AbfLRKRb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Dec 2019 05:17:31 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:47052 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726360AbfLRKRb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Dec 2019 05:17:31 -0500
Received: by mail-pl1-f196.google.com with SMTP id y8so751734pll.13;
        Wed, 18 Dec 2019 02:17:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=M9u/AAhgp7vczaWl5nRaS1BNA2aTAiH2Swv5B8ibH/Q=;
        b=csWjRkJ8ifwjkXfMnaGss5kZ3MngkIY+uU3MmTF0fjYfCz09pVZnvfS0t2+u6fCY5u
         XiElqaZ2m0CgIWwTkQAsXf8YyGnxyEHVOIJKNokeVb8GZ9kb1AxIeSyqoNU90HU24Mcf
         T1vZNZ5pKgowYBfyYtzNaWHlW92S1t9iKht+RkFxnw63U005rLNlL0ufy3h1GorbtFzh
         P/6Hq831StBoti94+hvtB53jy8tsxYzhT3KP4L2mV64tS6G23XyPiPmXUM3qkmZTmyfU
         4eb8DUWjzjfxBoU1lzWc/q/5yTIfq0ul4XrtiPe0j+8c+cZXWq/GGZMD4Fn8RTejcuNi
         tibA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=M9u/AAhgp7vczaWl5nRaS1BNA2aTAiH2Swv5B8ibH/Q=;
        b=jqvoqjVsjIGw41tegF/QbFPAMvr+KBlwmePjTLYpvDliApSLwRK4PjWs24vfTNE+BE
         cjVes494kNqEbpU8qXqAvvB14E/GfjWldNiOohH+A7I7QBLH/91WmNKfwzOdYlBRNWWm
         Iy8odnZCsLjR2g45KSMivFWAzpfXzYZv4ZbHRS03gLZlcVH3x+jiPXiz7bICmC3TM3UF
         1HQ+TsSvwHkUz3IP9izAwZ+8Jd1b9QrP41RZV3Yp9CPrsFMbzXm0bGtvCodKdQiyN+/P
         FI7XZKhj6F1hYr0X/+aULsgP/1LTGvHxFJt/q+Pgj1tYEz9PKtYoEuv6rixofsCskEe+
         V2Pw==
X-Gm-Message-State: APjAAAUy4T8dauCOq8bO372yROQ9Yl5gF9BDhGsrSC2OXvFo2PB73Q9M
        u9uqYO3aESvBDmhxsJIY/bRjkfkN9uMoH2sYvvY=
X-Google-Smtp-Source: APXvYqzkCy2aaHhQ4KsBIIbZJOe/vQs2YULgfDTU+9TvKf8ov3kabEdE3fGrQQXxhlhovh7ZPbPDlSa/0/j4zbEIla8=
X-Received: by 2002:a17:902:8d96:: with SMTP id v22mr1849928plo.262.1576664250410;
 Wed, 18 Dec 2019 02:17:30 -0800 (PST)
MIME-Version: 1.0
References: <20191217190604.638467-1-hdegoede@redhat.com>
In-Reply-To: <20191217190604.638467-1-hdegoede@redhat.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Wed, 18 Dec 2019 12:17:20 +0200
Message-ID: <CAHp75Vf8CDwW731uD4OMzB69P-D1AN3PzCMFBGGD4fvBFccpLg@mail.gmail.com>
Subject: Re: [PATCH] platform/x86: hp-wmi: Make buffer for HPWMI_FEATURE2_QUERY
 128 bytes
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 17, 2019 at 9:06 PM Hans de Goede <hdegoede@redhat.com> wrote:
>
> At least on the HP Envy x360 15-cp0xxx model the WMI interface
> for HPWMI_FEATURE2_QUERY requires an outsize of at least 128 bytes,
> otherwise it fails with an error code 5 (HPWMI_RET_INVALID_PARAMETERS):
>
> Dec 06 00:59:38 kernel: hp_wmi: query 0xd returned error 0x5
>
> We do not care about the contents of the buffer, we just want to know
> if the HPWMI_FEATURE2_QUERY command is supported.
>
> This commits bumps the buffer size, fixing the error.
>

Fixes tag?

> Cc: stable@vger.kernel.org
> BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=1520703
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
>  drivers/platform/x86/hp-wmi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/platform/x86/hp-wmi.c b/drivers/platform/x86/hp-wmi.c
> index 9579a706fc08..a881b709af25 100644
> --- a/drivers/platform/x86/hp-wmi.c
> +++ b/drivers/platform/x86/hp-wmi.c
> @@ -300,7 +300,7 @@ static int __init hp_wmi_bios_2008_later(void)
>
>  static int __init hp_wmi_bios_2009_later(void)
>  {
> -       int state = 0;
> +       u8 state[128];
>         int ret = hp_wmi_perform_query(HPWMI_FEATURE2_QUERY, HPWMI_READ, &state,
>                                        sizeof(state), sizeof(state));
>         if (!ret)
> --
> 2.23.0
>


-- 
With Best Regards,
Andy Shevchenko

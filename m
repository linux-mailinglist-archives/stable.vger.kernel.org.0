Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C5E3D6E51
	for <lists+stable@lfdr.de>; Tue, 15 Oct 2019 06:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727154AbfJOEpo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Oct 2019 00:45:44 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:38518 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726825AbfJOEpn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Oct 2019 00:45:43 -0400
Received: by mail-io1-f66.google.com with SMTP id u8so42908238iom.5;
        Mon, 14 Oct 2019 21:45:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+3CQrwrfm79mz3scaz1RQAhUfgTSVbfh5V7FnLf7Qgo=;
        b=pCSXWkDt5TDBaYlLWNYQWJ+FLbWrOHFlEkXBk3U93Dw5KjnGg+/V4LfID2r4636quy
         ZjoISTbUOEqXW/sx4JUrWztnzAs2LefwgBGWDqAdiH5pyAMjGyke9AVb6uJsjQJ+tkAA
         EUlncP0O8aXSVuJvLnBhP7ViY4ormZPfwZEuygWm2hdYmhSMzrPsBdpJqJkHZmdo8pFI
         WEn7upa+Cf2Rh1zO7poS0Ybq2Yza1JwRQBBMYJy20brOoDFSbmp83Dt8vCVpxXI397Vf
         XLH9Lq51mrZnSteZBSceBDCQf2fkl2qnVztuDrB4NVVACIMq+3BxbYawww5/EJgiCg6l
         bOOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+3CQrwrfm79mz3scaz1RQAhUfgTSVbfh5V7FnLf7Qgo=;
        b=YlPrjdMgLdVgTUimHsBSJ/qe5qY1D0B2TiAMclVJmEXsYzUDvm0KkPWtG3YHw2NsBA
         oM5Z+u7Z3d8g/T+shlsXcKlTYvkNTYPLegLL5GH95Bk2OWZyRytj+bnpqmf65Q92LDM7
         4xtXucuNk4ZxzMkRwa9qq0HJuvIRErD+g1ahGzzRlbVuX2GJ9JpSOFsDBl+yn9fyzNbZ
         O6fQszE5LJ9X0wJD/99A34jnekZlXj0dNVwPRdd/MJQ7tLVXpXC+0RMvLChm4nOD9Ssv
         vAti6/C5ZNwTLqwNMD0dp4akIi65xPnljWu4uxkVhCC6kdfrpnAl5UZXxUroJcSxYbJ5
         NZ1w==
X-Gm-Message-State: APjAAAXiB6i2Me+3z8/KDnvwB5SrbYyotyE/NSPgztr4FidwoObVfi2B
        OWSY0pi0exed2d+YrftdXFfV5vacS6Hm4+iz+1w=
X-Google-Smtp-Source: APXvYqyE7C/5dOxHpyK84GY/KZPQMl1u2A0crzcq69F5pdg+CxPo+mADj7k/8N4fuSYDiiTfZVB+Zf3ZiccM573HJio=
X-Received: by 2002:a92:1d5c:: with SMTP id d89mr3965578ild.94.1571114742491;
 Mon, 14 Oct 2019 21:45:42 -0700 (PDT)
MIME-Version: 1.0
References: <20191007051240.4410-2-andrew.smirnov@gmail.com> <20191014035417.4CE8F2083B@mail.kernel.org>
In-Reply-To: <20191014035417.4CE8F2083B@mail.kernel.org>
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
Date:   Mon, 14 Oct 2019 21:45:30 -0700
Message-ID: <CAHQ1cqHKy6TDiu8-=rG55FchccZirL1FZYMP2KuUxAud5k=0hA@mail.gmail.com>
Subject: Re: [PATCH 1/3] HID: logitech-hidpp: use devres to manage FF private data
To:     Sasha Levin <sashal@kernel.org>
Cc:     "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Henrik Rydberg <rydberg@bitmath.org>,
        Sam Bazely <sambazley@fastmail.com>,
        "Pierre-Loup A. Griffais" <pgriffais@valvesoftware.com>,
        Austin Palmer <austinp@valvesoftware.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Oct 13, 2019 at 8:54 PM Sasha Levin <sashal@kernel.org> wrote:
>
> Hi,
>
> [This is an automated email]
>
> This commit has been processed because it contains a -stable tag.
> The stable tag indicates that it's relevant for the following trees: all
>
> The bot has tested the following trees: v5.3.5, v5.2.20, v4.19.78, v4.14.148, v4.9.196, v4.4.196.
>
> v5.3.5: Build OK!
> v5.2.20: Build OK!
> v4.19.78: Failed to apply! Possible dependencies:
>     43cd97af70c65 ("HID: logitech: Stop setting drvdata to NULL on probe failure and remove")
>
> v4.14.148: Failed to apply! Possible dependencies:
>     43cd97af70c65 ("HID: logitech: Stop setting drvdata to NULL on probe failure and remove")
>
> v4.9.196: Failed to apply! Possible dependencies:
>     43cd97af70c65 ("HID: logitech: Stop setting drvdata to NULL on probe failure and remove")
>
> v4.4.196: Failed to apply! Possible dependencies:
>     43cd97af70c65 ("HID: logitech: Stop setting drvdata to NULL on probe failure and remove")
>     6c44b15e1c907 ("HID: logitech: check the return value of create_singlethread_workqueue")
>     7bfd2927adcac ("HID: hid-logitech-hidpp: Add basic support for Logitech G920")
>     7f4b49fef6ffb ("HID: hid-logitech-hidpp: Add range sysfs for Logitech G920")
>     af2e628d6be7a ("HID: logitech-hidpp: limit visibility of init/deinit functions")
>     ff21a635dd1a9 ("HID: logitech-hidpp: Force feedback support for the Logitech G920")
>
>
> NOTE: The patch will not be queued to stable trees until it is upstream.
>
> How should we proceed with this patch?

Please ignore this series, since it will be superseded by upcoming v2

Thanks,
Andrey Smirnov

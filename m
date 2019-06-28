Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7B4F5925C
	for <lists+stable@lfdr.de>; Fri, 28 Jun 2019 06:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726769AbfF1EOp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jun 2019 00:14:45 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:43831 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725792AbfF1EOp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Jun 2019 00:14:45 -0400
Received: by mail-io1-f66.google.com with SMTP id k20so9615449ios.10
        for <stable@vger.kernel.org>; Thu, 27 Jun 2019 21:14:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=TGPx0XCr0SYrtaY+/rgQrmEvCOZfshMg8qLZg3xkmas=;
        b=Pg8ah+fbHNJpSKIr7asSfNPHHJMqkZsCA1PCMrzWH7AqrSSFaeYfeWZw9PZ0soQ1J9
         TQgIIrMbd+tYBQDiqfA7AOg/tNSeVffWeXuTCdCIFBRHmxiiwNIs/lKrj55t4i/lwsdm
         Vp2T6pRjXKmZVKOeSsRTKpKUQfvuF3t5lyXk9gzsqdfdAAIXQBEcmN1RfnIY1WynsVxB
         ATQfZyhxPMYKv7Rpit551jclk7PS5EiMD+feqvVnHb8RdUctXwGYOUP7H4E4txxO/n6Z
         3Ibd1mdRF+xcxlxym3r+g6+fv6fiBxxjby+zH1gw4ePftPevFYpOcRb6/4C8gboEebAy
         VXKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=TGPx0XCr0SYrtaY+/rgQrmEvCOZfshMg8qLZg3xkmas=;
        b=rQlM8Pz5uF0E9dcAVo5JNnotEOLYrOh8fbQEGJtU5rnpMPUhajg+P10eVEX985ENi2
         JEc2gsr4Wu4nSqyys9seRR1W2TsGczt+I9yNvYZKs5743aV2WhaFWi8zgdrxFyGqdAq0
         CsKZnYpHZHC/ELHeI9R7RmBfkj21EZmwUAGWzGpwGE/kyA510toEx5EYZugDY/KA3Fck
         iVBrS6SGWXh0R+LCIu+/cLpDDe7yPkkNBv+0iWrIIEpGbCs4bkzx7IH46sddyRxRiGct
         FBFBnzgRVtrDc4QDf63Kggq8rGtVtcRF1jFIS1b3D4Ec5BiT/iEGZ9J4Tak4jnBgIHul
         VmVw==
X-Gm-Message-State: APjAAAVUdKZJEE0fGRJ1ohuZNyAEdDaND1cMFy7yTk8PHyrrSaXwXtj/
        s+5mYI+JscXcJPgTAJHhFLppfEd7qegUjCnnzEpDtnky
X-Google-Smtp-Source: APXvYqwh+p+rT2RzMzOwgQZg1mdHrIde4Bd45v/Wx5YhAn958lHCv95NM98/N0eRYBMiEkR+zRcA4vs2pVe95KuTxJg=
X-Received: by 2002:a5d:88c6:: with SMTP id i6mr8856094iol.107.1561695284224;
 Thu, 27 Jun 2019 21:14:44 -0700 (PDT)
MIME-Version: 1.0
References: <20190627100105.11517-1-kristian.evensen@gmail.com>
In-Reply-To: <20190627100105.11517-1-kristian.evensen@gmail.com>
From:   Kristian Evensen <kristian.evensen@gmail.com>
Date:   Fri, 28 Jun 2019 06:14:33 +0200
Message-ID: <CAKfDRXhHWCxKK6gDciar5eQg9Ojv4+0C7tgaSOmQFFGLCL9gqw@mail.gmail.com>
Subject: Re: [PATCH] qmi_wwan: Fix out-of-bounds read
To:     stable <stable@vger.kernel.org>
Cc:     =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Thu, Jun 27, 2019 at 12:01 PM Kristian Evensen
<kristian.evensen@gmail.com> wrote:
>
> commit 904d88d743b0c94092c5117955eab695df8109e8 upstream.
>
> The syzbot reported
>
>  Call Trace:
>   __dump_stack lib/dump_stack.c:77 [inline]
>   dump_stack+0xca/0x13e lib/dump_stack.c:113
>   print_address_description+0x67/0x231 mm/kasan/report.c:188
>   __kasan_report.cold+0x1a/0x32 mm/kasan/report.c:317
>   kasan_report+0xe/0x20 mm/kasan/common.c:614
>   qmi_wwan_probe+0x342/0x360 drivers/net/usb/qmi_wwan.c:1417
>   usb_probe_interface+0x305/0x7a0 drivers/usb/core/driver.c:361
>   really_probe+0x281/0x660 drivers/base/dd.c:509
>   driver_probe_device+0x104/0x210 drivers/base/dd.c:670
>   __device_attach_driver+0x1c2/0x220 drivers/base/dd.c:777
>   bus_for_each_drv+0x15c/0x1e0 drivers/base/bus.c:454
>
> Caused by too many confusing indirections and casts.
> id->driver_info is a pointer stored in a long.  We want the
> pointer here, not the address of it.
>
> Thanks-to: Hillf Danton <hdanton@sina.com>
> Reported-by: syzbot+b68605d7fadd21510de1@syzkaller.appspotmail.com
> Cc: Kristian Evensen <kristian.evensen@gmail.com>
> Fixes: e4bf63482c30 ("qmi_wwan: Add quirk for Quectel dynamic config")
> Signed-off-by: Bj=C3=B8rn Mork <bjorn@mork.no>
>
> [Upstream commit did not apply because I shuffled two lines in the
> backport. The fixes tag for 4.14 is 3a6a5107ceb3.]
>
> Signed-off-by: Kristian Evensen <kristian.evensen@gmail.com>
> ---

I see now that I forgot to set the correct prefix for the patch. The
prefix should be PATCH 4.14. Sorry about that. Please let me know if I
should resubmit.

BR,
Kristian

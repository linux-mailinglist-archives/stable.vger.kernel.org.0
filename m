Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2FD3135601
	for <lists+stable@lfdr.de>; Thu,  9 Jan 2020 10:42:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728635AbgAIJmj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jan 2020 04:42:39 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:40609 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728660AbgAIJmg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Jan 2020 04:42:36 -0500
Received: by mail-io1-f65.google.com with SMTP id x1so6402603iop.7;
        Thu, 09 Jan 2020 01:42:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JTVqPFCFqKIu52p3Shf6ezDJo+AR70XrI4KPt0+xR+I=;
        b=RGTilTOrxQnMK01eRyQ8ReEqYHttPvhypdA3W8vBn4figPeRjW5Pte/cZZPIUFzJMM
         907zGoBLh1Ve2yWDhfzmAb8MBNmNkAr0VyYX5aBNoJZhTuChx1Ev0h+xrYYXIwbxN8fq
         V+34bkOLYoRj+iVwq0QTr3J2t/3iOvZyMQIJNhF3ju5BK7kxvnrlP5QE/5Iuaqc/nWKX
         Kj/2xIlR1cUcMIJ/bad+h1QTViJYRQEvAViUsAWaG/e+EDvTHJYJ6hpEcm1CPWp7DXa+
         rytjj2oj+6GfjSB/rkCGWu1SeWXZgb0q2Eb6htyozeFF20V6ja/A8TRX1rbL8hrTrmpT
         r7ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JTVqPFCFqKIu52p3Shf6ezDJo+AR70XrI4KPt0+xR+I=;
        b=TamGad+R67bADlC3GBx+XASMLKq11fYH9SmSMaFFrkt008nyYGkbuEjFJ+/Mx2Fg9B
         sO3dO8CFwJ6glXzfAJs/Uvg79qc3mNoXb8gqG3rUQ1rl1nxd9SXPVS8qdqMyr58UmRz8
         sRBoMRUncMoKRoTgCzm3gjCrWPVrjK4bAhd24+ZHXlcaza9TrJOpIzbrUiaXb4BDHzrI
         8nNZmHi44H/tJhL2Pq49EukX3jwVg2fSVdHC+ls7dgq+qRDl8QEPuWkkh9WDpNFb6sbC
         3o7KHUv07aw86doQaynVcEoLpwBAkqehlS1uJPtsI/RuJJrfM6feE+WXncxf7nEtr3WO
         f9nQ==
X-Gm-Message-State: APjAAAWvARy/pyyZ9r4tQX3w08sJaCbaGk0hFEWCVoKU36rRhlxiu9mz
        95HSqCui/JDbjogLRosKIvWsJUNiOWVxD8xi10Y=
X-Google-Smtp-Source: APXvYqyganuPeYpaKDTdpCjlFATUP46sC8jymaDLN3+HM2uZ93qHvpnJ1NmCmsJNEY+fcfOnjjB341Ch76gOlVRwfvg=
X-Received: by 2002:a5d:9dd9:: with SMTP id 25mr7057853ioo.287.1578562955274;
 Thu, 09 Jan 2020 01:42:35 -0800 (PST)
MIME-Version: 1.0
References: <1576139703-9409-1-git-send-email-peter.chen@nxp.com>
In-Reply-To: <1576139703-9409-1-git-send-email-peter.chen@nxp.com>
From:   Peter Chen <hzpeterchen@gmail.com>
Date:   Thu, 9 Jan 2020 17:42:23 +0800
Message-ID: <CAL411-o4FYWYs2A15fAre8eym4R0ka8SRo5XqhiaMyk+A-KDcQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] usb: gadget: f_fs: set req->num_sgs as 0 for
 non-sg transfer
To:     Peter Chen <peter.chen@nxp.com>
Cc:     balbi@kernel.org, USB list <linux-usb@vger.kernel.org>,
        linux-imx@nxp.com, Jun Li <jun.li@nxp.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 12, 2019 at 4:38 PM Peter Chen <peter.chen@nxp.com> wrote:
>
> The UDC core uses req->num_sgs to judge if scatter buffer list is used.
> Eg: usb_gadget_map_request_by_dev. For f_fs sync io mode, the request
> is re-used for each request, so if the 1st request->length > PAGE_SIZE,
> and the 2nd request->length is <= PAGE_SIZE, the f_fs uses the 1st
> req->num_sgs for the 2nd request, it causes the UDC core get the wrong
> req->num_sgs value (The 2nd request doesn't use sg). For f_fs async
> io mode, it is not harm to initialize req->num_sgs as 0 either, in case,
> the UDC driver doesn't zeroed request structure.
>
> Cc: Jun Li <jun.li@nxp.com>
> Cc: stable <stable@vger.kernel.org>
> Fixes: 772a7a724f69 ("usb: gadget: f_fs: Allow scatter-gather buffers")
> Signed-off-by: Peter Chen <peter.chen@nxp.com>
> ---
> Changes for v2:
> - Using the correct patch, and initialize req->num_sgs as 0 for aio too.
>
>  drivers/usb/gadget/function/f_fs.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
> index 59d9d512dcda..ced2581cf99f 100644
> --- a/drivers/usb/gadget/function/f_fs.c
> +++ b/drivers/usb/gadget/function/f_fs.c
> @@ -1062,6 +1062,7 @@ static ssize_t ffs_epfile_io(struct file *file, struct ffs_io_data *io_data)
>                         req->num_sgs = io_data->sgt.nents;
>                 } else {
>                         req->buf = data;
> +                       req->num_sgs = 0;
>                 }
>                 req->length = data_len;
>
> @@ -1105,6 +1106,7 @@ static ssize_t ffs_epfile_io(struct file *file, struct ffs_io_data *io_data)
>                         req->num_sgs = io_data->sgt.nents;
>                 } else {
>                         req->buf = data;
> +                       req->num_sgs = 0;
>                 }
>                 req->length = data_len;
>
> --
> 2.17.1
>

A gental ping...

Thanks,
Peter

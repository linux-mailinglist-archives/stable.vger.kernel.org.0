Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A678179D9E
	for <lists+stable@lfdr.de>; Thu,  5 Mar 2020 02:51:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725875AbgCEBvw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Mar 2020 20:51:52 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45007 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725852AbgCEBvw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Mar 2020 20:51:52 -0500
Received: by mail-wr1-f65.google.com with SMTP id n7so5000881wrt.11;
        Wed, 04 Mar 2020 17:51:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YMsHVgBMpB6xZxkyUx2XvzHBpwWocp0SkiRH0EL4DrA=;
        b=TP+aujmfjbNebM8C57RgZvGmaGI0udNnwXD1VfG82E28gu2ypSabiftNSeVSOrxAfq
         RVO7rmB2+JXgt3LaJv2gVNCkCHZfzfxnDEMWYLtIKlmzbEUxo/nGrxG60bJTpI2Y++IU
         9Oxu94imBc9Pdgltp19ZJlgFRpRvjDsDXExktpx9x0bsTdf5K7gKgZFKfIdvcLAr/ga0
         scMVN2iq0A6MIHsrLnJOKWfO8rkEW2BxVVFcUw1wzobueV7NJpng9a4SXK1+KPxKNBE4
         eZFwgMWSmweTDPYfyIYRKGDOrvbPc9IqVBmVKEnD2Smgtt2mBJu5CiXHqFj44s5XhYp5
         8LVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YMsHVgBMpB6xZxkyUx2XvzHBpwWocp0SkiRH0EL4DrA=;
        b=QmIo5Hv8pVGGvFk5hMeHspJaESl2fgCG12UmWr0SjcfxZchQL7zX7YMjDNg6CAap79
         Mt2miNUDxsoecbB67zRy6plk+hW4vvtHAisYY8pqc3M9p1lj3OIHq1CT6+1twHxhWBiK
         N83kLrQQDynfjWgx0KlCqLLLCX70KXMj+uvYI9BF4TvuVWGuGkN0ktHLLao9yR6CsV5T
         EJrXvc5coMai/0qIyaFgHyEPox7yE/Yg46RnWCnY8+ayn72f/6zMoc1bXimE6EU8EeFh
         RAN9hykKoUNBGPCbPQUkw8hAKJPBEL+IjXuqLtIfKQsbfZaek+S8QkeLXtCtoTz2yC1G
         1d8w==
X-Gm-Message-State: ANhLgQ0GGoAqQcpA5T6kniQlxXgkKjjaijdfJzVovUP64ASpD99v5A8w
        9vl/t2ycSzDxo+XmtnFaienwPxlBjCmBhduJhHI=
X-Google-Smtp-Source: ADFU+vveDOkJ/hpWrsPkW+Zmz6E+YWx9N+SYAWkPkgKagACA2aFMZnSW4whrtmyf++JUgMR1Vo86FkRYxt5m5iJZIYs=
X-Received: by 2002:adf:9282:: with SMTP id 2mr7341773wrn.124.1583373110116;
 Wed, 04 Mar 2020 17:51:50 -0800 (PST)
MIME-Version: 1.0
References: <20200302220639.GA2393@dhcp-10-100-145-180.wdl.wdc.com> <20200303110731.65552-1-cengiz@kernel.wtf>
In-Reply-To: <20200303110731.65552-1-cengiz@kernel.wtf>
From:   Ming Lei <tom.leiming@gmail.com>
Date:   Thu, 5 Mar 2020 09:51:36 +0800
Message-ID: <CACVXFVNe4dLFyhaP9BKyR4bdS+zpskFLttPfQMDY0O5RvE0GMA@mail.gmail.com>
Subject: Re: [PATCH] blktrace: Protect q->blk_trace with RCU
To:     Cengiz Can <cengiz@kernel.wtf>
Cc:     Keith Busch <kbusch@kernel.org>,
        Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
        Jens Axboe <axboe@kernel.dk>,
        Bjorn Helgaas <helgaas@kernel.org>, Jan Kara <jack@suse.cz>,
        linux-block <linux-block@vger.kernel.org>,
        stable <stable@vger.kernel.org>, tristmd@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 3, 2020 at 8:37 PM Cengiz Can <cengiz@kernel.wtf> wrote:
>
> Added a reassignment into the NULL check block to fix the issue.
>
> Fixes: c780e86dd48 ("blktrace: Protect q->blk_trace with RCU")
>
> Signed-off-by: Cengiz Can <cengiz@kernel.wtf>
> ---
>  kernel/trace/blktrace.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
> index 4560878f0bac..29ea88f10b87 100644
> --- a/kernel/trace/blktrace.c
> +++ b/kernel/trace/blktrace.c
> @@ -1896,8 +1896,10 @@ static ssize_t sysfs_blk_trace_attr_store(struct device *dev,
>         }
>
>         ret = 0;
> -       if (bt == NULL)
> +       if (bt == NULL) {
>                 ret = blk_trace_setup_queue(q, bdev);
> +               bt = q->blk_trace;

I'd suggest to use the following line for avoiding RCU warning:

   bt = rcu_dereference_protected(q->blk_trace,
                                       lockdep_is_held(&q->blk_trace_mutex));

Otherwise, the patch looks fine for me:

Reviewed-by: Ming Lei <ming.lei@redhat.com>

Thanks,
Ming Lei

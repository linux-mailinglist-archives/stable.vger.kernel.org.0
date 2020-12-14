Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 025B32D96A1
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 11:52:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbgLNKvr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 05:51:47 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:45035 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726237AbgLNKvr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Dec 2020 05:51:47 -0500
Received: by mail-lf1-f68.google.com with SMTP id m25so28965401lfc.11;
        Mon, 14 Dec 2020 02:51:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SWhRX/NAZKOA9RtVoo0gk8MZ4dLnq8xQ/S9pdibaYEk=;
        b=gy+bbSQm1srTUlSiW0bUZ3ELb6/QYReNjf66JcFXP2/ckmacnhQiVvUFQUns5SlUe9
         4D8d8qePgW8p3r6VDaE5yvKFImBsTcx3ZWUDj3jl2g+8BB6gun9B92IeFy1gknnaHHtN
         rYJouUhJ8ezoSuqN7HURjlkE3V7t1lZx8r7eRhp+oFkJh/0iUZntzVg8vxbJSPDLwnhI
         i6lbzrFsMKQ8jZxea3hthFVKMQjGItqb6jzXf9SEBa3Ab/TWaFUhoNfk65os27PSBdL8
         TDecA0r1Qj2r6rvvgaINVP10+1M+2UWFmDObJ8GuFWIccBSEhjiR9HNgqgKA0cLzbAB+
         KTvQ==
X-Gm-Message-State: AOAM531ViIndBzM9tz/5qTB+OF03NG56RKS5vQywgttIzFDqmNtF3F4P
        CKrXy9jzwBx78d2Saw+1PqclpLjvm4ZcEQ==
X-Google-Smtp-Source: ABdhPJymF8WJboilYFyBUUptp8FxMj8aIncNP75EjAKJMVbZZpYOJqxhUdTVDXGh4l6NGCuHFeDPNg==
X-Received: by 2002:a2e:9ace:: with SMTP id p14mr4685863ljj.439.1607943064652;
        Mon, 14 Dec 2020 02:51:04 -0800 (PST)
Received: from xi.terra (c-b3cbe455.07-184-6d6c6d4.bbcust.telenor.se. [85.228.203.179])
        by smtp.gmail.com with ESMTPSA id p24sm1845434lfh.70.2020.12.14.02.51.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 02:51:03 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.93.0.4)
        (envelope-from <johan@kernel.org>)
        id 1kolRT-0007RK-OH; Mon, 14 Dec 2020 11:50:59 +0100
Date:   Mon, 14 Dec 2020 11:50:59 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        syzbot+e87ebe0f7913f71f2ea5@syzkaller.appspotmail.com,
        stable <stable@vger.kernel.org>, linux-usb@vger.kernel.org
Subject: Re: [PATCH] USB: yurex: fix control-URB timeout handling
Message-ID: <X9dDkwlOTFeo9eZ6@localhost>
References: <000000000000e2186705b65e671f@google.com>
 <20201214104444.28386-1-johan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201214104444.28386-1-johan@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 14, 2020 at 11:44:44AM +0100, Johan Hovold wrote:
> Make sure to always cancel the control URB in write() so that it can be
> reused after a timeout or spurious CMD_ACK.
> 
> Currently any further write requests after a timeout would fail after
> triggering a WARN() in usb_submit_urb() when attempting to submit the
> already active URB.
> 
> Reported-by: syzbot+e87ebe0f7913f71f2ea5@syzkaller.appspotmail.com
> Fixes: 6bc235a2e24a ("USB: add driver for Meywa-Denki & Kayac YUREX")
> Cc: stable <stable@vger.kernel.org>     # 2.6.37
> Signed-off-by: Johan Hovold <johan@kernel.org>
> ---

Forgot linux-usb...

Let's try this too:

#syz test: https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git usb-testing

>  drivers/usb/misc/yurex.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/usb/misc/yurex.c b/drivers/usb/misc/yurex.c
> index 73ebfa6e9715..c640f98d20c5 100644
> --- a/drivers/usb/misc/yurex.c
> +++ b/drivers/usb/misc/yurex.c
> @@ -496,6 +496,9 @@ static ssize_t yurex_write(struct file *file, const char __user *user_buffer,
>  		timeout = schedule_timeout(YUREX_WRITE_TIMEOUT);
>  	finish_wait(&dev->waitq, &wait);
>  
> +	/* make sure URB is idle after timeout or (spurious) CMD_ACK */
> +	usb_kill_urb(dev->cntl_urb);
> +
>  	mutex_unlock(&dev->io_mutex);
>  
>  	if (retval < 0) {

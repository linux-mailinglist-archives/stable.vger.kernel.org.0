Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4DCD34FB7A
	for <lists+stable@lfdr.de>; Wed, 31 Mar 2021 10:23:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbhCaIWe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Mar 2021 04:22:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234218AbhCaIWO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Mar 2021 04:22:14 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8D6CC06175F;
        Wed, 31 Mar 2021 01:22:08 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id j18so18741516wra.2;
        Wed, 31 Mar 2021 01:22:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=M1iFyRy+/vZUwYcc1X6N0dJDOfsIozzsPvSrVwXYI9E=;
        b=E9WAczEs5N19fSB2T1k0zRDej2UTmXciCl1vBTv2mrC+k/PVxFG7YLMPlJhGH3Ttdr
         kF5g0jXEYnQOkluMhUEwlstLasx2EeajhnzLS9Ti0AHqvCMzx5xPfPpp0bFjNjyhMK/O
         nU40OVqg5m/kZ6IkQ7np7Rh5UCeaIWvMfyzpZJicYdk7MWCEi0UN/TdssTSsF65QFfzn
         NtyzqznzHFNQT0I5VJpCxHtew9xVVpfEf1+h9cvs82OWshGVNOyf+/omSatS9Z6nFsG6
         wFCFbHXJlniMN0xKaQNtrq5qvxLpae8r1NJTiqaFG1oHBQbqbJdjimgjt8qqm3mu1ceL
         zCYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=M1iFyRy+/vZUwYcc1X6N0dJDOfsIozzsPvSrVwXYI9E=;
        b=Tn7dBDecP662mh4sW9SWEpFw3sCZJJOFr0bHZhgRjqJ0dYTEQVw0e7GzpbkR3l+gCW
         2Yorc1NLZrsQTTyvMQoNksSxl6wdx9mPiLzv6PnjkbQ42QZeJqIm3/aPLZ7xFDy3mFTC
         wU/g5bKPzPyDuzHRpXKbxkEy0BZEyGz6zaGazFrfJXWVdhy2y+VMoElDuMDcf+8N8cKw
         ssWVprm+EL2AN427miTVTyaAPqSTzLN1FhB3WIlv3VYY4jU6dlaqab9V7Xmlq0G3rV/K
         TVMm0qBtV9HiLC5AAItZlYRxwM2LC2Sbphqf2f8ObTjqMoTfbDkXk9h47CwEWtIresdg
         rWfA==
X-Gm-Message-State: AOAM531gF6k8OgzAJvNxrG38VUDOasp2E2+Mu2JX+D1Q3/tv7bMiMMuc
        tx2O5dwWBML1An6wn0DoZiE=
X-Google-Smtp-Source: ABdhPJxocGQz+VOIBDxcQHX4MBugeeIBnoWOESz5Gn2qa0vf/v1c+0QFQ56/BWtzigKb4KRRKERVqA==
X-Received: by 2002:adf:dd4f:: with SMTP id u15mr2293305wrm.260.1617178927531;
        Wed, 31 Mar 2021 01:22:07 -0700 (PDT)
Received: from 192.168.10.5 ([39.46.7.73])
        by smtp.gmail.com with ESMTPSA id i8sm2812844wrx.43.2021.03.31.01.22.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Mar 2021 01:22:07 -0700 (PDT)
Message-ID: <675efa79414d2d8cb3696d3ca3a0c3be99bd92fa.camel@gmail.com>
Subject: Re: [PATCH] media: em28xx: fix memory leak
From:   Muhammad Usama Anjum <musamaanjum@gmail.com>
To:     hverkuil-cisco@xs4all.nl
Cc:     syzkaller-bugs@googlegroups.com, dvyukov@google.com,
        linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "open list:EM28XX VIDEO4LINUX DRIVER" <linux-media@vger.kernel.org>,
        stable@vger.kernel.org
Date:   Wed, 31 Mar 2021 13:22:01 +0500
In-Reply-To: <20210324180753.GA410359@LEGION>
References: <20210324180753.GA410359@LEGION>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2021-03-24 at 23:07 +0500, Muhammad Usama Anjum wrote:
> If some error occurs, URB buffers should also be freed. If they aren't
> freed with the dvb here, the em28xx_dvb_fini call doesn't frees the URB
> buffers as dvb is set to NULL. The function in which error occurs should
> do all the cleanup for the allocations it had done.
> 
> Tested the patch with the reproducer provided by syzbot. This patch
> fixes the memleak.
> 
> Reported-by: syzbot+889397c820fa56adf25d@syzkaller.appspotmail.com
> Signed-off-by: Muhammad Usama Anjum <musamaanjum@gmail.com>
> ---
> Resending the same path as some email addresses were missing from the
> earlier email.
> 
> syzbot found the following issue on:
> 
> HEAD commit:    1a4431a5 Merge tag 'afs-fixes-20210315' of git://git.kerne..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=11013a7cd00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=ff6b8b2e9d5a1227
> dashboard link: https://syzkaller.appspot.com/bug?extid=889397c820fa56adf25d
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1559ae3ad00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=176985c6d00000
> 
>  drivers/media/usb/em28xx/em28xx-dvb.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
> index 526424279637..471bd74667e3 100644
> --- a/drivers/media/usb/em28xx/em28xx-dvb.c
> +++ b/drivers/media/usb/em28xx/em28xx-dvb.c
> @@ -2010,6 +2010,7 @@ static int em28xx_dvb_init(struct em28xx *dev)
>  	return result;
>  
>  out_free:
> +	em28xx_uninit_usb_xfer(dev, EM28XX_DIGITAL_MODE);
>  	kfree(dvb);
>  	dev->dvb = NULL;
>  	goto ret;

I'd received the following notice and waiting for the review:
On Thu, 2021-03-25 at 09:06 +0000, Patchwork wrote:
> Hello,
> 
> The following patch (submitted by you) has been updated in Patchwork:
> 
>  * linux-media: media: em28xx: fix memory leak
>      - http://patchwork.linuxtv.org/project/linux-media/patch/20210324180753.GA410359@LEGION/
>      - for: Linux Media kernel patches
>     was: New
>     now: Under Review
> 
> This email is a notification only - you do not need to respond.
> 
> Happy patchworking.
> 

Thanks,
Usama



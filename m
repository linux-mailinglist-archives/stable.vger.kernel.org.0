Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D4746D63FC
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 15:53:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235719AbjDDNxv convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 4 Apr 2023 09:53:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235728AbjDDNxi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 09:53:38 -0400
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DFF44488
        for <stable@vger.kernel.org>; Tue,  4 Apr 2023 06:53:25 -0700 (PDT)
Received: by mail-lf1-f42.google.com with SMTP id y15so42466033lfa.7
        for <stable@vger.kernel.org>; Tue, 04 Apr 2023 06:53:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680616403;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0E7K/KPGW5vigO6BCdiN8xBhVE7+xyqKMmORIVUDwHk=;
        b=MzmroS9VUwad3HYajfWAwN+baibbJ9IGhXgSTCo1+h1daZb4XbkAVFWkiw2LK2ubmK
         wyvPnWhbBRTpBjkpok7zYT9sAHldcdvSjV5LV1QRbf4YJeUR99UqISJCbnj1jpsOFQlF
         Q6notu9sgMJpxQ8KMkmxzzOxXgzoxYLdExbDWVCecM2RjH3nw6wMM6MBKfBzwcIVj9up
         UTrxFfv/vqY7q1YRvjeAkGvo8lTLafpCZgUMRITZR+mN2KXYTAgAdUyuioXvl7qVD97X
         qoV3SBm61tXTe9pPCWbdQ+evDzVFqPvLoYrHlM4sK9dRffu+jkGD0FDHDUno0DQynj4z
         G+Ug==
X-Gm-Message-State: AAQBX9cO/8G3u+RlcdiqUROL+qITeV/AUNwig+DjQYCe8+AkeHgGOuOM
        ISKKdjcxDRgnzGU6dj7hJRfb06Plz0Da4pF6
X-Google-Smtp-Source: AKy350a3WNQROiIbU3zNK6vucZz5dl0PTGniGgbHFhALETO70RElumaTWsmxzNcu9yedFjrXAqiXYw==
X-Received: by 2002:a05:6512:218e:b0:4eb:43f3:9610 with SMTP id b14-20020a056512218e00b004eb43f39610mr663796lft.20.1680616402803;
        Tue, 04 Apr 2023 06:53:22 -0700 (PDT)
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com. [209.85.208.169])
        by smtp.gmail.com with ESMTPSA id d7-20020ac25447000000b004d57fc74f2csm2341922lfn.266.2023.04.04.06.53.22
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Apr 2023 06:53:22 -0700 (PDT)
Received: by mail-lj1-f169.google.com with SMTP id a44so15273492ljr.10
        for <stable@vger.kernel.org>; Tue, 04 Apr 2023 06:53:22 -0700 (PDT)
X-Received: by 2002:a2e:2e0d:0:b0:2a1:d819:f0ae with SMTP id
 u13-20020a2e2e0d000000b002a1d819f0aemr1075019lju.9.1680616402168; Tue, 04 Apr
 2023 06:53:22 -0700 (PDT)
MIME-Version: 1.0
References: <20230404123624.360384-1-daniel.vetter@ffwll.ch>
In-Reply-To: <20230404123624.360384-1-daniel.vetter@ffwll.ch>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 4 Apr 2023 15:53:09 +0200
X-Gmail-Original-Message-ID: <CAMuHMdUR=rx2QPvpzsSCwXTSTsPQOudNMzyL3dtZGQdQfrQGDA@mail.gmail.com>
Message-ID: <CAMuHMdUR=rx2QPvpzsSCwXTSTsPQOudNMzyL3dtZGQdQfrQGDA@mail.gmail.com>
Subject: Re: [PATCH] fbdev: Don't spam dmesg on bad userspace ioctl input
To:     Daniel Vetter <daniel.vetter@ffwll.ch>
Cc:     DRI Development <dri-devel@lists.freedesktop.org>,
        syzbot+20dcf81733d43ddff661@syzkaller.appspotmail.com,
        Helge Deller <deller@gmx.de>, stable@vger.kernel.org,
        Daniel Vetter <daniel@ffwll.ch>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Rodrigo Siqueira <rodrigosiqueiramelo@gmail.com>,
        Melissa Wen <melissa.srw@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=0.5 required=5.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
        FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Daniel,

CC vkmsdrm maintainer

Thanks for your patch!

On Tue, Apr 4, 2023 at 2:36 PM Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> There's a few reasons the kernel should not spam dmesg on bad
> userspace ioctl input:
> - at warning level it results in CI false positives
> - it allows userspace to drown dmesg output, potentially hiding real
>   issues.
>
> None of the other generic EINVAL checks report in the
> FBIOPUT_VSCREENINFO ioctl do this, so it's also inconsistent.
>
> I guess the intent of the patch which introduced this warning was that
> the drivers ->fb_check_var routine should fail in that case. Reality
> is that there's too many fbdev drivers and not enough people
> maintaining them by far, and so over the past few years we've simply
> handled all these validation gaps by tighning the checks in the core,
> because that's realistically really all that will ever happen.
>
> Reported-by: syzbot+20dcf81733d43ddff661@syzkaller.appspotmail.com
> Link: https://syzkaller.appspot.com/bug?id=c5faf983bfa4a607de530cd3bb008888bf06cefc

    WARNING: fbcon: Driver 'vkmsdrmfb' missed to adjust virtual screen
size (0x0 vs. 64x768)

This is a bug in the vkmsdrmfb driver and/or DRM helpers.

The message was added to make sure the individual drivers are fixed.
Perhaps it should be changed to BUG() instead, so dmesg output
cannot be drown?

> Fixes: 6c11df58fd1a ("fbmem: Check virtual screen sizes in fb_set_var()")
> Cc: Helge Deller <deller@gmx.de>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: stable@vger.kernel.org # v5.4+
> Cc: Daniel Vetter <daniel@ffwll.ch>
> Cc: Javier Martinez Canillas <javierm@redhat.com>
> Cc: Thomas Zimmermann <tzimmermann@suse.de>
> Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>

NAKed-by: Geert Uytterhoeven <geert@linux-m68k.org>

> --- a/drivers/video/fbdev/core/fbmem.c
> +++ b/drivers/video/fbdev/core/fbmem.c
> @@ -1021,10 +1021,6 @@ fb_set_var(struct fb_info *info, struct fb_var_screeninfo *var)
>         /* verify that virtual resolution >= physical resolution */
>         if (var->xres_virtual < var->xres ||
>             var->yres_virtual < var->yres) {
> -               pr_warn("WARNING: fbcon: Driver '%s' missed to adjust virtual screen size (%ux%u vs. %ux%u)\n",
> -                       info->fix.id,
> -                       var->xres_virtual, var->yres_virtual,
> -                       var->xres, var->yres);
>                 return -EINVAL;
>         }

Gr{oetje,eeting}s,

                        Geert


--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E07B5608E5
	for <lists+stable@lfdr.de>; Wed, 29 Jun 2022 20:17:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbiF2SRP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jun 2022 14:17:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230347AbiF2SRJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jun 2022 14:17:09 -0400
Received: from albert.telenet-ops.be (albert.telenet-ops.be [IPv6:2a02:1800:110:4::f00:1a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4949D377E7
        for <stable@vger.kernel.org>; Wed, 29 Jun 2022 11:17:07 -0700 (PDT)
Received: from ramsan.of.borg ([84.195.186.194])
        by albert.telenet-ops.be with bizsmtp
        id p6H42700X4C55Sk066H48z; Wed, 29 Jun 2022 20:17:05 +0200
Received: from geert (helo=localhost)
        by ramsan.of.borg with local-esmtp (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1o6cFL-001LDH-W6; Wed, 29 Jun 2022 20:17:04 +0200
Date:   Wed, 29 Jun 2022 20:17:03 +0200 (CEST)
From:   Geert Uytterhoeven <geert@linux-m68k.org>
X-X-Sender: geert@ramsan.of.borg
To:     Thomas Zimmermann <tzimmermann@suse.de>
cc:     maarten.lankhorst@linux.intel.com, mripard@kernel.org,
        airlied@linux.ie, daniel@ffwll.ch, javierm@redhat.com,
        dri-devel@lists.freedesktop.org,
        =?ISO-8859-15?Q?Nuno_Gon=E7alves?= <nunojpg@gmail.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] drm/fb-helper: Fix out-of-bounds access
In-Reply-To: <20220621104617.8817-1-tzimmermann@suse.de>
Message-ID: <alpine.DEB.2.22.394.2206292006230.319606@ramsan.of.borg>
References: <20220621104617.8817-1-tzimmermann@suse.de>
User-Agent: Alpine 2.22 (DEB 394 2020-01-19)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-1133880722-1656526623=:319606"
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1133880722-1656526623=:319606
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8BIT

 	Hi Thomas,

On Tue, 21 Jun 2022, Thomas Zimmermann wrote:
> Clip memory range to screen-buffer size to avoid out-of-bounds access
> in fbdev deferred I/O's damage handling.
>
> Fbdev's deferred I/O can only track pages. From the range of pages, the
> damage handler computes the clipping rectangle for the display update.
> If the fbdev screen buffer ends near the beginning of a page, that page
> could contain more scanlines. The damage handler would then track these
> non-existing scanlines as dirty and provoke an out-of-bounds access
> during the screen update. Hence, clip the maximum memory range to the
> size of the screen buffer.
>
> While at it, rename the variables min/max to min_off/max_off in
> drm_fb_helper_deferred_io(). This avoids confusion with the macros of
> the same name.
>
> Reported-by: Nuno Gonçalves <nunojpg@gmail.com>
> Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
> Tested-by: Nuno Gonçalves <nunojpg@gmail.com>
> Fixes: 67b723f5b742 ("drm/fb-helper: Calculate damaged area in separate helper")

Thanks for your patch, which is now commit ae25885bdf59fde4
("drm/fb-helper: Fix out-of-bounds access") in drm-misc/for-linux-next.

I had seen the crash before, but thought it was a bug in my wip
atari-drm driver.  When diving deeper today, and consequently looking
for recent changes to the damage helper, I found this commit in
linux-next.

With your patch instead of my own workaround I used this morning, [1]
still works fine, so:
Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>.
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>.

[1] [PATCH] drm/fb-helper: Remove helpers to change frame buffer config
     https://lore.kernel.org/all/20220629105658.1373770-1-geert@linux-m68k.org

Gr{oetje,eeting}s,

 						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
 							    -- Linus Torvalds
--8323329-1133880722-1656526623=:319606--

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14ED86D7DAC
	for <lists+stable@lfdr.de>; Wed,  5 Apr 2023 15:25:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238074AbjDENZ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 09:25:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238222AbjDENZX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 09:25:23 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB46159CF
        for <stable@vger.kernel.org>; Wed,  5 Apr 2023 06:25:22 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id a640c23a62f3a-930bc91df7bso115558266b.1
        for <stable@vger.kernel.org>; Wed, 05 Apr 2023 06:25:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google; t=1680701121;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CUtULfA5bLZhhAnqEVdsPO4f4/cotKXMpX/rBKrBwCU=;
        b=I+E9eZK0O0wCuaG3RpVayfgX04qh8RTiRNjffiQYHn0uWhBbKHKxNdeIPxonIxU8ED
         Qkikb7s817DwN6tIqPLt7G5Lm0Ro1PkGnzdJGnWgPYTrUO/6zV3wAzqCdzS0JWzDCuKR
         iqXxo30r5oXOhJOTgaZNSkjJWFgk2k4uj5DOk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680701121;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CUtULfA5bLZhhAnqEVdsPO4f4/cotKXMpX/rBKrBwCU=;
        b=ulxeGtJn80x5tkQChj8P+iehWBjTqKO32mMFaJEzghwigvWSO64h8n/BsAGulZNi5j
         R/0V4UqGVDSBR8XGGMShjuBIHiCc3F0NGDG5SaiPkC9iy1rMsYMOE95W7Mj9/9lDsSrp
         UVE5V40FX8y5Zet4/wu0+MOue/IjABL0M3ifCOfbpb/LfM404pDgWXhacj2o3MInlFve
         pMxvJfcovawDWIICw1vZkEeiIqr3IssXIEWYOcV+Yt88zDoyUYEbBxauogUCcufQBkn3
         /T7p21AioIBAfAkflzce1ykRYu/0D56zXZkDls3drTw4/JahQVh7wBtnfmKlOQbXIuZs
         hciQ==
X-Gm-Message-State: AAQBX9fJTZafL71fXBhlV7iC6tvQBWFeQwCCDlxrMfXLxqgd1GSDy6eg
        7R5GWVvBzjmdd1yyKkrJiaX4iw==
X-Google-Smtp-Source: AKy350ZsNc/rtqu1NEGe53/lPebNr5LRx0G5RnZDO64RCYwlrsQnnIhn7bHPhGrr/AyAN7Sjecj++g==
X-Received: by 2002:a17:906:2216:b0:947:bff2:1c2d with SMTP id s22-20020a170906221600b00947bff21c2dmr3058456ejs.3.1680701120972;
        Wed, 05 Apr 2023 06:25:20 -0700 (PDT)
Received: from phenom.ffwll.local (212-51-149-33.fiber7.init7.net. [212.51.149.33])
        by smtp.gmail.com with ESMTPSA id bv20-20020a170906b1d400b009447277c2aasm7371257ejb.39.2023.04.05.06.25.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 06:25:20 -0700 (PDT)
Date:   Wed, 5 Apr 2023 15:25:18 +0200
From:   Daniel Vetter <daniel@ffwll.ch>
To:     Javier Martinez Canillas <javierm@redhat.com>
Cc:     Daniel Vetter <daniel.vetter@ffwll.ch>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        syzbot+20dcf81733d43ddff661@syzkaller.appspotmail.com,
        stable@vger.kernel.org, Daniel Vetter <daniel@ffwll.ch>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Daniel Vetter <daniel.vetter@intel.com>
Subject: Re: [PATCH 1/3] drm/fb-helper: set x/yres_virtual in
 drm_fb_helper_check_var
Message-ID: <ZC12vod/gn6vpHOR@phenom.ffwll.local>
References: <20230404194038.472803-1-daniel.vetter@ffwll.ch>
 <87h6tud3zc.fsf@minerva.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87h6tud3zc.fsf@minerva.mail-host-address-is-not-set>
X-Operating-System: Linux phenom 6.1.0-7-amd64 
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 05, 2023 at 12:21:11PM +0200, Javier Martinez Canillas wrote:
> Daniel Vetter <daniel.vetter@ffwll.ch> writes:
> 
> > Drivers are supposed to fix this up if needed if they don't outright
> > reject it. Uncovered by 6c11df58fd1a ("fbmem: Check virtual screen
> > sizes in fb_set_var()").
> >
> 
> Should have a Fixes: tag ? I understand what was uncovered by that commit
> but it help distros to figure out if something has to be cherry-picked by
> them. So I believe that would be useful to have it.
> 
> The patch looks good to me.

The cc: stable should go far enough back for that. Or that was at least my
idea ... I can add the Fixes: back since I had it but dropped it
intentionally because it's not really a bug in the fbmem patch.
-Daniel

> Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
> 
> -- 
> Best regards,
> 
> Javier Martinez Canillas
> Core Platforms
> Red Hat
> 

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A9B56D799C
	for <lists+stable@lfdr.de>; Wed,  5 Apr 2023 12:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236779AbjDEKWF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 06:22:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230118AbjDEKWE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 06:22:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9EC5270C
        for <stable@vger.kernel.org>; Wed,  5 Apr 2023 03:21:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680690075;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LwnbCCnkeV6p0EMxwdcDykkMOdpfLU8p8aqNhgjGBpc=;
        b=XawqWKddezFGGYDJzQTZYdwkwoFd5myKuQD0QWkvG1y0xUNhZMxL/PTf/OPtz5sUbYPOsG
        89B03QU8BEAoa3XzKyUs8t/9cYIztRfGamkAKzD3n/5jSzOmpkKSg8QD+0po2pcrer6Kcl
        UX484IO66/D4hHsBpM8apsnQDUD0FCQ=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-437-W8-01QlDPRWztN8anNrEYQ-1; Wed, 05 Apr 2023 06:21:13 -0400
X-MC-Unique: W8-01QlDPRWztN8anNrEYQ-1
Received: by mail-wm1-f72.google.com with SMTP id bi27-20020a05600c3d9b00b003ef6ee937b8so13737554wmb.2
        for <stable@vger.kernel.org>; Wed, 05 Apr 2023 03:21:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680690073;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LwnbCCnkeV6p0EMxwdcDykkMOdpfLU8p8aqNhgjGBpc=;
        b=VxIq3W5x02WOGLvmLRBBMuzt1eciFCuAN5sgvtkwuXlsMTRHISzvE+bVYeylqC9cr5
         SICw90FN1DIBdL5XzY79fEZvkA1Fr9po0SPnTWAxiNJlR+xAxWtOCgwh8BHICx4PSTDd
         HCwp77g4gkwK56E6GU2lQ2UPfv3J7iEPomhZSMcCnvhIAZp86tAFV+OuGUnbTO1MQCgA
         J0g1fdhFup/vyg9LeQvwhBhb2V1XJcpjb/cYEaZq+2rYGTQ8qxQuJoywDgdD5v8Em/Cw
         pfNkEnzsj2vGvYOigi59MsdUON90mpu1NeqSvUEIFzCF8013gbCURvKzPo0T/BXcT5K6
         wQ4Q==
X-Gm-Message-State: AAQBX9fq7ruw0lF/pa2t9ck/GU+MnW8EVyfkr0uVASPxneQkKZol1cWG
        ceBJZDCUZwjs9QCbnftzIR7zwahurhUH4T9qxiLtNhvUDoxlRnAsoJc0XFeQjzbWfYm1meSTRWr
        XsR2Tft5z+aa4PFSl
X-Received: by 2002:a5d:4dc3:0:b0:2cf:e3d0:2a43 with SMTP id f3-20020a5d4dc3000000b002cfe3d02a43mr3590092wru.4.1680690072796;
        Wed, 05 Apr 2023 03:21:12 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZIH4THo9EGjZAKkNBuLIQorIFwZkRC/w8hM10CIdydl5OhWOL9N0N6G0GANIOc9qFkYKffXA==
X-Received: by 2002:a5d:4dc3:0:b0:2cf:e3d0:2a43 with SMTP id f3-20020a5d4dc3000000b002cfe3d02a43mr3590080wru.4.1680690072550;
        Wed, 05 Apr 2023 03:21:12 -0700 (PDT)
Received: from localhost (205.pool92-176-231.dynamic.orange.es. [92.176.231.205])
        by smtp.gmail.com with ESMTPSA id y13-20020adff14d000000b002c55306f6edsm14670568wro.54.2023.04.05.03.21.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 03:21:12 -0700 (PDT)
From:   Javier Martinez Canillas <javierm@redhat.com>
To:     Daniel Vetter <daniel.vetter@ffwll.ch>,
        DRI Development <dri-devel@lists.freedesktop.org>
Cc:     Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        syzbot+20dcf81733d43ddff661@syzkaller.appspotmail.com,
        stable@vger.kernel.org, Daniel Vetter <daniel@ffwll.ch>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Daniel Vetter <daniel.vetter@intel.com>
Subject: Re: [PATCH 1/3] drm/fb-helper: set x/yres_virtual in
 drm_fb_helper_check_var
In-Reply-To: <20230404194038.472803-1-daniel.vetter@ffwll.ch>
References: <20230404194038.472803-1-daniel.vetter@ffwll.ch>
Date:   Wed, 05 Apr 2023 12:21:11 +0200
Message-ID: <87h6tud3zc.fsf@minerva.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Daniel Vetter <daniel.vetter@ffwll.ch> writes:

> Drivers are supposed to fix this up if needed if they don't outright
> reject it. Uncovered by 6c11df58fd1a ("fbmem: Check virtual screen
> sizes in fb_set_var()").
>

Should have a Fixes: tag ? I understand what was uncovered by that commit
but it help distros to figure out if something has to be cherry-picked by
them. So I believe that would be useful to have it.

The patch looks good to me.

Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>

-- 
Best regards,

Javier Martinez Canillas
Core Platforms
Red Hat


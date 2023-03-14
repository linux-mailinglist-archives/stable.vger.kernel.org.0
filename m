Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38CAA6B9B9D
	for <lists+stable@lfdr.de>; Tue, 14 Mar 2023 17:33:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbjCNQdu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Mar 2023 12:33:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230020AbjCNQdq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Mar 2023 12:33:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36FA088DB2
        for <stable@vger.kernel.org>; Tue, 14 Mar 2023 09:32:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678811556;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ENuFieBhxiHtLNw0jCbF63V+Z/gQ5SLpJHpUyZoTfIU=;
        b=Xdojz2MAojHH0owFC2nMyCSvX5sBSQKp46fdfnwgWWN4mgk/i0ax8NNRVdPD6XdkYaBHK4
        DQvOwQnWUcgBDFHiTWSDaiJ+19nt6ezRp5JbEycGhGkQfXC1uRSACwlKBxGO5J5Xm+0Q10
        mVs0BAtBrqLfoThwTao+FwMVSvpeGUw=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-19-BZ4miFTnNnK6sWTaTzteCA-1; Tue, 14 Mar 2023 12:32:34 -0400
X-MC-Unique: BZ4miFTnNnK6sWTaTzteCA-1
Received: by mail-wm1-f72.google.com with SMTP id o2-20020a05600c510200b003ed2c898324so1059802wms.1
        for <stable@vger.kernel.org>; Tue, 14 Mar 2023 09:32:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678811554;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ENuFieBhxiHtLNw0jCbF63V+Z/gQ5SLpJHpUyZoTfIU=;
        b=CZ56jxr8ImwdYz5aTVygfANPe8FEGlT1x9Spvdgi3o7t1mwjR5dip7ZrZr15585Rx7
         6SK+mMxb7u7kajW5CZFSuoycxHu9vBf/XAlzSDhIo50TEIkalmwLKyhpVKkpTVszAwiM
         aU8ZzzsURBRowh97qQ+gzE+10tAPNRQWjXFkMsKhhHzTEMQsDYNFtPTsLZMlodffoKUZ
         /LlgIBK+fRqlBazf1Q33ZRzLp0qpo3ieoneWLq8/mdoy9y2h4apjnsAOg7uwMLU9n1jR
         a1fyPOlQsoKGZsUEfDaQBOydk2wxFSoo3d8XWQz4QUQZiGumDAFBGPvfwtOIp4PnlYxK
         TXlQ==
X-Gm-Message-State: AO0yUKXtkjR4iEXIDG2P51JpBcqYyaQ2Wu8W9+GQHKzFrH0q2WieQbLz
        vYlbkAXEVHyUWjod1XD2u1/LEWgDXmVx06UC/nSBgjsclabMS6f7BODOrr3UnRwCLrgvnieXyVe
        bR1waTGgTls4cXGE3
X-Received: by 2002:a05:600c:3b99:b0:3ed:234d:b0c0 with SMTP id n25-20020a05600c3b9900b003ed234db0c0mr7627212wms.13.1678811553861;
        Tue, 14 Mar 2023 09:32:33 -0700 (PDT)
X-Google-Smtp-Source: AK7set83ZCHUGW/upSbL2NTJtL0Ht3VQsjtWJkbu2JlZJDbSTbrLj6MLNQ2M53zNysaSVXtrIug+Bw==
X-Received: by 2002:a05:600c:3b99:b0:3ed:234d:b0c0 with SMTP id n25-20020a05600c3b9900b003ed234db0c0mr7627193wms.13.1678811553599;
        Tue, 14 Mar 2023 09:32:33 -0700 (PDT)
Received: from localhost (205.pool92-176-231.dynamic.orange.es. [92.176.231.205])
        by smtp.gmail.com with ESMTPSA id l17-20020a7bc351000000b003e21f959453sm3258953wmj.32.2023.03.14.09.32.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 09:32:33 -0700 (PDT)
From:   Javier Martinez Canillas <javierm@redhat.com>
To:     Hans de Goede <hdegoede@redhat.com>,
        Ard Biesheuvel <ardb@kernel.org>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        dri-devel@lists.freedesktop.org, linux-efi@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/2] efi: sysfb_efi: Fix DMI quirks not working for
 simpledrm
In-Reply-To: <20230314123103.522115-1-hdegoede@redhat.com>
References: <20230314123103.522115-1-hdegoede@redhat.com>
Date:   Tue, 14 Mar 2023 17:32:32 +0100
Message-ID: <87fsa7l2e7.fsf@minerva.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hans de Goede <hdegoede@redhat.com> writes:

Hello Hans,

> Commit 8633ef82f101 ("drivers/firmware: consolidate EFI framebuffer setup
> for all arches") moved the sysfb_apply_efi_quirks() call in sysfb_init()
> from before the [sysfb_]parse_mode() call to after it.
> But sysfb_apply_efi_quirks() modifies the global screen_info struct which
> [sysfb_]parse_mode() parses, so doing it later is too late.
>
> This has broken all DMI based quirks for correcting wrong firmware efifb
> settings when simpledrm is used.
>

Indeed... sorry for missing this.

> To fix this move the sysfb_apply_efi_quirks() call back to its old place
> and split the new setup of the efifb_fwnode (which requires
> the platform_device) into its own function and call that at
> the place of the moved sysfb_apply_efi_quirks(pd) calls.
>
> Fixes: 8633ef82f101 ("drivers/firmware: consolidate EFI framebuffer setup for all arches")
> Cc: stable@vger.kernel.org
> Cc: Javier Martinez Canillas <javierm@redhat.com>
> Cc: Thomas Zimmermann <tzimmermann@suse.de>
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---

Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>

-- 
Best regards,

Javier Martinez Canillas
Core Platforms
Red Hat


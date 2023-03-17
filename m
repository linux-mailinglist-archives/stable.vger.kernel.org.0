Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D016B6BE5B9
	for <lists+stable@lfdr.de>; Fri, 17 Mar 2023 10:35:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230215AbjCQJf4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Mar 2023 05:35:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231300AbjCQJfw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Mar 2023 05:35:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2051BAD3C;
        Fri, 17 Mar 2023 02:35:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6FFE8B82464;
        Fri, 17 Mar 2023 09:35:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 100A7C433EF;
        Fri, 17 Mar 2023 09:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679045746;
        bh=Omg+SkEpbIcXnNJopGMFeOZdmErKoHj8IKn0VgieQFg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=EoNN4dyVUga9iD0RDEZ2TnJC77q3IYSOv9J03dgc//D2E0pke0MgdMd0b5JOXYSb7
         QXIpcd9BAzGUSGqPXFYf4KYS2TlDwtlzUrDm881XQYv4/1TibjIb6kOBoIL5gxiSCZ
         a8x3SVPTG7DJW2/0vnqrn+O7kSlsibg3Z027SqfW8AlD0DP3mPZifXc8MvrYBoHo9A
         jJQsCMFltz0gkyA84f/Em73kDWZTH3P+3rs69F+wXyOYXMu/eFiH/f/neQtGz/caiz
         R3LQMy9+9dLMVtw9nERBi/ayO1eLHjH3dVXqpDBt+BnawoRAXvk/tngVnouAAZNtgb
         dz4c48jb7sg0Q==
Received: by mail-lf1-f54.google.com with SMTP id br6so5689309lfb.11;
        Fri, 17 Mar 2023 02:35:45 -0700 (PDT)
X-Gm-Message-State: AO0yUKWmxf9oF52vTm+Px8Sg9zpji+tc2q3uqsHF/2vLVkl4dqKMBN62
        CkcwGn1GoQJd8kmiOOcl6SZwnpBErO5r88eVcKs=
X-Google-Smtp-Source: AK7set/pat6sxR9X2sBlMoniCNge7UuBIOTqvSvXr++BHQqWi654KI/9QQeHHQaB7UBlvAUKcwIEqSHGvKi7PdvT80M=
X-Received: by 2002:ac2:44a1:0:b0:4d9:861e:26cc with SMTP id
 c1-20020ac244a1000000b004d9861e26ccmr4116658lfm.4.1679045743996; Fri, 17 Mar
 2023 02:35:43 -0700 (PDT)
MIME-Version: 1.0
References: <20230314123103.522115-1-hdegoede@redhat.com> <87fsa7l2e7.fsf@minerva.mail-host-address-is-not-set>
In-Reply-To: <87fsa7l2e7.fsf@minerva.mail-host-address-is-not-set>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Fri, 17 Mar 2023 10:35:33 +0100
X-Gmail-Original-Message-ID: <CAMj1kXHUQ9pvxdE4d1=ewME2MPn=Qh0zoiZpn6RARHLR12hEww@mail.gmail.com>
Message-ID: <CAMj1kXHUQ9pvxdE4d1=ewME2MPn=Qh0zoiZpn6RARHLR12hEww@mail.gmail.com>
Subject: Re: [PATCH 1/2] efi: sysfb_efi: Fix DMI quirks not working for simpledrm
To:     Javier Martinez Canillas <javierm@redhat.com>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        dri-devel@lists.freedesktop.org, linux-efi@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 14 Mar 2023 at 17:32, Javier Martinez Canillas
<javierm@redhat.com> wrote:
>
> Hans de Goede <hdegoede@redhat.com> writes:
>
> Hello Hans,
>
> > Commit 8633ef82f101 ("drivers/firmware: consolidate EFI framebuffer setup
> > for all arches") moved the sysfb_apply_efi_quirks() call in sysfb_init()
> > from before the [sysfb_]parse_mode() call to after it.
> > But sysfb_apply_efi_quirks() modifies the global screen_info struct which
> > [sysfb_]parse_mode() parses, so doing it later is too late.
> >
> > This has broken all DMI based quirks for correcting wrong firmware efifb
> > settings when simpledrm is used.
> >
>
> Indeed... sorry for missing this.
>
> > To fix this move the sysfb_apply_efi_quirks() call back to its old place
> > and split the new setup of the efifb_fwnode (which requires
> > the platform_device) into its own function and call that at
> > the place of the moved sysfb_apply_efi_quirks(pd) calls.
> >
> > Fixes: 8633ef82f101 ("drivers/firmware: consolidate EFI framebuffer setup for all arches")
> > Cc: stable@vger.kernel.org
> > Cc: Javier Martinez Canillas <javierm@redhat.com>
> > Cc: Thomas Zimmermann <tzimmermann@suse.de>
> > Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> > ---
>
> Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
>

Thanks - I've queued these up now

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDB14456C1A
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 10:07:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbhKSJIp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 04:08:45 -0500
Received: from rfvt.org.uk ([37.187.119.221]:50592 "EHLO rfvt.org.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230296AbhKSJIp (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Nov 2021 04:08:45 -0500
X-Greylist: delayed 473 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Nov 2021 04:08:44 EST
Received: from wylie.me.uk (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by rfvt.org.uk (Postfix) with ESMTPS id E19ED834E2;
        Fri, 19 Nov 2021 08:57:35 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=wylie.me.uk;
        s=mydkim005; t=1637312255;
        bh=mPyHc9wIGw4BPjJP3WWjkXxwWTNA4sblu+Jv2L9FZn8=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To;
        b=A79h/7UJOyMHnfigtWhwR4A05Qi7zFmmK+XRxdKvEkZVNOXW2OubP4owPGZc5+vmE
         jFUgbNrxggb2JMbRN3zz1r2tMgPliQ1HyAvANFDnQcCJo+WjeoBuB3DBAFhl7ykUS+
         RCs0jds0I2fO+h4P9lUazGhXWxo5Jv2vdYT+wUZk5Lophpyzk1Qe5wbzPHpjiIZid2
         eZx6IeEuOWToOu5miWMKrqu5VE89veoZiCCpAT4aIFcNdZH/a/g/tjWRHlkKxv1Kmw
         5Lg34+ZLt7NMNi8v7dliqjllRqceZRQh1coAPBJEaP7LHeATR6Amtr+X1crDy3WNal
         iXOq/I574zLFw==
From:   alan@wylie.me.uk (Alan J. Wylie)
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Jiri Slaby <jirislaby@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        "Acked-by\: Jani Nikula" <jani.nikula@intel.com>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.15 808/917] drm: fb_helper: improve CONFIG_FB dependency
References: <20211115165428.722074685@linuxfoundation.org>
        <20211115165456.391822721@linuxfoundation.org>
        <9fdb2bf1-de52-1b9d-4783-c61ce39e8f51@kernel.org>
        <fd7132a4-a016-9bf2-bb08-616f5f9d6e85@kernel.org>
        <CAK8P3a3kE49BgyWozXH1rsxUr=ZDH1GM6r+nyeCRfe5r40QD_w@mail.gmail.com>
Date:   Fri, 19 Nov 2021 08:57:35 +0000
In-Reply-To: <CAK8P3a3kE49BgyWozXH1rsxUr=ZDH1GM6r+nyeCRfe5r40QD_w@mail.gmail.com>
        (Arnd Bergmann's message of "Fri, 19 Nov 2021 09:10:30 +0100")
Message-ID: <871r3cr08w.fsf@wylie.me.uk>
User-Agent: Gnus/5.130012 (Ma Gnus v0.12) Emacs/27 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Arnd Bergmann <arnd@arndb.de> writes:

> Ah right, I ran into a similar thing on my randconfig builds, this is
> what I have
> applied locally but wasn't completely sure about yet, it may need additional
> 'select DRM_KMS_CMA_HELPER' to cover all instances:

With 5.15.3, I had these errors on *one* of my boxes with Nvidia
drivers when building the nvidia drivers

Gentoo, nvidia-drivers-470.86

ERROR: modpost: "drm_atomic_helper_update_plane" [/work/tmp/portage/x11-drivers/nvidia-drivers-470.86/work/kernel/nvidia-drm.ko] undefined!
ERROR: modpost: "drm_atomic_helper_connector_reset" [/work/tmp/portage/x11-drivers/nvidia-drivers-470.86/work/kernel/nvidia-drm.ko] undefined!
ERROR: modpost: "drm_atomic_helper_page_flip" [/work/tmp/portage/x11-drivers/nvidia-drivers-470.86/work/kernel/nvidia-drm.ko] undefined!
ERROR: modpost: "drm_atomic_helper_swap_state" [/work/tmp/portage/x11-drivers/nvidia-drivers-470.86/work/kernel/nvidia-drm.ko] undefined!
ERROR: modpost: "drm_helper_probe_single_connector_modes" [/work/tmp/portage/x11-drivers/nvidia-drivers-470.86/work/kernel/nvidia-drm.ko] undefined!
ERROR: modpost: "drm_kms_helper_hotplug_event" [/work/tmp/portage/x11-drivers/nvidia-drivers-470.86/work/kernel/nvidia-drm.ko] undefined!
ERROR: modpost: "__drm_atomic_helper_crtc_destroy_state" [/work/tmp/portage/x11-drivers/nvidia-drivers-470.86/work/kernel/nvidia-drm.ko] undefined!
ERROR: modpost: "drm_atomic_helper_crtc_reset" [/work/tmp/portage/x11-drivers/nvidia-drivers-470.86/work/kernel/nvidia-drm.ko] undefined!
ERROR: modpost: "__drm_atomic_helper_plane_duplicate_state" [/work/tmp/portage/x11-drivers/nvidia-drivers-470.86/work/kernel/nvidia-drm.ko] undefined!
ERROR: modpost: "drm_atomic_helper_connector_duplicate_state" [/work/tmp/portage/x11-drivers/nvidia-drivers-470.86/work/kernel/nvidia-drm.ko] undefined!
WARNING: modpost: suppressed 12 unresolved symbol warnings because there were too many) 

After "make oldconfig", many DRM settings have been lost. Enabling
"CONFIG_DRM_CIRRUS_QEMU" gets them back, though a better way should
be found.

$ uname -a
Linux bilbo 5.15.2 #3 SMP PREEMPT Fri Nov 12 14:41:08 GMT 2021 x86_64
AMD FX(tm)-4300 Quad-Core Processor AuthenticAMD GNU/Linux

$ zcat /proc/config.gz  > .config

$ grep CONFIG_DRM .config | grep -v "is not set$"
CONFIG_DRM=m
CONFIG_DRM_KMS_HELPER=m
CONFIG_DRM_FBDEV_EMULATION=y
CONFIG_DRM_FBDEV_OVERALLOC=100
CONFIG_DRM_I2C_CH7006=m
CONFIG_DRM_I2C_SIL164=m
CONFIG_DRM_PANEL=y
CONFIG_DRM_BRIDGE=y
CONFIG_DRM_PANEL_BRIDGE=y
CONFIG_DRM_PANEL_ORIENTATION_QUIRKS=m

$ make oldconfig
#
# configuration written to .config
#

$ grep CONFIG_DRM .config | grep -v "is not set$"
CONFIG_DRM=m
CONFIG_DRM_BRIDGE=y
CONFIG_DRM_PANEL_ORIENTATION_QUIRKS=m

Comparing with the working system, that has VMM installed, and hence

CONFIG_DRM_CIRRUS_QEMU=m

Setting this and things are working again.

$ zcat /proc/config.gz  > .config

$ ./scripts/config --enable CONFIG_DRM_CIRRUS_QEMU

$ make oldconfig
#
# configuration written to .config
#

$ grep CONFIG_DRM .config | grep -v "is not set$"
CONFIG_DRM=m
CONFIG_DRM_KMS_HELPER=m
CONFIG_DRM_FBDEV_EMULATION=y
CONFIG_DRM_FBDEV_OVERALLOC=100
CONFIG_DRM_GEM_SHMEM_HELPER=y
CONFIG_DRM_I2C_CH7006=m
CONFIG_DRM_I2C_SIL164=m
CONFIG_DRM_PANEL=y
CONFIG_DRM_BRIDGE=y
CONFIG_DRM_PANEL_BRIDGE=y
CONFIG_DRM_CIRRUS_QEMU=m
CONFIG_DRM_PANEL_ORIENTATION_QUIRKS=m
$

-- 
Alan J. Wylie                                          https://www.wylie.me.uk/

Dance like no-one's watching. / Encrypt like everyone is.
Security is inversely proportional to convenience

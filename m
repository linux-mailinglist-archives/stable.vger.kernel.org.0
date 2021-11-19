Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 829F8456E13
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 12:16:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234431AbhKSLSw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 06:18:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:47110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229521AbhKSLSw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Nov 2021 06:18:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EFE3E619E5;
        Fri, 19 Nov 2021 11:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637320548;
        bh=ebn6eQi/XNLS2skGGx7gx0OtfsV07+MOad09equp6yw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hNpSNkFJOwMFWSdpSEhVFHmNZU+gMq3dwh9sWexAkJHYVM5JlRKQ8TOaVO3TIa008
         GH3r3adtdSq7twfK2f+WzmjbgqN/pm0LgHDutYJc2IIdMU2GEbjlJFZ66eDI8OBsIJ
         C/+YmhxarTia93z1jMsiesF2HpTiNKbyeBMEkPhQ=
Date:   Fri, 19 Nov 2021 12:15:45 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jiri Slaby <jirislaby@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "Acked-by: Jani Nikula" <jani.nikula@intel.com>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.15 808/917] drm: fb_helper: improve CONFIG_FB dependency
Message-ID: <YZeHYcPsjUMJ6x+q@kroah.com>
References: <20211115165428.722074685@linuxfoundation.org>
 <20211115165456.391822721@linuxfoundation.org>
 <9fdb2bf1-de52-1b9d-4783-c61ce39e8f51@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9fdb2bf1-de52-1b9d-4783-c61ce39e8f51@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 19, 2021 at 08:50:05AM +0100, Jiri Slaby wrote:
> On 15. 11. 21, 18:05, Greg Kroah-Hartman wrote:
> > From: Arnd Bergmann <arnd@arndb.de>
> > 
> > [ Upstream commit 9d6366e743f37d36ef69347924ead7bcc596076e ]
> 
> Hi,
> 
> this breaks build on openSUSE's armv7hl config:
> $ wget -O .config https://raw.githubusercontent.com/openSUSE/kernel-source/stable/config/armv7hl/default
> $ make -j168 CROSS_COMPILE=arm-suse-linux-gnueabi- ARCH=arm vmlinux
> ...
>   LD      .tmp_vmlinux.btf
> arm-suse-linux-gnueabi-ld: drivers/gpu/drm/panel/panel-simple.o: in function
> `panel_simple_probe':
> drivers/gpu/drm/panel/panel-simple.c:803: undefined reference to
> `drm_panel_dp_aux_backlight'
> $ grep -E 'CONFIG_(DRM|FB|DRM_KMS_HELPER|DRM_FBDEV_EMULATION)\>' .config
> CONFIG_DRM=y
> CONFIG_DRM_KMS_HELPER=m
> CONFIG_DRM_FBDEV_EMULATION=y
> CONFIG_FB=y
> 
> 5.16-rc1 builds just fine -- investigating why…

Ok, will go revert that, thanks.

greg k-h

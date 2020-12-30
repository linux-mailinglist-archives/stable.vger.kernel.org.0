Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 482C42E775E
	for <lists+stable@lfdr.de>; Wed, 30 Dec 2020 10:22:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726161AbgL3JWG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Dec 2020 04:22:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:60196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726144AbgL3JWG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Dec 2020 04:22:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 00F372078D;
        Wed, 30 Dec 2020 09:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609320085;
        bh=rUbSRIdhyVyskfTnTpqEi9ejHTGxyO+MSWyCfemGzbI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OJEGnid/WbFLDQ9NY5yPXNx0NdhsE5v2ZA0Ec+1uT6WU2NqITOL0YhjZDABqIvLpG
         O6Va5939Gm+/WVnFG+nSZKjE3rNJ4hnGkB6z3qGXqdDbB899JYKZaRbQjoKMWlXSJz
         xYRm0uNSkwdk5j67/5aonuJDjK7WpS8xQFHaKB2k=
Date:   Wed, 30 Dec 2020 10:22:43 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Harry Wentland <harry.wentland@amd.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.4 099/453] drm/amdgpu: fix build_coefficients() argument
Message-ID: <X+xG4/b+XW54u1ej@kroah.com>
References: <20201228124937.240114599@linuxfoundation.org>
 <20201228124941.984955049@linuxfoundation.org>
 <20201229175819.GA15548@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201229175819.GA15548@duo.ucw.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 29, 2020 at 06:58:19PM +0100, Pavel Machek wrote:
> Hi!
> 
> > From: Arnd Bergmann <arnd@arndb.de>
> > 
> > [ Upstream commit dbb60031dd0c2b85f10ce4c12ae604c28d3aaca4 ]
> > 
> > gcc -Wextra warns about a function taking an enum argument
> > being called with a bool:
> > 
> > drivers/gpu/drm/amd/amdgpu/../display/modules/color/color_gamma.c: In function 'apply_degamma_for_user_regamma':
> > drivers/gpu/drm/amd/amdgpu/../display/modules/color/color_gamma.c:1617:29: warning: implicit conversion from 'enum <anonymous>' to 'enum dc_transfer_func_predefined' [-Wenum-conversion]
> >  1617 |  build_coefficients(&coeff, true);
> > 
> > It appears that a patch was added using the old calling conventions
> > after the type was changed, and the value should actually be 0
> > (TRANSFER_FUNCTION_SRGB) here instead of 1 (true).
> 
> Yeah, but 4.19 still uses bool there, so this actually introduces a
> bug.
> 
> Please drop.

Now dropped, thanks.

greg k-h

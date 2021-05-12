Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C99737B96E
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 11:41:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230145AbhELJmc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 05:42:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:39862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230115AbhELJma (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 05:42:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 207F46108D;
        Wed, 12 May 2021 09:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620812479;
        bh=u286lNUk3x/9tGhtxahuUZmtJnO4ftN8zsF2mhOOpLw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=y6o3y9uwUTaJggB1zEq5ViFDM3ICbOZwLA5CsypZ2sTNr80wlrPwvYA+tJCfJXQPf
         8nxs1588QlH0wz/+m9K8EzbyGrA+XuItrH/9emv5+yOLQ1FLSZ31lyEwaEor8t0KRt
         YJwt6i0XZAPWhZ1Zay2l2wwSa8WTcQWbIw7Ea1Hg=
Date:   Wed, 12 May 2021 11:41:17 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Gerd Hoffmann <kraxel@redhat.com>
Cc:     stable@vger.kernel.org
Subject: Re: [[PATCH for 5.10]] drm/qxl: use ttm bo priorities
Message-ID: <YJuivdX2Vk4Kv9l3@kroah.com>
References: <20210510123140.2200366-1-kraxel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210510123140.2200366-1-kraxel@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 10, 2021 at 02:31:40PM +0200, Gerd Hoffmann wrote:
> Allow to set priorities for buffer objects.  Use priority 1 for surface
> and cursor command releases.  Use priority 0 for drawing command
> releases.  That way the short-living drawing commands are first in line
> when it comes to eviction, making it *much* less likely that
> ttm_bo_mem_force_space() picks something which can't be evicted and
> throws an error after waiting a while without success.
> 
> Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
> Acked-by: Thomas Zimmermann <tzimmermann@suse.de>
> Link: http://patchwork.freedesktop.org/patch/msgid/20210217123213.2199186-4-kraxel@redhat.com
> (cherry-picked from 4fff19ae427548d8c37260c975a4b20d3c040ec6)
> ---

What about 5.11 and 5.12?  We can't just backport to a single stable
tree and miss newer ones.

thanks,

greg k-h

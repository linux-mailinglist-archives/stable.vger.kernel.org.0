Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D081237BA37
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 12:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbhELKVS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 06:21:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48684 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230096AbhELKVR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 06:21:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620814809;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MBnluZvKQpwlggRx1/S7XuyJ8ifNdWufv+GinDV40gU=;
        b=hjp4wotoW39GYGE9Ki5epMICgKCS1weX4aq34MkhCbs8TSztCSsjNYRrB15m2hCTHn9coz
        D0ISV6dlrg9B4Lw8IBydjFTv0Ochvk6UE94FUslmzI2Yc/hrTpy24Tta7+/xpVxqghp4WG
        cy5DNWzvmkBo/OvjJ16+87YDmRIQYlE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-487-o-JN_fayM4yWTqEMs9YS8Q-1; Wed, 12 May 2021 06:20:06 -0400
X-MC-Unique: o-JN_fayM4yWTqEMs9YS8Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 099A8FC8C;
        Wed, 12 May 2021 10:20:05 +0000 (UTC)
Received: from sirius.home.kraxel.org (ovpn-114-0.ams2.redhat.com [10.36.114.0])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C39F86249C;
        Wed, 12 May 2021 10:20:04 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id 0CFC118003AF; Wed, 12 May 2021 12:20:03 +0200 (CEST)
Date:   Wed, 12 May 2021 12:20:02 +0200
From:   Gerd Hoffmann <kraxel@redhat.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
Subject: Re: [[PATCH for 5.10]] drm/qxl: use ttm bo priorities
Message-ID: <20210512102002.ebyzz2bbi4k6oyrv@sirius.home.kraxel.org>
References: <20210510123140.2200366-1-kraxel@redhat.com>
 <YJuivdX2Vk4Kv9l3@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJuivdX2Vk4Kv9l3@kroah.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 12, 2021 at 11:41:17AM +0200, Greg KH wrote:
> On Mon, May 10, 2021 at 02:31:40PM +0200, Gerd Hoffmann wrote:
> > Allow to set priorities for buffer objects.  Use priority 1 for surface
> > and cursor command releases.  Use priority 0 for drawing command
> > releases.  That way the short-living drawing commands are first in line
> > when it comes to eviction, making it *much* less likely that
> > ttm_bo_mem_force_space() picks something which can't be evicted and
> > throws an error after waiting a while without success.
> > 
> > Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
> > Acked-by: Thomas Zimmermann <tzimmermann@suse.de>
> > Link: http://patchwork.freedesktop.org/patch/msgid/20210217123213.2199186-4-kraxel@redhat.com
> > (cherry-picked from 4fff19ae427548d8c37260c975a4b20d3c040ec6)
> > ---
> 
> What about 5.11 and 5.12?  We can't just backport to a single stable
> tree and miss newer ones.

It's a clean cherry-pick for those (seems you've found the other mail
saying so meanwhile ...).

take care,
  Gerd


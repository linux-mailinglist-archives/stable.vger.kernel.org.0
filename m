Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 413E21C402D
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 18:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729779AbgEDQkF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 12:40:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:49246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729763AbgEDQjS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 12:39:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 25886206D9;
        Mon,  4 May 2020 16:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588610358;
        bh=sgByuzfhKbHojmkKvT8MCOvO9KSXVLWdnDVEzxVaYh8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WwEBh8fIJPbfXaiP896yZ5JWpTqbvZIAbQtpQQ9C73juh+PVG+94d7jnMqcCcxr6V
         CtUeVBJNDQlubZD2LU4+nE677X+7XCqOYE5J5WOJp4gpmxOdtT65wUt8x5g3EK9gc/
         r1EmDmHcEpFW8rNG+Hw4tdGbpQrlewiJoXZizxPY=
Date:   Mon, 4 May 2020 18:39:16 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Vasily Averin <vvs@virtuozzo.com>
Cc:     stable@vger.kernel.org, Gerd Hoffmann <kraxel@redhat.com>
Subject: Re: [PATCH 4.19] drm/qxl: qxl_release use after free
Message-ID: <20200504163916.GB2724164@kroah.com>
References: <7f93a18b-45de-457d-6901-f6babce1d56a@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7f93a18b-45de-457d-6901-f6babce1d56a@virtuozzo.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 04, 2020 at 02:36:27PM +0300, Vasily Averin wrote:
> >>From 933db73351d359f74b14f4af095808260aff11f9 Mon Sep 17 00:00:00 2001
> From: Vasily Averin <vvs@virtuozzo.com>
> Date: Wed, 29 Apr 2020 12:01:24 +0300
> Subject: drm/qxl: qxl_release use after free
> 
> From: Vasily Averin <vvs@virtuozzo.com>
> 
> commit 933db73351d359f74b14f4af095808260aff11f9 upstream.
> 
> qxl_release should not be accesses after qxl_push_*_ring_release() calls:
> userspace driver can process submitted command quickly, move qxl_release
> into release_ring, generate interrupt and trigger garbage collector.
> 
> It can lead to crashes in qxl driver or trigger memory corruption
> in some kmalloc-192 slab object
> 
> Gerd Hoffmann proposes to swap the qxl_release_fence_buffer_objects() +
> qxl_push_{cursor,command}_ring_release() calls to close that race window.
> 
> cc: stable@vger.kernel.org
> Fixes: f64122c1f6ad ("drm: add new QXL driver. (v1.4)")
> Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
> Link: http://patchwork.freedesktop.org/patch/msgid/fa17b338-66ae-f299-68fe-8d32419d9071@virtuozzo.com
> Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
> 
> backported to v.4.19 stable

Now replaced, thansk.

greg k-h

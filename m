Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 004571C4032
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 18:40:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729876AbgEDQk2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 12:40:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:51572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729870AbgEDQk2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 12:40:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD85520705;
        Mon,  4 May 2020 16:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588610428;
        bh=me9A0Tsq6VCQ8gxrwVBkQw/zcs3fJgv1vR14/TqibgE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tY9DDj5Gm+JJR/3jU/lRQGC5IEcGPfnELoZb0vlZKISnu913IwjCfqHbHTruyNmKq
         J8ikTNWJK6HpEZDDD2onnOm1d3PhB5jLceCNguHCZJpHo4/2ZxopB88yJb6HfOaRP0
         NXpNMg9jIhOZQSb6OlIMYYVReiyCbkZJLTfgeaR8=
Date:   Mon, 4 May 2020 18:40:26 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Vasily Averin <vvs@virtuozzo.com>
Cc:     stable@vger.kernel.org, Gerd Hoffmann <kraxel@redhat.com>
Subject: Re: [PATCH 4.14] drm/qxl: qxl_release use after free
Message-ID: <20200504164026.GC2724164@kroah.com>
References: <050bf096-986a-6ee8-7bef-37a532cc1fcd@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <050bf096-986a-6ee8-7bef-37a532cc1fcd@virtuozzo.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 04, 2020 at 02:38:18PM +0300, Vasily Averin wrote:
> >>From 933db73351d359f74b14f4af095808260aff11f9 Mon Sep 17 00:00:00 2001
> From: Vasily Averin <vvs@virtuozzo.com>
> Date: Wed, 29 Apr 2020 12:01:24 +0300
> Subject: drm/qxl: qxl_release use after free
> 
> From: Vasily Averin <vvs@virtuozzo.com>
> 
> commit 933db73351d359f74b14f4af095808260aff11f9 upstream.
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
> backported to v4.14-stable

Now replaced, thanks.

greg k-h

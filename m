Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 004094533B8
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 15:10:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237027AbhKPONV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 09:13:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:38036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233147AbhKPONV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Nov 2021 09:13:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C082161391;
        Tue, 16 Nov 2021 14:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637071824;
        bh=IZkKjcpHoScKEqUYfhPgfrSltD9+8CAGgglwa0nTCaY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JBCA6sAkjX4JbHish7k4V3FdqW0KwrnC8uko4TIWeBo5ntIyMR4YfhGGrs5Nkst/6
         RxurOuHZdfOeqNKuICDl7RV3D4dPJ/QeOYaVujnGlayVLgYQ3Vb4vLSvR1d0BdtacZ
         SxPTDt90u8H3wVvGKbG6DsooziHQA+2RW3+CPOq8=
Date:   Tue, 16 Nov 2021 15:10:22 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sergey Senozhatsky <senozhatsky@chromium.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.15 228/917] media: videobuf2: rework vb2_mem_ops API
Message-ID: <YZO7zobODuFxHxqJ@kroah.com>
References: <20211115165428.722074685@linuxfoundation.org>
 <20211115165436.520296731@linuxfoundation.org>
 <YZMH3DJ7FbNZbx0G@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YZMH3DJ7FbNZbx0G@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 16, 2021 at 10:22:36AM +0900, Sergey Senozhatsky wrote:
> On (21/11/15 17:55), Greg Kroah-Hartman wrote:
> > From: Sergey Senozhatsky <senozhatsky@chromium.org>
> > 
> > [ Upstream commit a4b83deb3e76fb9385ca58e2c072a145b3a320d6 ]
> > 
> > With the new DMA API we need an extension of the videobuf2 API.
> > Previously, videobuf2 core would set the non-coherent DMA bit
> > in the vb2_queue dma_attr field (if user-space would pass a
> > corresponding memory hint); the vb2 core then would pass the
> > vb2_queue dma_attrs to the vb2 allocators. The vb2 allocator
> > would use the queue's dma_attr and the DMA API would allocate
> > either coherent or non-coherent memory.
> > 
> > But we cannot do this anymore, since there is no corresponding DMA
> > attr flag and, hence, there is no way for the allocator to become
> > aware of what type of allocation user-space has requested. So we
> > need to pass more context from videobuf2 core to the allocators.
> > 
> > Fix this by changing the call_ptr_memop() macro to pass the
> > vb2 pointer to the corresponding op callbacks.
> > 
> > Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
> > Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> > Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> Hello Greg, Sasha,
> 
> This patch needs two fix up patches to be applied.
> 
> The first one is in Linus's tree (media: videobuf2: always set buffer vb2 pointer)
> 67f85135c57c8ea20b5417b28ae65e53dc2ec2c3

Now applied, thanks.

> The second one isn't yet (media: videobuf2-dma-sg: Fix buf->vb NULL pointer dereference)
> https://lore.kernel.org/all/20211101145355.533704-1-hdegoede@redhat.com/raw

I've grabbed this from linux-next now.

thanks,

greg k-h

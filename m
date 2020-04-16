Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7772F1AB5E1
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 04:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387787AbgDPCbZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 22:31:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:49910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729130AbgDPCbX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 22:31:23 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B23612076C;
        Thu, 16 Apr 2020 02:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587004283;
        bh=uKwAdvGQ5ZFib8v4yOSNbZkIRL7TkmEI2o6ekvw8p08=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=olcm7tUEns42BrBULl9HeILcYuBDhbeKpWlXusgJor2I54wZBAiExx8X+oAHn+o7V
         1GaagXYOeG9KUqt38jExFFik4bIhtPyiARp2ArwrUwBaPM35RuPmJZhOnVnNY6eYWk
         GX1ORSLuEtlLaDWVraXX0POlcJsnZieDOhch60gs=
Date:   Wed, 15 Apr 2020 22:31:21 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     chris@chris-wilson.co.uk, alexander.deucher@amd.com,
        kirill.shutemov@linux.intel.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] drm: Remove PageReserved manipulation
 from drm_pci_alloc" failed to apply to 4.19-stable tree
Message-ID: <20200416023121.GY1068@sasha-vm>
References: <158695037014053@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <158695037014053@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 15, 2020 at 01:32:50PM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.19-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From ea36ec8623f56791c6ff6738d0509b7920f85220 Mon Sep 17 00:00:00 2001
>From: Chris Wilson <chris@chris-wilson.co.uk>
>Date: Sun, 2 Feb 2020 17:16:31 +0000
>Subject: [PATCH] drm: Remove PageReserved manipulation from drm_pci_alloc
>
>drm_pci_alloc/drm_pci_free are very thin wrappers around the core dma
>facilities, and we have no special reason within the drm layer to behave
>differently. In particular, since
>
>commit de09d31dd38a50fdce106c15abd68432eebbd014
>Author: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
>Date:   Fri Jan 15 16:51:42 2016 -0800
>
>    page-flags: define PG_reserved behavior on compound pages
>
>    As far as I can see there's no users of PG_reserved on compound pages.
>    Let's use PF_NO_COMPOUND here.
>
>it has been illegal to combine GFP_COMP with SetPageReserved, so lets
>stop doing both and leave the dma layer to its own devices.
>
>Reported-by: Taketo Kabe
>Bug: https://gitlab.freedesktop.org/drm/intel/issues/1027
>Fixes: de09d31dd38a ("page-flags: define PG_reserved behavior on compound pages")
>Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
>Cc: <stable@vger.kernel.org> # v4.5+
>Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
>Link: https://patchwork.freedesktop.org/patch/msgid/20200202171635.4039044-1-chris@chris-wilson.co.uk

We didn't have 750afb08ca71 ("cross-tree: phase out
dma_zalloc_coherent()") on older kernels. Fixed and queued up.

-- 
Thanks,
Sasha

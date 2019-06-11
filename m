Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 022C73D0FD
	for <lists+stable@lfdr.de>; Tue, 11 Jun 2019 17:37:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390295AbfFKPhB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jun 2019 11:37:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:60540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388863AbfFKPhB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 11 Jun 2019 11:37:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 56409208E3;
        Tue, 11 Jun 2019 15:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560267420;
        bh=fEoHYLUoUcY9d8GXrqmAIqvlneWazjqtSYZ7U9oX254=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=L+HewiuH18Tn8PTXdwxGf11Sd+J2LlpmhDkd6ygLY6Iu1mKKOQHQnlsHmCPMsubcm
         uPzFSSJqL/U/01GKsriiICUZzR90OKciN7m2VNHDAhxuD4QY3foY7q/9jxkjP7xuBR
         V+Y1I/XKnIxmNNXSXQPRUkI2awrv2XIb0lnrKZ0A=
Date:   Tue, 11 Jun 2019 17:36:56 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sven Joachim <svenjoac@gmx.de>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dave Airlie <airlied@redhat.com>
Subject: Re: Linux 5.1.9 build failure with
 CONFIG_NOUVEAU_LEGACY_CTX_SUPPORT=n
Message-ID: <20190611153656.GA5084@kroah.com>
References: <87k1dsjkdo.fsf@turtle.gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k1dsjkdo.fsf@turtle.gmx.de>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 11, 2019 at 03:56:35PM +0200, Sven Joachim wrote:
> Commit 1e07d63749 ("drm/nouveau: add kconfig option to turn off nouveau
> legacy contexts. (v3)") has caused a build failure for me when I
> actually tried that option (CONFIG_NOUVEAU_LEGACY_CTX_SUPPORT=n):
> 
> ,----
> | Kernel: arch/x86/boot/bzImage is ready  (#1)
> |   Building modules, stage 2.
> |   MODPOST 290 modules
> | ERROR: "drm_legacy_mmap" [drivers/gpu/drm/nouveau/nouveau.ko] undefined!
> | scripts/Makefile.modpost:91: recipe for target '__modpost' failed
> `----
> 
> Upstream does not have that problem, as commit bed2dd8421 ("drm/ttm:
> Quick-test mmap offset in ttm_bo_mmap()") has removed the use of
> drm_legacy_mmap from nouveau_ttm.c.  Unfortunately that commit does not
> apply in 5.1.9.
> 
> Most likely 4.19.50 and 4.14.125 are also affected, I haven't tested
> them yet.

They probably are.

Should I just revert this patch in the stable tree, or add some other
patch (like the one pointed out here, which seems an odd patch for
stable...)

thanks,

greg k-h

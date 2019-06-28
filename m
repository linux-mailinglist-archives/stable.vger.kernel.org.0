Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FF195A71F
	for <lists+stable@lfdr.de>; Sat, 29 Jun 2019 00:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726586AbfF1Wre (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jun 2019 18:47:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:55460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726620AbfF1Wre (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 28 Jun 2019 18:47:34 -0400
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6DEF2133F
        for <stable@vger.kernel.org>; Fri, 28 Jun 2019 22:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561762053;
        bh=d1ga57vWxujYj83xEsaBg10bKl0FEJJQU18PfYyt+GU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=u89eE6ch4I1qAyBCHqMg6LeUUHX/LMLFV+tIkUvH1Cl2DFdP7Z68KKaQcwhfImYjE
         fz2qag2h+IfJ3DDvUpmfLRQ5chtTMTPs4sSvZLZi18ob20Ahft7BhrZL3wnP70qQac
         4w9UIEy4Kp88j41xtnb5cCg2FBXK1/phaxJBYs0I=
Received: by mail-qk1-f180.google.com with SMTP id d15so6270746qkl.4
        for <stable@vger.kernel.org>; Fri, 28 Jun 2019 15:47:32 -0700 (PDT)
X-Gm-Message-State: APjAAAVuGyEAfdWlzQ2uU2V8WfCaA8ue6lpLHThqNQHxWBUesKDImykl
        WNdrhvOB9JxhuVYEPhcpXr3iT8qureU1KSktuQ==
X-Google-Smtp-Source: APXvYqwZcAEztIfeJKR/l+OjGkLbDrNoV6cF8P4jA29+W4ejMA1/eHHgTvyF8p5wO1lb6pP/HPBIb+yXObkLHpBk8lg=
X-Received: by 2002:a37:a48e:: with SMTP id n136mr11138414qke.223.1561762052134;
 Fri, 28 Jun 2019 15:47:32 -0700 (PDT)
MIME-Version: 1.0
References: <20190627172414.27231-1-boris.brezillon@collabora.com>
In-Reply-To: <20190627172414.27231-1-boris.brezillon@collabora.com>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Fri, 28 Jun 2019 16:47:21 -0600
X-Gmail-Original-Message-ID: <CAL_JsqKFP2Z1B3oOK9DBZpmVN=tuK-RqqNWbg4=nKCH_cAZPzg@mail.gmail.com>
Message-ID: <CAL_JsqKFP2Z1B3oOK9DBZpmVN=tuK-RqqNWbg4=nKCH_cAZPzg@mail.gmail.com>
Subject: Re: [PATCH] drm/panfrost: Fix a double-free error
To:     Boris Brezillon <boris.brezillon@collabora.com>
Cc:     Tomeu Vizoso <tomeu@tomeuvizoso.net>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 27, 2019 at 11:24 AM Boris Brezillon
<boris.brezillon@collabora.com> wrote:
>
> drm_gem_shmem_create_with_handle() returns a GEM object and attach a
> handle to it. When the user closes the DRM FD, the core releases all
> GEM handles along with their backing GEM objs, which can lead to a
> double-free issue if panfrost_ioctl_create_bo() failed and went
> through the err_free path where drm_gem_object_put_unlocked() is
> called without deleting the associate handle.
>
> Replace this drm_gem_object_put_unlocked() call by a
> drm_gem_handle_delete() one to fix that.
>
> Fixes: f3ba91228e8e ("drm/panfrost: Add initial panfrost driver")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
> ---
> Reproduced for real when BO mapping fails because we ran out of
> memory.
> ---
>  drivers/gpu/drm/panfrost/panfrost_drv.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied to drm-misc-fixes.

Rob

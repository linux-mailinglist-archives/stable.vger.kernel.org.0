Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10D3F216928
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 11:35:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727058AbgGGJfi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 05:35:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726467AbgGGJfh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jul 2020 05:35:37 -0400
Received: from mail-vs1-xe42.google.com (mail-vs1-xe42.google.com [IPv6:2607:f8b0:4864:20::e42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FDE2C061755
        for <stable@vger.kernel.org>; Tue,  7 Jul 2020 02:35:37 -0700 (PDT)
Received: by mail-vs1-xe42.google.com with SMTP id 64so15913359vsl.3
        for <stable@vger.kernel.org>; Tue, 07 Jul 2020 02:35:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PbbA9beaLiSF4O3UrzLrvqCnm4COG/0M5t0WZEIdpEw=;
        b=er0HyREMkupG/3EJW0otUUNH+mYwIa48wMQbDFQyhoqit9SfsQstmJzLJP9gV66UMU
         PXyILl3zeyd/T4fr+taPHEZCIcaE/8NJ0bESFC4/c88te3TTwLJ2IFbiSWjNee6/P0xZ
         GwvSRWPrPiKaHGZya4ngA2IoCCFPRj1ryTcrejdpP4Ii0EqmVNgEdKVX6NLJR/cD4YB5
         PtDbGSWPs7dQOo2j+uFj3xokJVtUFwH271F6TUtT88yogG/gI07n5pDMFk9FnGjwHR9s
         32DadFAalVdCcrKgCsttAWMMXDlUO8DH6SDzMr2s/HliCth23TrRFiiB36lbx27OYqWb
         jUiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PbbA9beaLiSF4O3UrzLrvqCnm4COG/0M5t0WZEIdpEw=;
        b=PmEd5CLriINOdK7M7c9WjAnqehnJPsUCp+HYTWPtSWIgFlUDxv7d9uaL0o55HOtPi/
         oLtNZRTu1ljY8UXgc2vQ2jMTY5LpsINTcqXk3/SM+HwcNtuzJEtpU3efmFXAj347RBe7
         Y67MG1vLUfPWWW2kAycvCQ7o4l5vl10r0d9aRlcmWCH9SDxxA9OLL6Ws3tL0jPP1vk3r
         eLEiCd92JvjOoQ7ewUQLaqKbrRf5XLSmTrm2bkeykrj7Wr2113HmwczNYo9C8ucRIJZr
         Df9VmmD2W+04ciQ6Y41td+UPXLQLa1zYDFNHi/8EH1EbESUxxuvACZeXbtF2NQtME16K
         QPnQ==
X-Gm-Message-State: AOAM532Kxxk7UJPbnDTU2Xdr46ink9rojsykhZGo421oMRpfxDJGk9cC
        lQIL5yTUP5mlq6cgTRJyzbEULFtqiuQetdAqk3Y=
X-Google-Smtp-Source: ABdhPJwZOetY8BVjMzl+jBcJlK6Ym1lxGnf0Se8pyTHxI7NalaPDsFjMC0/0wKB8qMeicT22YJk7o6CcNCR3EXAScrI=
X-Received: by 2002:a67:ca03:: with SMTP id z3mr31895947vsk.34.1594114536435;
 Tue, 07 Jul 2020 02:35:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200706170021.8832-1-chris@chris-wilson.co.uk> <20200706170138.8993-1-chris@chris-wilson.co.uk>
In-Reply-To: <20200706170138.8993-1-chris@chris-wilson.co.uk>
From:   Matthew Auld <matthew.william.auld@gmail.com>
Date:   Tue, 7 Jul 2020 10:35:10 +0100
Message-ID: <CAM0jSHM6m4k1rk2Y7Q5S4e2x-K88xZK6ZP9hHTprWp=KGa0yJg@mail.gmail.com>
Subject: Re: [Intel-gfx] [PATCH] drm/i915/gt: Pin the rings before marking active
To:     Chris Wilson <chris@chris-wilson.co.uk>
Cc:     Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 6 Jul 2020 at 18:01, Chris Wilson <chris@chris-wilson.co.uk> wrote:
>
> On eviction, we acquire the vm->mutex and then wait on the vma->active.
> Thereore when binding and pinning the vma, we must follow the same
> sequence, lock/pin the vma then mark it active. Otherwise, we mark the
> vma as active, then wait for the vm->mutex, and meanwhile the evictor
> holding the mutex waits upon us to complete our activity.
>
> Fixes: 8ccfc20a7d56 ("drm/i915/gt: Mark ring->vma as active while pinned")
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
> Cc: <stable@vger.kernel.org> # v5.6+
Reviewed-by: Matthew Auld <matthew.auld@intel.com>

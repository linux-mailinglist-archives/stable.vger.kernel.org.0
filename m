Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CF6325311D
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 16:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728121AbgHZOUj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 10:20:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728050AbgHZOUf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Aug 2020 10:20:35 -0400
Received: from mail-ua1-x942.google.com (mail-ua1-x942.google.com [IPv6:2607:f8b0:4864:20::942])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08F7CC061574
        for <stable@vger.kernel.org>; Wed, 26 Aug 2020 07:20:34 -0700 (PDT)
Received: by mail-ua1-x942.google.com with SMTP id b12so599875uae.9
        for <stable@vger.kernel.org>; Wed, 26 Aug 2020 07:20:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sjSOraiR4FbGG6Ur2UAs6+vtqCNJ1lx1JCgkMDPitTk=;
        b=qYue+NH8i/tJVUCVEI+sdB9jN4sluLwOQTwn3irlruHy2HpMFXOsBpCYc/Tgeyy5yH
         oSg9162QKzEbGZLczKXME7pZuJmWluphLspCvFuBtLcgbM+9gPVPZnonhwNp0dsvDPCE
         B78Z8OX4PRggahWB8DtA/TkU+zVZhJ1o9Ydw2iGMapErf0pMB1sjf8LK0CKc+Ve7BHVc
         V1eshEuRFWHmt3DH8OctSKkSHmTyDJL26AvoRPUtX03END81DrT9jqg7x0gZ7SHIOZub
         rjyueVimwAGawJD/kbqy4eNyP2Cl2K4d2fIlIEhl24W45vJpHvFyzRi4om4floqHTLMM
         eGLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sjSOraiR4FbGG6Ur2UAs6+vtqCNJ1lx1JCgkMDPitTk=;
        b=mAlFzHQFoGaTnuN+opSwpABT6RHV+FUKEy29SAOADg/Ja4U3kQthmX/28q684uU6Me
         grXoH1P53JiHbnkibC/+YvJNrGfPANMBhPWXKq4T7LYGeu41DhWVS187419/o5j2eNG9
         zDsrUHOZ3CeRSrGoOFo14LVGvzKI2vUuEvAtRGmHF6ZeFBZt//QdlI7e4Rw5dFao35tE
         Chr9q+T4fzxZut0osE1J+dHGVU7H0ciwPyRlETLfJp6CDDOmTiKtfCkf3Hb4ZSgTzGHk
         DE3kWZIvfiCA59MUVM9AGpm8Kj+O5m9DZboZpd1sX0Xp91Uo3qXX+iQHrNgq3hMsDVsV
         YkKg==
X-Gm-Message-State: AOAM531YlW/zgehaN4FBRr4rcvKvPi+mqeaFbYrLkyYOuV4hSQdivodD
        l7eRAHtGgp5umdij/gpyT9nyxekOUQvJ5HoO+5OMA9+litc=
X-Google-Smtp-Source: ABdhPJxDqVMfk7ziG4e8i8XJU3zSsypVAXFKQYM2rdK1GF+a2S6Pl1Y5mpPV4XCaVjJUOW8bVQczn2r+UlJUU3NQqOY=
X-Received: by 2002:ab0:64c3:: with SMTP id j3mr8755084uaq.129.1598451631838;
 Wed, 26 Aug 2020 07:20:31 -0700 (PDT)
MIME-Version: 1.0
References: <20200826132811.17577-1-chris@chris-wilson.co.uk>
In-Reply-To: <20200826132811.17577-1-chris@chris-wilson.co.uk>
From:   Matthew Auld <matthew.william.auld@gmail.com>
Date:   Wed, 26 Aug 2020 15:20:05 +0100
Message-ID: <CAM0jSHNx0vL2y617r1xSdY3UnwBcCjuTmkz8nJjaEahqWM6WJQ@mail.gmail.com>
Subject: Re: [Intel-gfx] [PATCH 01/39] drm/i915/gem: Avoid implicit vmap for
 highmem on x86-32
To:     Chris Wilson <chris@chris-wilson.co.uk>
Cc:     Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        Harald Arnesen <harald@skogtun.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 26 Aug 2020 at 14:29, Chris Wilson <chris@chris-wilson.co.uk> wrote:
>
> On 32b, highmem uses a finite set of indirect PTE (i.e. vmap) to provide
> virtual mappings of the high pages. As these are finite, map_new_virtual()
> must wait for some other kmap() to finish when it runs out. If we map a
> large number of objects, there is no method for it to tell us to release
> the mappings, and we deadlock.
>
> However, if we make an explicit vmap of the page, that uses a larger
> vmalloc arena, and also has the ability to tell us to release unwanted
> mappings. Most importantly, it will fail and propagate an error instead
> of waiting forever.
>
> Fixes: fb8621d3bee8 ("drm/i915: Avoid allocating a vmap arena for a single page") #x86-32
> References: e87666b52f00 ("drm/i915/shrinker: Hook up vmap allocation failure notifier")
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Harald Arnesen <harald@skogtun.org>
> Cc: <stable@vger.kernel.org> # v4.7+
Reviewed-by: Matthew Auld <matthew.auld@intel.com>

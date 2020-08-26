Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 128A325393C
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 22:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727061AbgHZUnn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 16:43:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727003AbgHZUni (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Aug 2020 16:43:38 -0400
Received: from smtp.domeneshop.no (smtp.domeneshop.no [IPv6:2a01:5b40:0:3005::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA5BEC061574
        for <stable@vger.kernel.org>; Wed, 26 Aug 2020 13:43:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=skogtun.org
        ; s=ds201912; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ixkHCRJdIC6h9PWnFkCPzplR0jeUxkvYwD5QjYbVoF0=; b=CqgEgv/nQzM/0XqmWMa9fHRPLL
        ++EZK+dSb+K5QZTHM5jes/FWNLVecjz198HoMjtleZV251gMMoFrH6fYYBSGcwTrcCqYtCRMGk2M3
        X5w16YZWNEenf/lTOgcHYU0J/75fLOyHpXVrij/VeEfuh4bLzXUV5C45Mx4lKnx6rr0x/N+s6Axhx
        xcA0jOO2DclpWPp3klx5U2BbCVoW1rre1DJvAUUAVuvuJoSo0Ftl+RigjLuw4TgdNCqIzjYJfX0us
        1dyOd58y+FURIeQkLSx+ddjLbGfS2ZkdmisJK3MqRaZPa6FYQJxjR8we//GnPYtPPvjT6zvqf/MVg
        Yyo4vg+Q==;
Received: from [2a01:79c:cebf:7fb0:de97:df61:fecc:46bb] (port=56230)
        by smtp.domeneshop.no with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <harald@skogtun.org>)
        id 1kB2Gb-0006vA-3x; Wed, 26 Aug 2020 22:43:33 +0200
Subject: Re: [PATCH 01/39] drm/i915/gem: Avoid implicit vmap for highmem on
 x86-32
To:     Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org
References: <20200826132811.17577-1-chris@chris-wilson.co.uk>
From:   Harald Arnesen <harald@skogtun.org>
Message-ID: <bb7583d9-a519-60cc-84b3-56de69a6ac21@skogtun.org>
Date:   Wed, 26 Aug 2020 22:43:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200826132811.17577-1-chris@chris-wilson.co.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Chris Wilson [26.08.2020 15:27]:

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

Sorry, doesn't help on my machine (Thinkpad T520).
-- 
Hilsen Harald

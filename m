Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DE836D175B
	for <lists+stable@lfdr.de>; Fri, 31 Mar 2023 08:26:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbjCaG0B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Mar 2023 02:26:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjCaG0A (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Mar 2023 02:26:00 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5387FD53B
        for <stable@vger.kernel.org>; Thu, 30 Mar 2023 23:25:40 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id bi9so27550761lfb.12
        for <stable@vger.kernel.org>; Thu, 30 Mar 2023 23:25:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680243938;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=hgtInxHR98O+yLhpVW2/mvrEUc6/7NQut93JIoqVYmE=;
        b=Ur92w2KF9CB99Lo/wFgVxmv6E2bnDa9tbVh9f+8jTkkUYSL2bJIAlXLVF4upb7DbpQ
         Dkbs5WDpJIR+JB1bWUURd64whGvU1sMc68qg/Bnzst76wnQ03fAadppWA6WxWyZkxUCr
         AHMniH3uh2ShwL0Xyaz+s+tKFZvjIHdC3FMO17nueJ0bAGWSpszJVOdOFQDOTNbxkvCK
         e3VZGKErOyRhxi+y1c26uT5hnTjw1uHo8Nwcf6KZIJKKwnWPNUu1uEw9lDjgzMw/Un0O
         Tne9fDd6OxT/MAUEDSK1glsdVEaYqnMyEeV8tMDF8XrTLgQWGNyDfzTIEomFzLe9zRYb
         yi2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680243938;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hgtInxHR98O+yLhpVW2/mvrEUc6/7NQut93JIoqVYmE=;
        b=Iey290QnwOHwrBVkXkR3NTYZaf+y3dH43MJpcx0wd3W65brdQrYbe4eR5DysVCPSHR
         rNsUntoZ2akH8yW9hsVzPm9ZhbOG1pthQvaRo+YWBGaG2NgqERFS7WmgEdjw49uh9vjx
         QJd1Av7HRGEfuDZ/Dir9PMScOJvGXRu2DCMQnY21tzQ/v7hsEBiDNEbG2snjkEEB/og4
         ZjE4KE9ddR9Kcnh3dhabK0H2tXY7eJDcvlbGZHzAz6enMZuvKNpVLCEDPXovU33rDs7L
         6OSAp8hPv6jyfDBRV0UNbZw+8WIgrle2XBty2YmtBM7SIstM7GjGdBPezG9utkSENyhb
         zuPQ==
X-Gm-Message-State: AAQBX9fWs1Cx51DL27f2BWv0wEVcAfiCQYZBAPaiARTMMqF1tV47btMr
        EGiVKpEgyjSnShJBfkd6sv/uv0SyFyF79tRdRhY=
X-Google-Smtp-Source: AKy350Z1pHMdHOwDLajGCN+NxBSZWAFI2Ep7D9no6OYbptZeuDBw6+xKPvq14eDGaAfTewVNcAnpLZQRLm8Iip640Rs=
X-Received: by 2002:ac2:519c:0:b0:4d5:ca43:7047 with SMTP id
 u28-20020ac2519c000000b004d5ca437047mr7735343lfi.10.1680243938346; Thu, 30
 Mar 2023 23:25:38 -0700 (PDT)
MIME-Version: 1.0
References: <20230320151423.1708436-1-tvrtko.ursulin@linux.intel.com>
In-Reply-To: <20230320151423.1708436-1-tvrtko.ursulin@linux.intel.com>
From:   Matthew Auld <matthew.william.auld@gmail.com>
Date:   Fri, 31 Mar 2023 07:25:11 +0100
Message-ID: <CAM0jSHMFF7VeRFMqRwfbvVtRdc6-6RXipe3nvLijrCtTNdKweQ@mail.gmail.com>
Subject: Re: [PATCH] drm/i915: Fix context runtime accounting
To:     Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Cc:     Intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        stable@vger.kernel.org, Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 20 Mar 2023 at 15:14, Tvrtko Ursulin
<tvrtko.ursulin@linux.intel.com> wrote:
>
> From: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
>
> When considering whether to mark one context as stopped and another as
> started we need to look at whether the previous and new _contexts_ are
> different and not just requests. Otherwise the software tracked context
> start time was incorrectly updated to the most recent lite-restore time-
> stamp, which was in some cases resulting in active time going backward,
> until the context switch (typically the hearbeat pulse) would synchronise
> with the hardware tracked context runtime. Easiest use case to observe
> this behaviour was with a full screen clients with close to 100% engine
> load.
>
> Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
> Fixes: bb6287cb1886 ("drm/i915: Track context current active time")
> Cc: <stable@vger.kernel.org> # v5.19+

Seems reasonable to me, fwiw,
Reviewed-by: Matthew Auld <matthew.auld@intel.com>

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5AE26DDD0E
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 15:59:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231181AbjDKN7R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 09:59:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231230AbjDKN7M (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 09:59:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 836B7558F
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 06:58:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D5DC603F6
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 13:58:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74347C4339B;
        Tue, 11 Apr 2023 13:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681221531;
        bh=VlU99sz9SvZzmGI5TVaf2oNvPIpli2wqNNxnDEWH2HI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ijxEK/Sz+xKxvlKMYMtMawafGDX13cbBuzgNetgCM5CpvfNviS7+Cgrj7N+01hPAv
         7FKbQBx4CnKMFdnvzQeYBxS/q57mY5sflhaErJoedURV0q8OjgLkyF5XcRxkJ6H4na
         HymVDUQZIUoSf/eJ59q4ywAbCaHray7KTMq//si0=
Date:   Tue, 11 Apr 2023 15:58:49 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ville Syrjala <ville.syrjala@linux.intel.com>
Cc:     stable@vger.kernel.org, Manasi Navare <navaremanasi@google.com>,
        Drew Davenport <ddavenport@chromium.org>,
        Imre Deak <imre.deak@intel.com>,
        Jouni =?iso-8859-1?Q?H=F6gander?= <jouni.hogander@intel.com>
Subject: Re: [PATCH 6.1.y 1/3] drm/i915: Split icl_color_commit_noarm() from
 skl_color_commit_noarm()
Message-ID: <2023041117-cannot-sensuous-6f62@gregkh>
References: <2023040313-periscope-celery-403f@gregkh>
 <20230403162618.18469-1-ville.syrjala@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230403162618.18469-1-ville.syrjala@linux.intel.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 03, 2023 at 07:26:16PM +0300, Ville Syrjala wrote:
> From: Ville Syrjälä <ville.syrjala@linux.intel.com>
> 
> We're going to want different behavior for skl/glk vs. icl
> in .color_commit_noarm(), so split the hook into two. Arguably
> we already had slightly different behaviour since
> csc_enable/gamma_enable are never set on icl+, so the old
> code was perhaps a bit confusing as well.
> 
> Cc: <stable@vger.kernel.org> #v5.19+
> Cc: <stable@vger.kernel.org> # 05ca98523481: drm/i915: Use _MMIO_PIPE() for SKL_BOTTOM_COLOR
> Cc: Manasi Navare <navaremanasi@google.com>
> Cc: Drew Davenport <ddavenport@chromium.org>
> Cc: Imre Deak <imre.deak@intel.com>
> Cc: Jouni Högander <jouni.hogander@intel.com>
> Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
> Link: https://patchwork.freedesktop.org/patch/msgid/20230320095438.17328-2-ville.syrjala@linux.intel.com
> Reviewed-by: Imre Deak <imre.deak@intel.com>
> (cherry picked from commit f161eb01f50ab31f2084975b43bce54b7b671e17)
> Signed-off-by: Jani Nikula <jani.nikula@intel.com>
> (cherry picked from commit 76b767d4d1cd052e455cf18e06929e8b2b70101d)
> ---
>  drivers/gpu/drm/i915/display/intel_color.c | 21 ++++++++++++++++++++-
>  1 file changed, 20 insertions(+), 1 deletion(-)

This commit breaks the build.

Always test-build the stuff you send out.  please.

Whole series dropped from my review queue.

greg k-h

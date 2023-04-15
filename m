Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A0856E2F63
	for <lists+stable@lfdr.de>; Sat, 15 Apr 2023 08:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbjDOGxF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Apr 2023 02:53:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjDOGxE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Apr 2023 02:53:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9F4D49F0
        for <stable@vger.kernel.org>; Fri, 14 Apr 2023 23:53:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 756936010F
        for <stable@vger.kernel.org>; Sat, 15 Apr 2023 06:53:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81601C433EF;
        Sat, 15 Apr 2023 06:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681541582;
        bh=iOCwPAuKuIapN1fDhHM4kxCKqrAybMOYK8DM/4A0FFA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ujvKNI8w9IsgBvVof4A6MQQYkz9m2czkIiK6wDjCMcCDKuRsXKzauSrPHs05xuCx9
         rK9JUcVVA8RQlpyJS2rwpg+31SZTIb8HOq1K+oCc+oRmcFRbOZW3+f71ktWKJ2QG13
         JmrH1bCwx1FNXIGCsGtWfbEL+So5Vl7xwjWISflM=
Date:   Sat, 15 Apr 2023 08:53:00 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ville Syrjala <ville.syrjala@linux.intel.com>
Cc:     stable@vger.kernel.org, Manasi Navare <navaremanasi@google.com>,
        Drew Davenport <ddavenport@chromium.org>,
        Imre Deak <imre.deak@intel.com>,
        Jouni =?iso-8859-1?Q?H=F6gander?= <jouni.hogander@intel.com>
Subject: Re: [PATCH 6.1.y 1/2] drm/i915: Add a .color_post_update() hook
Message-ID: <2023041519-margin-agenda-66b4@gregkh>
References: <2023041254-wok-shine-8aaf@gregkh>
 <20230414083140.24095-1-ville.syrjala@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230414083140.24095-1-ville.syrjala@linux.intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 14, 2023 at 11:31:39AM +0300, Ville Syrjala wrote:
> From: Ville Syrjälä <ville.syrjala@linux.intel.com>
> 
> We're going to need stuff after the color management
> register latching has happened. Add a corresponding hook.
> 
> Cc: <stable@vger.kernel.org> #v5.19+
> Cc: <stable@vger.kernel.org> # 52a90349f2ed: drm/i915: Introduce intel_crtc_needs_fastset()
> Cc: <stable@vger.kernel.org> # 925ac8bc33bf: drm/i915: Remove some local 'mode_changed' bools
> Cc: <stable@vger.kernel.org> # f5e674e92e95: drm/i915: Introduce intel_crtc_needs_color_update()
> Cc: <stable@vger.kernel.org> # 4c35e5d11900: drm/i915: Activate DRRS after state readout
> Cc: <stable@vger.kernel.org> # efb2b57edf20: drm/i915: Move the DSB setup/cleaup into the color code
> Cc: Manasi Navare <navaremanasi@google.com>
> Cc: Drew Davenport <ddavenport@chromium.org>
> Cc: Imre Deak <imre.deak@intel.com>
> Cc: Jouni Högander <jouni.hogander@intel.com>
> Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
> Link: https://patchwork.freedesktop.org/patch/msgid/20230320095438.17328-4-ville.syrjala@linux.intel.com
> Reviewed-by: Imre Deak <imre.deak@intel.com>
> (cherry picked from commit 3962ca4e080a525fc9eae87aa6b2286f1fae351d)
> Signed-off-by: Jani Nikula <jani.nikula@intel.com>
> (cherry picked from commit c880f855d1e240a956dcfce884269bad92fc849c)
> ---
> Picked up one more dependency to ease the backport.

Can you just send all of the needed patches, as a series, so that we can
apply them at once?

Adding to the "dependency list" doesn't help much for patch series sent
to us like this, sorry.

greg k-h

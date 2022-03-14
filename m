Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAC2A4D7E5D
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 10:22:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231821AbiCNJXQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 05:23:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231739AbiCNJXP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 05:23:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0A14433A1
        for <stable@vger.kernel.org>; Mon, 14 Mar 2022 02:22:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AEF1EB80D24
        for <stable@vger.kernel.org>; Mon, 14 Mar 2022 09:22:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE40BC340E9;
        Mon, 14 Mar 2022 09:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647249723;
        bh=pfoLDqBHFdzWMK4nnCNY9wP5g0/yqx/AyTQaT9pM0YE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yHqK94TxRQ5zjkmVkb513Gj/CHV3BM+UgnAGRqc/l6vz7pZeycD9xEDrQ92xTxdyj
         0Cga1xzXhDhXJ4GAlxK42mKobIsrZgIU6VrnPUX/xY7rQwYLkUJ0gVd/Gf+lyP+bI/
         mOqncDOxVTRRPx/tAfP1STVnYn8rhSBnEZUJphI4=
Date:   Mon, 14 Mar 2022 10:21:58 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ville Syrjala <ville.syrjala@linux.intel.com>
Cc:     stable@vger.kernel.org, tvrtko.ursulin@intel.com,
        Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>
Subject: Re: [PATCH stable-5.15] drm/i915: Workaround broken BIOS DBUF
 configuration on TGL/RKL
Message-ID: <Yi8JNtEenUwDiWD1@kroah.com>
References: <16464835403018@kroah.com>
 <20220307165607.32368-1-ville.syrjala@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220307165607.32368-1-ville.syrjala@linux.intel.com>
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 07, 2022 at 06:56:07PM +0200, Ville Syrjala wrote:
> From: Ville Syrjälä <ville.syrjala@linux.intel.com>
> 
> commit 4e6f55120c7eccf6f9323bb681632e23cbcb3f3c upstream.
> 
> On TGL/RKL the BIOS likes to use some kind of bogus DBUF layout
> that doesn't match what the spec recommends. With a single active
> pipe that is not going to be a problem, but with multiple pipes
> active skl_commit_modeset_enables() goes into an infinite loop
> since it can't figure out any order in which it can commit the
> pipes without causing DBUF overlaps between the planes.
> 
> We'd need some kind of extra DBUF defrag stage in between to
> make the transition possible. But that is clearly way too complex
> a solution, so in the name of simplicity let's just sanitize the
> DBUF state by simply turning off all planes when we detect a
> pipe encroaching on its neighbours' DBUF slices. We only have
> to disable the primary planes as all other planes should have
> already been disabled (if they somehow were enabled) by
> earlier sanitization steps.
> 
> And for good measure let's also sanitize in case the DBUF
> allocations of the pipes already seem to overlap each other.
> 
> Cc: <stable@vger.kernel.org> # v5.14+
> Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/4762
> Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
> Link: https://patchwork.freedesktop.org/patch/msgid/20220204141818.1900-3-ville.syrjala@linux.intel.com
> Reviewed-by: Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>
> (cherry picked from commit 15512021eb3975a8c2366e3883337e252bb0eee5)
> Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
> (cherry picked from commit 4e6f55120c7eccf6f9323bb681632e23cbcb3f3c)
> ---
> The chain of additional cherry-picks needed to get
> intel_plane_disable_noatomic() destaticed looked pretty
> hairy, so I just fixed it up manually.

Now queued up, thanks.

greg k-h

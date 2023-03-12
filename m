Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FAA26B6544
	for <lists+stable@lfdr.de>; Sun, 12 Mar 2023 12:13:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230169AbjCLLNN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Mar 2023 07:13:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbjCLLNK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Mar 2023 07:13:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E22F07AB4
        for <stable@vger.kernel.org>; Sun, 12 Mar 2023 04:13:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A3BF7B802C8
        for <stable@vger.kernel.org>; Sun, 12 Mar 2023 11:13:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE302C433EF;
        Sun, 12 Mar 2023 11:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678619586;
        bh=vn6T+dgSQAH/a44bo7vTOMijpLAntt2Er++HWdriilY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CVUiT9YvA6OLgYWq+IeBYCYkKV18SIEGT45/pYK0desV/tVza84J4oClTrS+Y+Ah4
         YXHZxx6ZFm8TdK+DTYlxiLKyso48fvnWG5FHuxx0whpChzLN5JQPzd7xolYLfRflh0
         WPSkWXPxxq1fnwV21/coP+i03ol2oufis2oFZyfc=
Date:   Sun, 12 Mar 2023 12:13:03 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Philip =?iso-8859-1?Q?M=FCller?= <philm@manjaro.org>
Cc:     John Harrison <John.C.Harrison@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        intel-gfx@lists.freedesktop.org, stable@vger.kernel.org
Subject: Re: Stable Patch Don't use BAR mappings for ring buffers with LLC
 might create some issues with 5.15
Message-ID: <ZA2zv2/bv7WT+qSE@kroah.com>
References: <d955327b-cb1c-4646-76b9-b0499c0c64c6@manjaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d955327b-cb1c-4646-76b9-b0499c0c64c6@manjaro.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Mar 12, 2023 at 04:41:32PM +0700, Philip Müller wrote:
> ||||||||||||||||||||
> 
> ||
> 
> Hi all,
> 
> seems there is a report open on the "drm/i915: Don't use BAR mappings for ring buffers with LLC" patch, which was included into 5.15.99 lately.
> 
> I saw this patch also on 6.1 and 6.2. Older LTS kernels I didn't found them yet, even it is tagged to be included from v4.9+ on. However I saw also the patch "drm/i915: Don't use stolen memory for ring buffers with LLC" applied when applied to other kernel series.
> 
> Reverting the patch according to this fixes it:https://gitlab.freedesktop.org/drm/intel/-/issues/8284
> 
> Maybe double-check what is actually needed if this creates issues on some Intel i915 hardware. Thx.

Also another report of this here:
	https://lore.kernel.org/r/NQJqG8n--3-9@tuta.io

I'll go revert this for now and do a new release.

thanks,

greg k-h

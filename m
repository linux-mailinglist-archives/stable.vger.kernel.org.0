Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 335266A0472
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 10:06:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230170AbjBWJGA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 04:06:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbjBWJGA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 04:06:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32A2E4ECC7
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 01:05:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8CD1D61620
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 09:05:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D16E4C433EF;
        Thu, 23 Feb 2023 09:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677143153;
        bh=IWXHMRO4sn5EruF5pBF/9dp8WHP28UREAV5LasBBs6U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=x9lvZAR/7c/w3Scas6d2wCCF2WEjPyoNRiQLmZOkaQpQUSAPOnk9wqy7IQOyD4fg/
         TFboS7rMNYtsyr0N0jnx6dHF35FQkKl6aaWJcmv969cKuWg3PuoAXmBj9aDBjnutDX
         MNfzPB4JS26kbMl05y7XKfzGmbfb8TyCsiGaoyTw=
Date:   Thu, 23 Feb 2023 10:05:50 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ovidiu Panait <ovidiu.panait@eng.windriver.com>
Cc:     stable@vger.kernel.org, Zheng Wang <zyytlz.wz@163.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>
Subject: Re: [PATCH 5.15/5.10/5.4/4.19 1/1] drm/i915/gvt: fix double free bug
 in split_2MB_gtt_entry
Message-ID: <Y/csbnn9m7zOLJhh@kroah.com>
References: <20230220133554.2736427-1-ovidiu.panait@eng.windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230220133554.2736427-1-ovidiu.panait@eng.windriver.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 20, 2023 at 03:35:54PM +0200, Ovidiu Panait wrote:
> From: Zheng Wang <zyytlz.wz@163.com>
> 
> commit 4a61648af68f5ba4884f0e3b494ee1cabc4b6620 upstream.
> 
> If intel_gvt_dma_map_guest_page failed, it will call
> ppgtt_invalidate_spt, which will finally free the spt.
> But the caller function ppgtt_populate_spt_by_guest_entry
> does not notice that, it will free spt again in its error
> path.
> 
> Fix this by canceling the mapping of DMA address and freeing sub_spt.
> Besides, leave the handle of spt destroy to caller function instead
> of callee function when error occurs.
> 
> Fixes: b901b252b6cf ("drm/i915/gvt: Add 2M huge gtt support")
> Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
> Reviewed-by: Zhenyu Wang <zhenyuw@linux.intel.com>
> Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
> Link: http://patchwork.freedesktop.org/patch/msgid/20221229165641.1192455-1-zyytlz.wz@163.com
> Signed-off-by: Ovidiu Panait <ovidiu.panait@eng.windriver.com>
> ---
> Backport of CVE-2022-3707 fix.

Note, I think this is a bogus CVE, but whatever, you do you...

Now queued up, thanks.

greg k-h

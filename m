Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1255F64308E
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 19:39:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232600AbiLESjm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 13:39:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232720AbiLESjZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 13:39:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EE531055D
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 10:33:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 46492B80E6F
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 18:33:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 959F7C433D6;
        Mon,  5 Dec 2022 18:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670265188;
        bh=O8EQaQbIRcLPtA6QBTN2joU4tkP2c5UoYkJgGuM9v50=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nojFdnvqbi0p0usO2Xk2Zw6Njf1z6Wn0RoJlATCmmhYh6iFegXB8UWkQqMATspR4F
         zb2BC6of8KXEHtkQd2k9eBlxrskFPYLY6BdnHFKsPmhzNjqHyZyg2TIHhMIRFYbzPt
         VbH41pIULWe+Fg+TwAF6Vi0WOXhoEnkOKUjT5SdA=
Date:   Mon, 5 Dec 2022 19:33:06 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Cc:     stable@vger.kernel.org, vkoul@kernel.org,
        Sjoerd Simons <sjoerd@collabora.com>,
        Chao Song <chao.song@intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>
Subject: Re: [PATCH] soundwire: intel: Initialize clock stop timeout
Message-ID: <Y445YurEQGO0tQqJ@kroah.com>
References: <20221205170600.15002-1-pierre-louis.bossart@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221205170600.15002-1-pierre-louis.bossart@linux.intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 05, 2022 at 11:06:00AM -0600, Pierre-Louis Bossart wrote:
> From: Sjoerd Simons <sjoerd@collabora.com>
> 
> commit 13c30a755847c7e804e1bf755e66e3ff7b7f9367 upstream
> 
> The bus->clk_stop_timeout member is only initialized to a non-zero value
> during the codec driver probe. This can lead to corner cases where this
> value remains pegged at zero when the bus suspends, which results in an
> endless loop in sdw_bus_wait_for_clk_prep_deprep().
> 
> Corner cases include configurations with no codecs described in the
> firmware, or delays in probing codec drivers.
> 
> Initializing the default timeout to the smallest non-zero value avoid this
> problem and allows for the existing logic to be preserved: the
> bus->clk_stop_timeout is set as the maximum required by all codecs
> connected on the bus.
> 
> Fixes: 1f2dcf3a154ac ("soundwire: intel: set dev_num_ida_min")

This commit is is only in 6.1-rc1, so why does it need to go to any
older kernels?  Is this tag not correct?

thanks,

greg k-h

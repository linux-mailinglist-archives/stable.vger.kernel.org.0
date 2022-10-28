Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 571EA610FAD
	for <lists+stable@lfdr.de>; Fri, 28 Oct 2022 13:28:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbiJ1L2t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Oct 2022 07:28:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230174AbiJ1L2s (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Oct 2022 07:28:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBD4D1D1A98;
        Fri, 28 Oct 2022 04:28:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5837D627CA;
        Fri, 28 Oct 2022 11:28:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4634C433D7;
        Fri, 28 Oct 2022 11:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666956525;
        bh=6BWpUv9YCNj+rw9Dlvx3piMeifPJz53Dnij8qkSg5v8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cAMIzphTh+Jnm7MsF4ShxjCOdti21q5Lh6Z9/Uuxl4axmgTCFYDSr6DYAZ22FD79F
         +pEiPvY1pOO91TE0QWZGF2MdzNqR3S2XNgbuE64kIHr6HGJOknd2wYAvyWBNqWMNAz
         kgEOsdnrzCmVt37krEjXHjcmSftitEOPGw+XM09TwzzaOSFTh5SrKQNeREDAfJR0YR
         uikHdncfVImqocju8sXkJZ55aF+elIcEQCYU1bmiBzHUED5Qiu4ffyw5fAU6CGnFnU
         EhBafEvOxiVF105+31Cm5A3wld4rBo8KDU0aI39ei2/FYMT2lRv3/dsvPhRFM+6PE5
         rhq5appBMy1RA==
Date:   Fri, 28 Oct 2022 16:58:39 +0530
From:   Vinod Koul <vkoul@kernel.org>
To:     Bard Liao <yung-chuan.liao@linux.intel.com>
Cc:     alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        pierre-louis.bossart@linux.intel.com, bard.liao@intel.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] soundwire: intel: Initialize clock stop timeout
Message-ID: <Y1u855YZ/B3Q+FiI@matsya>
References: <20221020015624.1703950-1-yung-chuan.liao@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221020015624.1703950-1-yung-chuan.liao@linux.intel.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 20-10-22, 09:56, Bard Liao wrote:
> From: Sjoerd Simons <sjoerd@collabora.com>
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

Applied to fixes, thanks

-- 
~Vinod

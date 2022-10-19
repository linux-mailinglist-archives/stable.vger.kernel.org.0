Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35161604527
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 14:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233052AbiJSMWz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 08:22:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232108AbiJSMWm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 08:22:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7E891C5A68;
        Wed, 19 Oct 2022 04:57:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 44BA5B823AE;
        Wed, 19 Oct 2022 09:19:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F05A9C433C1;
        Wed, 19 Oct 2022 09:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666171172;
        bh=vWXcM3OIICH25cHPoU2uv46Vrp8M01gJ70s0hn1R9+o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uzbNN4+erPsU4dHda7XmpSyeltkYFA4ZahpNFpfiDK5jgxLySjvg+2SIhLjWhtoh9
         pCsAHnsSBQ/8oRrBrbhHr3yw9FJyC7qbWYQovPUlNbp1WPfN6ku9rAOX4Ase4Dfh5+
         3UWyIr4yrJqpQgOJNcnG/EnSfoiVyaNoV1Kz2NcGyoBB4F4x/r3nDI/CMU9GdigOnS
         lf7dHWoofjzLy8P7LX78wVBdZweX6sjYsT41PiHUTQgcwc23sPahlmH1B8bnw65F/x
         rmRutB7z5A15n3dHr/T7EhH/zsJajZxzWWcJe5avU05RHe2Hv9bmuGO4DxStN1rNLk
         BiECoiocZztJA==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1ol5EO-000596-AX; Wed, 19 Oct 2022 11:19:20 +0200
Date:   Wed, 19 Oct 2022 11:19:20 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Johan Hovold <johan+linaro@kernel.org>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.0 528/862] phy: qcom-qmp-usb: fix memleak on probe
 deferral
Message-ID: <Y0/BGJlX7CYylMR+@hovoldconsulting.com>
References: <20221019083249.951566199@linuxfoundation.org>
 <20221019083313.304749902@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221019083313.304749902@linuxfoundation.org>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 19, 2022 at 10:30:15AM +0200, Greg Kroah-Hartman wrote:
> From: Johan Hovold <johan+linaro@kernel.org>
> 
> [ Upstream commit a5d6b1ac56cbd6b5850a3a54e35f1cb71e8e8cdd ]
> 
> Switch to using the device-managed of_iomap helper to avoid leaking
> memory on probe deferral and driver unbind.
> 
> Note that this helper checks for already reserved regions and may fail
> if there are multiple devices claiming the same memory.

Again, because of the above, this should not be backported. Please drop.
 
> Two bindings currently rely on overlapping mappings for the PCS region
> so fallback to non-exclusive mappings for those for now.
> 
> Fixes: e78f3d15e115 ("phy: qcom-qmp: new qmp phy driver for qcom-chipsets")
> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
> Link: https://lore.kernel.org/r/20220916102340.11520-7-johan+linaro@kernel.org
> Signed-off-by: Vinod Koul <vkoul@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Johan

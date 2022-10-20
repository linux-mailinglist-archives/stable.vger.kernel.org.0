Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33EB6605674
	for <lists+stable@lfdr.de>; Thu, 20 Oct 2022 06:48:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbiJTEs2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Oct 2022 00:48:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbiJTEs0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Oct 2022 00:48:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4FF71B6C8D;
        Wed, 19 Oct 2022 21:48:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6178D619FC;
        Thu, 20 Oct 2022 04:48:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AFFCC433D6;
        Thu, 20 Oct 2022 04:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666241304;
        bh=yHjM7sdsctYMfU1Z/rjrmi77RVaXah2T8Djn1lp/JJ8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lcdOydVv2xqbmYt3ApeKUq6FQ/Ar3ORNKykwMDoWgYe3eKT+Nddra6SlB2dshXfaK
         SkH+QUUAJDS5uHycN1XGYEpzkSxU8V3YXn/ya/ML6RvYOw10ZMPpesWtzYP96hjYk8
         gW7fWPetZw3qVhmsLQQsGxlRE3X1lg3nnDDK/KJd2ntpYBm9Ch/SaIPkXEDafDYq3o
         ooZqTuUFbO3849gwE3n+7ae5OlBRAylMHhfrb7NEFe5zJeWlDyY7UE40LKdch1CLvH
         MbmQ+97OyCLQ1QuFX6pgqr7ko1Tx1QFJ+GWoY5s84ElUhBilajEf7PPGa1Ts4iD74k
         Ihr6GGVmLROVA==
Date:   Wed, 19 Oct 2022 21:48:22 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Hamza Mahfooz <hamza.mahfooz@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@linux.ie,
        daniel@ffwll.ch, guchun.chen@amd.com, aurabindo.pillai@amd.com,
        evan.quan@amd.com, seanpaul@chromium.org, contact@emersion.fr,
        greenfoo@u92.eu, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH AUTOSEL 5.19 07/16] drm/amdgpu: use dirty framebuffer
 helper
Message-ID: <Y1DTFiP12ws04eOM@sol.localdomain>
References: <20220921155332.234913-1-sashal@kernel.org>
 <20220921155332.234913-7-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220921155332.234913-7-sashal@kernel.org>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 21, 2022 at 11:53:23AM -0400, Sasha Levin wrote:
> From: Hamza Mahfooz <hamza.mahfooz@amd.com>
> 
> [ Upstream commit 66f99628eb24409cb8feb5061f78283c8b65f820 ]
> 
> Currently, we aren't handling DRM_IOCTL_MODE_DIRTYFB. So, use
> drm_atomic_helper_dirtyfb() as the dirty callback in the amdgpu_fb_funcs
> struct.
> 
> Signed-off-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
> Acked-by: Alex Deucher <alexander.deucher@amd.com>
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

I just spent a long time bisecting a hard-to-reproduce regression to this
commit, only to find that a revert was just queued this week.

Why was this commit backported to stable in the first place?  It didn't have Cc
stable, and it didn't claim to be fixing anything.

- Eric

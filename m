Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61BDB6C89B3
	for <lists+stable@lfdr.de>; Sat, 25 Mar 2023 01:44:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231786AbjCYAoB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Mar 2023 20:44:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjCYAoA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Mar 2023 20:44:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F4E812B
        for <stable@vger.kernel.org>; Fri, 24 Mar 2023 17:43:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0AE5562CBE
        for <stable@vger.kernel.org>; Sat, 25 Mar 2023 00:43:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ABFDC4339B;
        Sat, 25 Mar 2023 00:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679705038;
        bh=ihBZF/k16R/76bFJyJVD9mgzyhOUdAU1Qu40u0IqigI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OugUOpHKvRFNAeW7b7paZUL+Kl7DmS4Gjjttov5/7nfATO2MkpQcgPEdGjgoX77Ct
         /KZBKxGiuU/kJlZ/5274AWDwAvkG0p7gEfcMQnvUCMaC/tDdCFDcjVF/sVCee2d3Xy
         gHNWOLZBhglLlHG8AHKtYmjfBvyrnL1/CFYuQaOXMtQXKR7Hd5TyJeOIV8s7pevaVC
         YzeTLjggq6/doDug+SIMkfYJstwSlAZjJzv8MocvAvFQ1E0w4x1gENT+8hnXgj7QkM
         8fvFgxDmikRtww8wRHMzCbH/YXdQb5R+c+7JBOkfx9HPUWa0omEWxEe20AX1fU9SG0
         vi2TViwfGaNMw==
Date:   Fri, 24 Mar 2023 20:43:57 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Mario Limonciello <mario.limonciello@amd.com>
Cc:     stable@vger.kernel.org, Cruise Hung <Cruise.Hung@amd.com>,
        Wenjing Liu <Wenjing.Liu@amd.com>,
        Qingqing Zhuo <qingqing.zhuo@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: Re: [PATCH 6.2.y/6.1.y 1/1] drm/amd/display: Fix DP MST sinks
 removal issue
Message-ID: <ZB5DzbW6Kz3Sx7W4@sashalap>
References: <20230322220841.898-1-mario.limonciello@amd.com>
 <20230322220841.898-2-mario.limonciello@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230322220841.898-2-mario.limonciello@amd.com>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 22, 2023 at 05:08:41PM -0500, Mario Limonciello wrote:
>From: Cruise Hung <Cruise.Hung@amd.com>
>
>[Why]
>In USB4 DP tunneling, it's possible to have this scenario that
>the path becomes unavailable and CM tears down the path a little bit late.
>So, in this case, the HPD is high but fails to read any DPCD register.
>That causes the link connection type to be set to sst.
>And not all sinks are removed behind the MST branch.
>
>[How]
>Restore the link connection type if it fails to read DPCD register.
>
>Cc: stable@vger.kernel.org
>Cc: Mario Limonciello <mario.limonciello@amd.com>
>Reviewed-by: Wenjing Liu <Wenjing.Liu@amd.com>
>Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
>Signed-off-by: Cruise Hung <Cruise.Hung@amd.com>
>Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
>Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
>(cherry picked from commit cbd6c1b17d3b42b7935526a86ad5f66838767d03)
>Modified for stable backport as a lot of the code in this file was moved
>in 6.3 to drivers/gpu/drm/amd/display/dc/link/link_detection.c.
>Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>

Queued up, thanks!

-- 
Thanks,
Sasha

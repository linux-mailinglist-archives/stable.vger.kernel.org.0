Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A28E06986E9
	for <lists+stable@lfdr.de>; Wed, 15 Feb 2023 22:04:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230250AbjBOVEB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Feb 2023 16:04:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230244AbjBOVDa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Feb 2023 16:03:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A6F64740A;
        Wed, 15 Feb 2023 13:01:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0060461D72;
        Wed, 15 Feb 2023 21:01:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B77AC433EF;
        Wed, 15 Feb 2023 21:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676494911;
        bh=M6ZOoCl7jWICTgzLwXh9t/Dp/gETGHVOG4bryHSv4Sc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YWx3Z+N5LfxCD8fkfuIiM2xyRDjRLpTj4HKEHXJjoyzoe+qNYwqItdJphEBZhZEFL
         798v4Fg+KQyyKQ2E5wcIJZy9iEbUc2lpAUUBqzspgioaD3/mFsrtnx84ZhGTOJC25J
         uIKc5diPd40XXQZJOOMhhQtMJPaoQyCapFW0OI3BOCHlGLeAr9oGVbzmnSW22RuecA
         TtQY6d7JwYY8IqOaN1oX4dx5tEN+Sn/aw1LSIaFcQ8bAOdgQEn7Xt/vNjtLayq6r7Z
         xGYFKZXCmWIlJ3wEKvMdwQoQnGONrF/3QOs1Y2wrQolFCIlwkgajNTN4G/1BmRDtap
         CbUC0AbIbLhlg==
Date:   Wed, 15 Feb 2023 16:01:50 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Alex Deucher <alexdeucher@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        yifan1.zhang@amd.com, stylon.wang@amd.com, sunpeng.li@amd.com,
        airlied@gmail.com, Xinhui.Pan@amd.com, Rodrigo.Siqueira@amd.com,
        roman.li@amd.com, amd-gfx@lists.freedesktop.org, Jerry.Zuo@amd.com,
        aurabindo.pillai@amd.com, dri-devel@lists.freedesktop.org,
        daniel@ffwll.ch, Alex Deucher <alexander.deucher@amd.com>,
        harry.wentland@amd.com, christian.koenig@amd.com
Subject: Re: [PATCH AUTOSEL 6.1 24/24] drm/amd/display: disable S/G display
 on DCN 3.1.2/3
Message-ID: <Y+1IPsPAJNKRA8IA@sashalap>
References: <20230215204547.2760761-1-sashal@kernel.org>
 <20230215204547.2760761-24-sashal@kernel.org>
 <CADnq5_PEGUSTFAzPOQtJFpsBqWQMaox=E1AxE+-h3_FxSbHNzg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CADnq5_PEGUSTFAzPOQtJFpsBqWQMaox=E1AxE+-h3_FxSbHNzg@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 15, 2023 at 03:55:07PM -0500, Alex Deucher wrote:
>On Wed, Feb 15, 2023 at 3:46 PM Sasha Levin <sashal@kernel.org> wrote:
>>
>> From: Alex Deucher <alexander.deucher@amd.com>
>>
>> [ Upstream commit 077e9659581acab70f2dcc04b5bc799aca3a056b ]
>>
>> Causes flickering or white screens in some configurations.
>> Disable it for now until we can fix the issue.
>>
>> Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/2352
>> Cc: roman.li@amd.com
>> Cc: yifan1.zhang@amd.com
>> Reviewed-by: Yifan Zhang <yifan1.zhang@amd.com>
>> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>This was reverted upstream and should be dropped.

Ack, I'll drop it. Thanks!

-- 
Thanks,
Sasha

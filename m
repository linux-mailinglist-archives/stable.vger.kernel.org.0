Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC2FF637DB9
	for <lists+stable@lfdr.de>; Thu, 24 Nov 2022 17:51:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229448AbiKXQvB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Nov 2022 11:51:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiKXQvA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Nov 2022 11:51:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F7E5114B88;
        Thu, 24 Nov 2022 08:50:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DBFBB621AA;
        Thu, 24 Nov 2022 16:50:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17275C433D6;
        Thu, 24 Nov 2022 16:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669308658;
        bh=LqTeO6gNFJ8QzpGc7p1Ojhk4LXQvlTeE1H7lbaBY37I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=R6PpUCqscN7vv03f6DE3nnqQRkJ5f7xJXkmEn1/A6TX2DB2jIzeVWC2nrmvuWnfd7
         v7d/Yxm+73wnzbXxeL7wmPULHybcYkWnkKeSihr0wl0qqWQayeDcQXX5Plsk4JlVZf
         pC9MmgxljQ0mbjIMW/uvP7uVvf7+a34eFOaarpWpQzFfsIMl36agB7P2ytbY6xMWbX
         PRvmi2dKf/gZHmT9aBf0lfpKaGEHkN9PsIlityYeq4SMlFJ2DicV58Du5BA7g1Xyjw
         GDbE4j4Rn+s6BbSg5oY3azaJ3+UEGiSGasyggnfi1XzZW20JeuTUQy4bJydpxw86Jv
         AbI0OjCWy4hvg==
Date:   Thu, 24 Nov 2022 11:50:56 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Cc:     Michel =?iso-8859-1?Q?D=E4nzer?= <michel.daenzer@mailbox.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Philip Yang <Philip.Yang@amd.com>, Xinhui.Pan@amd.com,
        amd-gfx@lists.freedesktop.org, luben.tuikov@amd.com,
        dri-devel@lists.freedesktop.org, daniel@ffwll.ch,
        Alex Deucher <alexander.deucher@amd.com>, airlied@gmail.com
Subject: Re: [PATCH AUTOSEL 6.0 38/44] drm/amdgpu: Unlock bo_list_mutex after
 error handling
Message-ID: <Y3+g8KpFuNG/SqaR@sashalap>
References: <20221119021124.1773699-1-sashal@kernel.org>
 <20221119021124.1773699-38-sashal@kernel.org>
 <e08c0d60-45d1-85a6-9c55-38c8e87b56c3@mailbox.org>
 <0916abd9-265d-e4ed-819b-9dfa05e8d746@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0916abd9-265d-e4ed-819b-9dfa05e8d746@amd.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 21, 2022 at 12:07:40PM +0100, Christian König wrote:
>Am 21.11.22 um 10:57 schrieb Michel Dänzer:
>>On 11/19/22 03:11, Sasha Levin wrote:
>>>From: Philip Yang <Philip.Yang@amd.com>
>>>
>>>[ Upstream commit 64f65135c41a75f933d3bca236417ad8e9eb75de ]
>>>
>>>Get below kernel WARNING backtrace when pressing ctrl-C to kill kfdtest
>>>application.
>>>
>>>If amdgpu_cs_parser_bos returns error after taking bo_list_mutex, as
>>>caller amdgpu_cs_ioctl will not unlock bo_list_mutex, this generates the
>>>kernel WARNING.
>>>
>>>Add unlock bo_list_mutex after amdgpu_cs_parser_bos error handling to
>>>cleanup bo_list userptr bo.
>>>
>>>  WARNING: kfdtest/2930 still has locks held!
>>>  1 lock held by kfdtest/2930:
>>>   (&list->bo_list_mutex){+.+.}-{3:3}, at: amdgpu_cs_ioctl+0xce5/0x1f10 [amdgpu]
>>>   stack backtrace:
>>>    dump_stack_lvl+0x44/0x57
>>>    get_signal+0x79f/0xd00
>>>    arch_do_signal_or_restart+0x36/0x7b0
>>>    exit_to_user_mode_prepare+0xfd/0x1b0
>>>    syscall_exit_to_user_mode+0x19/0x40
>>>    do_syscall_64+0x40/0x80
>>>
>>>Signed-off-by: Philip Yang <Philip.Yang@amd.com>
>>>Reviewed-by: Christian König <christian.koenig@amd.com>
>>>Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
>>>Signed-off-by: Sasha Levin <sashal@kernel.org>
>>>---
>>>  drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c | 1 +
>>>  1 file changed, 1 insertion(+)
>>>
>>>diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
>>>index b7bae833c804..9d59f83c8faa 100644
>>>--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
>>>+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
>>>@@ -655,6 +655,7 @@ static int amdgpu_cs_parser_bos(struct amdgpu_cs_parser *p,
>>>  		}
>>>  		mutex_unlock(&p->bo_list->bo_list_mutex);
>>>  	}
>>>+	mutex_unlock(&p->bo_list->bo_list_mutex);
>>>  	return r;
>>>  }
>>Looks doubtful that this is a correct backport — there's an identical mutex_unlock call just above.
>
>
>Oh, yes good point. This patch doesn't needs to be backported at all 
>because it just fixes a problem introduced in the same cycle:

Dropping it, thanks!

-- 
Thanks,
Sasha

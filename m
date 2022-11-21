Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6D21631D90
	for <lists+stable@lfdr.de>; Mon, 21 Nov 2022 10:58:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231200AbiKUJ6N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Nov 2022 04:58:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231240AbiKUJ6H (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Nov 2022 04:58:07 -0500
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [IPv6:2001:67c:2050:0:465::101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E21D2CE1D;
        Mon, 21 Nov 2022 01:58:01 -0800 (PST)
Received: from smtp102.mailbox.org (smtp102.mailbox.org [IPv6:2001:67c:2050:b231:465::102])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4NG2rK4SWLz9sTV;
        Mon, 21 Nov 2022 10:57:53 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
        t=1669024673;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iKWoYQiC0VAkiUCGzxBqoBdAdK+x56nxwPF3bP38f5U=;
        b=oNEvH4skY4TBp/Ebbs17fzLDKLt1MO3gpxbnmrfFp/zJjTgU4pjE7N3OiqekH5FeIqyj14
        Vibdkb7NEiCkA0c8x/bAEq61vtdDZjV5fBgPHwwB0/53H4ssd4oM1NDsDM7627fRISwR08
        QQhKSCJaD2rLD5ZBlplgNtABFnAHvKT+LzWfmKLa5UDIk45bk7BVdUtqdQLSZRGhWrbKMx
        UkSreraXxBo7Yee9MP52QLJcvR0kxljqM0aGHasWFZUwRlqChBTSWJiHrepV1Vf+s9lMQM
        b6+GdB5MumediOvZHBudK+QTJpn1zlLGMg2SjK3gHQ/EW56BazjA2UxiMMYdFw==
Message-ID: <e08c0d60-45d1-85a6-9c55-38c8e87b56c3@mailbox.org>
Date:   Mon, 21 Nov 2022 10:57:51 +0100
MIME-Version: 1.0
Subject: Re: [PATCH AUTOSEL 6.0 38/44] drm/amdgpu: Unlock bo_list_mutex after
 error handling
Content-Language: en-CA
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Philip Yang <Philip.Yang@amd.com>, Xinhui.Pan@amd.com,
        amd-gfx@lists.freedesktop.org, luben.tuikov@amd.com,
        dri-devel@lists.freedesktop.org, daniel@ffwll.ch,
        Alex Deucher <alexander.deucher@amd.com>, airlied@gmail.com,
        =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
References: <20221119021124.1773699-1-sashal@kernel.org>
 <20221119021124.1773699-38-sashal@kernel.org>
From:   =?UTF-8?Q?Michel_D=c3=a4nzer?= <michel.daenzer@mailbox.org>
In-Reply-To: <20221119021124.1773699-38-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-MBO-RS-META: f8ftg7acuaueygqxyku7kzfg6jpuxt7h
X-MBO-RS-ID: ffdceb14de5baed1f1c
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/19/22 03:11, Sasha Levin wrote:
> From: Philip Yang <Philip.Yang@amd.com>
> 
> [ Upstream commit 64f65135c41a75f933d3bca236417ad8e9eb75de ]
> 
> Get below kernel WARNING backtrace when pressing ctrl-C to kill kfdtest
> application.
> 
> If amdgpu_cs_parser_bos returns error after taking bo_list_mutex, as
> caller amdgpu_cs_ioctl will not unlock bo_list_mutex, this generates the
> kernel WARNING.
> 
> Add unlock bo_list_mutex after amdgpu_cs_parser_bos error handling to
> cleanup bo_list userptr bo.
> 
>  WARNING: kfdtest/2930 still has locks held!
>  1 lock held by kfdtest/2930:
>   (&list->bo_list_mutex){+.+.}-{3:3}, at: amdgpu_cs_ioctl+0xce5/0x1f10 [amdgpu]
>   stack backtrace:
>    dump_stack_lvl+0x44/0x57
>    get_signal+0x79f/0xd00
>    arch_do_signal_or_restart+0x36/0x7b0
>    exit_to_user_mode_prepare+0xfd/0x1b0
>    syscall_exit_to_user_mode+0x19/0x40
>    do_syscall_64+0x40/0x80
> 
> Signed-off-by: Philip Yang <Philip.Yang@amd.com>
> Reviewed-by: Christian König <christian.koenig@amd.com>
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
> index b7bae833c804..9d59f83c8faa 100644
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
> @@ -655,6 +655,7 @@ static int amdgpu_cs_parser_bos(struct amdgpu_cs_parser *p,
>  		}
>  		mutex_unlock(&p->bo_list->bo_list_mutex);
>  	}
> +	mutex_unlock(&p->bo_list->bo_list_mutex);
>  	return r;
>  }
>  

Looks doubtful that this is a correct backport — there's an identical mutex_unlock call just above.


-- 
Earthling Michel Dänzer            |                  https://redhat.com
Libre software enthusiast          |         Mesa and Xwayland developer


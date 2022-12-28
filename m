Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB3416584DC
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 18:03:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234356AbiL1RD0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 12:03:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234391AbiL1RDG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 12:03:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2AC31E3F6
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:57:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5FA9561558
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:57:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AED1AC433F0;
        Wed, 28 Dec 2022 16:57:04 +0000 (UTC)
Message-ID: <c7446d24-746d-9271-3535-2fdd576b06f0@xs4all.nl>
Date:   Wed, 28 Dec 2022 17:57:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH 6.0 0847/1073] media: v4l2-ctrls-api.c: add back dropped
 ctrl->is_new = 1
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, Alice Yuan <alice.yuan@nxp.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
References: <20221228144328.162723588@linuxfoundation.org>
 <20221228144351.026655624@linuxfoundation.org>
Content-Language: en-US
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
In-Reply-To: <20221228144351.026655624@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 28/12/2022 15:40, Greg Kroah-Hartman wrote:
> From: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> 
> [ Upstream commit 73278d483378cf850ade923a1107a70297b2602a ]
> 
> The patch adding support for dynamically allocated arrays accidentally
> dropped the line setting ctrl->is_new to 1, thus new string values were
> always ignored.
> 
> Fixes: fb582cba4492 ("media: v4l2-ctrls: add support for dynamically allocated arrays.")
> Reported-by: Alice Yuan <alice.yuan@nxp.com>
> Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/media/v4l2-core/v4l2-ctrls-api.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-ctrls-api.c b/drivers/media/v4l2-core/v4l2-ctrls-api.c
> index 50d012ba3c02..7781ebd7ee95 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls-api.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls-api.c
> @@ -155,6 +155,7 @@ static int user_to_new(struct v4l2_ext_control *c, struct v4l2_ctrl *ctrl)
>  			 * then return an error.
>  			 */
>  			if (strlen(ctrl->p_new.p_char) == ctrl->maximum && last)
> +			ctrl->is_new = 1;
>  				return -ERANGE;

This is obviously wrong.

Something got messed up in mainline where my original patch:

https://git.linuxtv.org/hverkuil/media_tree.git/commit/?h=for-v6.1a&id=c33692033135acc96dfdd00dca6e8a392c545b0a

got mangled to the version you have here.

I guess I'll have to post a new patch for mainline fixing the mangled fix.

I only now noticed that you posted the backport patch for review on Dec 25th :-(

Oh well, string control support was broken, and is now even more broken.

Regards,

	Hans

>  		}
>  		return ret;


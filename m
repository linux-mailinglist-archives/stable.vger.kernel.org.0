Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02F8D66ABCE
	for <lists+stable@lfdr.de>; Sat, 14 Jan 2023 14:51:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230149AbjANNvJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Jan 2023 08:51:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230002AbjANNvF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Jan 2023 08:51:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8DDF6EB8
        for <stable@vger.kernel.org>; Sat, 14 Jan 2023 05:51:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8394CB8075A
        for <stable@vger.kernel.org>; Sat, 14 Jan 2023 13:51:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96791C433EF;
        Sat, 14 Jan 2023 13:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673704262;
        bh=rKTwYVpDoGt0vB0ty0KKH1wORHxgymzWoQtMXWzlPso=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vye9dTdkbOrNjojcQvwGwqqbm+FgcgMRJV+Pe7tyvS350lFOQz7aPijQwseoi1y66
         ooXd1PK8eVC6jOwI1kDOakaS/fOKn/1CIq6chLLuJ+hy43UxY3QaMyuEEviToitSUm
         RiIxtAX5khFMpHfQ3MYJjEiuEw04fK33e33UfOxw=
Date:   Sat, 14 Jan 2023 14:50:59 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alex Deucher <alexander.deucher@amd.com>
Cc:     stable@vger.kernel.org, Ao Zhong <hacc1225@gmail.com>,
        daniel@octaforge.org, Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Subject: Re: [PATCH] drm/amd/display: move remaining FPU code to dml folder
Message-ID: <Y8KzQ90TcjY1Th4L@kroah.com>
References: <20230112202444.2008744-1-alexander.deucher@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230112202444.2008744-1-alexander.deucher@amd.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 12, 2023 at 03:24:44PM -0500, Alex Deucher wrote:
> From: Ao Zhong <hacc1225@gmail.com>
> 
> pipes[pipe_cnt].pipe.src.dcc_fraction_of_zs_req_luma = 0;
> pipes[pipe_cnt].pipe.src.dcc_fraction_of_zs_req_chroma = 0;
> these two operations in dcn32/dcn32_resource.c still need to use FPU,
> This will cause compilation to fail on ARM64 platforms because
> -mgeneral-regs-only is enabled by default to disable the hardware FPU.
> Therefore, imitate the dcn31_zero_pipe_dcc_fraction function in
> dml/dcn31/dcn31_fpu.c, declare the dcn32_zero_pipe_dcc_fraction function
> in dcn32_fpu.c, and move above two operations into this function.
> 
> Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/2288
> Cc: daniel@octaforge.org
> Reviewed-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
> Signed-off-by: Ao Zhong <hacc1225@gmail.com>
> Signed-off-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> (cherry picked from commit 58ddbecb14c792b7fe0d92ae5e25c9179d62ff25)
> Cc: stable@vger.kernel.org # 6.1.x
> ---
>  drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c | 5 +++--
>  drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c  | 8 ++++++++
>  drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.h  | 3 +++
>  3 files changed, 14 insertions(+), 2 deletions(-)

Now queued up, thanks.

greg k-h

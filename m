Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03C6460F4E5
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 12:25:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235414AbiJ0KZm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 06:25:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235254AbiJ0KZ3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 06:25:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63F9E33436
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 03:25:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0FB3F6227C
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 10:25:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E693EC433D6;
        Thu, 27 Oct 2022 10:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666866325;
        bh=RqV/iaZIMIpM99T7JianjPgXGIa9f+LuyszBt2xWVQ8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=u2EHQEEc4tllYVvVRZbgqt58i1WvtvQ3TuG89Zwz30vcFo+OnjWSLuSgyNn2V2rQ1
         BpEcAjpQ7/kt7yA749mwpnrLyDhkIotowF/2Bo6PCl0MBijz5SmOnxWx4aZjnVEoVL
         8DL45oOa/0YsNjtyLWrkIDDidgKAL1RjDhqiN40U=
Date:   Thu, 27 Oct 2022 12:25:20 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ovidiu Panait <ovidiu.panait@windriver.com>
Cc:     stable@vger.kernel.org, Chen-Yu Tsai <wenst@chromium.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: Re: [PATCH 4.14 1/1] media: v4l2-mem2mem: Apply DST_QUEUE_OFF_BASE
 on MMAP buffers across ioctls
Message-ID: <Y1pckHsJk+mJM773@kroah.com>
References: <20221025144102.226693-1-ovidiu.panait@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221025144102.226693-1-ovidiu.panait@windriver.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 25, 2022 at 05:41:02PM +0300, Ovidiu Panait wrote:
> From: Chen-Yu Tsai <wenst@chromium.org>
> 
> commit 8310ca94075e784bbb06593cd6c068ee6b6e4ca6 upstream.
> 
> DST_QUEUE_OFF_BASE is applied to offset/mem_offset on MMAP capture buffers
> only for the VIDIOC_QUERYBUF ioctl, while the userspace fields (including
> offset/mem_offset) are filled in for VIDIOC_{QUERY,PREPARE,Q,DQ}BUF
> ioctls. This leads to differences in the values presented to userspace.
> If userspace attempts to mmap the capture buffer directly using values
> from DQBUF, it will fail.
> 
> Move the code that applies the magic offset into a helper, and call
> that helper from all four ioctl entry points.
> 
> [hverkuil: drop unnecessary '= 0' in v4l2_m2m_querybuf() for ret]
> 
> Fixes: 7f98639def42 ("V4L/DVB: add memory-to-memory device helper framework for videobuf")
> Fixes: 908a0d7c588e ("[media] v4l: mem2mem: port to videobuf2")
> Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
> Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
> [OP: adjusted return logic for 4.14]
> Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>

All now queued up, thanks.

greg k-h

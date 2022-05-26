Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDDC3534F0B
	for <lists+stable@lfdr.de>; Thu, 26 May 2022 14:24:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238069AbiEZMYJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 May 2022 08:24:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229899AbiEZMYJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 May 2022 08:24:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27FF3C966E;
        Thu, 26 May 2022 05:24:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E0322B820D0;
        Thu, 26 May 2022 12:24:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E651C385A9;
        Thu, 26 May 2022 12:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653567845;
        bh=pXQ2y8qFFse1aW7YCdsD7dao6a8hX9aO58+GzC/aTXg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WzgnavGfQcAGdgHfWGM+61V0ZIvYhglLUR7rph10TGTHK9TXNrrArftyN3KxljxZG
         BcZqTFep1SO5Q/LTHreT4nBus3TZp/A/9F/IF1yi8T/3d6kjKbGQxeKOqpIInfUrpI
         XT8yZcvpnEelrzAFW8uOI2TJ6R9S2hu/zwFMTHbM=
Date:   Thu, 26 May 2022 14:24:01 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mark-PK Tsai <mark-pk.tsai@mediatek.com>
Cc:     stable@vger.kernel.org, mchehab@kernel.org, matthias.bgg@gmail.com,
        hverkuil-cisco@xs4all.nl, sakari.ailus@linux.intel.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, yj.chiang@mediatek.com
Subject: Re: [PATCH 5.4 0/2] media: vim2m: Fix potential NULL pointer
 dereference
Message-ID: <Yo9xYT2Ln6V9MbYA@kroah.com>
References: <20220525082731.28235-1-mark-pk.tsai@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220525082731.28235-1-mark-pk.tsai@mediatek.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 25, 2022 at 04:27:29PM +0800, Mark-PK Tsai wrote:
> Backport upstream solution [1][2] to fix below kernel panic:
> 
> Unable to handle kernel NULL pointer dereference at virtual address 0000000000000208
> ...
> pc : _raw_spin_lock_irqsave+0x50/0x90
> lr : v4l2_m2m_cancel_job+0x38/0x1c4 [v4l2_mem2mem]
> sp : ffffffc012d2bcb0
> x29: ffffffc012d2bcb0 x28: ffffff8098d6bb00
> x27: 0000000000000000 x26: ffffffc01009b5c8
> x25: 00000000000e001f x24: ffffff808ff3eb50
> x23: ffffffc01009f5a0 x22: 0000000000000000
> x21: ffffff808ffef000 x20: 0000000000000208
> x19: 0000000000000000 x18: ffffffc012b51048
> x17: ffffffc011e0ef7c x16: 00000000000000c0
> x15: ffffffc010fc78f4 x14: ffffffc0119dd790
> x13: 0000000000001b26 x12: 0000000053555555
> x11: 0000000000000002 x10: 0000000000000001
> x9 : 0000000000000000 x8 : 0000000000000208
> x7 : 2020202020202020 x6 : ffffffc011e313a6
> x5 : 0000000000000000 x4 : 0000000000000008
> x3 : 000000000000002e x2 : 0000000000000001
> x1 : 0000000000000000 x0 : 0000000000000208
> Call trace:
>  _raw_spin_lock_irqsave+0x50/0x90
>  v4l2_m2m_cancel_job+0x38/0x1c4 [v4l2_mem2mem]
>  v4l2_m2m_ctx_release+0x38/0x60 [v4l2_mem2mem]
>  vim2m_release+0x5c/0xe0 [vim2m]
>  v4l2_release+0x90/0x18c
>  __fput+0xdc/0x2cc
>  ____fput+0x10/0x1c
>  task_work_run+0xc4/0x130
>  do_notify_resume+0xdc/0x158
>  work_pending+0x8/0x10
> 
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=cf7f34777a5b4100a3a44ff95f3d949c62892bdd
> [2] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=1a28dce222a6ece725689ad58c0cf4a1b48894f4
> 
> Mark-PK Tsai (2):
>   media: vim2m: Register video device after setting up internals
>   media: vim2m: initialize the media device earlier
> 
>  drivers/media/platform/vim2m.c | 22 +++++++++++++---------
>  1 file changed, 13 insertions(+), 9 deletions(-)
> 
> -- 
> 2.18.0
> 

All now queued up, thanks.

greg k-h

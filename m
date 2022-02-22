Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04DF74BF1B6
	for <lists+stable@lfdr.de>; Tue, 22 Feb 2022 06:52:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbiBVFv7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 00:51:59 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:41428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229985AbiBVFv4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 00:51:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2195F56C2D
        for <stable@vger.kernel.org>; Mon, 21 Feb 2022 21:51:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AFF9C60E65
        for <stable@vger.kernel.org>; Tue, 22 Feb 2022 05:51:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AFD2C340E8;
        Tue, 22 Feb 2022 05:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645509089;
        bh=7N7bbT8UXd0iht9TN0tMfte5WvN6G9Kpk3tDRkT/1jg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QiDH/1SIEbULyIhrDgvoqfxfA0xaNKmuCM5BjvCyn2fb88PcB6PCtBE579UD56fVE
         9tgzBkrBbKkWf8sVanAMhidBT5HAuH2BB8u4dF0F2OqpLGuTMxVhu3y07hSd6NvAPz
         wSa53XADjYbFAGlksAyKia5/gK35VpZ2c83xf8Mg=
Date:   Tue, 22 Feb 2022 06:51:24 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jens Wiklander <jens.wiklander@linaro.org>
Cc:     stable@vger.kernel.org, Sumit Garg <sumit.garg@linaro.org>,
        Lars Persson <larper@axis.com>
Subject: Re: [PATCH backport 5.4 v2] optee: use driver internal tee_context
 for some rpc
Message-ID: <YhR53Fz8rkHBff3X@kroah.com>
References: <20220221224859.1535057-1-jens.wiklander@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220221224859.1535057-1-jens.wiklander@linaro.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 21, 2022 at 11:48:59PM +0100, Jens Wiklander wrote:
> commit aceeafefff736057e8f93f19bbfbef26abd94604 upstream
> 
> Adds a driver private tee_context to struct optee.
> 
> The new driver internal tee_context is used when allocating driver
> private shared memory. This decouples the shared memory object from its
> original tee_context. This is needed when the life time of such a memory
> allocation outlives the client tee_context.
> 
> This fixes a problem where the tee_context allocated on behalf of a
> process outlives the process because some longer lived driver internal
> shared memory has been allocated using that tee_context.
> 
> Fixes: 217e0250cccb ("tee: use reference counting for tee_context")
> Reported-by: Lars Persson <larper@axis.com>
> Cc: stable@vger.kernel.org # 1e2c3ef0496e tee: export teedev_open() and teedev_close_context()
> Cc: stable@vger.kernel.org
> Reviewed-by: Sumit Garg <sumit.garg@linaro.org>
> [JW: backport to 5.4-stable + update commit message]
> Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
> ---
> Hi,
> 
> This is an update to the previous patch posted with the same name.

What changed in v2?

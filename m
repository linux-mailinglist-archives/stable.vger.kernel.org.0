Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68F1350B7CF
	for <lists+stable@lfdr.de>; Fri, 22 Apr 2022 15:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233827AbiDVNC4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Apr 2022 09:02:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1447763AbiDVNCy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Apr 2022 09:02:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D5BB60E4;
        Fri, 22 Apr 2022 06:00:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E5D14B82D2D;
        Fri, 22 Apr 2022 12:59:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 038CFC385A8;
        Fri, 22 Apr 2022 12:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650632397;
        bh=EuI02HnZPhPPNa3QKg88JZRW0CEqpWBj8AMo5mHer+U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JecLKEygMG9ILc1dRzuK3b4RNTdFfnvWcZF9hCg/xrhiaMRzPmi4nkX9j9cttsj+E
         Q+DPYQlCUr90BGFxlMdtbFcEpV5ooPCAfjY2FUR2uGa9CDuPrgk1BzJu7WO7zv3E0i
         ac2V+8AmGIU96/YneETnRD7wZbHagqEmeSD3vPOU=
Date:   Fri, 22 Apr 2022 14:59:54 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Xiaomeng Tong <xiam0nd.tong@gmail.com>
Cc:     balbi@kernel.org, joel@jms.id.au, andrew@aj.id.au,
        rentao.bupt@gmail.com, caihuoqing@baidu.com,
        benh@kernel.crashing.org, linux-usb@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-aspeed@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] aspeed-vhub: epn: fix an incorrect member check on list
 iterator
Message-ID: <YmKmysEfb9GY5ng4@kroah.com>
References: <20220327062431.5847-1-xiam0nd.tong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220327062431.5847-1-xiam0nd.tong@gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Mar 27, 2022 at 02:24:31PM +0800, Xiaomeng Tong wrote:
> The bug is here:
> 	if (&req->req == u_req) {
> 
> The list iterator 'req' will point to a bogus position containing
> HEAD if the list is empty or no element is found. This case must
> be checked before any use of the iterator, otherwise it may bypass
> the 'if (&req->req == u_req) {' check in theory, if '*u_req' obj is
> just allocated in the same addr with '&req->req'.
> 
> To fix this bug, just mova all thing inside the loop and return 0,
> otherwise return error.
> 
> Cc: stable@vger.kernel.org
> Fixes: 7ecca2a4080cb ("usb/gadget: Add driver for Aspeed SoC virtual hub")
> Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
> ---
>  drivers/usb/gadget/udc/aspeed-vhub/epn.c | 23 ++++++++++-------------
>  1 file changed, 10 insertions(+), 13 deletions(-)

Does not apply anymore :(

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E1DB65EA91
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 13:19:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232901AbjAEMSu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 07:18:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233197AbjAEMSd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 07:18:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B81885A8AB
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 04:18:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 54CF4619F6
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 12:18:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53DA7C433EF;
        Thu,  5 Jan 2023 12:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672921103;
        bh=hv1EV/irLjHJQAyoHKa6C4KDVEhonROZ4XUZ0ToC0fQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Gf0gw6lMHhFnp/R+FKSWjblrHqXd0pj4hA8muqIwwgZa1U5fhJQvX9k6VLSw8Eqzs
         QI0wbub5PnleV2FaVjoUQ0AyRdzwnib111z/fOuz3qgiHmAKcmMveUoMRxrAWj0ux4
         4yKbqCy3VadeVGmf9z3A1UbirXsLeokMilo8In/w+K1WkCuBCAXPeJGm/+0MG99DjV
         +AoaIhmmB8U5p8jhwlnFxE1x3jZxFINHea1uHrY/H4stKPiiugXamFwz/n083fLQWM
         82djg9sCYq6VULJDKM+GZXVHbKWf4jFm72sxJRV1tZ8PS/6ih4K99HSd3QlUYibzA8
         JOvW6BkjY5FVQ==
Date:   Thu, 5 Jan 2023 12:18:18 +0000
From:   Lee Jones <lee@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        John Keeping <john@metanate.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.15 481/731] usb: gadget: f_hid: fix f_hidg lifetime vs
 cdev
Message-ID: <Y7bACmZQdEhlf121@google.com>
References: <20221228144256.536395940@linuxfoundation.org>
 <20221228144310.493605271@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221228144310.493605271@linuxfoundation.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 28 Dec 2022, Greg Kroah-Hartman wrote:

> From: John Keeping <john@metanate.com>
> 
> [ Upstream commit 89ff3dfac604614287ad5aad9370c3f984ea3f4b ]
> 
> The embedded struct cdev does not have its lifetime correctly tied to
> the enclosing struct f_hidg, so there is a use-after-free if /dev/hidgN
> is held open while the gadget is deleted.
> 
> This can readily be replicated with libusbgx's example programs (for
> conciseness - operating directly via configfs is equivalent):
> 
> 	gadget-hid
> 	exec 3<> /dev/hidg0
> 	gadget-vid-pid-remove
> 	exec 3<&-
> 
> Pull the existing device up in to struct f_hidg and make use of the
> cdev_device_{add,del}() helpers.  This changes the lifetime of the
> device object to match struct f_hidg, but note that it is still added
> and deleted at the same time.
> 
> Fixes: 71adf1189469 ("USB: gadget: add HID gadget driver")
> Tested-by: Lee Jones <lee@kernel.org>
> Reviewed-by: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
> Reviewed-by: Lee Jones <lee@kernel.org>
> Signed-off-by: John Keeping <john@metanate.com>
> Link: https://lore.kernel.org/r/20221122123523.3068034-2-john@metanate.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/usb/gadget/function/f_hid.c | 52 ++++++++++++++++-------------
>  1 file changed, 28 insertions(+), 24 deletions(-)
 
Dear Stable,

Would you be kind enough to take this back as far back as linux.4.14.y
please?  There is a trivial fix-up required for kernels older than
v5.15, but it's the same fix-up back through v4.14.

Thanks.

--- 
Lee Jones [李琼斯]

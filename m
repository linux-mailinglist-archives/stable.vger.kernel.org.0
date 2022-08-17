Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E49C5596DEB
	for <lists+stable@lfdr.de>; Wed, 17 Aug 2022 14:00:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236015AbiHQL7h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Aug 2022 07:59:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233652AbiHQL7h (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Aug 2022 07:59:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 455FE6BCFB;
        Wed, 17 Aug 2022 04:59:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E056DB81BA5;
        Wed, 17 Aug 2022 11:59:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 119C3C433D6;
        Wed, 17 Aug 2022 11:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660737573;
        bh=Ji8MOQ19wzA4/F9kygo62h2DmZDs5FvDx5cfnZE86t0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=syJa61+KfnRDHBzwmXOTbsgS2OciauRjwMtrhPeImbJCebsN8Nbo0VkrCXF/oXFVX
         qEfBvH4BTrejUML915MQwSpnvw/gTOFgyN9GO8gcoU+GqEGiP4r+jdlEoogT+TWsqm
         JH9hIao5CpKpz3VJrBQoIDXM9XgQJfTMeMxR+oPg=
Date:   Wed, 17 Aug 2022 13:59:30 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Andri Yngvason <andri@yngvason.is>
Cc:     Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        linux-input@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH RESEND] HID: multitouch: Add memory barriers
Message-ID: <YvzYIm21ZKYpUApA@kroah.com>
References: <20220817113247.3530979-1-andri@yngvason.is>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220817113247.3530979-1-andri@yngvason.is>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 17, 2022 at 11:32:48AM +0000, Andri Yngvason wrote:
> This fixes a race with the release-timer by adding acquire/release
> barrier semantics.

What race?

> 
> I noticed that contacts were sometimes sticking, even with the "sticky
> fingers" quirk enabled. This fixes that problem.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Andri Yngvason <andri@yngvason.is>
> ---
>  drivers/hid/hid-multitouch.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
> index 2e72922e36f5..91a4d3fc30e0 100644
> --- a/drivers/hid/hid-multitouch.c
> +++ b/drivers/hid/hid-multitouch.c
> @@ -1186,7 +1186,7 @@ static void mt_touch_report(struct hid_device *hid,
>  	int contact_count = -1;
>  
>  	/* sticky fingers release in progress, abort */
> -	if (test_and_set_bit(MT_IO_FLAGS_RUNNING, &td->mt_io_flags))
> +	if (test_and_set_bit_lock(MT_IO_FLAGS_RUNNING, &td->mt_io_flags))

So this is now a lock?

Why not just use a real lock instead?

thanks,

greg k-h

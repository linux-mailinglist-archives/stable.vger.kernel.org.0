Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D3D7622A89
	for <lists+stable@lfdr.de>; Wed,  9 Nov 2022 12:29:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbiKIL3r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Nov 2022 06:29:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229987AbiKIL3o (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Nov 2022 06:29:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77F5910054;
        Wed,  9 Nov 2022 03:29:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0DDF9619E1;
        Wed,  9 Nov 2022 11:29:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF761C4347C;
        Wed,  9 Nov 2022 11:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667993380;
        bh=vL0H/xg+uyXS8iiPDew7LK7Mbki2qfEr/CbZcV15j8w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sIYdJJb5vWalABgOzySHd+vPCnVOhmAFGdCq0wa+NtT1jBIED2Jb9Y2A9mT74nGIh
         Ev8M9oLZlkblhyVsb69RPlWlnCmIrFDwGZ75S/BKFdy3rphDkw9IxUyTXlK3eyL51M
         gM64kryzubzXqLBqTrsrjhxVdc4aexRwxS/OHswo=
Date:   Wed, 9 Nov 2022 12:29:36 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nicolas Dumazet <ndumazet@google.com>
Cc:     Jean-Francois Le Fillatre <jflf_kernel@gmx.com>,
        Petar Kostic <petar@kostic.dev>,
        Oliver Neukum <oneukum@suse.com>, Ole Ernst <olebowle@gmx.com>,
        Hannu Hartikainen <hannu@hrtk.in>,
        Jimmy Wang <wangjm221@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] usb: add NO_LPM quirk for Realforce 87U Keyboard
Message-ID: <Y2uPIItkmcYgDy6k@kroah.com>
References: <20221027090342.38928-1-ndumazet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221027090342.38928-1-ndumazet@google.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 27, 2022 at 11:03:42AM +0200, Nicolas Dumazet wrote:
> Before adding this quirk, this (mechanical keyboard) device would not be
> recognized, logging:
> 
>   new full-speed USB device number 56 using xhci_hcd
>   unable to read config index 0 descriptor/start: -32
>   chopping to 0 config(s)
> 
> It would take dozens of plugging/unpuggling cycles for the keyboard to
> be recognized. Keyboard seems to simply work after applying this quirk.
> 
> This issue had been reported by users in two places already ([1], [2])
> but nobody tried upstreaming a patch yet. After testing I believe their
> suggested fix (DELAY_INIT + NO_LPM + DEVICE_QUALIFIER) was probably a
> little overkill. I assume this particular combination was tested because
> it had been previously suggested in [3], but only NO_LPM seems
> sufficient for this device.
> 
> [1]: https://qiita.com/float168/items/fed43d540c8e2201b543
> [2]: https://blog.kostic.dev/posts/making-the-realforce-87ub-work-with-usb30-on-Ubuntu/
> [3]: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1678477
> 
> ---
> Changes in v2:
>   - add the entry to the right location (sorting entries by
>     vendor/device id).
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Nicolas Dumazet <ndumazet@google.com>
> ---

By putting your s-o-b below the --- line, tools will drop it, how did
you test this?

Put the v2 stuff below the --- line, don't add a new one.  See the
thousands of examples on the list for how to do this correctly (as well
as the kernel documentation.)

Can you fix this up and resend a v3 please?

thanks,

greg k-h

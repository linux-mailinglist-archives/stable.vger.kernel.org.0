Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B14BE47DF4A
	for <lists+stable@lfdr.de>; Thu, 23 Dec 2021 08:04:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242425AbhLWHEv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Dec 2021 02:04:51 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:49956 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232658AbhLWHEu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Dec 2021 02:04:50 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6F5BEB81F7C;
        Thu, 23 Dec 2021 07:04:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C429C36AE5;
        Thu, 23 Dec 2021 07:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640243088;
        bh=uk3Bv7U+Fq9ElkgcVl0tqJsEanoo1dl/iKOmRHfyyAk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DOkxalg8GBRk2ch4gImd38oZDSZkt/MVpvqMvktIrgf0nwKx2L8sNShi4KXhynfMx
         qw0IsfbyHvs3/HBcUEKEp+UnRB43Ex5vGA2fioR87QbzbhkxkSNb95scA/MhM28HkP
         YVEuie9RaVPSeo6qMUbRbby5BnqZnJoA6PNEMEBE=
Date:   Thu, 23 Dec 2021 08:04:42 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "James D. Turner" <linuxkernel.foss@dmarc-none.turner.link>
Cc:     linux-kernel@vger.kernel.org, Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        linux-input@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] HID: holtek-mouse: start hardware in probe
Message-ID: <YcQfil1zb908p2hs@kroah.com>
References: <875yrgf05r.fsf@turner.link>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <875yrgf05r.fsf@turner.link>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 21, 2021 at 09:21:41PM -0500, James D. Turner wrote:
> The holtek_mouse_probe() function is missing the necessary code to
> start the hardware. When an Etekcity Scroll X1 (M555) USB mouse is
> plugged in, the mouse receives power and the kernel recognizes it as a
> USB device, but the system does not respond to any movement, clicking,
> or scrolling of the mouse. Presumably, this bug also affects all other
> mice supported by the hid-holtek-mouse driver, although this has not
> been tested. On the stable linux-5.15.y branch, testing confirms that
> the bug was introduced in commit a579510a64ed ("HID: check for valid
> USB device for many HID drivers"), which was first included in
> v5.15.8. Based on the source code, this bug appears to be present in
> all currently-supported kernels (mainline, stable, and all LTS
> kernels). Testing on hardware confirms that this proposed patch fixes
> the bug for kernel v5.15.10. Fix holtek_mouse_probe() to call the
> necessary functions to start the hardware.
> 
> Fixes: 93020953d0fa ("HID: check for valid USB device for many HID drivers")
> Cc: Jiri Kosina <jikos@kernel.org>
> Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> Cc: linux-input@vger.kernel.org
> Cc: stable@vger.kernel.org
> Signed-off-by: James D. Turner <linuxkernel.foss@dmarc-none.turner.link>
> ---
> This is my first time submitting a kernel patch. I think I've followed
> all the directions, but please let me know if I should do something
> differently.
> 
> In addition to testing this patch for the stable v5.15.10 kernel on real
> hardware, I also tested it for the latest master of the hid repository
> (commit 03090cc76ee3 ("Merge branch 'for-linus' of
> git://git.kernel.org/pub/scm/linux/kernel/git/hid/hid")) using a VM with
> USB passthrough.

Thanks for the patch, but isn't this the same as commit 93a2207c254c
("HID: holtek: fix mouse probing") in Linus's tree right now?

thanks,

greg k-h

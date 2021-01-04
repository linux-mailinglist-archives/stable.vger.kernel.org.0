Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BBA52E981D
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 16:11:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727136AbhADPLo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 10:11:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:53404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727083AbhADPLo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 10:11:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A3C1521BE5;
        Mon,  4 Jan 2021 15:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609773063;
        bh=jfC5TGYge5FLC+AyQhZQPVIncGTR0lKNlaiG+ceF0BI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oEMrT2TaHdF/of51Z86DlK4zs/k83FCS44EY4+EDxwee1FgffgckzqS/qlN48N5Oo
         morwMwkxT8n9CgqqsVz1mxD96P7Ka5RsHeLHY87UzNJat7Nvs1QV+WFoBW3UGF/+Me
         IrbzZoQ0jYrH3UAvFapI2QZXAt7BD0kJPQcM/lDcCjgeea6vRSponkGwDxfHy+HNPP
         hYbKMQOJFdH0YidEqae4xOI0qaR8BNIv/IMWyb1QKLpJvjiojTZKWB9aKhJ79C5FEZ
         1zZltdMi8Hwzng3hyB0R3Hst05+yx6amOpnBs6gXGxOspE6iwD0TyaCe+5qQzlOOq0
         Vej1omQCa5bUA==
Received: from johan by xi.lan with local (Exim 4.93.0.4)
        (envelope-from <johan@kernel.org>)
        id 1kwRVc-0000bg-7e; Mon, 04 Jan 2021 16:11:00 +0100
Date:   Mon, 4 Jan 2021 16:11:00 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Johan Hovold <johan@kernel.org>, Pete Zaitcev <zaitcev@redhat.com>,
        linux-usb@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] USB: usblp: fix DMA to stack
Message-ID: <X/MwBCt0Z/B1D7vw@hovoldconsulting.com>
References: <20210104145302.2087-1-johan@kernel.org>
 <X/MtNtTd96S39HQL@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X/MtNtTd96S39HQL@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 04, 2021 at 03:59:02PM +0100, Greg Kroah-Hartman wrote:
> On Mon, Jan 04, 2021 at 03:53:02PM +0100, Johan Hovold wrote:
> > Stack-allocated buffers cannot be used for DMA (on all architectures).
> > 
> > Replace the HP-channel macro with a helper function that allocates a
> > dedicated transfer buffer so that it can continue to be used with
> > arguments from the stack.

> Wow, no one uses this driver anymore it seems, this should have
> triggered a runtime warning on newer kernels :(

This helper is only used by the IOCNR_HP_SET_CHANNEL ioctl so perhaps
it's just that one which isn't used much.

Johan

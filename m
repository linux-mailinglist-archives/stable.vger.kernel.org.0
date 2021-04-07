Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DE2A356B20
	for <lists+stable@lfdr.de>; Wed,  7 Apr 2021 13:26:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245703AbhDGL0F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Apr 2021 07:26:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:38018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245698AbhDGL0E (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 7 Apr 2021 07:26:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D30DE6102A;
        Wed,  7 Apr 2021 11:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617794753;
        bh=fp9e7C8temPHioHnfMeuShTqKsHUij0RHUo6TqZrCNs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ckP6pwJ+dw5GZcDOONZJTO3eldsrYzYtzmpJWlUFJYYiPkWVV5P3gltO1FyyMr4Ha
         mCUF4kKyPhoRYLKfhzNwA3T4TFSKmJK5IWx13/OcXybWG1/pREvOYr1xoQRsktUZml
         z4wlxd5MfDC+nFo3f5vOdQX6k19Q5W0yZtECoV/VmdyT21cBR26bWkUU83PsQhr5FX
         newpyk6G3e39jleTDs2NzyOwRPtiJ9MjJP/kQewANJxZWkhHnRdJspyDoVHVR2TYBS
         zvAsV9tWufIh0ikwGEl1u6yN0VZO7pqcIOgICoEFYr67fHhGIBGe3gYtDgpGXGQwZy
         JhbbphEYNBDUw==
Received: from johan by xi.lan with local (Exim 4.93.0.4)
        (envelope-from <johan@kernel.org>)
        id 1lU6Jd-0000Sv-Dv; Wed, 07 Apr 2021 13:25:45 +0200
Date:   Wed, 7 Apr 2021 13:25:45 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Anthony Mallet <anthony.mallet@laas.fr>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Oliver Neukum <oneukum@suse.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/3] Revert "USB: cdc-acm: fix rounding error in
 TIOCSSERIAL"
Message-ID: <YG2WuTPjPhLPR/v7@hovoldconsulting.com>
References: <20210407102845.32720-1-johan@kernel.org>
 <20210407102845.32720-2-johan@kernel.org>
 <24685.37311.759816.776098@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <24685.37311.759816.776098@gargle.gargle.HOWL>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 07, 2021 at 01:04:31PM +0200, Anthony Mallet wrote:
> On Wednesday  7 Apr 2021, at 12:28, Johan Hovold wrote:
> > With HZ=250, the default 0.5 second value of close_delay is converted to
> > 125 jiffies when set and is converted back to 50 centiseconds by
> > TIOCGSERIAL as expected (not 12 cs as was claimed).
> 
> It was "12" (instead of 50) because the conversion gor TIOCGSERIAL was
> initially broken, and that was fixed in the previous commit
> 633e2b2ded739a34bd0fb1d8b5b871f7e489ea29

Right, so this patch is still just broken. The missing jiffies
conversion had already been added.

> > For completeness: With different default values for these parameters or
> > with a HZ value not divisible by two, the lack of rounding when setting
> > the default values in tty_port_init() could result in an -EPERM being
> > returned, but this is hardly something we need to worry about.
> 
> The -EPERM is harmful when a regular user wants to update other
> members of serial_struct without changing the close delays,
> e.g. ASYNC_LOW_LATENCY, which is granted to regular users.

You're missing the point; -EPERM will *not* be returned -- and this
patch was never needed.

Johan

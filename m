Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98D9F27ADA5
	for <lists+stable@lfdr.de>; Mon, 28 Sep 2020 14:17:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726578AbgI1MRX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Sep 2020 08:17:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:53924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726409AbgI1MRX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Sep 2020 08:17:23 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 20A762083B;
        Mon, 28 Sep 2020 12:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601295442;
        bh=dBmPwjXMITa6gYn63Dk0BO4f8iE4EkQ09/cGjU/9nM4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=T706bGfADXUPSJiVmZgarIiwqgurAF9VmF711JAjYYZ41GZWVnBhm97INxa0Geevq
         O8A/P6LcRd+pbv5cveKhk0XmBifPGLpTF2gavOLmloh6vY42vbVOC2tRgglC1xyUYm
         rYnsZqC+Bgt7Dqvei+TWNPuFYawybsVLyyQ3C7yY=
Date:   Mon, 28 Sep 2020 14:17:29 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ajay Kaher <akaher@vmware.com>
Cc:     b.zolnierkie@samsung.com, daniel.vetter@ffwll.ch,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, w@1wt.eu, yuanmingbuaa@gmail.com,
        srivatsab@vmware.com, srivatsa@csail.mit.edu
Subject: Re: [PATCH 4.4 20/46] fbcon: remove soft scrollback code
Message-ID: <20200928121729.GA661457@kroah.com>
References: <20200921162034.253730633@linuxfoundation.org>
 <1601273217-47349-1-git-send-email-akaher@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1601273217-47349-1-git-send-email-akaher@vmware.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 28, 2020 at 11:36:57AM +0530, Ajay Kaher wrote:
> > @@ -3378,7 +3054,6 @@ static const struct consw fb_con = {
> >  	.con_font_default	= fbcon_set_def_font,
> >  	.con_font_copy 		= fbcon_copy_font,
> >  	.con_set_palette 	= fbcon_set_palette,
> > -	.con_scrolldelta 	= fbcon_scrolldelta,
> >  	.con_set_origin 	= fbcon_set_origin,
> >  	.con_invert_region 	= fbcon_invert_region,
> >  	.con_screen_pos 	= fbcon_screen_pos,
> 
> If I am not wrong, this change creates crash in v4.4.y.
> As before calling con_scrolldelta, NULL check is missing inside
> console_callback() for v4.4.y, refer:
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/drivers/tty/vt/vt.c?h=linux-4.4.y#n2487
> 
> This NULL check was added in commit 97293de977365fe672daec2523e66ef457104921,
> and this is not merged to v4.4.y

Good catch, will go queue up that portion of that commit to 4.4.y now,
thanks!

greg k-h

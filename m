Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47A1011BB9F
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 19:25:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730100AbfLKSZs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 13:25:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:54308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726242AbfLKSZs (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 13:25:48 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 306E62077B;
        Wed, 11 Dec 2019 18:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576088747;
        bh=eixX/1xTAHg++GRNlIYq1TYG687Pp9j630mdHZc3cHk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JkXCKh6kTKu09+5b6fDW8rBd9BKqRReM3oQFcZvJLVWu3FU4wrEnjIXsVbRaOJe6q
         vhyhsJqeyRppF9Fz4KM9a+VB5iR26Pj5Pc/+jgcgmG/Pdtpp+ZKb9ArdXe/wuW3i2+
         CTgOeD2W7Rciz86SmLPEQ7fvnoh2Ef8VeeweRmIY=
Date:   Wed, 11 Dec 2019 19:25:45 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, stable@kernel.org,
        Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.4 27/37] ext4: work around deleting a file with
 i_nlink == 0 safely
Message-ID: <20191211182545.GB715013@kroah.com>
References: <20191211153813.24126-1-sashal@kernel.org>
 <20191211153813.24126-27-sashal@kernel.org>
 <20191211161959.GB129186@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191211161959.GB129186@mit.edu>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 11, 2019 at 11:19:59AM -0500, Theodore Y. Ts'o wrote:
> On Wed, Dec 11, 2019 at 10:38:03AM -0500, Sasha Levin wrote:
> > From: Theodore Ts'o <tytso@mit.edu>
> > 
> > [ Upstream commit c7df4a1ecb8579838ec8c56b2bb6a6716e974f37 ]
> > 
> > If the file system is corrupted such that a file's i_links_count is
> > too small, then it's possible that when unlinking that file, i_nlink
> > will already be zero.  Previously we were working around this kind of
> > corruption by forcing i_nlink to one; but we were doing this before
> > trying to delete the directory entry --- and if the file system is
> > corrupted enough that ext4_delete_entry() fails, then we exit with
> > i_nlink elevated, and this causes the orphan inode list handling to be
> > FUBAR'ed, such that when we unmount the file system, the orphan inode
> > list can get corrupted.
> > 
> > A better way to fix this is to simply skip trying to call drop_nlink()
> > if i_nlink is already zero, thus moving the check to the place where
> > it makes the most sense.
> > 
> > https://bugzilla.kernel.org/show_bug.cgi?id=205433
> > 
> > Link: https://lore.kernel.org/r/20191112032903.8828-1-tytso@mit.edu
> > Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> > Cc: stable@kernel.org
> > Reviewed-by: Andreas Dilger <adilger@dilger.ca>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> I'm confused; this was explicitly cc'ed to stable@kernel.org, so why
> is your AUTOSEL picking this up?  I would have thought this would get
> picked up via the normal stable kernel processes.

Perhaps because it is still in my queue, I haven't gotten there yet, but
will do so after this next round of -rcs are released.

thanks,

greg k-h

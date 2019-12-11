Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8500011B870
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 17:20:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729296AbfLKQUG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 11:20:06 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:57899 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728912AbfLKQUG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Dec 2019 11:20:06 -0500
Received: from callcc.thunk.org (guestnat-104-132-34-105.corp.google.com [104.132.34.105] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id xBBGK0x7002440
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 Dec 2019 11:20:00 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id CCB6C421A48; Wed, 11 Dec 2019 11:19:59 -0500 (EST)
Date:   Wed, 11 Dec 2019 11:19:59 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        stable@kernel.org, Andreas Dilger <adilger@dilger.ca>,
        linux-ext4@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.4 27/37] ext4: work around deleting a file with
 i_nlink == 0 safely
Message-ID: <20191211161959.GB129186@mit.edu>
References: <20191211153813.24126-1-sashal@kernel.org>
 <20191211153813.24126-27-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191211153813.24126-27-sashal@kernel.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 11, 2019 at 10:38:03AM -0500, Sasha Levin wrote:
> From: Theodore Ts'o <tytso@mit.edu>
> 
> [ Upstream commit c7df4a1ecb8579838ec8c56b2bb6a6716e974f37 ]
> 
> If the file system is corrupted such that a file's i_links_count is
> too small, then it's possible that when unlinking that file, i_nlink
> will already be zero.  Previously we were working around this kind of
> corruption by forcing i_nlink to one; but we were doing this before
> trying to delete the directory entry --- and if the file system is
> corrupted enough that ext4_delete_entry() fails, then we exit with
> i_nlink elevated, and this causes the orphan inode list handling to be
> FUBAR'ed, such that when we unmount the file system, the orphan inode
> list can get corrupted.
> 
> A better way to fix this is to simply skip trying to call drop_nlink()
> if i_nlink is already zero, thus moving the check to the place where
> it makes the most sense.
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=205433
> 
> Link: https://lore.kernel.org/r/20191112032903.8828-1-tytso@mit.edu
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> Cc: stable@kernel.org
> Reviewed-by: Andreas Dilger <adilger@dilger.ca>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

I'm confused; this was explicitly cc'ed to stable@kernel.org, so why
is your AUTOSEL picking this up?  I would have thought this would get
picked up via the normal stable kernel processes.

Thanks,

						- Ted

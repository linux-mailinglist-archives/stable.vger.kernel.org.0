Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94C7515C2D0
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:39:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728935AbgBMPgG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:36:06 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:53309 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728602AbgBMPgF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Feb 2020 10:36:05 -0500
Received: from callcc.thunk.org (guestnat-104-133-0-101.corp.google.com [104.133.0.101] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 01DFa0Y4015789
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Feb 2020 10:36:01 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 29FD342032C; Thu, 13 Feb 2020 10:36:00 -0500 (EST)
Date:   Thu, 13 Feb 2020 10:36:00 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Jan Kara <jack@suse.cz>
Cc:     linux-ext4@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] ext4: Fix checksum errors with indexed dirs
Message-ID: <20200213153600.GD239974@mit.edu>
References: <20200210144316.22081-1-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200210144316.22081-1-jack@suse.cz>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 10, 2020 at 03:43:16PM +0100, Jan Kara wrote:
> DIR_INDEX has been introduced as a compat ext4 feature. That means that
> even kernels / tools that don't understand the feature may modify the
> filesystem. This works because for kernels not understanding indexed dir
> format, internal htree nodes appear just as empty directory entries.
> Index dir aware kernels then check the htree structure is still
> consistent before using the data. This all worked reasonably well until
> metadata checksums were introduced. The problem is that these
> effectively made DIR_INDEX only ro-compatible because internal htree
> nodes store checksums in a different place than normal directory blocks.
> Thus any modification ignorant to DIR_INDEX (or just clearing
> EXT4_INDEX_FL from the inode) will effectively cause checksum mismatch
> and trigger kernel errors. So we have to be more careful when dealing
> with indexed directories on filesystems with checksumming enabled.
> 
> 1) We just disallow loading any directory inodes with EXT4_INDEX_FL when
> DIR_INDEX is not enabled. This is harsh but it should be very rare (it
> means someone disabled DIR_INDEX on existing filesystem and didn't run
> e2fsck), e2fsck can fix the problem, and we don't want to answer the
> difficult question: "Should we rather corrupt the directory more or
> should we ignore that DIR_INDEX feature is not set?"
> 
> 2) When we find out htree structure is corrupted (but the filesystem and
> the directory should in support htrees), we continue just ignoring htree
> information for reading but we refuse to add new entries to the
> directory to avoid corrupting it more.
> 
> CC: stable@vger.kernel.org
> Fixes: dbe89444042a ("ext4: Calculate and verify checksums for htree nodes")
> Signed-off-by: Jan Kara <jack@suse.cz>

Applied, thanks.

					- Ted

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F13E32EFF4
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 17:23:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbhCEQW6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 11:22:58 -0500
Received: from verein.lst.de ([213.95.11.211]:47396 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229832AbhCEQWk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 11:22:40 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id CB60568B05; Fri,  5 Mar 2021 17:22:37 +0100 (CET)
Date:   Fri, 5 Mar 2021 17:22:37 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        David Howells <dhowells@redhat.com>,
        Al Viro <viro@zeniv.linux>, linux-fsdevel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] mount: fix mounting of detached mounts onto targets
 that reside on shared mounts
Message-ID: <20210305162237.GA24675@lst.de>
References: <20210304174155.61792-1-christian.brauner@ubuntu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210304174155.61792-1-christian.brauner@ubuntu.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 04, 2021 at 06:41:55PM +0100, Christian Brauner wrote:
> Creating a series of detached mounts, attaching them to the filesystem,
> and unmounting them can be used to trigger an integer overflow in
> ns->mounts causing the kernel to block any new mounts in count_mounts()
> and returning ENOSPC because it falsely assumes that the maximum number
> of mounts in the mount namespace has been reached, i.e. it thinks it
> can't fit the new mounts into the mount namespace anymore.
> 
> Depending on the number of mounts in your system, this can be reproduced
> on any kernel that supportes open_tree() and move_mount() with the
> following instructions:
> 
> 1. Compile the following program "repro.c" via "make repro"
>   > cat repro.c

Can you wire this up for xfstests?

The patch itself looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BFA738BD81
	for <lists+stable@lfdr.de>; Fri, 21 May 2021 06:43:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239173AbhEUEpL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 May 2021 00:45:11 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:40988 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S239172AbhEUEpL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 May 2021 00:45:11 -0400
Received: from callcc.thunk.org (c-73-8-226-230.hsd1.il.comcast.net [73.8.226.230])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 14L4hh8u023398
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 May 2021 00:43:45 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 18B91420119; Fri, 21 May 2021 00:43:43 -0400 (EDT)
Date:   Fri, 21 May 2021 00:43:42 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Alexey Makhalov <amakhalov@vmware.com>
Cc:     linux-ext4@vger.kernel.org, stable@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>
Subject: Re: [PATCH] ext4: fix memory leak in ext4_fill_super
Message-ID: <YKc6fidMj95TZp2w@mit.edu>
References: <20210428221928.38960-1-amakhalov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210428221928.38960-1-amakhalov@vmware.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 28, 2021 at 10:19:28PM +0000, Alexey Makhalov wrote:
> I've recently discovered that doing infinite loop of
>   systemctl start <ext4_on_lvm>.mount, and
>   systemctl stop <ext4_on_lvm>.mount
> linearly increases percpu allocator memory consumption.
> In several hours, it might lead to system instability by
> consuming most of the memory.
> 
> Bug is not reproducible when the ext4 filesystem is on
> physical partition, but it is persistent when ext4 is on
> logical volume.

Why is this the case?  It sounds like we're looking a buffer for each
mount where the block size is not 1k.  It shouldn't matter whether it
is a physical partition or not.

				- Ted

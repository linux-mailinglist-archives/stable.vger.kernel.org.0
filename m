Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A10C9F878
	for <lists+stable@lfdr.de>; Wed, 28 Aug 2019 04:57:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726178AbfH1C5D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 22:57:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:37772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726096AbfH1C5C (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 22:57:02 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C1BE20674;
        Wed, 28 Aug 2019 02:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566961021;
        bh=8zKhyDo2kSA0djNQy3eL/9ao3YcxHPEvNHgL1NT9DcQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hRBp0rf5JFJDnbu1kMc3QL0sxl27+WKzldnunNpm1W1afWwJOdp0mT//+DdaH4LSs
         TZ6PKSHFNhaGBgzTzmCEdpcKHPAcU+ZH6cSKhML4OAkJ0+O3VO9k1/PI/93/pdUH0S
         0B2ERdmLvHzRXtW3PxuHwyQRw+M0X4WXl2OfL4AI=
Date:   Tue, 27 Aug 2019 22:57:00 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Ben Hutchings <ben.hutchings@codethink.co.uk>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH 4.4 01/13] GFS2: don't set rgrp gl_object until it's
 inserted into rgrp tree
Message-ID: <20190828025700.GW5281@sasha-vm>
References: <20190827230906.GA11046@xylophone.i.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190827230906.GA11046@xylophone.i.decadent.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 28, 2019 at 12:09:06AM +0100, Ben Hutchings wrote:
>From: Bob Peterson <rpeterso@redhat.com>
>
>commit 36e4ad0316c017d5b271378ed9a1c9a4b77fab5f upstream.
>
>Before this patch, function read_rindex_entry would set a rgrp
>glock's gl_object pointer to itself before inserting the rgrp into
>the rgrp rbtree. The problem is: if another process was also reading
>the rgrp in, and had already inserted its newly created rgrp, then
>the second call to read_rindex_entry would overwrite that value,
>then return a bad return code to the caller. Later, other functions
>would reference the now-freed rgrp memory by way of gl_object.
>In some cases, that could result in gfs2_rgrp_brelse being called
>twice for the same rgrp: once for the failed attempt and once for
>the "real" rgrp release. Eventually the kernel would panic.
>There are also a number of other things that could go wrong when
>a kernel module is accessing freed storage. For example, this could
>result in rgrp corruption because the fake rgrp would point to a
>fake bitmap in memory too, causing gfs2_inplace_reserve to search
>some random memory for free blocks, and find some, since we were
>never setting rgd->rd_bits to NULL before freeing it.
>
>This patch fixes the problem by not setting gl_object until we
>have successfully inserted the rgrp into the rbtree. Also, it sets
>rd_bits to NULL as it frees them, which will ensure any accidental
>access to the wrong rgrp will result in a kernel panic rather than
>file system corruption, which is preferred.
>
>Signed-off-by: Bob Peterson <rpeterso@redhat.com>
>[bwh: Backported to 4.4: adjust context]
>Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>

I've queued the series up, thanks Ben!

--
Thanks,
Sasha

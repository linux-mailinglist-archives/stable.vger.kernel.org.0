Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7663111C084
	for <lists+stable@lfdr.de>; Thu, 12 Dec 2019 00:26:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726928AbfLKX0h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 18:26:37 -0500
Received: from mo-csw1514.securemx.jp ([210.130.202.153]:42314 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726589AbfLKX0h (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Dec 2019 18:26:37 -0500
Received: by mo-csw.securemx.jp (mx-mo-csw1514) id xBBNQGx9023348; Thu, 12 Dec 2019 08:26:16 +0900
X-Iguazu-Qid: 34tMdwKSzMOQZNctuq
X-Iguazu-QSIG: v=2; s=0; t=1576106776; q=34tMdwKSzMOQZNctuq; m=kiQa5XRS9qAOPHWASNRbe18DoY7epzfGCCQxMfHhxyc=
Received: from imx12.toshiba.co.jp (imx12.toshiba.co.jp [61.202.160.132])
        by relay.securemx.jp (mx-mr1510) id xBBNQE0K001920;
        Thu, 12 Dec 2019 08:26:15 +0900
Received: from enc02.toshiba.co.jp ([61.202.160.51])
        by imx12.toshiba.co.jp  with ESMTP id xBBNQEC0000183;
        Thu, 12 Dec 2019 08:26:14 +0900 (JST)
Received: from hop101.toshiba.co.jp ([133.199.85.107])
        by enc02.toshiba.co.jp  with ESMTP id xBBNQEUg014415;
        Thu, 12 Dec 2019 08:26:14 +0900
Date:   Thu, 12 Dec 2019 08:26:13 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 070/243] xfs: extent shifting doesnt fully
 invalidate page cache
X-TSB-HOP: ON
Message-ID: <20191211232613.pxegji52vf4gd3eh@toshiba.co.jp>
References: <20191211150339.185439726@linuxfoundation.org>
 <20191211150343.827226097@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191211150343.827226097@linuxfoundation.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 11, 2019 at 04:03:52PM +0100, Greg Kroah-Hartman wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> [ Upstream commit 7f9f71be84bcab368e58020a42f6d0dd97adf0ce ]
> 
> The extent shifting code uses a flush and invalidate mechainsm prior
> to shifting extents around. This is similar to what
> xfs_free_file_space() does, but it doesn't take into account things
> like page cache vs block size differences, and it will fail if there
> is a page that it currently busy.
> 
> xfs_flush_unmap_range() handles all of these cases, so just convert
> xfs_prepare_shift() to us that mechanism rather than having it's own
> special sauce.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>


This commit also required following commit:

commit 1749d1ea89bdf3181328b7d846e609d5a0e53e50
Author: Brian Foster <bfoster@redhat.com>
Date:   Fri Apr 26 07:30:24 2019 -0700

    xfs: add missing error check in xfs_prepare_shift()

    xfs_prepare_shift() fails to check the error return from
    xfs_flush_unmap_range(). If the latter fails, that could lead to an
    insert/collapse range operation over a delalloc range, which is not
    supported.

    Add an error check and return appropriately. This is reproduced
    rarely by generic/475.

    Fixes: 7f9f71be84bc ("xfs: extent shifting doesn't fully invalidate page cache")
    Signed-off-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
    Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
    Reviewed-by: Allison Collins <allison.henderson@oracle.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>

Best regards,
  Nobuhirio

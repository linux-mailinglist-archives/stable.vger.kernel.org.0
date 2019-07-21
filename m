Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E93366F650
	for <lists+stable@lfdr.de>; Mon, 22 Jul 2019 00:13:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726167AbfGUWNy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Jul 2019 18:13:54 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:46730 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725989AbfGUWNx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Jul 2019 18:13:53 -0400
X-Greylist: delayed 1829 seconds by postgrey-1.27 at vger.kernel.org; Sun, 21 Jul 2019 18:13:53 EDT
Received: from dread.disaster.area (pa49-195-139-63.pa.nsw.optusnet.com.au [49.195.139.63])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id DA6E814ADF1;
        Mon, 22 Jul 2019 07:43:20 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1hpJav-0008J8-8F; Mon, 22 Jul 2019 07:42:13 +1000
Date:   Mon, 22 Jul 2019 07:42:13 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     linux-xfs@vger.kernel.org, gregkh@linuxfoundation.org,
        Alexander.Levin@microsoft.com, stable@vger.kernel.org,
        amir73il@gmail.com, hch@infradead.org, zlang@redhat.com,
        Brian Foster <bfoster@redhat.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: don't trip over uninitialized buffer on extent read
 of corrupted inode
Message-ID: <20190721214213.GO7689@dread.disaster.area>
References: <20190718230617.7439-1-mcgrof>
 <20190719193032.11096-1-mcgrof@kernel.org>
 <20190719230729.GS19023@42.do-not-panic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190719230729.GS19023@42.do-not-panic.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0 cx=a_idp_d
        a=fNT+DnnR6FjB+3sUuX8HHA==:117 a=fNT+DnnR6FjB+3sUuX8HHA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=0o9FgrsRnhwA:10
        a=7-415B0cAAAA:8 a=-Irqs6BH2dvYNhbzDXcA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 19, 2019 at 11:07:29PM +0000, Luis Chamberlain wrote:
> On Fri, Jul 19, 2019 at 07:30:32PM +0000, Luis Chamberlain wrote:
> > [mcgrof: fixes kz#204223 ]
> 
> This patch can be ingored for now for stable. It does not actually
> fix the issue, just delays it a bit. Once I stress test over 1000
> runs with some other fixes I have I'll send a new set of stable
> fixes.

generic/388 is one of the tests we expect to uncover interesting
failures over time.  i.e. every time we fix a problem in these
tests, it will expose another issue that we haven't been able to
exercise until easier-to-hit failures have been fixed.

The best you can do right now is minimise the occurence of failures
by backporting fixes - this test (like generic/475) will continue to
uncover new shutdown and recovery issues as they are exposed by
new fixes. Expecting it to pass 1000 times without failure on an
older stable kernel is, IMO, a somewhat unrealistic expectation...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

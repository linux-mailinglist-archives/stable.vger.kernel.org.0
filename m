Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93C6745510E
	for <lists+stable@lfdr.de>; Thu, 18 Nov 2021 00:20:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241565AbhKQXXl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Nov 2021 18:23:41 -0500
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:26806 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239894AbhKQXXi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Nov 2021 18:23:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1637191240; x=1668727240;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ZE9SIgTL+Wxoq7/4dH4765g3Cf380Fcb/0+EcXT1Ea0=;
  b=ZJyqdQIHXXYQgEJvLaE2+3Mfbp3gPWIumOjUNp4rGG7expIXUDGipyQV
   ezJVIazD7enkpXTDLmfrLuUDSHc1fbegpGcFwFEwpdJj058eGCKo4ImGq
   5jr7DXo/5Hft8MABNj0jF59FQDTM4DYbjRAo2+4z+fxbs7XXeTyBnFSDY
   M=;
X-IronPort-AV: E=Sophos;i="5.87,243,1631577600"; 
   d="scan'208";a="152802226"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2b-5a09360d.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP; 17 Nov 2021 23:20:39 +0000
Received: from EX13MTAUEE002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2b-5a09360d.us-west-2.amazon.com (Postfix) with ESMTPS id BA29B41AA4;
        Wed, 17 Nov 2021 23:20:37 +0000 (UTC)
Received: from EX13D14UEE003.ant.amazon.com (10.43.62.11) by
 EX13MTAUEE002.ant.amazon.com (10.43.62.24) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Wed, 17 Nov 2021 23:20:37 +0000
Received: from EX13MTAUEE002.ant.amazon.com (10.43.62.24) by
 EX13D14UEE003.ant.amazon.com (10.43.62.11) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Wed, 17 Nov 2021 23:20:37 +0000
Received: from dev-dsk-shaoyi-2b-c0ca772a.us-west-2.amazon.com (172.22.152.76)
 by mail-relay.amazon.com (10.43.62.224) with Microsoft SMTP Server id
 15.0.1497.26 via Frontend Transport; Wed, 17 Nov 2021 23:20:37 +0000
Received: by dev-dsk-shaoyi-2b-c0ca772a.us-west-2.amazon.com (Postfix, from userid 13116433)
        id 0D29441AC1; Wed, 17 Nov 2021 23:20:36 +0000 (UTC)
Date:   Wed, 17 Nov 2021 23:20:36 +0000
From:   Shaoying Xu <shaoyi@amazon.com>
To:     Greg KH <greg@kroah.com>
CC:     <stable@vger.kernel.org>
Subject: Re: [PATCH 5.4] ext4: fix lazy initialization next schedule time
 computation in more granular unit
Message-ID: <20211117232036.GA14594@amazon.com>
References: <20211115214212.GA18940@amazon.com> <YZVDshkxnSxnIdfq@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <YZVDshkxnSxnIdfq@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Thank you! Can the patch also be added to kernel 4.19 and 4.14 please? 

On Wed, Nov 17, 2021 at 07:02:26PM +0100, Greg KH wrote:
> CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
> 
> 
> 
> On Mon, Nov 15, 2021 at 09:42:12PM +0000, Shaoying Xu wrote:
> > commit 39fec6889d15a658c3a3ebb06fd69d3584ddffd3 upstream.
> >
> > Ext4 file system has default lazy inode table initialization setup once
> > it is mounted. However, it has issue on computing the next schedule time
> > that makes the timeout same amount in jiffies but different real time in
> > secs if with various HZ values. Therefore, fix by measuring the current
> > time in a more granular unit nanoseconds and make the next schedule time
> > independent of the HZ value.
> >
> > Fixes: bfff68738f1c ("ext4: add support for lazy inode table initialization")
> > Signed-off-by: Shaoying Xu <shaoyi@amazon.com>
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> > Link: https://lore.kernel.org/r/20210902164412.9994-2-shaoyi@amazon.com
> > Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> > ---
> > Member lr_sbi was removed from the struct ext4_li_request since kernel 5.9
> > so the way to access s_li_wait_mult was also changed. To adapt to the old
> > kernel versions, adjust the upstream fix by following the old ext4_li_request
> > strucutre.
> 
> Now queued up, thanks.
> 
> greg k-h

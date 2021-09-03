Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D72DB3FF99A
	for <lists+stable@lfdr.de>; Fri,  3 Sep 2021 06:39:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231953AbhICEkS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Sep 2021 00:40:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbhICEkS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Sep 2021 00:40:18 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DDC4C061575;
        Thu,  2 Sep 2021 21:39:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=OJvdQPrTeeSIW2aKxp3H75/EFGJNAh2MQGun3kF8gc0=; b=W8GXkwjGUGrcZ0YktI/byhySfl
        Z/jry2yBMifvlxl8QXdmc5ZxMkmCBf+Wy5K0VlaE+Y3/MCNtf7XO0YM427IX3v106SfIUKXo9axJT
        pSn8U7K6glCI4oxHqxGT5pmbDqy+atR2geCfAEwW956s1uu0Evh6ttbocHqN5/3mGJkfDe3qnAyCF
        3tItNaKTVzk3rGFY/TtJrXCfmak8tMMv+faduqTXcbz4SmZHxgd55FIAWF1Vec6fp+0ANlwO064TV
        OScCOndgwmf8H39+bZ4wVbJ3yxqBuGu7d0CjbsgiU3BkL/4wzfgzO8sK6kMyQA6bUXWG9tRzgG47F
        cEeBGBzw==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mM0yI-0047Vt-Ps; Fri, 03 Sep 2021 04:38:47 +0000
Date:   Fri, 3 Sep 2021 05:38:34 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Christian L?hle <CLoehle@hyperstone.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] sd: sd_open: prevent device removal during sd_open
Message-ID: <YTGmyp0kzhVsuk5K@infradead.org>
References: <98bfca4cbaa24462994bcb533d365414@hyperstone.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <98bfca4cbaa24462994bcb533d365414@hyperstone.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 02, 2021 at 01:57:13PM +0000, Christian L?hle wrote:
> sd and parent devices must not be removed as sd_open checks for events
> 
> sd_need_revalidate and sd_revalidate_disk traverse the device path
> to check for event changes. If during this, e.g. the scsi host is being
> removed and its resources freed, this traversal crashes.
> Locking with scan_mutex for just a scsi disk open may seem blunt, but there
> does not seem to be a more granular option. Also opening /dev/sdX directly
> happens rarely enough that this shouldn't cause any issues.

Can you please root cause how the device could not be valid, as that
should not happen?

>
> The issue occurred on an older kernel with the following trace:
> stack segment: 0000 [#1] PREEMPT SMP PTI
> CPU: 1 PID: 121457 Comm: python3 Not tainted 4.14.238hyLinux #1

.. preferably with a current mainline kernel as things changed a lot
in this area.

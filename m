Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8695190573
	for <lists+stable@lfdr.de>; Fri, 16 Aug 2019 18:09:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727440AbfHPQJE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Aug 2019 12:09:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35996 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727357AbfHPQJD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Aug 2019 12:09:03 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C4478882EA;
        Fri, 16 Aug 2019 16:09:03 +0000 (UTC)
Received: from ming.t460p (ovpn-8-16.pek2.redhat.com [10.72.8.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3C2223786;
        Fri, 16 Aug 2019 16:08:56 +0000 (UTC)
Date:   Sat, 17 Aug 2019 00:08:51 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, stable@vger.kernel.org,
        Mark Ray <mark.ray@hpe.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] blk-mq: remove blk_mq_hw_sysfs_cpus
Message-ID: <20190816160826.GB29878@ming.t460p>
References: <20190816074849.7197-1-ming.lei@redhat.com>
 <5baa0c28-6e12-5a61-0254-de0e49cf1596@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5baa0c28-6e12-5a61-0254-de0e49cf1596@kernel.dk>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Fri, 16 Aug 2019 16:09:03 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 16, 2019 at 08:20:42AM -0600, Jens Axboe wrote:
> On 8/16/19 1:48 AM, Ming Lei wrote:
> > It is reported that sysfs buffer overflow can be triggered in case
> > of too many CPU cores(>841 on 4K PAGE_SIZE) when showing CPUs in
> > blk_mq_hw_sysfs_cpus_show().
> > 
> > This info isn't useful, given users may retrieve the CPU list
> > from sw queue entries under same kobject dir, so far not see
> > any active users.
> > 
> > So remove the entry as suggested by Greg.
> 
> I think that's a bit frivolous, there could very well be scripts or
> apps that use it. Let's just fix the overflow.

I am fine with either way.

There are two fixes:

1) without format change:
https://lore.kernel.org/linux-block/c5b1b6f3-d461-9379-7e5c-6c6bee6a7bd5@kernel.dk/T/#t

2) format change:
https://lore.kernel.org/linux-block/20190816070948.GD1368@kroah.com/T/#t

If either one isn't fine, please let me know, and I will cook new one for you.


Thanks,
Ming

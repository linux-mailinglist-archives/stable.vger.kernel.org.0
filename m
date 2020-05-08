Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23EF21CBB6C
	for <lists+stable@lfdr.de>; Sat,  9 May 2020 01:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728353AbgEHXxJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 19:53:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:54958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727778AbgEHXxJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 19:53:09 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C36D12063A;
        Fri,  8 May 2020 23:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588981987;
        bh=HhHKaurLAmb7NjsgrxbGjxSSVFmDRRfuuN9UCDjB39o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NlxsLycULu/0pDE5VncKMqsY68TvDzrBX4Z64itAzdFVs23jjGQe08PfomP/NtWT8
         t+PlAdQE7wuMV/9rpzTnihUcJMRtJqlsdArVibUT/u4A0ZhILXtPYgryyu3m8JvFgO
         cvEh5TrYedonuRC3JSEcG71eqRoSLBbbgIM2fD/M=
Date:   Fri, 8 May 2020 16:53:06 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     David Hildenbrand <david@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-nvdimm@lists.01.org, kexec@lists.infradead.org,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        stable@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v4 1/4] device-dax: Don't leak kernel memory to user
 space after unloading kmem
Message-Id: <20200508165306.7cd806f7e451c5c9bc2a40ac@linux-foundation.org>
In-Reply-To: <20200508084217.9160-2-david@redhat.com>
References: <20200508084217.9160-1-david@redhat.com>
        <20200508084217.9160-2-david@redhat.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri,  8 May 2020 10:42:14 +0200 David Hildenbrand <david@redhat.com> wrote:

> Assume we have kmem configured and loaded:
>   [root@localhost ~]# cat /proc/iomem
>   ...
>   140000000-33fffffff : Persistent Memory$
>     140000000-1481fffff : namespace0.0
>     150000000-33fffffff : dax0.0
>       150000000-33fffffff : System RAM
> 
> Assume we try to unload kmem. This force-unloading will work, even if
> memory cannot get removed from the system.
>   [root@localhost ~]# rmmod kmem
>   [   86.380228] removing memory fails, because memory [0x0000000150000000-0x0000000157ffffff] is onlined
>   ...
>   [   86.431225] kmem dax0.0: DAX region [mem 0x150000000-0x33fffffff] cannot be hotremoved until the next reboot
> 
> Now, we can reconfigure the namespace:
>   [root@localhost ~]# ndctl create-namespace --force --reconfig=namespace0.0 --mode=devdax
>   [  131.409351] nd_pmem namespace0.0: could not reserve region [mem 0x140000000-0x33fffffff]dax
>   [  131.410147] nd_pmem: probe of namespace0.0 failed with error -16namespace0.0 --mode=devdax
>   ...
> 
> This fails as expected due to the busy memory resource, and the memory
> cannot be used. However, the dax0.0 device is removed, and along its name.
> 
> The name of the memory resource now points at freed memory (name of the
> device).
>   [root@localhost ~]# cat /proc/iomem
>   ...
>   140000000-33fffffff : Persistent Memory
>     140000000-1481fffff : namespace0.0
>     150000000-33fffffff : �_�^7_��/_��wR��WQ���^��� ...
>     150000000-33fffffff : System RAM
> 
> We have to make sure to duplicate the string. While at it, remove the
> superfluous setting of the name and fixup a stale comment.
> 
> Fixes: 9f960da72b25 ("device-dax: "Hotremove" persistent memory that is used like normal RAM")
> Cc: stable@vger.kernel.org # v5.3

hm.

Is this really -stable material?  These are all privileged operations,
I expect?

Assuming "yes", I've queued this separately, staged for 5.7-rcX.  I'll
redo patches 2-4 as a three-patch series for 5.8-rc1.

> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Vishal Verma <vishal.l.verma@intel.com>
> Cc: Dave Jiang <dave.jiang@intel.com>
> Cc: Pavel Tatashin <pasha.tatashin@soleen.com>

Reviewers, please ;)



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7687352BE9
	for <lists+stable@lfdr.de>; Fri,  2 Apr 2021 18:09:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235667AbhDBOmx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Apr 2021 10:42:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235724AbhDBOmw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Apr 2021 10:42:52 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A140AC0613E6
        for <stable@vger.kernel.org>; Fri,  2 Apr 2021 07:42:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Bw7ISwmFV0i1SzllnQ2AVohh/lybr5ParuExcTXKJKg=; b=LAQSsv5uOnx0JrA0LDyFhl9r+2
        5l2kW1mnPfTNrIY4ns6ovHqeN6VeP2uFLLgkTCXr3I41UD5qywqrdoMfLZ47Rg8Arl0o+ADTXKhRN
        AznFUAAgCp4RoJ3qyGytoRiDcpBwOM093dTv/gz2NoocS+BFielEdSJnpP9NMF4NYP/I8vyvcFcKy
        pN3/tYJgbUbiQRqDFLtsbnoB8SWTbjgtkT1uRrtIOM2dmy+Wqvv5d/ObsRsI28NQiIalmGXkVTW0A
        t+AX7MpwM3pAIDWv/ScOqj4twGYgbx4v90qeyRissqF1s10M6ZESK+0WUyAUXG+RnwUXz6BVYaXBX
        EQtk5nwg==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lSKzA-007kKL-30; Fri, 02 Apr 2021 14:42:21 +0000
Date:   Fri, 2 Apr 2021 15:41:20 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     yangerkun <yangerkun@huawei.com>, stable@vger.kernel.org,
        vbabka@suse.cz, linux-mm@kvack.org, open-iscsi@googlegroups.com,
        cleech@redhat.com, "zhangyi (F)" <yi.zhang@huawei.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        liuyongqiang13@huawei.com,
        "Zhengyejian (Zetta)" <zhengyejian1@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        chenzhou10@huawei.com
Subject: Re: [QUESTION] WARNNING after 3d8e2128f26a ("sysfs: Add sysfs_emit
 and sysfs_emit_at to format sysfs output")
Message-ID: <20210402144120.GO351017@casper.infradead.org>
References: <5837f5d9-2235-3ac2-f3f2-712e6cf4da5c@huawei.com>
 <YGbLiIL8ewIX1Hrt@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YGbLiIL8ewIX1Hrt@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 02, 2021 at 09:45:12AM +0200, Greg KH wrote:
> Why is the buffer alignment considered a "waste" here?  If that change
> is in Linus's tree and newer kernels (it showed up in 5.4 which was
> released quite a while ago), where are the people complaining about it
> there?
> 
> I think backporting 59bb47985c1d ("mm, sl[aou]b: guarantee natural
> alignment for kmalloc(power-of-two)") seems like the correct thing to do
> here to bring things into alignment (pun intended) with newer kernels.

It's only a waste for slabs which need things like redzones (eg we could
get 7 512-byte allocations out of a 4kB page with a 64 byte redzone
and no alignment ; with alignment we can only get four).  Since slub
can enable/disable redzones on a per-slab basis, and redzones aren't
terribly interesting now that we have kasan/kfence, nobody really cares.


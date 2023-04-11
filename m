Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEA776DCFAE
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 04:25:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbjDKCZk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Apr 2023 22:25:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbjDKCZj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Apr 2023 22:25:39 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8C892690;
        Mon, 10 Apr 2023 19:25:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=yhPVj9bkaKyOeFej+CfgkaNLlr/1Qr/o0GaaGMTZo/c=; b=mzNoeW+wr9QIHGNDW3WjRgQk2j
        29wt2EIFds8PQQD106I5Tns9glgc5NmbUGc5PQx8BTm3uOTseisyE1lkjoMB2igmYEAzKQZROd/A9
        6Xc+ocbXKbyT9pTCExrPwstOxHw550lolQ1uUUF3x8s7TdsFo/7azyKssLvW2KNYPwtl7cOBq44ZE
        DbCR80Pu5eDpYmhgXUtJbZXPXsSVMSVCfZTPNHIrJDhw5JuT0HS7rqIncz6Zd4nbogYkiGnNKi18s
        QwyEGJDcZ3aamkl3KXybuJKRHmtbkonb037tSgQwyD4QH6b3YzVOpL6tnDYfCo12YW4/bqv3z/K7G
        xyTWtC+w==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pm3h2-005AMa-7J; Tue, 11 Apr 2023 02:25:12 +0000
Date:   Tue, 11 Apr 2023 03:25:12 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     kernel test robot <oliver.sang@intel.com>
Cc:     "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        oe-lkp@lists.linux.dev, lkp@intel.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        ying.huang@intel.com, feng.tang@intel.com, fengwei.yin@intel.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        maple-tree@lists.infradead.org,
        Suren Baghdasaryan <surenb@google.com>, stable@vger.kernel.org,
        syzbot+8d95422d3537159ca390@syzkaller.appspotmail.com
Subject: Re: [PATCH 8/8] mm: enable maple tree RCU mode by default.
Message-ID: <ZDTFCOg7/I1WIviR@casper.infradead.org>
References: <20230327185532.2354250-9-Liam.Howlett@oracle.com>
 <202304110907.a7339b10-oliver.sang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202304110907.a7339b10-oliver.sang@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=DKIM_INVALID,DKIM_SIGNED,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 11, 2023 at 09:25:16AM +0800, kernel test robot wrote:
> kernel test robot noticed a -8.5% regression of stress-ng.mmapaddr.ops_per_sec on:

Assuming this is the test in question:

https://github.com/ColinIanKing/stress-ng/blob/master/stress-mmapaddr.c

then yes, this is expected.  The test calls mmap() and munmap() a lot,
and we've made those slower in order to fix a bug.

While it does take pagefaults (which is a better test than some
microbenchmarks), it only takes one pagefault per call to mmap() and
munmap(), which is not representative of real workloads.

Thanks for running the test.

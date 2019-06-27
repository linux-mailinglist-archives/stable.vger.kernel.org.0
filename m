Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DEAB582A8
	for <lists+stable@lfdr.de>; Thu, 27 Jun 2019 14:34:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726511AbfF0MeS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jun 2019 08:34:18 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:38506 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726059AbfF0MeS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jun 2019 08:34:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=QQUdy9qv7ABtkbJ3dGIuBeaEJk7dGMp7ONsxEfM/sUo=; b=GB++/qHL9hKxCF/RRNMnajjsu
        xKIvNL4xju2zGJKLaeidmxAup1NRvdhZjR3qz5yxAEki0voDqhp3K+7wBftYKcCS72jZrOA4UebYR
        6L73m6dtLHtZnrVEgDp+vgb4NX2jCDSJ9Wkb8IubBlfTXdwBFfLTnU/lJAH6LMyDKYsLpBbJO1qgw
        lgCL8lJdNVBxGDTi+PaQfAnimGwjCx09EVneNK413YhsRaMygyBBhgr74JEXnMhv92HXfD4mqTLlZ
        y4VGOKeHb8nEXmqYQzy2b65mZZ7IR8LavdkAcrSMkldtnd15+4M6uzfMhCcV+Okn/QUGtYvSJY5gx
        QaMJ3DiKw==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hgTbT-00045v-KE; Thu, 27 Jun 2019 12:34:15 +0000
Date:   Thu, 27 Jun 2019 05:34:15 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     linux-nvdimm@lists.01.org, Jan Kara <jack@suse.cz>,
        stable@vger.kernel.org, Robert Barror <robert.barror@intel.com>,
        Seema Pandit <seema.pandit@intel.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] filesystem-dax: Disable PMD support
Message-ID: <20190627123415.GA4286@bombadil.infradead.org>
References: <156159454541.2964018.7466991316059381921.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156159454541.2964018.7466991316059381921.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 26, 2019 at 05:15:45PM -0700, Dan Williams wrote:
> Ever since the conversion of DAX to the Xarray a RocksDB benchmark has
> been encountering intermittent lockups. The backtraces always include
> the filesystem-DAX PMD path, multi-order entries have been a source of
> bugs in the past, and disabling the PMD path allows a test that fails in
> minutes to run for an hour.

On May 4th, I asked you:

Since this is provoked by a fatal signal, it must have something to do
with a killable or interruptible sleep.  There's only one of those in the
DAX code; fatal_signal_pending() in dax_iomap_actor().  Does rocksdb do
I/O with write() or through a writable mmap()?  I'd like to know before
I chase too far down this fault tree analysis.


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD7A85A171
	for <lists+stable@lfdr.de>; Fri, 28 Jun 2019 18:54:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726618AbfF1QyT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jun 2019 12:54:19 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:38532 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726605AbfF1QyT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Jun 2019 12:54:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=4aCzK6AWV7v8l05GIE3EDguMtt1Ba9XnxuuiQ3Rlk3Q=; b=Z8w/Lg4IyFUwGyPbT6LlhpKWU
        wUw/qfThpPpDK1EVkDTJ1UJiw38r1aWCtwbytMCtGAED4QvCWUMKs5Oh/6QO0Wybph75WFSCNiE4z
        SSCY5E2KKmjqFf4YfC/RXkZbftMs0PDsnBkPp83MsdPmHC1whEcp4+szoDy/HcGbBBak06He3xVFX
        Dv2t+nDoKM8qsnEYpPu09UUtlaDwdS+RkH8iyE0U10HWCA+u5ZYlH/WcMlbenvCowHplBHyZKDmM9
        2YOpnvA7s/rZiLu/O8vCEzzqGKQwJz/jt4166JDneHDGirGpfGEMfS4Uo/xcZIJl7ErIdb9zvCDZq
        /5Yxuz+9w==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hgu8f-0002TR-BH; Fri, 28 Jun 2019 16:54:17 +0000
Date:   Fri, 28 Jun 2019 09:54:17 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     linux-nvdimm <linux-nvdimm@lists.01.org>, Jan Kara <jack@suse.cz>,
        stable <stable@vger.kernel.org>,
        Robert Barror <robert.barror@intel.com>,
        Seema Pandit <seema.pandit@intel.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] filesystem-dax: Disable PMD support
Message-ID: <20190628165417.GD4286@bombadil.infradead.org>
References: <156159454541.2964018.7466991316059381921.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20190627123415.GA4286@bombadil.infradead.org>
 <CAPcyv4jQP-SFJGor-Q3VCRQ0xwt3MuVpH2qHx2wzyRA88DGQww@mail.gmail.com>
 <CAPcyv4jjqooboxivY=AsfEPhCvxdwU66GpwE9vM+cqrZWvtX3g@mail.gmail.com>
 <CAPcyv4h6HgNE38RF5TxO3C268ZvrxgcPNrPWOt94MnO5gP_pjw@mail.gmail.com>
 <CAPcyv4gwd1_VHk_MfHeNSxyH+N1=aatj9WkKXqYNPkSXe4bFDg@mail.gmail.com>
 <20190627195948.GB4286@bombadil.infradead.org>
 <CAPcyv4iB3f1hDdCsw=Cy234dP-RXpxGyXDoTwEU8nt5qUDEVQg@mail.gmail.com>
 <20190628163721.GC4286@bombadil.infradead.org>
 <CAPcyv4jeRwhYWnGw9RrfDA54RRa9LK4JPuF3zQ-av=HdRqCTJw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4jeRwhYWnGw9RrfDA54RRa9LK4JPuF3zQ-av=HdRqCTJw@mail.gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 28, 2019 at 09:39:01AM -0700, Dan Williams wrote:
> On Fri, Jun 28, 2019 at 9:37 AM Matthew Wilcox <willy@infradead.org> wrote:
> > That was the conclusion I came to; that one thread holding the mmap sem
> > for read isn't being woken up when it should be.  Just need to find it ...
> > obviously it's something to do with the PMD entries.
> 
> Can you explain to me one more time, yes I'm slow on the uptake on
> this, the difference between xas_load() and xas_find_conflict() and
> why it's ok for dax_lock_page() to use xas_load() while
> grab_mapping_entry() uses xas_find_conflict()?

When used with a non-zero 'order', xas_find_conflict() will return
an entry whereas xas_load() might return a pointer to a node.
dax_lock_page() always uses a zero order, so they would always do the
same thing (xas_find_conflict() would be less efficient).

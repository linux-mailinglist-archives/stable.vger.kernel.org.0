Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61B6E58B51
	for <lists+stable@lfdr.de>; Thu, 27 Jun 2019 21:59:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726441AbfF0T7v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jun 2019 15:59:51 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:41422 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726384AbfF0T7v (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jun 2019 15:59:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=1zaJPISJ/EM3luyF1vz7G/5Xji346kDTt6heztPdAbM=; b=Opin+Qydyf8b8u+uTC3Ub0SNO
        bNiTRXwZJKK3vmcNgV3Q+9ZsiLEpy0Z/TptTzlqTB/at+xjh5msPBhEbfBZw2ume9YxOvHLAyj+mR
        vneJqGV8dfXGHd2fo6u2nzXrMquEyTDAhcs/rjOCT1tNz10efzK73Zc+asQMhIG2/TKghMpiHcCEt
        jQMbY9H3RIcg2UIxJBohct5anRwA9gw7fz+Rq2giBj3pqDhWPfqxDk3f6ts7XQjV6A5U21Aq3bcfP
        eqUCt08yZKTPer3mQ6Bg+Sly5ULCt7EJx5YiuALhtj6Cg2It6s4hByBpQujCnvyeNIeuWALavj14k
        pspOiFNAg==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hgaYe-0007ij-P9; Thu, 27 Jun 2019 19:59:48 +0000
Date:   Thu, 27 Jun 2019 12:59:48 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     linux-nvdimm <linux-nvdimm@lists.01.org>, Jan Kara <jack@suse.cz>,
        stable <stable@vger.kernel.org>,
        Robert Barror <robert.barror@intel.com>,
        Seema Pandit <seema.pandit@intel.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] filesystem-dax: Disable PMD support
Message-ID: <20190627195948.GB4286@bombadil.infradead.org>
References: <156159454541.2964018.7466991316059381921.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20190627123415.GA4286@bombadil.infradead.org>
 <CAPcyv4jQP-SFJGor-Q3VCRQ0xwt3MuVpH2qHx2wzyRA88DGQww@mail.gmail.com>
 <CAPcyv4jjqooboxivY=AsfEPhCvxdwU66GpwE9vM+cqrZWvtX3g@mail.gmail.com>
 <CAPcyv4h6HgNE38RF5TxO3C268ZvrxgcPNrPWOt94MnO5gP_pjw@mail.gmail.com>
 <CAPcyv4gwd1_VHk_MfHeNSxyH+N1=aatj9WkKXqYNPkSXe4bFDg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4gwd1_VHk_MfHeNSxyH+N1=aatj9WkKXqYNPkSXe4bFDg@mail.gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 27, 2019 at 12:09:29PM -0700, Dan Williams wrote:
> > This bug feels like we failed to unlock, or unlocked the wrong entry
> > and this hunk in the bisected commit looks suspect to me. Why do we
> > still need to drop the lock now that the radix_tree_preload() calls
> > are gone?
> 
> Nevermind, unmapp_mapping_pages() takes a sleeping lock, but then I
> wonder why we don't restart the lookup like the old implementation.

We have the entry locked:

                /*
                 * Make sure 'entry' remains valid while we drop
                 * the i_pages lock.
                 */
                dax_lock_entry(xas, entry);

                /*
                 * Besides huge zero pages the only other thing that gets
                 * downgraded are empty entries which don't need to be
                 * unmapped.
                 */
                if (dax_is_zero_entry(entry)) {
                        xas_unlock_irq(xas);
                        unmap_mapping_pages(mapping,
                                        xas->xa_index & ~PG_PMD_COLOUR,
                                        PG_PMD_NR, false);
                        xas_reset(xas);
                        xas_lock_irq(xas);
                }

If something can remove a locked entry, then that would seem like the
real bug.  Might be worth inserting a lookup there to make sure that it
hasn't happened, I suppose?

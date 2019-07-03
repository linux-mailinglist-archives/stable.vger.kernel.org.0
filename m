Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0283F5E812
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 17:47:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbfGCPrE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jul 2019 11:47:04 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:46780 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725847AbfGCPrD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Jul 2019 11:47:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=c5kOloQ+WKclVgeWbSMLX2CoWuvmPxmxrcEhF8nzqns=; b=HV+JnjgFvWKjV4CCm3LWNei+D
        dUQKdFpMgH9c7rrzBjIXKkcJmHfgvDLB/WAqpvJ85YhAxls3FjsnA0ioLob9VZbnQQJbtcq2/fkgL
        oswHKQkgdurqbO1Lecz3uaI0H1QfUF93Gmia3dxrNobIbd+5s5Hmt2PyB2S+Uo3EgYdV9UMC6BR5h
        uWqfZOlarNzVMFxAFe9LAZVBzLVAMWnzYhg5OI7sbYmYdFyV2+nCogciXfogxQNahbsmIayIytAyg
        w2cjhCNkefcxaW6b9xkLQoMDP/TBLkKdwn0YSfYiXuaLYFvPrq9QgRlCaBW11Tr3+Q4EBFRoQbyw3
        qcfPIWf3A==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hihTJ-0000Vu-0v; Wed, 03 Jul 2019 15:47:01 +0000
Date:   Wed, 3 Jul 2019 08:47:00 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     Jan Kara <jack@suse.cz>
Cc:     Dan Williams <dan.j.williams@intel.com>,
        Seema Pandit <seema.pandit@intel.com>,
        linux-nvdimm <linux-nvdimm@lists.01.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Robert Barror <robert.barror@intel.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] filesystem-dax: Disable PMD support
Message-ID: <20190703154700.GI1729@bombadil.infradead.org>
References: <CAPcyv4jjqooboxivY=AsfEPhCvxdwU66GpwE9vM+cqrZWvtX3g@mail.gmail.com>
 <CAPcyv4h6HgNE38RF5TxO3C268ZvrxgcPNrPWOt94MnO5gP_pjw@mail.gmail.com>
 <CAPcyv4gwd1_VHk_MfHeNSxyH+N1=aatj9WkKXqYNPkSXe4bFDg@mail.gmail.com>
 <20190627195948.GB4286@bombadil.infradead.org>
 <CAPcyv4iB3f1hDdCsw=Cy234dP-RXpxGyXDoTwEU8nt5qUDEVQg@mail.gmail.com>
 <20190629160336.GB1180@bombadil.infradead.org>
 <CAPcyv4ge3Ht1k_v=tSoVA6hCzKg1N3imhs_rTL3oTB+5_KC8_Q@mail.gmail.com>
 <CAA9_cmcb-Prn6CnOx-mJfb9CRdf0uG9u4M1Vq1B1rKVemCD-Vw@mail.gmail.com>
 <20190630152324.GA15900@bombadil.infradead.org>
 <20190701121119.GE31621@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190701121119.GE31621@quack2.suse.cz>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 01, 2019 at 02:11:19PM +0200, Jan Kara wrote:
> BTW, looking into the xarray code, I think I found another difference
> between the old radix tree code and the new xarray code that could cause
> issues. In the old radix tree code if we tried to insert PMD entry but
> there was some PTE entry in the covered range, we'd get EEXIST error back
> and the DAX fault code relies on this. I don't see how similar behavior is
> achieved by xas_store()...

Are you referring to this?

-               entry = dax_make_locked(0, size_flag | DAX_EMPTY);
-
-               err = __radix_tree_insert(&mapping->i_pages, index,
-                               dax_entry_order(entry), entry);
-               radix_tree_preload_end();
-               if (err) {
-                       xa_unlock_irq(&mapping->i_pages);
-                       /*
-                        * Our insertion of a DAX entry failed, most likely
-                        * because we were inserting a PMD entry and it
-                        * collided with a PTE sized entry at a different
-                        * index in the PMD range.  We haven't inserted
-                        * anything into the radix tree and have no waiters to
-                        * wake.
-                        */
-                       return ERR_PTR(err);
-               }

If so, that can't happen any more because we no longer drop the i_pages
lock while the entry is NULL, so the entry is always locked while the
i_pages lock is dropped.

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D007A565CF9
	for <lists+stable@lfdr.de>; Mon,  4 Jul 2022 19:26:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234022AbiGDR0S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jul 2022 13:26:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233785AbiGDR0S (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jul 2022 13:26:18 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D551120BD;
        Mon,  4 Jul 2022 10:26:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=2O7jbtUUBQdght/8/u2Xd4jdIRo54n9MTaKJeIIYcDY=; b=e/Jz5LeczVAr2Gb17LAJQAOzek
        V76VFKC10UMt+zc8aSes6NPC8R7cwGFH5NQ8dP9c5Btc5RFT/RBkvqYfgW/FeQsniafImfOSE3OJx
        MKyqPinerqrKwho/jrTbS5rvlPNLxEMwUOIHfGXFRGGkuNGdUE/5nDDDbNrZkD9IkdhypDeUaj4Se
        AH5fgPj+v2Jn12Jq/2r2w6SCgXM0Dw6jKOyWW8YXTW0GT9Pmy1wcqYaN3J+ZzqlNhziyWUKBrskDR
        NVAErJeff4lczaD/MxuIjsbUGEn8LoRlcLfs9F+INleXMUSfd/tlMm4qyFBFxslgACkwhJf7+Z5N5
        FevJu5cA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o8Ppo-00HSn3-IM; Mon, 04 Jul 2022 17:26:08 +0000
Date:   Mon, 4 Jul 2022 18:26:08 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Alexander Gordeev <agordeev@linux.ibm.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Baoquan He <bhe@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: Re: [PATCH 5.18 112/181] vmcore: convert copy_oldmem_page() to take
 an iov_iter
Message-ID: <YsMisFQdaUZpxroY@casper.infradead.org>
References: <20220627111944.553492442@linuxfoundation.org>
 <20220627111947.945731832@linuxfoundation.org>
 <YrnaYJA675eGIy03@osiris>
 <YrqpEZV3yu31t6E2@kroah.com>
 <Yrq70Ctw3UYPFnzC@li-4a3a4a4c-28e5-11b2-a85c-a8d192c6f089.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yrq70Ctw3UYPFnzC@li-4a3a4a4c-28e5-11b2-a85c-a8d192c6f089.ibm.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 28, 2022 at 10:29:04AM +0200, Alexander Gordeev wrote:
> On Tue, Jun 28, 2022 at 09:09:05AM +0200, Greg Kroah-Hartman wrote:
> > > This one breaks s390. You would also need to apply the following two commits:
> > > 
> > > cc02e6e21aa5 ("s390/crash: add missing iterator advance in copy_oldmem_page()")
> > > af2debd58bd7 ("s390/crash: make copy_oldmem_page() return number of bytes copied")
> > 
> > Both of them are also in the 5.18-rc queue here, right?
> 
> Yes, these are:
> 
> 	[PATCH 5.18 113/181] s390/crash: add missing iterator advance in copy_oldmem_page() Greg Kroah-Hartman

It's generally considered polite to cc the original author when you
fix one of their patches.  I wasn't aware of this patch.

While the code change looks right, the commit message is wrong;
copy_oldmem_user() and copy_oldmem_kernel() need to GO AWAY.  You
need to be more like the other architectures and end up calling
copy_to_iter().  I have no idea what this memcpy_hsa_kernel()
and memcpy_hsa_user() are all about, but I was hoping that somebody
from the s390 team would react to:

    s390 needs more work to pass the iov_iter down further, or refactor, but
    I'd be more comfortable if someone who can test on s390 did that work.

Maybe you'll do it.

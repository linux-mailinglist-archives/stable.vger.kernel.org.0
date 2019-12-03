Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0216110FE66
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 14:08:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725957AbfLCNIB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 08:08:01 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:52300 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725954AbfLCNIB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Dec 2019 08:08:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=EcIcKJaf0Vzu8gfZz02oe7Gwnt0ERuFDFTLCCrtsorU=; b=CUrXyLSfM0j73HpzyXClUZ9ZB
        Ya7bqqBtCIpv+OfHzcjkp8AY3lZyjlOwMWwBORH1exJBQlXKuRhyu6hN9mAkkBSWypIvRJzID6bH9
        MEt5gGpJM9F/LG9UBnRGyO8JMV5Z+uNRSREp1xk9HOWxG+3rqxnTxffGV/PxbjCab2+0G2FF+0Gop
        wJ/pNAa+v8fo1IVysoeY5Y6awX6A+pEspjRT1OxergIKgPLlAjskkMhIDebmlyQbgkHTxlCKkvB3r
        dnHufob/L8HJlVtJiXPbEofyXbHdLMcke2iNXBFYorJeiP3N/wURx5wmHHpK8ocxtTYf31SN1trqZ
        LtHuZlL1A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ic7uI-0000jv-0C; Tue, 03 Dec 2019 13:07:58 +0000
Date:   Tue, 3 Dec 2019 05:07:57 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Jan Stancek <jstancek@redhat.com>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        hch@infradead.org, darrick.wong@oracle.com,
        linuxppc-dev@lists.ozlabs.org,
        Memory Management <mm-qe@redhat.com>,
        LTP Mailing List <ltp@lists.linux.it>,
        Linux Stable maillist <stable@vger.kernel.org>,
        CKI Project <cki-project@redhat.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [bug] userspace hitting sporadic SIGBUS on xfs (Power9,
 ppc64le), v4.19 and later
Message-ID: <20191203130757.GA2267@infradead.org>
References: <cki.6C6A189643.3T2ZUWEMOI@redhat.com>
 <1738119916.14437244.1575151003345.JavaMail.zimbra@redhat.com>
 <8736e3ffen.fsf@mpe.ellerman.id.au>
 <1420623640.14527843.1575289859701.JavaMail.zimbra@redhat.com>
 <1766807082.14812757.1575377439007.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1766807082.14812757.1575377439007.JavaMail.zimbra@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 03, 2019 at 07:50:39AM -0500, Jan Stancek wrote:
> My theory is that there's a race in iomap. There appear to be
> interleaved calls to iomap_set_range_uptodate() for same page
> with varying offset and length. Each call sees bitmap as _not_
> entirely "uptodate" and hence doesn't call SetPageUptodate().
> Even though each bit in bitmap ends up uptodate by the time
> all calls finish.

Weird.  That should be prevented by the page lock that all callers
of iomap_set_range_uptodate.  But in case I miss something, does
the patch below trigger?  If not it is not jut a race, but might
be some weird ordering problem with the bitops, especially if it
only triggers on ppc, which is very weakly ordered.

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index d33c7bc5ee92..25e942c71590 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -148,6 +148,8 @@ iomap_set_range_uptodate(struct page *page, unsigned off, unsigned len)
 	unsigned int i;
 	bool uptodate = true;
 
+	WARN_ON_ONCE(!PageLocked(page));
+
 	if (iop) {
 		for (i = 0; i < PAGE_SIZE / i_blocksize(inode); i++) {
 			if (i >= first && i <= last)

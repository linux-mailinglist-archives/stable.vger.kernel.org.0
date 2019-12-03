Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1920711003D
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 15:35:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725848AbfLCOfg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 09:35:36 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:39181 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726131AbfLCOff (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Dec 2019 09:35:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575383734;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=caPtWip/0Fp5+ectyuqp7DEQ7XYV0c3s4L4d01Olulc=;
        b=WEtSHrR4TSDSof+iccORI8sudNhGB3DS/BfmEnjhBt2QkoZpIu7udxLXr5YTxk2xYF7DnV
        IV9rbAppB2/3xcr3aGkCCM6CHcX0r2GTtmZhBUzEkvFMieixoKhiEP+vTidAPbXTlEqzR7
        7sF24kpqY7cTh3n243+iGKTnzIHiGu8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-153-nTjUyosROfSoxodUoDcwQA-1; Tue, 03 Dec 2019 09:35:30 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3ED932F2E;
        Tue,  3 Dec 2019 14:35:29 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 123BB600CC;
        Tue,  3 Dec 2019 14:35:28 +0000 (UTC)
Received: from zmail17.collab.prod.int.phx2.redhat.com (zmail17.collab.prod.int.phx2.redhat.com [10.5.83.19])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5EEB35BBFA;
        Tue,  3 Dec 2019 14:35:28 +0000 (UTC)
Date:   Tue, 3 Dec 2019 09:35:28 -0500 (EST)
From:   Jan Stancek <jstancek@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        darrick wong <darrick.wong@oracle.com>,
        linuxppc-dev@lists.ozlabs.org,
        Memory Management <mm-qe@redhat.com>,
        LTP Mailing List <ltp@lists.linux.it>,
        Linux Stable maillist <stable@vger.kernel.org>,
        CKI Project <cki-project@redhat.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Message-ID: <433638211.14837331.1575383728189.JavaMail.zimbra@redhat.com>
In-Reply-To: <20191203130757.GA2267@infradead.org>
References: <cki.6C6A189643.3T2ZUWEMOI@redhat.com> <1738119916.14437244.1575151003345.JavaMail.zimbra@redhat.com> <8736e3ffen.fsf@mpe.ellerman.id.au> <1420623640.14527843.1575289859701.JavaMail.zimbra@redhat.com> <1766807082.14812757.1575377439007.JavaMail.zimbra@redhat.com> <20191203130757.GA2267@infradead.org>
Subject: Re: [bug] userspace hitting sporadic SIGBUS on xfs (Power9,
 ppc64le), v4.19 and later
MIME-Version: 1.0
X-Originating-IP: [10.43.17.163, 10.4.195.10]
Thread-Topic: userspace hitting sporadic SIGBUS on xfs (Power9, ppc64le), v4.19 and later
Thread-Index: cD3CqeEaO/UMqfbg0OYzRaML88GplQ==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: nTjUyosROfSoxodUoDcwQA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


----- Original Message -----
> On Tue, Dec 03, 2019 at 07:50:39AM -0500, Jan Stancek wrote:
> > My theory is that there's a race in iomap. There appear to be
> > interleaved calls to iomap_set_range_uptodate() for same page
> > with varying offset and length. Each call sees bitmap as _not_
> > entirely "uptodate" and hence doesn't call SetPageUptodate().
> > Even though each bit in bitmap ends up uptodate by the time
> > all calls finish.
> 
> Weird.  That should be prevented by the page lock that all callers
> of iomap_set_range_uptodate.  But in case I miss something, does
> the patch below trigger?  If not it is not jut a race, but might
> be some weird ordering problem with the bitops, especially if it
> only triggers on ppc, which is very weakly ordered.
> 
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index d33c7bc5ee92..25e942c71590 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -148,6 +148,8 @@ iomap_set_range_uptodate(struct page *page, unsigned off,
> unsigned len)
>  	unsigned int i;
>  	bool uptodate = true;
>  
> +	WARN_ON_ONCE(!PageLocked(page));
> +
>  	if (iop) {
>  		for (i = 0; i < PAGE_SIZE / i_blocksize(inode); i++) {
>  			if (i >= first && i <= last)
> 

Hit it pretty quick this time:

# uptime
 09:27:42 up 22 min,  2 users,  load average: 0.09, 13.38, 26.18

# /mnt/testarea/ltp/testcases/bin/genbessel                                                                                                                                     
Bus error (core dumped)

# dmesg | grep -i -e warn -e call                                                                                                                                               
[    0.000000] dt-cpu-ftrs: not enabling: system-call-vectored (disabled or unsupported by kernel)
[    0.000000] random: get_random_u64 called from cache_random_seq_create+0x98/0x1e0 with crng_init=0
[    0.000000] rcu:     Offload RCU callbacks from CPUs: (none).
[    5.312075] megaraid_sas 0031:01:00.0: megasas_disable_intr_fusion is called outbound_intr_mask:0x40000009
[    5.357307] megaraid_sas 0031:01:00.0: megasas_disable_intr_fusion is called outbound_intr_mask:0x40000009
[    5.485126] megaraid_sas 0031:01:00.0: megasas_enable_intr_fusion is called outbound_intr_mask:0x40000000

So, extra WARN_ON_ONCE applied on top of v5.4-8836-g81b6b96475ac
did not trigger.

Is it possible for iomap code to submit multiple bio-s for same
locked page and then receive callbacks in parallel?


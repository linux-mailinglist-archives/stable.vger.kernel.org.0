Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4744D1F5714
	for <lists+stable@lfdr.de>; Wed, 10 Jun 2020 16:54:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729956AbgFJOxw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jun 2020 10:53:52 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:44637 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729946AbgFJOxv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Jun 2020 10:53:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591800829;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IbTlbvpZrjIt//+klHw+rfy1TKM7Gl7DCLWB4vzgCck=;
        b=SW9VZ65fSxcqT+4V6nlzi257B2k8CtFJP5wH2Wgl27nwUMzZ/dzte9Vt3dqSU8SSp6Owem
        chNYU+tLPujGbbjb+LkgO279I8P1PquBVsfW7nijvz1vhCqcsSgUUBIvPN9qJGeLPmIerJ
        d1jPQ0jMu3Xq2Y1+QvVKEcNjF6F/ZI4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-290-5TsqfYi9M4uGVu0V354nDg-1; Wed, 10 Jun 2020 10:53:43 -0400
X-MC-Unique: 5TsqfYi9M4uGVu0V354nDg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4264118A4175;
        Wed, 10 Jun 2020 14:53:10 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.40.193.72])
        by smtp.corp.redhat.com (Postfix) with SMTP id AD26E5C1BD;
        Wed, 10 Jun 2020 14:53:07 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Wed, 10 Jun 2020 16:53:09 +0200 (CEST)
Date:   Wed, 10 Jun 2020 16:53:06 +0200
From:   Oleg Nesterov <oleg@redhat.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        lkft-triage@lists.linaro.org
Subject: Re: [PATCH 4.19 24/25] uprobes: ensure that uprobe->offset and
 ->ref_ctr_offset are properly aligned
Message-ID: <20200610145305.GA3254@redhat.com>
References: <20200609174048.576094775@linuxfoundation.org>
 <20200609174051.488794266@linuxfoundation.org>
 <CA+G9fYukN5V1z3g6Qwe9K5xnnXEuFafWdqGfDA1Wj2iVstoxfw@mail.gmail.com>
 <20200609190321.GA1046130@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200609190321.GA1046130@kroah.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 06/09, Greg Kroah-Hartman wrote:
>
> On Wed, Jun 10, 2020 at 12:25:56AM +0530, Naresh Kamboju wrote:
> > > @@ -911,6 +907,15 @@ static int __uprobe_register(struct inod
> > >         if (offset > i_size_read(inode))
> > >                 return -EINVAL;
> > >
> > > +       /*
> > > +        * This ensures that copy_from_page(), copy_to_page() and
> > > +        * __update_ref_ctr() can't cross page boundary.
> > > +        */
> > > +       if (!IS_ALIGNED(offset, UPROBE_SWBP_INSN_SIZE))
> > > +               return -EINVAL;
> > > +       if (!IS_ALIGNED(ref_ctr_offset, sizeof(short)))
> >
> > stable-rc 4.19 build failure for x86_64, i386 and arm.
> > make -sk KBUILD_BUILD_USER=TuxBuild -C/linux -j16 ARCH=x86 HOSTCC=gcc
> > CC="sccache gcc" O=build
> >
> > 75 #
> > 76 In file included from ../kernel/events/uprobes.c:25:
> > 77 ../kernel/events/uprobes.c: In function ‘__uprobe_register’:
> > 78 ../kernel/events/uprobes.c:916:18: error: ‘ref_ctr_offset’
> > undeclared (first use in this function); did you mean
> > ‘per_cpu_offset’?
> > 79  916 | if (!IS_ALIGNED(ref_ctr_offset, sizeof(short)))
> > 80  | ^~~~~~~~~~~~~~
> > 81 ../include/linux/kernel.h:62:30: note: in definition of macro ‘IS_ALIGNED’
> > 82  62 | #define IS_ALIGNED(x, a) (((x) & ((typeof(x))(a) - 1)) == 0)
> > 83  | ^
> > 84 ../kernel/events/uprobes.c:916:18: note: each undeclared identifier
> > is reported only once for each function it appears in
> > 85  916 | if (!IS_ALIGNED(ref_ctr_offset, sizeof(short)))
> > 86  | ^~~~~~~~~~~~~~
> > 87 ../include/linux/kernel.h:62:30: note: in definition of macro ‘IS_ALIGNED’
> > 88  62 | #define IS_ALIGNED(x, a) (((x) & ((typeof(x))(a) - 1)) == 0)
> > 89  | ^
> > 90 make[3]: *** [../scripts/Makefile.build:304: kernel/events/uprobes.o] Error 1
> >
> > --
> > Linaro LKFT
> > https://lkft.linaro.org
>
> Good catch, my builders just caught it too :(
>
> 4.19, 4.14, 4.9, and 4.4 are all broken, I have a fix will test it and
> push out -rc2 for all of those with it in a bit, thanks.

Yes, SDT markers were added by 1cc33161a83d20b5462b1e93f95d3ce6388079ee in v4.20.

See the patch for v4.4 below. It changes uprobe_register(), not __uprobe_register()
to check IS_ALIGNED(offset, UPROBE_SWBP_INSN_SIZE) only.

Greg, please let me know if you want me to send the patches for 4.9/4.14/4.19.

Oleg.

--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -601,10 +601,6 @@ static int prepare_uprobe(struct uprobe *uprobe, struct file *file,
 	if (ret)
 		goto out;
 
-	/* uprobe_write_opcode() assumes we don't cross page boundary */
-	BUG_ON((uprobe->offset & ~PAGE_MASK) +
-			UPROBE_SWBP_INSN_SIZE > PAGE_SIZE);
-
 	smp_wmb(); /* pairs with rmb() in find_active_uprobe() */
 	set_bit(UPROBE_COPY_INSN, &uprobe->flags);
 
@@ -883,6 +879,13 @@ int uprobe_register(struct inode *inode, loff_t offset, struct uprobe_consumer *
 	if (offset > i_size_read(inode))
 		return -EINVAL;
 
+	/*
+	 * This ensures that copy_from_page() an copy_to_page()
+	 * can't cross page boundary.
+	 */
+	if (!IS_ALIGNED(offset, UPROBE_SWBP_INSN_SIZE))
+		return -EINVAL;
+
  retry:
 	uprobe = alloc_uprobe(inode, offset);
 	if (!uprobe)
@@ -1691,6 +1694,9 @@ static int is_trap_at_addr(struct mm_struct *mm, unsigned long vaddr)
 	uprobe_opcode_t opcode;
 	int result;
 
+	if (WARN_ON_ONCE(!IS_ALIGNED(vaddr, UPROBE_SWBP_INSN_SIZE)))
+		return -EINVAL;
+
 	pagefault_disable();
 	result = __copy_from_user_inatomic(&opcode, (void __user*)vaddr,
 							sizeof(opcode));


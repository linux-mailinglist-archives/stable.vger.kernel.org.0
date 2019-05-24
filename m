Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFD1A29600
	for <lists+stable@lfdr.de>; Fri, 24 May 2019 12:38:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390579AbfEXKiW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 May 2019 06:38:22 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:42420 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390583AbfEXKiW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 May 2019 06:38:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=1SIR/nalPssf/0C1EVzh7EOnaBoQ17v7Xe1OGlM5rzQ=; b=ee0aSNpWwygM7bJYH/G/7m8DJ
        furwOdTstRcsrNpmN6Fq7aPPCYd1qriYL+0cGkWIpIHLqhGZ37wZt9y5WBYxirfSgiawpKxOngZRa
        OlXZxOVYDAMUBWCCN7+NOR4XYxA4iEWLObX/+hB2Osox4bvPTH+Mf3vFeTrTSGxRwCY2f3IOy4NLl
        AByn3HSQKiBeHrmeS3w1Fc1nTXquwTd9QJHWETl+2H0XVaAI8Pl0m4bRdoOYU7qBilW2NO7xAIn4I
        fk6P9Sa0/wnKYE1Hv3bn4kHNE9bYrYeBJD9k66Qq5HlyETDzDRcXbG3u5CnH9oS8zaqyo9BP8JbCN
        YGudmZBJQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hU7Zu-0006du-ET; Fri, 24 May 2019 10:37:34 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 0835320281C32; Fri, 24 May 2019 12:37:32 +0200 (CEST)
Date:   Fri, 24 May 2019 12:37:31 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     Andrea Parri <andrea.parri@amarulasolutions.com>,
        linux-kernel@vger.kernel.org, will.deacon@arm.com,
        aou@eecs.berkeley.edu, arnd@arndb.de, bp@alien8.de,
        catalin.marinas@arm.com, davem@davemloft.net, fenghua.yu@intel.com,
        heiko.carstens@de.ibm.com, herbert@gondor.apana.org.au,
        ink@jurassic.park.msu.ru, jhogan@kernel.org, linux@armlinux.org.uk,
        mattst88@gmail.com, mingo@kernel.org, mpe@ellerman.id.au,
        palmer@sifive.com, paul.burton@mips.com, paulus@samba.org,
        ralf@linux-mips.org, rth@twiddle.net, stable@vger.kernel.org,
        tglx@linutronix.de, tony.luck@intel.com, vgupta@synopsys.com,
        gregkh@linuxfoundation.org, jhansen@vmware.com, vdasa@vmware.com,
        aditr@vmware.com, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 00/18] locking/atomic: atomic64 type cleanup
Message-ID: <20190524103731.GN2606@hirez.programming.kicks-ass.net>
References: <20190522132250.26499-1-mark.rutland@arm.com>
 <20190523083013.GA4616@andrea>
 <20190523101926.GA3370@lakrids.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190523101926.GA3370@lakrids.cambridge.arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 23, 2019 at 11:19:26AM +0100, Mark Rutland wrote:

> [mark@lakrids:~/src/linux]% git grep '\(return\|=\)\s\+atomic\(64\)\?_set'
> include/linux/vmw_vmci_defs.h:  return atomic_set((atomic_t *)var, (u32)new_val);
> include/linux/vmw_vmci_defs.h:  return atomic64_set(var, new_val);
> 

Oh boy, what a load of crap you just did find.

How about something like the below? I've not read how that buffer is
used, but the below preserves all broken without using atomic*_t.

---
diff --git a/include/linux/vmw_vmci_defs.h b/include/linux/vmw_vmci_defs.h
index 0c06178e4985..8ee472118f54 100644
--- a/include/linux/vmw_vmci_defs.h
+++ b/include/linux/vmw_vmci_defs.h
@@ -438,8 +438,8 @@ enum {
 struct vmci_queue_header {
 	/* All fields are 64bit and aligned. */
 	struct vmci_handle handle;	/* Identifier. */
-	atomic64_t producer_tail;	/* Offset in this queue. */
-	atomic64_t consumer_head;	/* Offset in peer queue. */
+	u64 producer_tail;	/* Offset in this queue. */
+	u64 consumer_head;	/* Offset in peer queue. */
 };
 
 /*
@@ -740,13 +740,9 @@ static inline void *vmci_event_data_payload(struct vmci_event_data *ev_data)
  * prefix will be used, so correctness isn't an issue, but using a
  * 64bit operation still adds unnecessary overhead.
  */
-static inline u64 vmci_q_read_pointer(atomic64_t *var)
+static inline u64 vmci_q_read_pointer(u64 *var)
 {
-#if defined(CONFIG_X86_32)
-	return atomic_read((atomic_t *)var);
-#else
-	return atomic64_read(var);
-#endif
+	return READ_ONCE(*(unsigned long *)var);
 }
 
 /*
@@ -755,23 +751,17 @@ static inline u64 vmci_q_read_pointer(atomic64_t *var)
  * never exceeds a 32bit value in this case. On 32bit SMP, using a
  * locked cmpxchg8b adds unnecessary overhead.
  */
-static inline void vmci_q_set_pointer(atomic64_t *var,
-				      u64 new_val)
+static inline void vmci_q_set_pointer(u64 *var, u64 new_val)
 {
-#if defined(CONFIG_X86_32)
-	return atomic_set((atomic_t *)var, (u32)new_val);
-#else
-	return atomic64_set(var, new_val);
-#endif
+	/* XXX buggered on big-endian */
+	WRITE_ONCE(*(unsigned long *)var, (unsigned long)new_val);
 }
 
 /*
  * Helper to add a given offset to a head or tail pointer. Wraps the
  * value of the pointer around the max size of the queue.
  */
-static inline void vmci_qp_add_pointer(atomic64_t *var,
-				       size_t add,
-				       u64 size)
+static inline void vmci_qp_add_pointer(u64 *var, size_t add, u64 size)
 {
 	u64 new_val = vmci_q_read_pointer(var);
 
@@ -848,8 +838,8 @@ static inline void vmci_q_header_init(struct vmci_queue_header *q_header,
 				      const struct vmci_handle handle)
 {
 	q_header->handle = handle;
-	atomic64_set(&q_header->producer_tail, 0);
-	atomic64_set(&q_header->consumer_head, 0);
+	q_header->producer_tail = 0;
+	q_header->consumer_head = 0;
 }
 
 /*

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D5A6489C3E
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 16:34:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235105AbiAJPev (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 10:34:51 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:53424 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231674AbiAJPev (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 10:34:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 20C3FB81671;
        Mon, 10 Jan 2022 15:34:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05E2BC36AE3;
        Mon, 10 Jan 2022 15:34:46 +0000 (UTC)
Date:   Mon, 10 Jan 2022 10:34:45 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Pingfan Liu <kernelfans@gmail.com>
Cc:     linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Tom Zanussi <zanussi@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH 2/2] tracing: Add test for user space strings when
 filtering on string pointers
Message-ID: <20220110103445.21801e12@gandalf.local.home>
In-Reply-To: <YdukyGuyYlCa/sZT@piliu.users.ipa.redhat.com>
References: <20220107225655.647376947@goodmis.org>
        <20220107225840.003487216@goodmis.org>
        <YdukyGuyYlCa/sZT@piliu.users.ipa.redhat.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 10 Jan 2022 11:15:20 +0800
Pingfan Liu <kernelfans@gmail.com> wrote:

> Hi Steven,
> 
> This patch passed my test. But I have some concern, please see comment inline.

Thanks, can I add a "Tested-by:" from you?

(when I have my final version)

> > index 996920ed1812..cf0fa9a785c7 100644
> > --- a/kernel/trace/trace_events_filter.c
> > +++ b/kernel/trace/trace_events_filter.c
> > @@ -5,6 +5,7 @@
> >   * Copyright (C) 2009 Tom Zanussi <tzanussi@gmail.com>
> >   */
> >  
> > +#include <linux/uaccess.h>
> >  #include <linux/module.h>
> >  #include <linux/ctype.h>
> >  #include <linux/mutex.h>
> > @@ -654,12 +655,50 @@ DEFINE_EQUALITY_PRED(32);
> >  DEFINE_EQUALITY_PRED(16);
> >  DEFINE_EQUALITY_PRED(8);
> >  
> > +/* user space strings temp buffer */
> > +#define USTRING_BUF_SIZE	512  
> 
> Should it be PATH_MAX(4096) in case of matching against a file path?

I went back and forth with this size in my head, and since I currently do
not free it, and it is 4 * nr_cpus in size, I went with the smallest number
I felt was OK.

We can increase it in the future, and even expose the size to user space.

> 
> > +
> > +struct ustring_buffer {
> > +	char		buffer[USTRING_BUF_SIZE];
> > +};
> > +
> > +static __percpu struct ustring_buffer *ustring_per_cpu;
> > +
> > +static __always_inline char *test_string(char *str)
> > +{
> > +	struct ustring_buffer *ubuf;
> > +	char __user *ustr;
> > +	char *kstr;
> > +
> > +	if (!ustring_per_cpu)
> > +		return NULL;
> > +
> > +	ubuf = this_cpu_ptr(ustring_per_cpu);
> > +	kstr = ubuf->buffer;
> > +
> > +	if (likely((unsigned long)str >= TASK_SIZE)) {
> > +		/* For safety, do not trust the string pointer */
> > +		if (!strncpy_from_kernel_nofault(kstr, str, USTRING_BUF_SIZE))  
> 
> Since no other trace_event_class except event_class_syscall_enter tries
> to uaccess, so the unreliable source only comes from
> event_class_syscall_enter.
> 
> In that case, the access to kernel address is forbidden. So here just
> return -EACCES ?

I changed the way all pointers work. Any event that access a string pointer
(there are a few), and we filter on it, then I want it to go through this
path.

And returning -EACCES is useless this is done in the filtering logic and
that error will not be exposed to anyone. The best we can do is to fail the
filter.

> 
> > +			return NULL;
> > +	} else {
> > +		/* user space address? */
> > +		ustr = str;
> > +		if (!strncpy_from_user_nofault(kstr, ustr, USTRING_BUF_SIZE))
> > +			return NULL;
> > +	}
> > +	return kstr;
> > +}
> > +
> >  /* Filter predicate for fixed sized arrays of characters */
> >  static int filter_pred_string(struct filter_pred *pred, void *event)
> >  {
> >  	char *addr = (char *)(event + pred->offset);
> >  	int cmp, match;
> >  
> > +	addr = test_string(addr);  
> 
> Among all of trace_event_class, only event_class_syscall_enter exposed
> to this fault (uprobe does not uaccess). So I think the strncpy_*() can
> be avoided based on class, which improves performance.

The thing is, tracing should never cause a fault in the system. If a
pointer is bad and you filter on it, it should not cause a crash. Your
patch showed me we have this issues with kernel pointers too. And since we
have no safe "strncmp" the best we can do is a safe "strncpy" and then
compare it.

You actually exposed more issues than the one you were trying to solve, and
this patch now addresses those issues.

Yes, it will impact performance, but robustness always trumps performance.

> 
> > +	if (!addr)
> > +		return 0;
> > +
> >  	cmp = pred->regex.match(addr, &pred->regex, pred->regex.field_len);
> >  
> >  	match = cmp ^ pred->not;
> > @@ -671,10 +710,16 @@ static int filter_pred_string(struct filter_pred *pred, void *event)
> >  static int filter_pred_pchar(struct filter_pred *pred, void *event)
> >  {
> >  	char **addr = (char **)(event + pred->offset);
> > +	char *str;
> >  	int cmp, match;
> > -	int len = strlen(*addr) + 1;	/* including tailing '\0' */
> > +	int len;
> > +
> > +	str = test_string(*addr);
> > +	if (!str)
> > +		return 0;
> >  
> > -	cmp = pred->regex.match(*addr, &pred->regex, len);
> > +	len = strlen(str) + 1;	/* including tailing '\0' */
> > +	cmp = pred->regex.match(str, &pred->regex, len);
> >  
> >  	match = cmp ^ pred->not;
> >  
> > @@ -784,6 +829,10 @@ static int filter_pred_none(struct filter_pred *pred, void *event)
> >  
> >  static int regex_match_full(char *str, struct regex *r, int len)
> >  {
> > +	str = test_string(str);  
> 
> Since all regex_match_*() are called in filter_pred_*(), which have
> already protected codes from page fault. So no need to double check.

Ah, you're right. I only need to add this to filter_pred_pchar() and not
the regex.

Thanks, I'll send a v2.

-- Steve

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A25233FD8F8
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 13:45:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234678AbhIALqi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 07:46:38 -0400
Received: from mo1.intermailgate.com ([91.203.103.210]:46416 "EHLO
        mo1.intermailgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241703AbhIALqi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Sep 2021 07:46:38 -0400
Received: from localhost (localhost [127.0.0.1])
        by mo1.intermailgate.com (Postfix) with ESMTP id D7BFC20494
        for <stable@vger.kernel.org>; Wed,  1 Sep 2021 13:45:38 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=bof.de; s=20180522;
        t=1630496738; bh=snDAFh2sLTFtFgQhP3mkBsKwG3Vpjt1iYxklszpjdJ8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc;
        b=tiwlv0yR8cTQUR5lvDE8tc8oVfcRsjCEAj/PinWzTLfeRDyu6KXYC9c3UrGV+MfPk
         MliKR+akZktUgmpfDd7vIB6ZCNKPOEwMWbaNDizZpJ/7HeV3Ez9Hlim3uvX5lYsawL
         ljQg5RYF/aJM0XiqGY178/apkYT9IrxGWgPSBI6Y=
Received: from mail-lf1-f48.google.com (unknown [162.158.183.219])
        by mo1.intermailgate.com (Postfix) with ESMTPSA id 30E4F20230
        for <stable@vger.kernel.org>; Wed,  1 Sep 2021 13:45:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=bof.de; s=20180522;
        t=1630496734; bh=snDAFh2sLTFtFgQhP3mkBsKwG3Vpjt1iYxklszpjdJ8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc;
        b=nbsKf7VWiTrh1ApwH8Iw6VCEVo2+nG9nDfGJCPxK21fJ0zswvV49MtqcLSetw24Io
         EK8rKowdpLEXTM+Q9iP3cgH9YSpFB+Wd/+tcQrRzZqN/INPGNCYcLsx4R92NgjZQBg
         U0Jra3S5dWanc4JlfyNgLOzqeCU9Qi1S1fD9YcGs=
Received: by mail-lf1-f48.google.com with SMTP id s10so5701649lfr.11
        for <stable@vger.kernel.org>; Wed, 01 Sep 2021 04:45:34 -0700 (PDT)
X-Gm-Message-State: AOAM5314pN7i2nODM4oy4jTML/eVipfwVYSgKmSb0ZURuYYGRZSIWsQN
        NfQhDBuvNPuvbggVIoHAH96MhKu8GChTo+ldEZ0=
X-Google-Smtp-Source: ABdhPJx8bBwmRqxgFiicnDj0RjkzEixggHMFgmLSgS+gJvOO4rDq9N24B0iO6eVfvbsgR1KwnWsf48JxVD/8qyXcUVY=
X-Received: by 2002:a05:6512:b23:: with SMTP id w35mr25411875lfu.480.1630496733600;
 Wed, 01 Sep 2021 04:45:33 -0700 (PDT)
MIME-Version: 1.0
References: <YSy7lOd+qB7LXq1n@zn.tnic> <YS9La4mrykpcTDXz@kroah.com>
In-Reply-To: <YS9La4mrykpcTDXz@kroah.com>
From:   Patrick Schaaf <bof@bof.de>
Date:   Wed, 1 Sep 2021 13:45:14 +0200
X-Gmail-Original-Message-ID: <CAJ26g5SYOavFVeuuvNrz4dwP=gFr5nuC4YPau7Hq+aDZYgk8Hg@mail.gmail.com>
Message-ID: <CAJ26g5SYOavFVeuuvNrz4dwP=gFr5nuC4YPau7Hq+aDZYgk8Hg@mail.gmail.com>
Subject: Re: [PATCH] kthread: Fix PF_KTHREAD vs to_kthread() race
To:     Greg KH <greg@kroah.com>
Cc:     Borislav Petkov <bp@alien8.de>, stable@vger.kernel.org,
        bugzilla.kernel.org@e3q.eu
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 1, 2021 at 11:44 AM Greg KH <greg@kroah.com> wrote:
>
> On Mon, Aug 30, 2021 at 01:05:56PM +0200, Borislav Petkov wrote:
> >
> > please queue for 5.10-stable.
> >
> > See https://bugzilla.kernel.org/show_bug.cgi?id=214159 for more info.
>
> Now queued up, thanks.

I just booted a further of my prod servers with that applied to
5.10.61, patch needed a little mangling, attached below. Once more (as
with the 5.4 one),  will report about stability in a few days,
initially looks fine.

best regards
  Patrick

Tested-By: Patrick Schaaf <bof@bof.de>

diff -purN linux-5.10.61-orig/kernel/kthread.c linux-5.10.61-p/kernel/kthread.c
--- linux-5.10.61-orig/kernel/kthread.c 2021-08-26 14:51:21.000000000 +0200
+++ linux-5.10.61-p/kernel/kthread.c    2021-09-01 09:52:31.056738951 +0200
@@ -84,6 +84,25 @@ static inline struct kthread *to_kthread
        return (__force void *)k->set_child_tid;
 }

+/*
+ * Variant of to_kthread() that doesn't assume @p is a kthread.
+ *
+ * Per construction; when:
+ *
+ *   (p->flags & PF_KTHREAD) && p->set_child_tid
+ *
+ * the task is both a kthread and struct kthread is persistent. However
+ * PF_KTHREAD on it's own is not, kernel_thread() can exec() (See umh.c and
+ * begin_new_exec()).
+ */
+static inline struct kthread *__to_kthread(struct task_struct *p)
+{
+       void *kthread = (__force void *)p->set_child_tid;
+       if (kthread && !(p->flags & PF_KTHREAD))
+               kthread = NULL;
+       return kthread;
+}
+
 void free_kthread_struct(struct task_struct *k)
 {
        struct kthread *kthread;
@@ -168,8 +187,9 @@ EXPORT_SYMBOL_GPL(kthread_freezable_shou
  */
 void *kthread_func(struct task_struct *task)
 {
-       if (task->flags & PF_KTHREAD)
-               return to_kthread(task)->threadfn;
+       struct kthread *kthread = __to_kthread(task);
+       if (kthread)
+               return kthread->threadfn;
        return NULL;
 }
 EXPORT_SYMBOL_GPL(kthread_func);
@@ -199,10 +219,11 @@ EXPORT_SYMBOL_GPL(kthread_data);
  */
 void *kthread_probe_data(struct task_struct *task)
 {
-       struct kthread *kthread = to_kthread(task);
+       struct kthread *kthread = __to_kthread(task);
        void *data = NULL;

-       copy_from_kernel_nofault(&data, &kthread->data, sizeof(data));
+       if (kthread)
+               copy_from_kernel_nofault(&data, &kthread->data, sizeof(data));
        return data;
 }

@@ -514,9 +535,9 @@ void kthread_set_per_cpu(struct task_str
        set_bit(KTHREAD_IS_PER_CPU, &kthread->flags);
 }

-bool kthread_is_per_cpu(struct task_struct *k)
+bool kthread_is_per_cpu(struct task_struct *p)
 {
-       struct kthread *kthread = to_kthread(k);
+       struct kthread *kthread = __to_kthread(p);
        if (!kthread)
                return false;

diff -purN linux-5.10.61-orig/kernel/sched/fair.c
linux-5.10.61-p/kernel/sched/fair.c
--- linux-5.10.61-orig/kernel/sched/fair.c      2021-08-26
14:51:21.000000000 +0200
+++ linux-5.10.61-p/kernel/sched/fair.c 2021-09-01 09:48:06.860333848 +0200
@@ -7569,7 +7569,7 @@ int can_migrate_task(struct task_struct
                return 0;

        /* Disregard pcpu kthreads; they are where they need to be. */
-       if ((p->flags & PF_KTHREAD) && kthread_is_per_cpu(p))
+       if (kthread_is_per_cpu(p))
                return 0;

        if (!cpumask_test_cpu(env->dst_cpu, p->cpus_ptr)) {

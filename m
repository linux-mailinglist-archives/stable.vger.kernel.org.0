Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B72C41C9E69
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 00:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726815AbgEGWZ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 18:25:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726437AbgEGWZ2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 May 2020 18:25:28 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ACA4C05BD0A
        for <stable@vger.kernel.org>; Thu,  7 May 2020 15:25:27 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id f7so3705752pfa.9
        for <stable@vger.kernel.org>; Thu, 07 May 2020 15:25:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ruvKB/r5U5U9Os2KZjBYBX9D7kyzSo+ZlwnM5cSiqeE=;
        b=V2frT0bMO5pywn4rC4FlUiQXYp34MdhakawaLF6YQw0ARQpzs/i7vBjWovF58iUPlc
         6gKPJ0MOxZ+9tPoGPIoZ89/c6USjmlRXXhNhKaksqZJzd0ZhTsmCsdlxA6ONX69SqdXo
         a94AxC6sbrARI1xM2Xx49l3zwuYH4iNO1qeNP+kN2DPrZmW7YiV7rovgr0t830soWwYb
         Jny2tsEvj/HJ4xj9QpAWE2RPds0m0kY/ityT+tPzYLDcrj6GqNXfj6Dh4zG5Gob/IVp1
         JOr8RD7G4GkNEVlvl4TPt0YPQ+Z3xWVqu2t6RH3nRJE72Z8adlzcUQWopeREMXUe6KhM
         4JpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ruvKB/r5U5U9Os2KZjBYBX9D7kyzSo+ZlwnM5cSiqeE=;
        b=T26qWKrVbfi2U4aU5rwAfkHJrI0eqWQYk2EoHqmNJE+7iQaKqPEk1oc2zg300xCLT+
         JKvDohngxgXJBKMpzj8nCk72E9BzMN22c1gPrPGoqCWKQICw8qk+H8HM4njufs+cLSgJ
         I0ubWMLJ7IR3sZrEnBmeDhJEKiIW9djgmNlzKFQpSufHdH1WwG1q0BP+WoyhLnaWKGCG
         q7XFyUk5YKrO1CoCenJzVinrElgwFyYpvQJYXJEklSq4XWnAbbIJvKAGFKYhKS8XHgKe
         pp0zffwA+vFgU+v7Qty9JKwsh5P0T+1KS/qtjez2dlNOtsb1DHMAGKzCCxw3DyNIXBON
         maeg==
X-Gm-Message-State: AGi0PuZUouYlg2TeivdhfX/LzJ3rZjgSEYU3Md1vyxPTdxIjn4q9ZTf+
        wz647BIoscosoENNm3nWIAKaF6BUIJI=
X-Google-Smtp-Source: APiQypLYzNsgbDLLy8ELztbg2CD02ndhzDj7VMaCU+d5sYFNRUYR7Utn5USUuf2n2PnN7mA0eVYbFg==
X-Received: by 2002:a63:3385:: with SMTP id z127mr14134277pgz.168.1588890326314;
        Thu, 07 May 2020 15:25:26 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id w125sm4397052pgw.22.2020.05.07.15.25.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 May 2020 15:25:25 -0700 (PDT)
Subject: Re: [PATCH] fs/io_uring: fix O_PATH fds in openat, openat2, statx
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Max Kellermann <mk@cm4all.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20200507185725.15840-1-mk@cm4all.com>
 <20200507190131.GF23230@ZenIV.linux.org.uk>
 <4cac0e53-656c-50f0-3766-ae3cc6c0310a@kernel.dk>
 <20200507192903.GG23230@ZenIV.linux.org.uk>
 <8e3c88cc-027b-4f90-b4f8-a20d11d35c4b@kernel.dk>
 <20200507220637.GH23230@ZenIV.linux.org.uk>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <283c8edb-fea2-5192-f1d6-3cc57815b1e2@kernel.dk>
Date:   Thu, 7 May 2020 16:25:24 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200507220637.GH23230@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/7/20 4:06 PM, Al Viro wrote:
> On Thu, May 07, 2020 at 02:53:30PM -0600, Jens Axboe wrote:
> 
>> I think the patch is correct as-is, I took a good look at how we're
>> currently handling it. None of those three ops should fiddle with
>> the fd at all, and all of them do forbid the use of fixed files (the
>> descriptor table look-alikes), so that part is fine, too.
>>
>> There's some low hanging fruit around optimizing and improving it,
>> I'm including an updated version below. Max, can you double check
>> with your testing?
> 
> <looks>
> 
> Could you explain WTF is io_issue_sqe() doing in case of IORING_OP_CLOSE?
> Specifically, what is the value of
>         req->close.fd = READ_ONCE(sqe->fd);
>         if (req->file->f_op == &io_uring_fops ||
>             req->close.fd == req->ctx->ring_fd)
>                 return -EBADF;
> in io_close_prep()?  And what does happen if some joker does dup2()
> of something with io_uring_fops into our slot right after that check?
> Before the subsequent
>         ret = __close_fd_get_file(req->close.fd, &req->close.put_file);
> that is.

I agree, there's a gap there. We should do the check in the op handler,
and under the files_struct lock. How about something like the below?


diff --git a/fs/file.c b/fs/file.c
index c8a4e4c86e55..50ee73b76d17 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -646,18 +646,13 @@ int __close_fd(struct files_struct *files, unsigned fd)
 }
 EXPORT_SYMBOL(__close_fd); /* for ksys_close() */
 
-/*
- * variant of __close_fd that gets a ref on the file for later fput.
- * The caller must ensure that filp_close() called on the file, and then
- * an fput().
- */
-int __close_fd_get_file(unsigned int fd, struct file **res)
+int __close_fd_get_file_locked(struct files_struct *files, unsigned int fd,
+			       struct file **res)
+	__releases(&files->file_lock)
 {
-	struct files_struct *files = current->files;
 	struct file *file;
 	struct fdtable *fdt;
 
-	spin_lock(&files->file_lock);
 	fdt = files_fdtable(files);
 	if (fd >= fdt->max_fds)
 		goto out_unlock;
@@ -677,6 +672,19 @@ int __close_fd_get_file(unsigned int fd, struct file **res)
 	return -ENOENT;
 }
 
+/*
+ * variant of __close_fd that gets a ref on the file for later fput.
+ * The caller must ensure that filp_close() called on the file, and then
+ * an fput().
+ */
+int __close_fd_get_file(unsigned int fd, struct file **res)
+{
+	struct files_struct *files = current->files;
+
+	spin_lock(&files->file_lock);
+	return __close_fd_get_file_locked(files, fd, res);
+}
+
 void do_close_on_exec(struct files_struct *files)
 {
 	unsigned i;
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 979d9f977409..740547106717 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3399,10 +3399,6 @@ static int io_close_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return -EBADF;
 
 	req->close.fd = READ_ONCE(sqe->fd);
-	if (req->file->f_op == &io_uring_fops ||
-	    req->close.fd == req->ctx->ring_fd)
-		return -EBADF;
-
 	return 0;
 }
 
@@ -3430,10 +3426,19 @@ static void io_close_finish(struct io_wq_work **workptr)
 
 static int io_close(struct io_kiocb *req, bool force_nonblock)
 {
+	struct files_struct *files = current->files;
 	int ret;
 
 	req->close.put_file = NULL;
-	ret = __close_fd_get_file(req->close.fd, &req->close.put_file);
+	spin_lock(&files->file_lock);
+	if (req->file->f_op == &io_uring_fops ||
+	    req->close.fd == req->ctx->ring_fd) {
+		spin_unlock(&files->file_lock);
+		return -EBADF;
+	}
+
+	ret = __close_fd_get_file_locked(files, req->close.fd,
+						&req->close.put_file);
 	if (ret < 0)
 		return ret;
 
diff --git a/include/linux/fdtable.h b/include/linux/fdtable.h
index f07c55ea0c22..11d19303af46 100644
--- a/include/linux/fdtable.h
+++ b/include/linux/fdtable.h
@@ -122,6 +122,8 @@ extern void __fd_install(struct files_struct *files,
 extern int __close_fd(struct files_struct *files,
 		      unsigned int fd);
 extern int __close_fd_get_file(unsigned int fd, struct file **res);
+extern int __close_fd_get_file_locked(struct files_struct *files,
+				      unsigned int fd, struct file **res);
 
 extern struct kmem_cache *files_cachep;
 

-- 
Jens Axboe


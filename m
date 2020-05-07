Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 006221C9EE0
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 01:03:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbgEGXDY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 19:03:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727099AbgEGXDX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 May 2020 19:03:23 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B888C05BD43
        for <stable@vger.kernel.org>; Thu,  7 May 2020 16:03:21 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id n11so3170036pgl.9
        for <stable@vger.kernel.org>; Thu, 07 May 2020 16:03:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QSHssQjKD6+vYMmq/gxw+OjPipIa2F9Y4+vFL26ooGI=;
        b=lQLfQGLzYXAlL8dJX5jl559roV3lhBENjWgWt4fbxsf1RmSYMZCU+el0VVO9T+0FiC
         c8pZKsm+RwuijEVirPevAoquCHjBi24Cnw/I/VPkgUT7hF8pH3ZOrZNMWHVdI2J74gr4
         ll/a1QfmqtjnCH5ncjYKRJ/wa2SCEYZfNEgBWPI5u4rY+YFGanCcD83VRoPeno5hm5qA
         KB1DB05IosCcEQBt8x0WABe6eDaRjA8dN3iAM6dVgQqFqsiJPRwzLH4+jOJBBXbrzDGL
         bJQ8EiNFqcd0jxu/s366TT/u3FPHT9JbejK/tVslMtIIl74v2PPdHQQvx4ZpU35iHot7
         Q7oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QSHssQjKD6+vYMmq/gxw+OjPipIa2F9Y4+vFL26ooGI=;
        b=epDkt2ZZ6RfFYyN6viXHMJEp06TzMa8bIpbVykGUGRk9PjeGhS+8I7vhsBEyhyc4us
         9kslF4hdjL6jTtH4nJau7Y8O57Iq2lePt2iV+EexzXyYjuBwjDN5Gbr1BpST9xhjjI0O
         y8ySsbLf8/P1sqI3tYpnAx7hRK1Xus5aoy5UydmAhxgRXRZBAYlnpZ8sKRBNgkNuR5ur
         KnHOjHwD4NA1YOWeuS8pYZCuxFP4ICkPkHGfvsVNBX+s/eNCtnGv90GQL9eAX+ytiyOM
         XiCQ/4ATUt97tjNfbPK0iZTbmDpcKwqWMEq1CRx4HS4cG58bmplSLNh5QfT9K4dvJtwh
         v0Vw==
X-Gm-Message-State: AGi0PuYTlzPMUHjbQx1UfIUKkokXbGH2zGyo1P5R4AeJW+nX5LBqKmF/
        e888lEHfeV6z0VQfv7LsQg3nE+tIrI8=
X-Google-Smtp-Source: APiQypKwoJfk4HPHvT4IexdeCehxEsTZnAGLXVeoookLh5pz2Z0Qh+aUk2uqWMm7ZmzGofBDoD932g==
X-Received: by 2002:a63:c306:: with SMTP id c6mr13444816pgd.311.1588892600499;
        Thu, 07 May 2020 16:03:20 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id f9sm4477969pgj.2.2020.05.07.16.03.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 May 2020 16:03:19 -0700 (PDT)
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
 <283c8edb-fea2-5192-f1d6-3cc57815b1e2@kernel.dk>
 <20200507224447.GI23230@ZenIV.linux.org.uk>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <e16125f2-c3ec-f029-c607-19bede54fa17@kernel.dk>
Date:   Thu, 7 May 2020 17:03:17 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200507224447.GI23230@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/7/20 4:44 PM, Al Viro wrote:
> On Thu, May 07, 2020 at 04:25:24PM -0600, Jens Axboe wrote:
> 
>>  static int io_close(struct io_kiocb *req, bool force_nonblock)
>>  {
>> +	struct files_struct *files = current->files;
>>  	int ret;
>>  
>>  	req->close.put_file = NULL;
>> -	ret = __close_fd_get_file(req->close.fd, &req->close.put_file);
>> +	spin_lock(&files->file_lock);
>> +	if (req->file->f_op == &io_uring_fops ||
>> +	    req->close.fd == req->ctx->ring_fd) {
>> +		spin_unlock(&files->file_lock);
>> +		return -EBADF;
>> +	}
>> +
>> +	ret = __close_fd_get_file_locked(files, req->close.fd,
>> +						&req->close.put_file);
> 
> Pointless.  By that point req->file might have nothing in common with
> anything in any descriptor table.

How about the below then? Stop using req->file, defer the lookup until
we're in the handler instead. Not sure the 'fd' check makes sense
at this point, but at least we should be consistent in terms of
once we lookup the file and check the f_op.

> Al, carefully _not_ saying anything about the taste and style of the
> entire thing...

It's just a quickie, didn't put much concern into the style and naming
of the locked helper. What do you prefer there? Normally I'd do __,
but it's already that, so... There's only one other user of it, so
we could just make the regular one be close_fd_get_file() and use
the __ prefix for the new locked variant.

But I figured it was more important to get the details right first,
the style is easier to polish.


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
index 979d9f977409..54ef10240bf3 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -786,7 +786,6 @@ static const struct io_op_def io_op_defs[] = {
 		.needs_fs		= 1,
 	},
 	[IORING_OP_CLOSE] = {
-		.needs_file		= 1,
 		.file_table		= 1,
 	},
 	[IORING_OP_FILES_UPDATE] = {
@@ -3399,10 +3398,6 @@ static int io_close_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return -EBADF;
 
 	req->close.fd = READ_ONCE(sqe->fd);
-	if (req->file->f_op == &io_uring_fops ||
-	    req->close.fd == req->ctx->ring_fd)
-		return -EBADF;
-
 	return 0;
 }
 
@@ -3430,10 +3425,21 @@ static void io_close_finish(struct io_wq_work **workptr)
 
 static int io_close(struct io_kiocb *req, bool force_nonblock)
 {
+	struct files_struct *files = current->files;
+	struct file *file;
 	int ret;
 
 	req->close.put_file = NULL;
-	ret = __close_fd_get_file(req->close.fd, &req->close.put_file);
+	spin_lock(&files->file_lock);
+	if (req->close.fd == req->ctx->ring_fd)
+		goto badf;
+
+	file = fcheck_files(files, req->close.fd);
+	if (!file || file->f_op == &io_uring_fops)
+		goto badf;
+
+	ret = __close_fd_get_file_locked(files, req->close.fd,
+						&req->close.put_file);
 	if (ret < 0)
 		return ret;
 
@@ -3458,6 +3464,9 @@ static int io_close(struct io_kiocb *req, bool force_nonblock)
 	 */
 	__io_close_finish(req);
 	return 0;
+badf:
+	spin_unlock(&files->file_lock);
+	return -EBADF;
 }
 
 static int io_prep_sfr(struct io_kiocb *req, const struct io_uring_sqe *sqe)
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


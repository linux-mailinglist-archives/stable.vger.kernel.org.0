Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41DF81CB2EA
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 17:33:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727917AbgEHPdT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 11:33:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726897AbgEHPdT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 May 2020 11:33:19 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F37CDC05BD09
        for <stable@vger.kernel.org>; Fri,  8 May 2020 08:33:17 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id s10so1758779iln.11
        for <stable@vger.kernel.org>; Fri, 08 May 2020 08:33:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5Cd+7bkSYmAgh5DN2n8p/aA30ZkROc8uSmHqYwQWmIo=;
        b=1iPAXJkZlmhJ7BWDzF+X/VxemjHkBOyCJgHgt65w4dKt/0PlKCx0c/u64jtLZxjAjf
         RhtUZjMuUdqdzPQ3LA99pdgmqUHu3PM/094MHVDxE6NeWVI4x/nePVvrHxnkwZz54Dj6
         mhprggRTf6YEW316PXqEfnWWBJUx0fO7rt6kzkIgVx/CMs4YfolvA9bfWOOuGaTWGBg1
         Iw8bCQEj6A8zfNpUO0qxMcGPc5t+KauHAuUR78JZRDN1xPNFPuzqiN6TtJFhDMlyjLt+
         2svlxe7tUdDVWIdczvsS82svc0CNZUfqjSnzY+sF3UmFRL+vEmpTKOEhv4nqKVU1TiZt
         nZkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5Cd+7bkSYmAgh5DN2n8p/aA30ZkROc8uSmHqYwQWmIo=;
        b=T/jxhgrBxyU/WO9N4kfwkpZLJKX0Drw4edJCjNehAuMsoSawIztrN5VYje96I6O+6t
         JmLz2JldNof2hEU4/M5prH33X9hxUxhZwV6VG1asSrg5rQZ6hPf7qGWGsbAIDtfCHeIa
         DQaLRNnB/BztCvgB+jVmPoN2NUhzgS/LWAkrUIDkjCvjxdZNHHrIhIEvmBURWUlEvnjT
         n1KE+50zwPJo60Czwjzq95ucJ7Sisfn89gfJ0Ud7mYJz4C4sl2SdGm+s9hV5L/4l4tZi
         HLKPYPXC2OZNPxGw0jXBqDIHRKFvhMh//OA5nLq30/mJu2hXhc0y9F8aYysTZP9Y7mzA
         iofA==
X-Gm-Message-State: AGi0PubCWQwWJWN/8G867oe3dRQAJ1BGxgMb0BGxD2eHwBPVAj8xnrZd
        SMF3bsY/ydRITIgpqZK7rOJgBhTPeiQ=
X-Google-Smtp-Source: APiQypKdVtlaL71EVvq3emaUv8Y5xpm9c6baK99R3bNrpVMnsd3KYQCR5+DwQRQy+eekJ9a63TUoAg==
X-Received: by 2002:a92:8804:: with SMTP id h4mr69496ild.251.1588951997047;
        Fri, 08 May 2020 08:33:17 -0700 (PDT)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id u17sm923258ilb.86.2020.05.08.08.33.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 May 2020 08:33:16 -0700 (PDT)
Subject: Re: [PATCH] fs/io_uring: fix O_PATH fds in openat, openat2, statx
To:     Hillf Danton <hdanton@sina.com>
Cc:     Al Viro <viro@zeniv.linux.org.uk>, Max Kellermann <mk@cm4all.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20200507185725.15840-1-mk@cm4all.com>
 <20200507190131.GF23230@ZenIV.linux.org.uk>
 <4cac0e53-656c-50f0-3766-ae3cc6c0310a@kernel.dk>
 <20200507192903.GG23230@ZenIV.linux.org.uk>
 <8e3c88cc-027b-4f90-b4f8-a20d11d35c4b@kernel.dk>
 <20200507220637.GH23230@ZenIV.linux.org.uk>
 <283c8edb-fea2-5192-f1d6-3cc57815b1e2@kernel.dk>
 <20200507224447.GI23230@ZenIV.linux.org.uk>
 <e16125f2-c3ec-f029-c607-19bede54fa17@kernel.dk>
 <20200507233132.GJ23230@ZenIV.linux.org.uk>
 <629de3b6-cf80-fe37-1dde-7f0464da0a04@kernel.dk>
 <20200508152918.12340-1-hdanton@sina.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <35aa8592-5565-3578-d90f-3b56bb8ab078@kernel.dk>
Date:   Fri, 8 May 2020 09:33:15 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200508152918.12340-1-hdanton@sina.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/8/20 9:29 AM, Hillf Danton wrote:
> Dunno if what's missing makes  grumpy.
> 
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -3439,6 +3439,11 @@ static void io_close_finish(struct io_wq
>  static int io_close(struct io_kiocb *req, bool force_nonblock)
>  {
>  	int ret;
> +	struct fd f;
> +
> +	f = fdget(req->close.fd);
> +	if (!f.file)
> +		return -EBADF;
>  
>  	req->close.put_file = NULL;
>  	ret = __close_fd_get_file(req->close.fd, &req->close.put_file);

Can you expand? With the last patch posted, we don't do that fget/fdget
at all. __close_fd_get_file() will error out if we don't have a file
there. It does change the close error from -EBADF to -ENOENT, so maye we
just need to improve that?


diff --git a/fs/io_uring.c b/fs/io_uring.c
index 979d9f977409..9fd1257c8404 100644
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
 
@@ -3434,8 +3429,11 @@ static int io_close(struct io_kiocb *req, bool force_nonblock)
 
 	req->close.put_file = NULL;
 	ret = __close_fd_get_file(req->close.fd, &req->close.put_file);
-	if (ret < 0)
+	if (ret < 0) {
+		if (ret == -ENOENT)
+			ret = -EBADF;
 		return ret;
+	}
 
 	/* if the file has a flush method, be safe and punt to async */
 	if (req->close.put_file->f_op->flush && force_nonblock) {

-- 
Jens Axboe


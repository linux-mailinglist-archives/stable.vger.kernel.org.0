Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8805E1C9CC3
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 22:53:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726922AbgEGUxd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 16:53:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726495AbgEGUxd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 May 2020 16:53:33 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62C64C05BD0A
        for <stable@vger.kernel.org>; Thu,  7 May 2020 13:53:33 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id b8so2430641plm.11
        for <stable@vger.kernel.org>; Thu, 07 May 2020 13:53:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=apC70P+WGdPKFsrjSIHDzYRXCNXoO9MhbSn/BWD3G1Q=;
        b=OTWBXUeeTVTEseUVg355oFX82yg8MruupyfYZFSCg6gAGmbwuWRX662bE/yyJZNWxi
         ohqBq4POZYu7WQSEMXILeUHRLnFEXrMBoSzlOmDxOb6TOpRVhXTFaMrjy5ophX+xJoNc
         MRzyaACYbyiVYh5rL0wqg4/oa+OT1embbQSHuGGWuboMrVfMXJAs3g4usw+stF2L71MR
         2pKMjb4E1KIKhxuTYlateeggED0szL6XVHuW8Mz7OXCp3IV+hPMgkrS78j8fLzIfLtW+
         +PZU7XB9FgyE8aIC5y2eHzAlmcEN8l7DGJh6imxocojoJ22F/MAXqVhyCfEbl1I+EC9y
         JwyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=apC70P+WGdPKFsrjSIHDzYRXCNXoO9MhbSn/BWD3G1Q=;
        b=Ge0ATiMCJE/Ncm6IQmBwKMBw1ptPByQka4FieJIQJBeXFE262xfWC0pjd97d0McOCK
         s4Rp9Eaj82BHGZY6WAgxO91lJl6xsU3NQiOL4IlFlrEx/zuetD/zenNDgZ7X8h2eGRtp
         C7gQSgUSmeOdEu2L1L/7N3+h69gLsm1dBdeK8KTVthzEasNgpYq3HmIXv3MhyDJ1aTwp
         9kAYH26Ryy3q4DlQvhX3gWKPUIdBAxz77Uj7zwv8IuiD4MGoE/qiDa1nHLBLm0cA15R9
         TnwPL0FJCMzlKAmOHaatC6T/bypRKP+fEIhQ10e4MHTtPEvCngwfSym1VP4isEgkCIF7
         UXpw==
X-Gm-Message-State: AGi0PubReybqDXb/Jy4vgSlzwlqv6+Ptc4MDwN76srZkfZnN9DWk5CPg
        3/eEiqQ1iYX5MNykTESURfkXfuFDfJk=
X-Google-Smtp-Source: APiQypI6Lw41gK0iQ1uMGOotk8bGMyFO+59MIl/grRNa2oRHJkBrJup38vmMv+fodfelMDXFmm2eOQ==
X-Received: by 2002:a17:902:70c6:: with SMTP id l6mr13647889plt.31.1588884812313;
        Thu, 07 May 2020 13:53:32 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id b2sm4272683pgg.77.2020.05.07.13.53.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 May 2020 13:53:31 -0700 (PDT)
Subject: Re: [PATCH] fs/io_uring: fix O_PATH fds in openat, openat2, statx
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Max Kellermann <mk@cm4all.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20200507185725.15840-1-mk@cm4all.com>
 <20200507190131.GF23230@ZenIV.linux.org.uk>
 <4cac0e53-656c-50f0-3766-ae3cc6c0310a@kernel.dk>
 <20200507192903.GG23230@ZenIV.linux.org.uk>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <8e3c88cc-027b-4f90-b4f8-a20d11d35c4b@kernel.dk>
Date:   Thu, 7 May 2020 14:53:30 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200507192903.GG23230@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/7/20 1:29 PM, Al Viro wrote:
> On Thu, May 07, 2020 at 01:05:23PM -0600, Jens Axboe wrote:
>> On 5/7/20 1:01 PM, Al Viro wrote:
>>> On Thu, May 07, 2020 at 08:57:25PM +0200, Max Kellermann wrote:
>>>> If an operation's flag `needs_file` is set, the function
>>>> io_req_set_file() calls io_file_get() to obtain a `struct file*`.
>>>>
>>>> This fails for `O_PATH` file descriptors, because those have no
>>>> `struct file*`
>>>
>>> O_PATH descriptors most certainly *do* have that.  What the hell
>>> are you talking about?
>>
>> Yeah, hence I was interested in the test case. Since this is
>> bypassing that part, was assuming we'd have some logic error
>> that attempted a file grab for a case where we shouldn't.
> 
> Just in case - you do realize that you should either resolve the
> descriptor yourself (and use the resulting struct file *, without
> letting anyone even look at the descriptor) *or* pass the
> descriptor as-is and don't even look at the descriptor table?
> 
> Once more, with feeling:
> 
> Descriptor tables are inherently sharable objects.  You can't resolve
> a descriptor twice and assume you'll get the same thing both times.
> You can't insert something into descriptor table and assume that the
> same slot will be holding the same struct file reference after
> the descriptor table has been unlocked.
> 
> Again, resolving the descriptor more than once in course of syscall
> is almost always a serious bug; there are very few exceptions and
> none of the mentioned in that patch are anywhere near those.
> 
> IOW, that patch will either immediately break things on O_PATH
> (if you are really passing struct file *) or it's probably correct,
> but the reason is entirely different - it's that you are passing
> descriptor, which gets resolved by whatever you are calling, in
> which case io_uring has no business resolving it.  And if that's
> the case, you are limited to real descriptors - your descriptor
> table lookalikes won't be of any use.

I think the patch is correct as-is, I took a good look at how we're
currently handling it. None of those three ops should fiddle with
the fd at all, and all of them do forbid the use of fixed files (the
descriptor table look-alikes), so that part is fine, too.

There's some low hanging fruit around optimizing and improving it,
I'm including an updated version below. Max, can you double check
with your testing?


diff --git a/fs/io_uring.c b/fs/io_uring.c
index dd680eb153cb..979d9f977409 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -680,8 +680,6 @@ struct io_op_def {
 	unsigned		needs_mm : 1;
 	/* needs req->file assigned */
 	unsigned		needs_file : 1;
-	/* needs req->file assigned IFF fd is >= 0 */
-	unsigned		fd_non_neg : 1;
 	/* hash wq insertion if file is a regular file */
 	unsigned		hash_reg_file : 1;
 	/* unbound wq insertion if file is a non-regular file */
@@ -784,8 +782,6 @@ static const struct io_op_def io_op_defs[] = {
 		.needs_file		= 1,
 	},
 	[IORING_OP_OPENAT] = {
-		.needs_file		= 1,
-		.fd_non_neg		= 1,
 		.file_table		= 1,
 		.needs_fs		= 1,
 	},
@@ -799,8 +795,6 @@ static const struct io_op_def io_op_defs[] = {
 	},
 	[IORING_OP_STATX] = {
 		.needs_mm		= 1,
-		.needs_file		= 1,
-		.fd_non_neg		= 1,
 		.needs_fs		= 1,
 		.file_table		= 1,
 	},
@@ -837,8 +831,6 @@ static const struct io_op_def io_op_defs[] = {
 		.buffer_select		= 1,
 	},
 	[IORING_OP_OPENAT2] = {
-		.needs_file		= 1,
-		.fd_non_neg		= 1,
 		.file_table		= 1,
 		.needs_fs		= 1,
 	},
@@ -5368,15 +5360,6 @@ static void io_wq_submit_work(struct io_wq_work **workptr)
 	io_steal_work(req, workptr);
 }
 
-static int io_req_needs_file(struct io_kiocb *req, int fd)
-{
-	if (!io_op_defs[req->opcode].needs_file)
-		return 0;
-	if ((fd == -1 || fd == AT_FDCWD) && io_op_defs[req->opcode].fd_non_neg)
-		return 0;
-	return 1;
-}
-
 static inline struct file *io_file_from_index(struct io_ring_ctx *ctx,
 					      int index)
 {
@@ -5414,14 +5397,11 @@ static int io_file_get(struct io_submit_state *state, struct io_kiocb *req,
 }
 
 static int io_req_set_file(struct io_submit_state *state, struct io_kiocb *req,
-			   int fd, unsigned int flags)
+			   int fd)
 {
 	bool fixed;
 
-	if (!io_req_needs_file(req, fd))
-		return 0;
-
-	fixed = (flags & IOSQE_FIXED_FILE);
+	fixed = (req->flags & REQ_F_FIXED_FILE) != 0;
 	if (unlikely(!fixed && req->needs_fixed_file))
 		return -EBADF;
 
@@ -5798,7 +5778,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		       struct io_submit_state *state, bool async)
 {
 	unsigned int sqe_flags;
-	int id, fd;
+	int id;
 
 	/*
 	 * All io need record the previous position, if LINK vs DARIN,
@@ -5850,8 +5830,10 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 					IOSQE_ASYNC | IOSQE_FIXED_FILE |
 					IOSQE_BUFFER_SELECT | IOSQE_IO_LINK);
 
-	fd = READ_ONCE(sqe->fd);
-	return io_req_set_file(state, req, fd, sqe_flags);
+	if (!io_op_defs[req->opcode].needs_file)
+		return 0;
+
+	return io_req_set_file(state, req, READ_ONCE(sqe->fd));
 }
 
 static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,

-- 
Jens Axboe


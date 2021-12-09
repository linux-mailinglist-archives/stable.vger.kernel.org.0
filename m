Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20FD346ECE4
	for <lists+stable@lfdr.de>; Thu,  9 Dec 2021 17:16:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236966AbhLIQUR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Dec 2021 11:20:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235758AbhLIQUQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Dec 2021 11:20:16 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74A8BC0617A1
        for <stable@vger.kernel.org>; Thu,  9 Dec 2021 08:16:43 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id g19so5846026pfb.8
        for <stable@vger.kernel.org>; Thu, 09 Dec 2021 08:16:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RIF2M33Kso+Zt+36TF5CsecFlK0NvYqCcC7VpLjGgGk=;
        b=IA4aXVcXtkHFoBmTo3MRpoH6DXn+QixzXlgWSiJoHOFlo702F2KVjTOUraQiSNTC/D
         QKrOGML8g64wweS+tMQ7IP6eQGubC7My/W2n9H3+P8YxMvFJo/2shz6XIhglL9lEDTMe
         4D+kJLiaqrEvPy03APMhB3KvU99KLrhHQUfaybTYZTscmMT/YnL4fdQ53HF5nmDQAuUK
         9rt1EqhOTx0G0x8RSxNFRG62/Cmk6HxPwcfJzSkG75ckFI5irdkWkB7IK9mmOkkqIskC
         mvp1GeEQCXtC43gC+TSi02sO9vtOKbK0wNnzchav9qsmo3dMLigBF6c5+7nEUgoszE6a
         QiRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RIF2M33Kso+Zt+36TF5CsecFlK0NvYqCcC7VpLjGgGk=;
        b=1Pz9jHb19o9NqjAKK1eYid/Q1k/zlikSuWFhgzmuK5wz9aXms6wbI72ZMR0yVyR6sB
         1+GkkLQiAn3ZhrcXPmTmySuQgbUoYwwq2Ype3H8WgRIAx0xCWyEArllBSKVcbYyXuzyG
         YJlm2FvSGjsAtOApNSH1fmEKLaT2tCeJM1Hh5i2MEl9a5v9mT/2Dp6yRD8inWxyojeOV
         GRnfEpG9f2W1PpZXIPji8Pqy77lPxNpqyKJQo1y05xWYC49t5TeAR51vBBmvQqgmOx1X
         SxvYATPuSxA/+bcX5FNMQpqNrc8CE4OCE0oPffQPSr795J+K2c/pVpYdkj8fpcEvVasM
         OoRA==
X-Gm-Message-State: AOAM531MX2VltirgtLszxFLDCmyb4UpJpMgaQJsg4h8tCiuEqge7j7Co
        rL0nK3L4lFGZz7/2lMzpdQruCU+F+bk5VA==
X-Google-Smtp-Source: ABdhPJxZIn684VT7tOSkxgIFnb/GasNgGbsFE7w5ZZvTvflpNs9mDKZ8VHpRCcqoIQ2LagkwSH4sow==
X-Received: by 2002:a63:fd12:: with SMTP id d18mr34222931pgh.345.1639066602403;
        Thu, 09 Dec 2021 08:16:42 -0800 (PST)
Received: from [172.20.4.26] ([66.185.175.30])
        by smtp.gmail.com with ESMTPSA id q1sm194837pfu.33.2021.12.09.08.16.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Dec 2021 08:16:42 -0800 (PST)
Subject: [PATCH v2 2/2] io_uring: ensure task_work gets run as part of
 cancelations
To:     io-uring@vger.kernel.org
Cc:     syzbot+21e6887c0be14181206d@syzkaller.appspotmail.com,
        stable@vger.kernel.org
References: <20211209155956.383317-1-axboe@kernel.dk>
 <20211209155956.383317-3-axboe@kernel.dk>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <89990fca-63d3-cbac-85cc-bce2818dd30e@kernel.dk>
Date:   Thu, 9 Dec 2021 09:16:40 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20211209155956.383317-3-axboe@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If we successfully cancel a work item but that work item needs to be
processed through task_work, then we can be sleeping uninterruptibly
in io_uring_cancel_generic() and never process it. Hence we don't
make forward progress and we end up with an uninterruptible sleep
warning.

Add the waitqueue earlier to ensure that any wakeups from cancelations
are seen, and switch to using uninterruptible sleep so that postponed
task_work additions get seen and processed.

While in there, correct a comment that should be IFF, not IIF.

Reported-by: syzbot+21e6887c0be14181206d@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

v2 - don't move prepare_to_wait(), it'll run into issues with locking
     etc, and we don't need to as the inflight tracking guards against
     missing a wakeup for a completion.

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b4d5b8d168bf..111db33b940e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -9826,7 +9826,7 @@ static __cold void io_uring_drop_tctx_refs(struct task_struct *task)
 
 /*
  * Find any io_uring ctx that this task has registered or done IO on, and cancel
- * requests. @sqd should be not-null IIF it's an SQPOLL thread cancellation.
+ * requests. @sqd should be not-null IFF it's an SQPOLL thread cancellation.
  */
 static __cold void io_uring_cancel_generic(bool cancel_all,
 					   struct io_sq_data *sqd)
@@ -9868,8 +9868,10 @@ static __cold void io_uring_cancel_generic(bool cancel_all,
 							     cancel_all);
 		}
 
-		prepare_to_wait(&tctx->wait, &wait, TASK_UNINTERRUPTIBLE);
+		prepare_to_wait(&tctx->wait, &wait, TASK_INTERRUPTIBLE);
+		io_run_task_work();
 		io_uring_drop_tctx_refs(current);
+
 		/*
 		 * If we've seen completions, retry without waiting. This
 		 * avoids a race where a completion comes in before we did

-- 
Jens Axboe


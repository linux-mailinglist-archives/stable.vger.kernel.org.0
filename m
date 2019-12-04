Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37F16112EFC
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 16:53:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727878AbfLDPxr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 10:53:47 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:37572 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727008AbfLDPxr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Dec 2019 10:53:47 -0500
Received: by mail-pg1-f194.google.com with SMTP id q127so77256pga.4
        for <stable@vger.kernel.org>; Wed, 04 Dec 2019 07:53:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=JleJhV0Wk/0B8WcXlzsCq/PQIquo6P+PnAdSBo0D6pE=;
        b=FMHH2YgAoeovlpMtXXo6MD+ZxlJRfJ1fY2ostuZvoHdXMXORm80/T7A2bRsHE7b3Pc
         IwWSpJwPVV/EiL2K/RtykypoP03suyPLojSlQ+cMqYZKuAl7ToeKFWJ6q5jnYVaaWZwx
         odBZkkLtsY/LZEFDN4938pJK1E/WUv+XUfgMcMat7zG1dO9WO4+EgFQrFiXHCExw6Jz2
         PJFsijlBsWhHkNoKR9DdpHuc481rt4ltHMeCWxUxBnHKxvKT94yVnO917RIlfqFgPzSF
         t2coY53yBqXmnyQrKK7mFNc4sS0V1dEYjUIr5FGoBpDGuHfxJZ8oZp/B3A3jTh4fLUiv
         VBsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=JleJhV0Wk/0B8WcXlzsCq/PQIquo6P+PnAdSBo0D6pE=;
        b=brp5kZnpd47XRfnEEe5vKpi12TATV9EUJ6OTRBI/aa8JT9uqBbrwWCii41Sihbmxe+
         MYjp6eRko3ZLk5neK4FOiT0CY/vWFXY7v9O+6TT6VCh9U557LSYyvmJp1tw8BMAPLT2y
         iNrVTxtFz1Q4z+U0sOP9lNFENxGoVfFmzK4fldBl0fOjEvKodO67Sj38WoEMRnWC5b6V
         Ai3DKKJJvMbx5Pam6oL+w77zIv83Dn0znzzyhUgHOv58UMj7pbBKba1VlO2EF2J/MDoB
         QFwBqOSSjCI+ZBc7/w1aDHcea9s5b0dtY75VKre5xJSNAWDplRs20J0WRCBmmbilyD0q
         8zog==
X-Gm-Message-State: APjAAAUzLkZ48/Heserti6rTaMuVqoBAr7csSX0Fzi1rFYFFb6i1MuA1
        tVf3U9o2T6jEcMDtlSlnoIgeLveGNukGwQ==
X-Google-Smtp-Source: APXvYqznVTZHUN/g79+8sDzJFo348tnPPVCYX8tK9bVnaCm4Jp5h5c/Gl6mIPZzby67qiicpbhwLgg==
X-Received: by 2002:a63:5d03:: with SMTP id r3mr4264664pgb.306.1575474826147;
        Wed, 04 Dec 2019 07:53:46 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.79])
        by smtp.gmail.com with ESMTPSA id y17sm8080389pfn.86.2019.12.04.07.53.44
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Dec 2019 07:53:45 -0800 (PST)
To:     stable@vger.kernel.org
From:   Jens Axboe <axboe@kernel.dk>
Subject: io_uring stable addition
Message-ID: <a33932d5-c5ff-ff4d-2bb4-3a1c3401a850@kernel.dk>
Date:   Wed, 4 Dec 2019 08:53:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

We have an issue with drains not working due to missing copy of some
state, it's affecting 5.2/5.3/5.4. I'm attaching the patch for 5.4,
however the patch should apply to 5.2 and 5.3 as well by just removing
the last hunk. The last hunk is touching the linked code, which was
introduced with 5.4.

Can we get this queued up for stable? Thanks! Don't have an email for
Tomáš, assuming the reported-by is fine with just his name. Want to
ensure I include attribution I do have.


From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: ensure req->submit is copied when req is deferred

There's an issue with deferred requests through drain, where if we do
need to defer, we're not copying over the sqe_submit state correctly.
This can result in using uninitialized data when we then later go and
submit the deferred request, like this check in __io_submit_sqe():

         if (unlikely(s->index >= ctx->sq_entries))
                 return -EINVAL;

with 's' being uninitialized, we can randomly fail this check. Fix this
by copying sqe_submit state when we defer a request.

Reported-by: Andres Freund <andres@anarazel.de>
Reported-by: Tomáš Chaloupka
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2c819c3c855d..0393545a39a7 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2016,7 +2017,7 @@ static int io_timeout(struct io_kiocb *req, const struct io_uring_sqe *sqe)
  }
  
  static int io_req_defer(struct io_ring_ctx *ctx, struct io_kiocb *req,
-			const struct io_uring_sqe *sqe)
+			struct sqe_submit *s)
  {
  	struct io_uring_sqe *sqe_copy;
  
@@ -2034,7 +2035,8 @@ static int io_req_defer(struct io_ring_ctx *ctx, struct io_kiocb *req,
  		return 0;
  	}
  
-	memcpy(sqe_copy, sqe, sizeof(*sqe_copy));
+	memcpy(&req->submit, s, sizeof(*s));
+	memcpy(sqe_copy, s->sqe, sizeof(*sqe_copy));
  	req->submit.sqe = sqe_copy;
  
  	INIT_WORK(&req->work, io_sq_wq_submit_work);
@@ -2399,7 +2401,7 @@ static int io_queue_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
  {
  	int ret;
  
-	ret = io_req_defer(ctx, req, s->sqe);
+	ret = io_req_defer(ctx, req, s);
  	if (ret) {
  		if (ret != -EIOCBQUEUED) {
  			io_free_req(req);
@@ -2426,7 +2428,7 @@ static int io_queue_link_head(struct io_ring_ctx *ctx, struct io_kiocb *req,
  	 * list.
  	 */
  	req->flags |= REQ_F_IO_DRAIN;
-	ret = io_req_defer(ctx, req, s->sqe);
+	ret = io_req_defer(ctx, req, s);
  	if (ret) {
  		if (ret != -EIOCBQUEUED) {
  			io_free_req(req);

-- 
Jens Axboe


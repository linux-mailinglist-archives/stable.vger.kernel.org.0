Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 726B63287CE
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:30:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238527AbhCAR2v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:28:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:48856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238249AbhCARYA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:24:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 12E2465068;
        Mon,  1 Mar 2021 16:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617331;
        bh=LhcZVeNCRJS1Z6vXuuq/RF6MV1TwjipyFenDsbvlGMM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1BRd3kAuUxlJ/IQ0F1kPn1f9oTPlWKlKrRy4xVSl/YLhoX3zMyWRfKXiwuJLydIwF
         6gkbA9eWF7bKSkNzVi2dVt039rVLvvZYDH6ypWdGVHpLqncm5HbAiC7ZapUXK9ik4O
         b8W0PN3paQhS9K5rxgRuAMSDxHe8VxRJJund+h3g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.4 009/340] bfq: Avoid false bfq queue merging
Date:   Mon,  1 Mar 2021 17:09:13 +0100
Message-Id: <20210301161048.765559820@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

commit 41e76c85660c022c6bf5713bfb6c21e64a487cec upstream.

bfq_setup_cooperator() uses bfqd->in_serv_last_pos so detect whether it
makes sense to merge current bfq queue with the in-service queue.
However if the in-service queue is freshly scheduled and didn't dispatch
any requests yet, bfqd->in_serv_last_pos is stale and contains value
from the previously scheduled bfq queue which can thus result in a bogus
decision that the two queues should be merged. This bug can be observed
for example with the following fio jobfile:

[global]
direct=0
ioengine=sync
invalidate=1
size=1g
rw=read

[reader]
numjobs=4
directory=/mnt

where the 4 processes will end up in the one shared bfq queue although
they do IO to physically very distant files (for some reason I was able to
observe this only with slice_idle=1ms setting).

Fix the problem by invalidating bfqd->in_serv_last_pos when switching
in-service queue.

Fixes: 058fdecc6de7 ("block, bfq: fix in-service-queue check for queue merging")
CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
Acked-by: Paolo Valente <paolo.valente@linaro.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/bfq-iosched.c |    1 +
 1 file changed, 1 insertion(+)

--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -2937,6 +2937,7 @@ static void __bfq_set_in_service_queue(s
 	}
 
 	bfqd->in_service_queue = bfqq;
+	bfqd->in_serv_last_pos = 0;
 }
 
 /*



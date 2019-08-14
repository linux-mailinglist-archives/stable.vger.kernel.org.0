Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5E528D91A
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:05:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729477AbfHNRFn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:05:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:54614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728559AbfHNRFk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:05:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C95B821721;
        Wed, 14 Aug 2019 17:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802340;
        bh=v4VLVQDSvMnhfsEqgws/49qzElS6zd8ANglCL/PMcNI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yRakyMTEJ/SodPrVMODLKmPH+gZnzogQLUVvVk81EQZjBbBKNbGZXU7xt64CO+9W5
         a4M/Kkkz62MmgXiPRuC3Vu7y0ywhjb+2YDGDqNGCFSW6mo3uTeoIayYI+63cN6Kxz4
         YNgZNaJzJe9kL0e3ab0Xz4ADkUnfzb7YtrjmhnEc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 060/144] rq-qos: dont reset has_sleepers on spurious wakeups
Date:   Wed, 14 Aug 2019 19:00:16 +0200
Message-Id: <20190814165802.340386441@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165759.466811854@linuxfoundation.org>
References: <20190814165759.466811854@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 64e7ea875ef63b2801be7954cf7257d1bfccc266 ]

If we raced with somebody else getting an inflight counter we could fail
to get an inflight counter with no sleepers on the list, and thus need
to go to sleep.  In this case has_sleepers should be true because we are
now relying on the waker to get our inflight counter for us.  And in the
case of spurious wakeups we'd still want this to be the case.  So set
has_sleepers to true if we went to sleep to make sure we're woken up the
proper way.

Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-rq-qos.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-rq-qos.c b/block/blk-rq-qos.c
index 659ccb8b693fa..e5d75280b431e 100644
--- a/block/blk-rq-qos.c
+++ b/block/blk-rq-qos.c
@@ -260,7 +260,7 @@ void rq_qos_wait(struct rq_wait *rqw, void *private_data,
 			break;
 		}
 		io_schedule();
-		has_sleeper = false;
+		has_sleeper = true;
 	} while (1);
 	finish_wait(&rqw->wait, &data.wq);
 }
-- 
2.20.1




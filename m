Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60E39178060
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 19:59:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732892AbgCCR4Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:56:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:38566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732863AbgCCR4Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:56:24 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2DDA20656;
        Tue,  3 Mar 2020 17:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583258184;
        bh=17gVuyQ1l3tn5XxQiYJeWbGZ1+R3HWDG6NBZT0iJcxg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WfeIO7hj3gm3jN4E5I84Ufru1xbYH6/nOtxDuWgdG97yK6LFkaXQePi5AKXL421GJ
         GDs5IgDJ2POaljJEc5GZTHP1PLhZHTN2bCEbdbA6lm0rbHkHWwB2+VNKtZjaxTVwwI
         O3qg0pTg3wA8ij2ODl563xzy+PMvMLlPBaT4Rbss=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bijan Mottahedeh <bijan.mottahedeh@oracle.com>,
        Sagi Grimberg <sagi@grimberg.me>, Jens Axboe <axboe@kernel.dk>,
        Keith Busch <kbusch@kernel.org>
Subject: [PATCH 5.4 104/152] nvme-pci: Hold cq_poll_lock while completing CQEs
Date:   Tue,  3 Mar 2020 18:43:22 +0100
Message-Id: <20200303174314.420132252@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174302.523080016@linuxfoundation.org>
References: <20200303174302.523080016@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>

commit 9515743bfb39c61aaf3d4f3219a645c8d1fe9a0e upstream.

Completions need to consumed in the same order the controller submitted
them, otherwise future completion entries may overwrite ones we haven't
handled yet. Hold the nvme queue's poll lock while completing new CQEs to
prevent another thread from freeing command tags for reuse out-of-order.

Fixes: dabcefab45d3 ("nvme: provide optimized poll function for separate poll queues")
Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/nvme/host/pci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1084,9 +1084,9 @@ static int nvme_poll(struct blk_mq_hw_ct
 
 	spin_lock(&nvmeq->cq_poll_lock);
 	found = nvme_process_cq(nvmeq, &start, &end, -1);
+	nvme_complete_cqes(nvmeq, start, end);
 	spin_unlock(&nvmeq->cq_poll_lock);
 
-	nvme_complete_cqes(nvmeq, start, end);
 	return found;
 }
 



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7187D411DEE
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:24:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344784AbhITR0M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:26:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:49392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349371AbhITRW4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:22:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6302761A81;
        Mon, 20 Sep 2021 17:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157289;
        bh=TNnIlN/FipTnrX/m7pCV4oGypbQ800FZkJL/lFe+UeI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dv6XDML2HekNwJWqVEUhxJ5/IaiQrL/iQy+YgC+FitpjL0cM+bLbDBUn/4YLicXdQ
         dgvfTB5aQgCLd1cw670fWmVPoyi8ytKKIIvR3qb7j84zrGKaHRS75YVvJIOOsD2JeX
         rxmgobHvo8drYECZgLwt6wfyXsILRUbec5iksx3Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>,
        Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4.14 108/217] block: bfq: fix bfq_set_next_ioprio_data()
Date:   Mon, 20 Sep 2021 18:42:09 +0200
Message-Id: <20210920163928.297882002@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163924.591371269@linuxfoundation.org>
References: <20210920163924.591371269@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Damien Le Moal <damien.lemoal@wdc.com>

commit a680dd72ec336b81511e3bff48efac6dbfa563e7 upstream.

For a request that has a priority level equal to or larger than
IOPRIO_BE_NR, bfq_set_next_ioprio_data() prints a critical warning but
defaults to setting the request new_ioprio field to IOPRIO_BE_NR. This
is not consistent with the warning and the allowed values for priority
levels. Fix this by setting the request new_ioprio field to
IOPRIO_BE_NR - 1, the lowest priority level allowed.

Cc: <stable@vger.kernel.org>
Fixes: aee69d78dec0 ("block, bfq: introduce the BFQ-v0 I/O scheduler as an extra scheduler")
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Link: https://lore.kernel.org/r/20210811033702.368488-2-damien.lemoal@wdc.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/bfq-iosched.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -3825,7 +3825,7 @@ bfq_set_next_ioprio_data(struct bfq_queu
 	if (bfqq->new_ioprio >= IOPRIO_BE_NR) {
 		pr_crit("bfq_set_next_ioprio_data: new_ioprio %d\n",
 			bfqq->new_ioprio);
-		bfqq->new_ioprio = IOPRIO_BE_NR;
+		bfqq->new_ioprio = IOPRIO_BE_NR - 1;
 	}
 
 	bfqq->entity.new_weight = bfq_ioprio_to_weight(bfqq->new_ioprio);



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 953A340E548
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:26:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245452AbhIPRKD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:10:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:35904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349853AbhIPRHw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:07:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ACD6D61B3D;
        Thu, 16 Sep 2021 16:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810175;
        bh=R1NafBof8/6TdChE5XijfeJnzbJe1uh8ymIGcb/0XFA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ID/ee7TgHrCqxOiekSq42c+kxu+rqXIFVNtAB0kIMEyqtJwrOjC+1Wya4C7YqQWyP
         d0vTyC2ohEz2zsHb6tc8rWaXi/LaPO+YL+/tO+jjbZliQVotYgCqVBJoYRuCdVd8qw
         joj8GjtOH6rc0oH/8hXDUUDMcvHoxFvV9QEf95BU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>,
        Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.14 044/432] block: bfq: fix bfq_set_next_ioprio_data()
Date:   Thu, 16 Sep 2021 17:56:33 +0200
Message-Id: <20210916155812.307764565@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
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
@@ -5296,7 +5296,7 @@ bfq_set_next_ioprio_data(struct bfq_queu
 	if (bfqq->new_ioprio >= IOPRIO_BE_NR) {
 		pr_crit("bfq_set_next_ioprio_data: new_ioprio %d\n",
 			bfqq->new_ioprio);
-		bfqq->new_ioprio = IOPRIO_BE_NR;
+		bfqq->new_ioprio = IOPRIO_BE_NR - 1;
 	}
 
 	bfqq->entity.new_weight = bfq_ioprio_to_weight(bfqq->new_ioprio);



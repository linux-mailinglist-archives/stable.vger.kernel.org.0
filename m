Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D94640E1DC
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:15:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243550AbhIPQcF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:32:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:38924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243166AbhIPQaH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:30:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 911056138F;
        Thu, 16 Sep 2021 16:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809138;
        bh=SBjnB2/jwGZQdtEUeDSV8Jvs09ODmXxMnqaoW1X+oEw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KomuwNnBOBcOora04pUO7FHUuxYabz7lv5tTGefZXbpE1kEx9vLCaVQKKr3NEqh/I
         Q8Ricv6tz8ZELgTAthbQLdRnmoxY5nko2NyAfjk8CdsfpowhqkuZCNfQ4/qNzdv/t6
         GsuDW8V8gbWz/yzKo6MqAGR9tt4ipopz/yZDDh+Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>,
        Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.13 037/380] block: bfq: fix bfq_set_next_ioprio_data()
Date:   Thu, 16 Sep 2021 17:56:34 +0200
Message-Id: <20210916155805.231647872@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
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
@@ -5258,7 +5258,7 @@ bfq_set_next_ioprio_data(struct bfq_queu
 	if (bfqq->new_ioprio >= IOPRIO_BE_NR) {
 		pr_crit("bfq_set_next_ioprio_data: new_ioprio %d\n",
 			bfqq->new_ioprio);
-		bfqq->new_ioprio = IOPRIO_BE_NR;
+		bfqq->new_ioprio = IOPRIO_BE_NR - 1;
 	}
 
 	bfqq->entity.new_weight = bfq_ioprio_to_weight(bfqq->new_ioprio);



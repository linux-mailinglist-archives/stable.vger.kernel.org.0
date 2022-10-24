Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B13C60A7FD
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 15:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234952AbiJXNAq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:00:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235172AbiJXM7d (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:59:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 695619AC31;
        Mon, 24 Oct 2022 05:18:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7FD2561311;
        Mon, 24 Oct 2022 12:17:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D077C433D6;
        Mon, 24 Oct 2022 12:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666613860;
        bh=E8zRWJgVGId9cs8kWTiDR2jfYW9wv4Ht58bFMgmBLW0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YOEkcqVRdBQ6KQipBUpNxjinP93lEFcEjwRDl3N7OPP2EHCUL5/8H86A8Aw7RlM0f
         G8CUY8xsCjIv5rSuhizrgoTJwZmdhrS/LjJrwP5OiqAY6gt+5fwCEYAUWWgI6yAByV
         BtBPU11LRK1eemZvePpIDPvTg6wSpaBd6X6Q3G2Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeffle Xu <jefflexu@linux.alibaba.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Khazhismel Kumykov <khazhy@google.com>
Subject: [PATCH 5.10 041/390] block: fix inflight statistics of part0
Date:   Mon, 24 Oct 2022 13:27:18 +0200
Message-Id: <20221024113024.353587445@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113022.510008560@linuxfoundation.org>
References: <20221024113022.510008560@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeffle Xu <jefflexu@linux.alibaba.com>

commit b0d97557ebfc9d5ba5f2939339a9fdd267abafeb upstream.

The inflight of partition 0 doesn't include inflight IOs to all
sub-partitions, since currently mq calculates inflight of specific
partition by simply camparing the value of the partition pointer.

Thus the following case is possible:

$ cat /sys/block/vda/inflight
       0        0
$ cat /sys/block/vda/vda1/inflight
       0      128

While single queue device (on a previous version, e.g. v3.10) has no
this issue:

$cat /sys/block/sda/sda3/inflight
       0       33
$cat /sys/block/sda/inflight
       0       33

Partition 0 should be specially handled since it represents the whole
disk. This issue is introduced since commit bf0ddaba65dd ("blk-mq: fix
sysfs inflight counter").

Besides, this patch can also fix the inflight statistics of part 0 in
/proc/diskstats. Before this patch, the inflight statistics of part 0
doesn't include that of sub partitions. (I have marked the 'inflight'
field with asterisk.)

$cat /proc/diskstats
 259       0 nvme0n1 45974469 0 367814768 6445794 1 0 1 0 *0* 111062 6445794 0 0 0 0 0 0
 259       2 nvme0n1p1 45974058 0 367797952 6445727 0 0 0 0 *33* 111001 6445727 0 0 0 0 0 0

This is introduced since commit f299b7c7a9de ("blk-mq: provide internal
in-flight variant").

Fixes: bf0ddaba65dd ("blk-mq: fix sysfs inflight counter")
Fixes: f299b7c7a9de ("blk-mq: provide internal in-flight variant")
Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
[axboe: adapt for 5.11 partition change]
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[khazhy: adapt for 5.10 partition]
Signed-off-by: Khazhismel Kumykov <khazhy@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-mq.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -105,7 +105,8 @@ static bool blk_mq_check_inflight(struct
 {
 	struct mq_inflight *mi = priv;
 
-	if (rq->part == mi->part && blk_mq_rq_state(rq) == MQ_RQ_IN_FLIGHT)
+	if ((!mi->part->partno || rq->part == mi->part) &&
+	    blk_mq_rq_state(rq) == MQ_RQ_IN_FLIGHT)
 		mi->inflight[rq_data_dir(rq)]++;
 
 	return true;



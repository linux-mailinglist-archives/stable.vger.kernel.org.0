Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30EF04FD813
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:35:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351640AbiDLHV0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:21:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351857AbiDLHNB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:13:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46BECDC8;
        Mon, 11 Apr 2022 23:53:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0037DB81B35;
        Tue, 12 Apr 2022 06:53:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D054C385A1;
        Tue, 12 Apr 2022 06:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746422;
        bh=x51UV5VOPeaHL0AME3MQUuSQK78drrrzIIMbVhno/eE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rsw/qHZnBLF/eyXikQ2almWTvHomLPW9zeCdb/pqF1wjHPnT/IQVuMQtn90aOVI8x
         H1AFOVLnB8fsYQRRBKphPwps5b21H7xmYyYloQ6iw5PnhFDVQui5w4Q0RSqyFTKRyz
         p8ZRnrAO9S/CYinKW3Okf/i7zjqyxxfbsZ02/Y8o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>,
        Wei Liu <wei.liu@kernel.org>
Subject: [PATCH 5.15 268/277] Drivers: hv: vmbus: Replace smp_store_mb() with virt_store_mb()
Date:   Tue, 12 Apr 2022 08:31:11 +0200
Message-Id: <20220412062949.799111130@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062942.022903016@linuxfoundation.org>
References: <20220412062942.022903016@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrea Parri (Microsoft) <parri.andrea@gmail.com>

commit eaa03d34535872d29004cb5cf77dc9dec1ba9a25 upstream.

Following the recommendation in Documentation/memory-barriers.txt for
virtual machine guests.

Fixes: 8b6a877c060ed ("Drivers: hv: vmbus: Replace the per-CPU channel lists with a global array of channels")
Signed-off-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
Link: https://lore.kernel.org/r/20220328154457.100872-1-parri.andrea@gmail.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hv/channel_mgmt.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/hv/channel_mgmt.c
+++ b/drivers/hv/channel_mgmt.c
@@ -380,7 +380,7 @@ void vmbus_channel_map_relid(struct vmbu
 	 * execute:
 	 *
 	 *  (a) In the "normal (i.e., not resuming from hibernation)" path,
-	 *      the full barrier in smp_store_mb() guarantees that the store
+	 *      the full barrier in virt_store_mb() guarantees that the store
 	 *      is propagated to all CPUs before the add_channel_work work
 	 *      is queued.  In turn, add_channel_work is queued before the
 	 *      channel's ring buffer is allocated/initialized and the
@@ -392,14 +392,14 @@ void vmbus_channel_map_relid(struct vmbu
 	 *      recv_int_page before retrieving the channel pointer from the
 	 *      array of channels.
 	 *
-	 *  (b) In the "resuming from hibernation" path, the smp_store_mb()
+	 *  (b) In the "resuming from hibernation" path, the virt_store_mb()
 	 *      guarantees that the store is propagated to all CPUs before
 	 *      the VMBus connection is marked as ready for the resume event
 	 *      (cf. check_ready_for_resume_event()).  The interrupt handler
 	 *      of the VMBus driver and vmbus_chan_sched() can not run before
 	 *      vmbus_bus_resume() has completed execution (cf. resume_noirq).
 	 */
-	smp_store_mb(
+	virt_store_mb(
 		vmbus_connection.channels[channel->offermsg.child_relid],
 		channel);
 }



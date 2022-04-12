Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A7BD4FD100
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 08:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230021AbiDLG4y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 02:56:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351446AbiDLGxh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 02:53:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84EA53DA48;
        Mon, 11 Apr 2022 23:40:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2F3EBB81B29;
        Tue, 12 Apr 2022 06:40:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80B43C385A6;
        Tue, 12 Apr 2022 06:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649745641;
        bh=oDImVcA9cfPt7E/z+vtoCCvZwDU3/Nit5GS/d6jmwkg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c+o/iUxBf/zyiA1NSu7553Z+g9BEM58UBnEyI1I5EVGNwD7e3LKsaTmal7Yx7fbYZ
         Jb9gDHgkOVcA3wPmlTYagxTr0eWIX2GCvtw1dwH0JqDrWA+hsurWSnHLVjitVSK6yk
         GbtX9ciUVV7rzmbqCi5ULJ8BnxJ6YqLIfikUS/tk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>,
        Wei Liu <wei.liu@kernel.org>
Subject: [PATCH 5.10 168/171] Drivers: hv: vmbus: Replace smp_store_mb() with virt_store_mb()
Date:   Tue, 12 Apr 2022 08:30:59 +0200
Message-Id: <20220412062932.761365844@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062927.870347203@linuxfoundation.org>
References: <20220412062927.870347203@linuxfoundation.org>
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
@@ -350,7 +350,7 @@ void vmbus_channel_map_relid(struct vmbu
 	 * execute:
 	 *
 	 *  (a) In the "normal (i.e., not resuming from hibernation)" path,
-	 *      the full barrier in smp_store_mb() guarantees that the store
+	 *      the full barrier in virt_store_mb() guarantees that the store
 	 *      is propagated to all CPUs before the add_channel_work work
 	 *      is queued.  In turn, add_channel_work is queued before the
 	 *      channel's ring buffer is allocated/initialized and the
@@ -362,14 +362,14 @@ void vmbus_channel_map_relid(struct vmbu
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



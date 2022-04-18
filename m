Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C7C6505435
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:02:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240638AbiDRNEx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:04:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241826AbiDRNDa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:03:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C24B33EB1;
        Mon, 18 Apr 2022 05:44:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D961C6124B;
        Mon, 18 Apr 2022 12:44:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E426CC385A1;
        Mon, 18 Apr 2022 12:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650285878;
        bh=Y+wvMQmBYMXimVlEy/JTM10FdVRp4VVo24cbL45XkYg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0FkQHjchSbsBagkLzD+6pwNrr7CB4mub+L2/0RimtrITc5S3pCrUoraVhaPk53B4n
         K6DkJnV4m6DiIvKU65jT5dioc9wDJDJzF0g7VA9YyTSwuHpM9RUPrZMgbbN2Ng8UP3
         u75szJ9+cpKTOMea+ruP/90Oi7cixzz2OwtK5mWM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nadav Amit <namit@vmware.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.4 53/63] smp: Fix offline cpu check in flush_smp_call_function_queue()
Date:   Mon, 18 Apr 2022 14:13:50 +0200
Message-Id: <20220418121137.744444333@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121134.149115109@linuxfoundation.org>
References: <20220418121134.149115109@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nadav Amit <namit@vmware.com>

commit 9e949a3886356fe9112c6f6f34a6e23d1d35407f upstream.

The check in flush_smp_call_function_queue() for callbacks that are sent
to offline CPUs currently checks whether the queue is empty.

However, flush_smp_call_function_queue() has just deleted all the
callbacks from the queue and moved all the entries into a local list.
This checks would only be positive if some callbacks were added in the
short time after llist_del_all() was called. This does not seem to be
the intention of this check.

Change the check to look at the local list to which the entries were
moved instead of the queue from which all the callbacks were just
removed.

Fixes: 8d056c48e4862 ("CPU hotplug, smp: flush any pending IPI callbacks before CPU offline")
Signed-off-by: Nadav Amit <namit@vmware.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20220319072015.1495036-1-namit@vmware.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/smp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -222,7 +222,7 @@ static void flush_smp_call_function_queu
 
 	/* There shouldn't be any pending callbacks on an offline CPU. */
 	if (unlikely(warn_cpu_offline && !cpu_online(smp_processor_id()) &&
-		     !warned && !llist_empty(head))) {
+		     !warned && entry != NULL)) {
 		warned = true;
 		WARN(1, "IPI on offline CPU %d\n", smp_processor_id());
 



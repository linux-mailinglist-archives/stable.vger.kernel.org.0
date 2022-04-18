Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9614D50555C
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:24:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241648AbiDRNMq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:12:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241103AbiDRNGf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:06:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 625E120BCD;
        Mon, 18 Apr 2022 05:47:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 12617B80E4E;
        Mon, 18 Apr 2022 12:47:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60619C385A7;
        Mon, 18 Apr 2022 12:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650286024;
        bh=GWct4j8vHMTNJlD+w0aPeGQoSvV2bVI6BpkNRMBq7SU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zvCdEZbo3WsjFCllwvMxPbLWO33A4SEh4azkqdsFMgLloBAOfDXDDCiqd/qjh29Vk
         DqPLoh+SBu/ZHCP77+95gGDQSBSmFVXIvYmquZRtD/ygfjjry7kILy/G0S+F3La3hI
         PrOC7SMUwhX+qKjYtuu+YnfmgnbJSdZnihjeHypk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nadav Amit <namit@vmware.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 4.19 31/32] smp: Fix offline cpu check in flush_smp_call_function_queue()
Date:   Mon, 18 Apr 2022 14:14:11 +0200
Message-Id: <20220418121128.032949764@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121127.127656835@linuxfoundation.org>
References: <20220418121127.127656835@linuxfoundation.org>
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
@@ -221,7 +221,7 @@ static void flush_smp_call_function_queu
 
 	/* There shouldn't be any pending callbacks on an offline CPU. */
 	if (unlikely(warn_cpu_offline && !cpu_online(smp_processor_id()) &&
-		     !warned && !llist_empty(head))) {
+		     !warned && entry != NULL)) {
 		warned = true;
 		WARN(1, "IPI on offline CPU %d\n", smp_processor_id());
 



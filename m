Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAF215B7456
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 17:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235970AbiIMPYh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 11:24:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236151AbiIMPXo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 11:23:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DF1B7B297;
        Tue, 13 Sep 2022 07:37:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7B52EB80FE7;
        Tue, 13 Sep 2022 14:35:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC76BC433D6;
        Tue, 13 Sep 2022 14:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663079719;
        bh=lMBmQCuOAROTSUMKv5nvaRUZ3Exuta+3MSNMDuwKbRg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TKEQAlBsHXDLYD+70MLm44goFsW0/BUN2LdJDJ1215ZBMGn0lzg936ME+Y8YWsrxA
         qnbCLLBXTdKxY8dWlBgrfbKVtJLk/8HjM4iTJynLz3BObwfka/pBYkry2zdM0Vjcvn
         ovJzFXnlvFy6FC7mle2DBAS8uoWivic29hQfRJkE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4.14 48/61] scsi: mpt3sas: Fix use-after-free warning
Date:   Tue, 13 Sep 2022 16:07:50 +0200
Message-Id: <20220913140348.870320531@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140346.422813036@linuxfoundation.org>
References: <20220913140346.422813036@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>

commit 991df3dd5144f2e6b1c38b8d20ed3d4d21e20b34 upstream.

Fix the following use-after-free warning which is observed during
controller reset:

refcount_t: underflow; use-after-free.
WARNING: CPU: 23 PID: 5399 at lib/refcount.c:28 refcount_warn_saturate+0xa6/0xf0

Link: https://lore.kernel.org/r/20220906134908.1039-2-sreekanth.reddy@broadcom.com
Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -2804,6 +2804,7 @@ static struct fw_event_work *dequeue_nex
 		fw_event = list_first_entry(&ioc->fw_event_list,
 				struct fw_event_work, list);
 		list_del_init(&fw_event->list);
+		fw_event_work_put(fw_event);
 	}
 	spin_unlock_irqrestore(&ioc->fw_event_lock, flags);
 
@@ -2840,7 +2841,6 @@ _scsih_fw_event_cleanup_queue(struct MPT
 		if (cancel_work_sync(&fw_event->work))
 			fw_event_work_put(fw_event);
 
-		fw_event_work_put(fw_event);
 	}
 }
 



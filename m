Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8B0D6AF242
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:52:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233367AbjCGSwF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:52:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231359AbjCGSvr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:51:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EBD9A76B6
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:40:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8CC2461526
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:39:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8450CC433EF;
        Tue,  7 Mar 2023 18:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678214360;
        bh=OUKx0O9/qLVy2CVxU/LKgpYFGwRNlpTn5XASeLVUjS0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jn8dMGR4NJEX+inR8scmG5r+lT0dOHaBW0IH+22rZKhAlGGCV3FzhGoZrpI2dr9aT
         7ewjILEyadKU1e7GKG67Y6kuVyLPEytgLOcBEv1ra0KJyVu/1CL4aPgsgU/TINDLSI
         13XYP7MJLe2zG7j0dglxQwchWzF90KT1cQJc482A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 6.1 795/885] dm: add cond_resched() to dm_wq_requeue_work()
Date:   Tue,  7 Mar 2023 18:02:09 +0100
Message-Id: <20230307170036.436147902@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Snitzer <snitzer@kernel.org>

commit f77692d65d54665d81815349cc727baa85e8b71d upstream.

Otherwise the while() loop in dm_wq_requeue_work() can result in a
"dead loop" on systems that have preemption disabled. This is
particularly problematic on single cpu systems.

Fixes: 8b211aaccb915 ("dm: add two stage requeue mechanism")
Cc: stable@vger.kernel.org
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1020,6 +1020,7 @@ static void dm_wq_requeue_work(struct wo
 		io->next = NULL;
 		__dm_io_complete(io, false);
 		io = next;
+		cond_resched();
 	}
 }
 



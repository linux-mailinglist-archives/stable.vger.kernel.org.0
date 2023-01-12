Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEC33667770
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:43:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238528AbjALOnT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:43:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238081AbjALOmg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:42:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 993DD42601
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:32:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2615162039
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:32:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16646C433A8;
        Thu, 12 Jan 2023 14:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673533929;
        bh=8yx7VHqOxfznkS4KtcOunc1wyZ2/AlyvqifprNDAnuY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DO4OURWcIc4MGeVUo3na6aaqrB8o4cvNCveJlKghPM2EHrZ6pP/g7uwkmvNxv71X8
         CS1waoyBMPaLTAL7Lmon+L9ez8pub/Mw0szlKTkPYZIAco8vfqhyu2ipOjmMvUVx7C
         hNLRMAzLLnfacFNzmM1twXoz69Qm4HIXHwX3trNI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Luo Meng <luomeng12@huawei.com>,
        Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 5.10 631/783] dm clone: Fix UAF in clone_dtr()
Date:   Thu, 12 Jan 2023 14:55:47 +0100
Message-Id: <20230112135553.559336345@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luo Meng <luomeng12@huawei.com>

commit e4b5957c6f749a501c464f92792f1c8e26b61a94 upstream.

Dm_clone also has the same UAF problem when dm_resume()
and dm_destroy() are concurrent.

Therefore, cancelling timer again in clone_dtr().

Cc: stable@vger.kernel.org
Fixes: 7431b7835f554 ("dm: add clone target")
Signed-off-by: Luo Meng <luomeng12@huawei.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-clone-target.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/md/dm-clone-target.c
+++ b/drivers/md/dm-clone-target.c
@@ -1966,6 +1966,7 @@ static void clone_dtr(struct dm_target *
 
 	mempool_exit(&clone->hydration_pool);
 	dm_kcopyd_client_destroy(clone->kcopyd_client);
+	cancel_delayed_work_sync(&clone->waker);
 	destroy_workqueue(clone->wq);
 	hash_table_exit(clone);
 	dm_clone_metadata_close(clone->cmd);



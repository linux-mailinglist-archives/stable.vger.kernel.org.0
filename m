Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 417596677A1
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:46:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239932AbjALOqD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:46:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238664AbjALOp1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:45:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B394C559F9
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:33:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 67798B81E69
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:33:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B846AC433EF;
        Thu, 12 Jan 2023 14:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673534026;
        bh=SHBOkh6gYiAYE9krLX7aewZ50j2jMcjc1ogtAwU3EWQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fYNTMoPBUFwmFkZpf+CC71hqcgYGGleEspdeTSlH7M1Mn7HQeIXJrcE0/alEU6myz
         Cf04+NM33M9jm0F/cMu3M34ctvjHue2nlj9A2xQUgmOFfqUW1uD4mcUHhmtAFYTkkR
         FwXwClAwX8gvGqtPP/3EvjSOAoJuYB1KjY+P6Yh8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Luo Meng <luomeng12@huawei.com>,
        Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 5.10 630/783] dm integrity: Fix UAF in dm_integrity_dtr()
Date:   Thu, 12 Jan 2023 14:55:46 +0100
Message-Id: <20230112135553.512094281@linuxfoundation.org>
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

commit f50cb2cbabd6c4a60add93d72451728f86e4791c upstream.

Dm_integrity also has the same UAF problem when dm_resume()
and dm_destroy() are concurrent.

Therefore, cancelling timer again in dm_integrity_dtr().

Cc: stable@vger.kernel.org
Fixes: 7eada909bfd7a ("dm: add integrity target")
Signed-off-by: Luo Meng <luomeng12@huawei.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-integrity.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -4388,6 +4388,8 @@ static void dm_integrity_dtr(struct dm_t
 	BUG_ON(!RB_EMPTY_ROOT(&ic->in_progress));
 	BUG_ON(!list_empty(&ic->wait_list));
 
+	if (ic->mode == 'B')
+		cancel_delayed_work_sync(&ic->bitmap_flush_work);
 	if (ic->metadata_wq)
 		destroy_workqueue(ic->metadata_wq);
 	if (ic->wait_wq)



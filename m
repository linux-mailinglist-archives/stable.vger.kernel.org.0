Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA28E69CC77
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:40:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbjBTNkh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:40:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231514AbjBTNkg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:40:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13C491C58D
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:40:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A653D60EA7
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:40:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B71E2C433D2;
        Mon, 20 Feb 2023 13:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676900435;
        bh=tlnF0aRLL0OO7zq4zta9AHbWNC51A2Pqbf849c5B8pM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sV7A5d2MYvXcnT6dzSj8dhuZpObQEPRyCbROeSWrt044A1R5TpwzICV98qgm6tw5j
         R1GIAaAxLIeb8NqkJ0GQR4HDg4Ki0E5MKeTAaLa8/ggZnqM6TtZp+Ry73WJYGRiGYN
         zheAlXrd7XXNXZxhhV2eG8LwOtyjICUAiDFX6bBs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Maurizio Lombardi <mlombard@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 08/89] scsi: target: core: Fix warning on RT kernels
Date:   Mon, 20 Feb 2023 14:35:07 +0100
Message-Id: <20230220133553.380921940@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133553.066768704@linuxfoundation.org>
References: <20230220133553.066768704@linuxfoundation.org>
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

From: Maurizio Lombardi <mlombard@redhat.com>

[ Upstream commit 84ed64b1a7a7fcd507598dee7708c1f225123711 ]

Calling spin_lock_irqsave() does not disable the interrupts on realtime
kernels, remove the warning and replace assert_spin_locked() with
lockdep_assert_held().

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20230110125310.55884-1-mlombard@redhat.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_tmr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
index 6d1179a7f043..bba24eaea2ce 100644
--- a/drivers/target/target_core_tmr.c
+++ b/drivers/target/target_core_tmr.c
@@ -95,8 +95,8 @@ static bool __target_check_io_state(struct se_cmd *se_cmd,
 {
 	struct se_session *sess = se_cmd->se_sess;
 
-	assert_spin_locked(&sess->sess_cmd_lock);
-	WARN_ON_ONCE(!irqs_disabled());
+	lockdep_assert_held(&sess->sess_cmd_lock);
+
 	/*
 	 * If command already reached CMD_T_COMPLETE state within
 	 * target_complete_cmd() or CMD_T_FABRIC_STOP due to shutdown,
-- 
2.39.0




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EB4E6C1632
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:03:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232117AbjCTPDS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:03:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230332AbjCTPCe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:02:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE3162195D
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 07:58:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7EA05B80ECD
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 14:58:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3217C433EF;
        Mon, 20 Mar 2023 14:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679324315;
        bh=yyAmvTzP9IHyWxV4Jdjqlo4809+LGWPKyRNtsQBqZ3k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kWzO4RfojWGrkWJCmjYU+ymNWICMK+Vl3uqejAWfnGXZxFTatkE0ayYl7iiqK42eF
         RJn7pwhnp9EKdQReBXqXQVLFbAa/PuyLzGvrdHXeHS7FEVoYJkFXadQ3E8vypemfuQ
         DlKiHstgOkY4OgkIvVr6KhS/TIleNrtbPiApzeK8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Daniil Tatianin <d-tatianin@yandex-team.ru>,
        Simon Horman <simon.horman@corigine.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 06/36] qed/qed_dev: guard against a possible division by zero
Date:   Mon, 20 Mar 2023 15:54:32 +0100
Message-Id: <20230320145424.474561208@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145424.191578432@linuxfoundation.org>
References: <20230320145424.191578432@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniil Tatianin <d-tatianin@yandex-team.ru>

[ Upstream commit 1a9dc5610ef89d807acdcfbff93a558f341a44da ]

Previously we would divide total_left_rate by zero if num_vports
happened to be 1 because non_requested_count is calculated as
num_vports - req_count. Guard against this by validating num_vports at
the beginning and returning an error otherwise.

Found by Linux Verification Center (linuxtesting.org) with the SVACE
static analysis tool.

Fixes: bcd197c81f63 ("qed: Add vport WFQ configuration APIs")
Signed-off-by: Daniil Tatianin <d-tatianin@yandex-team.ru>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Link: https://lore.kernel.org/r/20230309201556.191392-1-d-tatianin@yandex-team.ru
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qed/qed_dev.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_dev.c b/drivers/net/ethernet/qlogic/qed/qed_dev.c
index e50fc8f714dcf..7e5beb4136014 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_dev.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_dev.c
@@ -4062,6 +4062,11 @@ static int qed_init_wfq_param(struct qed_hwfn *p_hwfn,
 
 	num_vports = p_hwfn->qm_info.num_vports;
 
+	if (num_vports < 2) {
+		DP_NOTICE(p_hwfn, "Unexpected num_vports: %d\n", num_vports);
+		return -EINVAL;
+	}
+
 	/* Accounting for the vports which are configured for WFQ explicitly */
 	for (i = 0; i < num_vports; i++) {
 		u32 tmp_speed;
-- 
2.39.2




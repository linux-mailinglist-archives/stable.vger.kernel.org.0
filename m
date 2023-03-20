Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D80B56C1858
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:23:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232713AbjCTPXi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:23:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232111AbjCTPXR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:23:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B19BAA25B
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:16:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8863CB80D34
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:16:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1A0DC4339B;
        Mon, 20 Mar 2023 15:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325364;
        bh=AJP7oNcdbJX/dQ+np7TFPAclgxmHUJa1+6jzkW3nMdE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CVJrYQ11zMp6U1rCbhbNw6MOaCLIAWb7RKlmYUZFiHabQtM1WFkh7Hv7+Fj1+JNdM
         5HstaX/qZMjbUCD8RRX/R70SSbS5oRmeALkwILE1Tcm8y3Lah0OQo8/0m9nWIrqV/I
         IM/6/ryUnAolY0T0cMaUHzmZdyUqWBo73xpdBTXU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Daniil Tatianin <d-tatianin@yandex-team.ru>,
        Simon Horman <simon.horman@corigine.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 047/198] qed/qed_dev: guard against a possible division by zero
Date:   Mon, 20 Mar 2023 15:53:05 +0100
Message-Id: <20230320145509.450849375@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145507.420176832@linuxfoundation.org>
References: <20230320145507.420176832@linuxfoundation.org>
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
index d61cd32ec3b65..86a93cac26470 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_dev.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_dev.c
@@ -5083,6 +5083,11 @@ static int qed_init_wfq_param(struct qed_hwfn *p_hwfn,
 
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




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA33759A1C3
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:35:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351584AbiHSQLq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:11:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351620AbiHSQI4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:08:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8CD12CE33;
        Fri, 19 Aug 2022 08:56:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9A875B8280C;
        Fri, 19 Aug 2022 15:56:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C6B8C433D7;
        Fri, 19 Aug 2022 15:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924595;
        bh=C+7qbxZDcsHmioA8hGAKIIf6AxtRN3IaVwqqKwIMSR0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AVgU59mM3PEXyMhgJe4+HWiGriZaz5cjnm0yV3iYCXuS13+mMjYNuJu8hFfLwdH/N
         29/t9zxPY5gvTqaK/wRfshhCzVGh4q473/IKjbzF0XKJZNc7eTSSy8a7an94Lz7G9a
         Um0yST6wK/TEJxEwos6tZRK/bN3d1mRx33liMfsw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexey Kodanev <aleksei.kodanev@bell-sw.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 180/545] wifi: iwlegacy: 4965: fix potential off-by-one overflow in il4965_rs_fill_link_cmd()
Date:   Fri, 19 Aug 2022 17:39:10 +0200
Message-Id: <20220819153837.419379545@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
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

From: Alexey Kodanev <aleksei.kodanev@bell-sw.com>

[ Upstream commit a8eb8e6f7159c7c20c0ddac428bde3d110890aa7 ]

As a result of the execution of the inner while loop, the value
of 'idx' can be equal to LINK_QUAL_MAX_RETRY_NUM. However, this
is not checked after the loop and 'idx' is used to write the
LINK_QUAL_MAX_RETRY_NUM size array 'lq_cmd->rs_table[idx]' below
in the outer loop.

The fix is to check the new value of 'idx' inside the nested loop,
and break both loops if index equals the size. Checking it at the
start is now pointless, so let's remove it.

Detected using the static analysis tool - Svace.

Fixes: be663ab67077 ("iwlwifi: split the drivers for agn and legacy devices 3945/4965")
Signed-off-by: Alexey Kodanev <aleksei.kodanev@bell-sw.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20220608171614.28891-1-aleksei.kodanev@bell-sw.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlegacy/4965-rs.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlegacy/4965-rs.c b/drivers/net/wireless/intel/iwlegacy/4965-rs.c
index 9a491e5db75b..532e3b91777d 100644
--- a/drivers/net/wireless/intel/iwlegacy/4965-rs.c
+++ b/drivers/net/wireless/intel/iwlegacy/4965-rs.c
@@ -2403,7 +2403,7 @@ il4965_rs_fill_link_cmd(struct il_priv *il, struct il_lq_sta *lq_sta,
 		/* Repeat initial/next rate.
 		 * For legacy IL_NUMBER_TRY == 1, this loop will not execute.
 		 * For HT IL_HT_NUMBER_TRY == 3, this executes twice. */
-		while (repeat_rate > 0 && idx < LINK_QUAL_MAX_RETRY_NUM) {
+		while (repeat_rate > 0) {
 			if (is_legacy(tbl_type.lq_type)) {
 				if (ant_toggle_cnt < NUM_TRY_BEFORE_ANT_TOGGLE)
 					ant_toggle_cnt++;
@@ -2422,6 +2422,8 @@ il4965_rs_fill_link_cmd(struct il_priv *il, struct il_lq_sta *lq_sta,
 			    cpu_to_le32(new_rate);
 			repeat_rate--;
 			idx++;
+			if (idx >= LINK_QUAL_MAX_RETRY_NUM)
+				goto out;
 		}
 
 		il4965_rs_get_tbl_info_from_mcs(new_rate, lq_sta->band,
@@ -2466,6 +2468,7 @@ il4965_rs_fill_link_cmd(struct il_priv *il, struct il_lq_sta *lq_sta,
 		repeat_rate--;
 	}
 
+out:
 	lq_cmd->agg_params.agg_frame_cnt_limit = LINK_QUAL_AGG_FRAME_LIMIT_DEF;
 	lq_cmd->agg_params.agg_dis_start_th = LINK_QUAL_AGG_DISABLE_START_DEF;
 
-- 
2.35.1




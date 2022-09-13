Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C50575B73B9
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 17:13:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235621AbiIMPLP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 11:11:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235820AbiIMPJ1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 11:09:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8E9E6A4B4;
        Tue, 13 Sep 2022 07:32:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E337614CF;
        Tue, 13 Sep 2022 14:30:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAFB6C433C1;
        Tue, 13 Sep 2022 14:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663079446;
        bh=LEpUZMkV6Ilyrdm2GkdaMsTLhpVpLArKf32CrezfHIY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pt90J1PMcWbrj1QS54+j8PurYxVPuWqCM4oUpv21QFfuqVWWDDr0GW0iA1H6dZ0q7
         zxDgqJtVYGokXpJ1NS7B2XjDUHqOWVzItfGnTUqMwcExXUMircPwCtk0O9POqSU/Gd
         eeW5SNBHyQEM+GPLWN+C1cgt+PJlPYyReg+kJd7E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stanislaw Gruszka <stf_xl@wp.pl>,
        Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 4.19 03/79] wifi: iwlegacy: 4965: corrected fix for potential off-by-one overflow in il4965_rs_fill_link_cmd()
Date:   Tue, 13 Sep 2022 16:06:21 +0200
Message-Id: <20220913140349.014608159@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140348.835121645@linuxfoundation.org>
References: <20220913140348.835121645@linuxfoundation.org>
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

From: Stanislaw Gruszka <stf_xl@wp.pl>

commit 6d0ef7241553f3553a0a2764c69b07892705924c upstream.

This reverts commit a8eb8e6f7159c7c20c0ddac428bde3d110890aa7 as
it can cause invalid link quality command sent to the firmware
and address the off-by-one issue by fixing condition of while loop.

Cc: stable@vger.kernel.org
Fixes: a8eb8e6f7159 ("wifi: iwlegacy: 4965: fix potential off-by-one overflow in il4965_rs_fill_link_cmd()")
Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20220815073737.GA999388@wp.pl
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/intel/iwlegacy/4965-rs.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/drivers/net/wireless/intel/iwlegacy/4965-rs.c
+++ b/drivers/net/wireless/intel/iwlegacy/4965-rs.c
@@ -2422,7 +2422,7 @@ il4965_rs_fill_link_cmd(struct il_priv *
 		/* Repeat initial/next rate.
 		 * For legacy IL_NUMBER_TRY == 1, this loop will not execute.
 		 * For HT IL_HT_NUMBER_TRY == 3, this executes twice. */
-		while (repeat_rate > 0) {
+		while (repeat_rate > 0 && idx < (LINK_QUAL_MAX_RETRY_NUM - 1)) {
 			if (is_legacy(tbl_type.lq_type)) {
 				if (ant_toggle_cnt < NUM_TRY_BEFORE_ANT_TOGGLE)
 					ant_toggle_cnt++;
@@ -2441,8 +2441,6 @@ il4965_rs_fill_link_cmd(struct il_priv *
 			    cpu_to_le32(new_rate);
 			repeat_rate--;
 			idx++;
-			if (idx >= LINK_QUAL_MAX_RETRY_NUM)
-				goto out;
 		}
 
 		il4965_rs_get_tbl_info_from_mcs(new_rate, lq_sta->band,
@@ -2487,7 +2485,6 @@ il4965_rs_fill_link_cmd(struct il_priv *
 		repeat_rate--;
 	}
 
-out:
 	lq_cmd->agg_params.agg_frame_cnt_limit = LINK_QUAL_AGG_FRAME_LIMIT_DEF;
 	lq_cmd->agg_params.agg_dis_start_th = LINK_QUAL_AGG_DISABLE_START_DEF;
 



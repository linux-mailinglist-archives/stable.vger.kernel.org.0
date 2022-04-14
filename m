Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9FE550119F
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245087AbiDNNiL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:38:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344429AbiDNNcE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:32:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1EA2BF54;
        Thu, 14 Apr 2022 06:29:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9FC8EB82893;
        Thu, 14 Apr 2022 13:29:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E52DFC385A1;
        Thu, 14 Apr 2022 13:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649942976;
        bh=WuMbpQJqPc+BMU+TWM9FmX46rYyb+WkfYBs1d+P81t0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ccndDuVZjSI2IpsQQHxglszlTxZ4cUhqYESXWwhO5sS4SAv0VD1ExS1MBHb7mOYF7
         rx/3Ukob06rgIsSPuisuk7N3NwAWwpgA+Uy8HJwHkhsldg93c4mGNtWYigYnzE3Fpn
         7ngTLXKawR6t7v+JEdz5t1L7v3JJ62UfpZ1tblps=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lucas Denefle <lucas.denefle@converge.io>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 289/338] w1: w1_therm: fixes w1_seq for ds28ea00 sensors
Date:   Thu, 14 Apr 2022 15:13:12 +0200
Message-Id: <20220414110847.115509822@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110838.883074566@linuxfoundation.org>
References: <20220414110838.883074566@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Lucas Denefle <lucas.denefle@converge.io>

[ Upstream commit 41a92a89eee819298f805c40187ad8b02bb53426 ]

w1_seq was failing due to several devices responding to the
CHAIN_DONE at the same time. Now properly selects the current
device in the chain with MATCH_ROM. Also acknowledgment was
read twice.

Signed-off-by: Lucas Denefle <lucas.denefle@converge.io>
Link: https://lore.kernel.org/r/20220223113558.232750-1-lucas.denefle@converge.io
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/w1/slaves/w1_therm.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/w1/slaves/w1_therm.c b/drivers/w1/slaves/w1_therm.c
index 3c350dfbcd0b..aba727294bc8 100644
--- a/drivers/w1/slaves/w1_therm.c
+++ b/drivers/w1/slaves/w1_therm.c
@@ -693,16 +693,20 @@ static ssize_t w1_seq_show(struct device *device,
 		if (sl->reg_num.id == reg_num->id)
 			seq = i;
 
+		if (w1_reset_bus(sl->master))
+			goto error;
+
+		/* Put the device into chain DONE state */
+		w1_write_8(sl->master, W1_MATCH_ROM);
+		w1_write_block(sl->master, (u8 *)&rn, 8);
 		w1_write_8(sl->master, W1_42_CHAIN);
 		w1_write_8(sl->master, W1_42_CHAIN_DONE);
 		w1_write_8(sl->master, W1_42_CHAIN_DONE_INV);
-		w1_read_block(sl->master, &ack, sizeof(ack));
 
 		/* check for acknowledgment */
 		ack = w1_read_8(sl->master);
 		if (ack != W1_42_SUCCESS_CONFIRM_BYTE)
 			goto error;
-
 	}
 
 	/* Exit from CHAIN state */
-- 
2.35.1




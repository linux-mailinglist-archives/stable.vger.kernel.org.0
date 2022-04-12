Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 346F54FD671
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355835AbiDLH3Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:29:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240435AbiDLHT0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:19:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75DD925C76;
        Mon, 11 Apr 2022 23:59:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CE392B81A8F;
        Tue, 12 Apr 2022 06:59:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C94DC385A1;
        Tue, 12 Apr 2022 06:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746770;
        bh=f5WP94l2ij7cAQc6yP2J2xfY3E3FBE12z8liPEMYcEg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eD7f+AJANjBqUBp6R9/cS6C0DxYyM6hOXOKC5w3s6y7lQAmPfPY8uSyde063MchDy
         o0jwOvAeAAjjOaTnHsTd3HCnWegvmdbaujVT4DrQNf9LlXCXKp4K/nBg+HZzEs8ma1
         Nn3Z77yaY9+MvpiQFn+Pe7CEalcAHEwivl3OjckU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lucas Denefle <lucas.denefle@converge.io>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 125/285] w1: w1_therm: fixes w1_seq for ds28ea00 sensors
Date:   Tue, 12 Apr 2022 08:29:42 +0200
Message-Id: <20220412062947.273912788@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062943.670770901@linuxfoundation.org>
References: <20220412062943.670770901@linuxfoundation.org>
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
index ca70c5f03206..9cbeeb4923ec 100644
--- a/drivers/w1/slaves/w1_therm.c
+++ b/drivers/w1/slaves/w1_therm.c
@@ -2090,16 +2090,20 @@ static ssize_t w1_seq_show(struct device *device,
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




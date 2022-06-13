Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47C4D54946A
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:32:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355822AbiFMLts (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:49:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357560AbiFMLqV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:46:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5721C13E27;
        Mon, 13 Jun 2022 03:52:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AF68BB80D3A;
        Mon, 13 Jun 2022 10:52:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17307C34114;
        Mon, 13 Jun 2022 10:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655117566;
        bh=f5PpVOOP3sRfv4brxVzINldqUAaGx0LXGTxUjPP4kic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bSTVZBB91Yz9zSHydNDsN6M8hYNk74vAUaiYf2yo5N76CjT0J8S/FFIZRXQNN+R1J
         CEcsu+83ozYeWd8DlHSQztJcb8VveOHv32g6nG1wIBgQNqR02H4vKXUPpITCvHH6Fv
         Rnss52rhL9se6ePb5rVhSTyeqlmcyM2d8IATGRiY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wenli Looi <wlooi@ucalgary.ca>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 058/287] ath9k: fix ar9003_get_eepmisc
Date:   Mon, 13 Jun 2022 12:08:02 +0200
Message-Id: <20220613094925.628008225@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094923.832156175@linuxfoundation.org>
References: <20220613094923.832156175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wenli Looi <wlooi@ucalgary.ca>

[ Upstream commit 9aaff3864b603408c02c629957ae8d8ff5d5a4f2 ]

The current implementation is reading the wrong eeprom type.

Fixes: d8ec2e2a63e8 ("ath9k: Add an eeprom_ops callback for retrieving the eepmisc value")
Signed-off-by: Wenli Looi <wlooi@ucalgary.ca>
Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20220320233010.123106-5-wlooi@ucalgary.ca
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 4d45d5a8ad2e..db583a6aeb0c 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -5615,7 +5615,7 @@ unsigned int ar9003_get_paprd_scale_factor(struct ath_hw *ah,
 
 static u8 ar9003_get_eepmisc(struct ath_hw *ah)
 {
-	return ah->eeprom.map4k.baseEepHeader.eepMisc;
+	return ah->eeprom.ar9300_eep.baseEepHeader.opCapFlags.eepMisc;
 }
 
 const struct eeprom_ops eep_ar9300_ops = {
-- 
2.35.1




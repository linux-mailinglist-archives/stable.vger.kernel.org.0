Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82F8B541971
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:22:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378085AbiFGVWK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:22:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380886AbiFGVRH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:17:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D42E21F9EE;
        Tue,  7 Jun 2022 11:58:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A57D66176D;
        Tue,  7 Jun 2022 18:58:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF3DCC34115;
        Tue,  7 Jun 2022 18:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628281;
        bh=NnXQHT5P4J/X8Kbs05INx5ZZMNbLDhdSV/Bsk9NGxg8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hy1zX11B7qN5NA+yYteD6KBhFHj8bX+LO9XH4afUXT16bKcx4QQBEJuG2+LyaztfW
         JW3+otmueU8+EIA3TC6NlnGzEkP/dcmLDmxETbUoNnhruyxc7dEKH3zni5Q8KFAJpK
         +qlIM5P56i1ClFIESZ+V55h0S6RFk4HTV2d6rZ8U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wenli Looi <wlooi@ucalgary.ca>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 271/879] ath9k: fix ar9003_get_eepmisc
Date:   Tue,  7 Jun 2022 18:56:29 +0200
Message-Id: <20220607165010.715719433@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
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
index b0a4ca3559fd..abed1effd95c 100644
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




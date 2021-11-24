Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 158E945C4E5
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:49:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354749AbhKXNw4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:52:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:40038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354495AbhKXNuy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:50:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 870946322E;
        Wed, 24 Nov 2021 13:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759050;
        bh=UGWsXtZD4HtpX0l6+YggKbhovcCPwxUC18g+pLyaXmQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NbmJDAuge5kZFydnXaEa7mxkzBmBEVueURWc89q3ok83dkine7dKAZyyLnAwqRnBR
         UNLllwIWgNiqPuqlq8Rx4oYsoUMPpYc8bPsDaZEI668jluEOKVwpPLlXOLJHUUsMQd
         CvINPDfxiRxTrznIRoZOY7XE4v2ph46PlUoNLbOY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Elder <elder@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 115/279] net: ipa: disable HOLB drop when updating timer
Date:   Wed, 24 Nov 2021 12:56:42 +0100
Message-Id: <20211124115722.761705009@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Elder <elder@linaro.org>

[ Upstream commit 816316cacad2b5abd5b41423cf04e4845239abd4 ]

The head-of-line blocking timer should only be modified when
head-of-line drop is disabled.

One of the steps in recovering from a modem crash is to enable
dropping of packets with timeout of 0 (immediate).  We don't know
how the modem configured its endpoints, so before we program the
timer, we need to ensure HOL_BLOCK is disabled.

Fixes: 84f9bd12d46db ("soc: qcom: ipa: IPA endpoints")
Signed-off-by: Alex Elder <elder@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ipa/ipa_endpoint.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 006da4642a0ba..ef790fd0ab56a 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -853,6 +853,7 @@ static void ipa_endpoint_init_hol_block_timer(struct ipa_endpoint *endpoint,
 	u32 offset;
 	u32 val;
 
+	/* This should only be changed when HOL_BLOCK_EN is disabled */
 	offset = IPA_REG_ENDP_INIT_HOL_BLOCK_TIMER_N_OFFSET(endpoint_id);
 	val = hol_block_timer_val(ipa, microseconds);
 	iowrite32(val, ipa->reg_virt + offset);
@@ -883,6 +884,7 @@ void ipa_endpoint_modem_hol_block_clear_all(struct ipa *ipa)
 		if (endpoint->toward_ipa || endpoint->ee_id != GSI_EE_MODEM)
 			continue;
 
+		ipa_endpoint_init_hol_block_enable(endpoint, false);
 		ipa_endpoint_init_hol_block_timer(endpoint, 0);
 		ipa_endpoint_init_hol_block_enable(endpoint, true);
 	}
-- 
2.33.0




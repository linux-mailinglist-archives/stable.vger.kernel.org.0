Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AFD845C4E1
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:49:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352372AbhKXNwy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:52:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:40040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354492AbhKXNuy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:50:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 340F76138F;
        Wed, 24 Nov 2021 13:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759046;
        bh=KYamQo9SxxRUI/rR7B+uhg2UMEcnlWUsFVv4r2iEVp4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OaOXAqIbCNmwMBPrQsCsH9+g06MCTdaYruCLuGvoE/ZolkhfAQdHMhzWDVPJ9jQHW
         gjVCgrpBDacav2jjB/zcgOgdVygVpaGk4OzDJsDH6pWkNj6DMk+x6OxK6I4kVnTMFt
         SdM+Rr5kk/o/e8Y+vDp/idO3tKYZquP6wCTz6t5o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Elder <elder@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 114/279] net: ipa: HOLB register sometimes must be written twice
Date:   Wed, 24 Nov 2021 12:56:41 +0100
Message-Id: <20211124115722.721316115@linuxfoundation.org>
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

[ Upstream commit 6e228d8cbb1cc6ba78022d406340e901e08d26e0 ]

Starting with IPA v4.5, the HOL_BLOCK_EN register must be written
twice when enabling head-of-line blocking avoidance.

Fixes: 84f9bd12d46db ("soc: qcom: ipa: IPA endpoints")
Signed-off-by: Alex Elder <elder@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ipa/ipa_endpoint.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 5528d97110d56..006da4642a0ba 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -868,6 +868,9 @@ ipa_endpoint_init_hol_block_enable(struct ipa_endpoint *endpoint, bool enable)
 	val = enable ? HOL_BLOCK_EN_FMASK : 0;
 	offset = IPA_REG_ENDP_INIT_HOL_BLOCK_EN_N_OFFSET(endpoint_id);
 	iowrite32(val, endpoint->ipa->reg_virt + offset);
+	/* When enabling, the register must be written twice for IPA v4.5+ */
+	if (enable && endpoint->ipa->version >= IPA_VERSION_4_5)
+		iowrite32(val, endpoint->ipa->reg_virt + offset);
 }
 
 void ipa_endpoint_modem_hol_block_clear_all(struct ipa *ipa)
-- 
2.33.0




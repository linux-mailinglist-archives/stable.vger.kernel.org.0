Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36C461D0EE9
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 12:03:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733161AbgEMJtC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:49:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:47684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732597AbgEMJs6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:48:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E6DC20575;
        Wed, 13 May 2020 09:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363337;
        bh=7t/1B8SMUNJlx2mXgH50/BFXjRUypT2lzL9JCbMpWjo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZBza9qcaCvBODFXALJWcuKB3vSkE+w3x8xafbDMyyoxwazuyPsccOnDu6t7QE6wkm
         LOzOfc1OMZqQl3aZBln+UqQvBCyjfRxm1/vrNSIY2q7L7VLEQ4xAMXMkVHAMt5y7iw
         OscTlE+d07E7GoVJxbofkE2RsqNBH8VVfrk/GXO8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 32/90] bnxt_en: Reduce BNXT_MSIX_VEC_MAX value to supported CQs per PF.
Date:   Wed, 13 May 2020 11:44:28 +0200
Message-Id: <20200513094411.891864798@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513094408.810028856@linuxfoundation.org>
References: <20200513094408.810028856@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

[ Upstream commit 9e68cb0359b20f99c7b070f1d3305e5e0a9fae6d ]

Broadcom adapters support only maximum of 512 CQs per PF. If user sets
MSIx vectors more than supported CQs, firmware is setting incorrect value
for msix_vec_per_pf_max parameter. Fix it by reducing the BNXT_MSIX_VEC_MAX
value to 512, even though the maximum # of MSIx vectors supported by adapter
are 1280.

Fixes: f399e8497826 ("bnxt_en: Use msix_vec_per_pf_max and msix_vec_per_pf_min devlink params.")
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h
@@ -39,7 +39,7 @@ static inline void bnxt_link_bp_to_dl(st
 #define NVM_OFF_DIS_GRE_VER_CHECK	171
 #define NVM_OFF_ENABLE_SRIOV		401
 
-#define BNXT_MSIX_VEC_MAX	1280
+#define BNXT_MSIX_VEC_MAX	512
 #define BNXT_MSIX_VEC_MIN_MAX	128
 
 enum bnxt_nvm_dir_type {



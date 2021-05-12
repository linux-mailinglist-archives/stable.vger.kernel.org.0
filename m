Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 110DD37C58B
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234028AbhELPlT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:41:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:51290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236043AbhELPgs (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:36:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B9BD61C39;
        Wed, 12 May 2021 15:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832692;
        bh=HAjZwOB7Sbf6jomtEiu3agcmtEFNo+gOOifVn3WIxO0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=McV1GE20H2g86LH/+g5ZvPZBQracGSYtYQ49KwqUCiwsTF8mVZ1voLkN22WL2KDgD
         eAR0jxGEMVWctABSq+atHcxtHPPrmzegYDmMiJuwNg2w7/wMr4wRVXWbmsiUCosB+k
         /C/DrUY6wzkBCe2v70wQ9NcMLcZVipQv/HbyyW2Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 385/530] nfc: pn533: prevent potential memory corruption
Date:   Wed, 12 May 2021 16:48:15 +0200
Message-Id: <20210512144832.427832448@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit ca4d4c34ae9aa5c3c0da76662c5e549d2fc0cc86 ]

If the "type_a->nfcid_len" is too large then it would lead to memory
corruption in pn533_target_found_type_a() when we do:

	memcpy(nfc_tgt->nfcid1, tgt_type_a->nfcid_data, nfc_tgt->nfcid1_len);

Fixes: c3b1e1e8a76f ("NFC: Export NFCID1 from pn533")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nfc/pn533/pn533.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/nfc/pn533/pn533.c b/drivers/nfc/pn533/pn533.c
index f7464bd6d57c..18e3435ab8f3 100644
--- a/drivers/nfc/pn533/pn533.c
+++ b/drivers/nfc/pn533/pn533.c
@@ -706,6 +706,9 @@ static bool pn533_target_type_a_is_valid(struct pn533_target_type_a *type_a,
 	if (PN533_TYPE_A_SEL_CASCADE(type_a->sel_res) != 0)
 		return false;
 
+	if (type_a->nfcid_len > NFC_NFCID1_MAXSIZE)
+		return false;
+
 	return true;
 }
 
-- 
2.30.2




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9025A38A46B
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:04:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234934AbhETKFk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:05:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:37244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235042AbhETKBx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:01:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 84D236188B;
        Thu, 20 May 2021 09:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503573;
        bh=Fwi46aN8Lroh7P3llNUWYvqlDdJ4u5WEjMbiHFpS/rA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LANjfGInpcL/RYtyrCdmvgW7kDAyDGA+FuqpxDVKfgZwG9iAYvxkCJpXH9v4j1XI7
         gh2YF04WX/yJNNOTplbI6KnvOtcfmaAABpED0TPTb2L9eFqwyNx8WTuBndf/j+eLnk
         0OdqIFY+BQ3fniFquoN42wVvP21p+w09VuFeb5is=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 255/425] nfc: pn533: prevent potential memory corruption
Date:   Thu, 20 May 2021 11:20:24 +0200
Message-Id: <20210520092139.806742005@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
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
index a0cc1cc45292..01da9331f4cb 100644
--- a/drivers/nfc/pn533/pn533.c
+++ b/drivers/nfc/pn533/pn533.c
@@ -692,6 +692,9 @@ static bool pn533_target_type_a_is_valid(struct pn533_target_type_a *type_a,
 	if (PN533_TYPE_A_SEL_CASCADE(type_a->sel_res) != 0)
 		return false;
 
+	if (type_a->nfcid_len > NFC_NFCID1_MAXSIZE)
+		return false;
+
 	return true;
 }
 
-- 
2.30.2




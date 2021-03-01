Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E49BA328E06
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:24:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241343AbhCATWm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:22:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:43884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241334AbhCATRl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:17:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D6ABC65176;
        Mon,  1 Mar 2021 17:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618461;
        bh=xxHIthO+Tx85OMbCDOiBkQxt46n8uaKklXdfUTJUu7w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wSNZbNVoSe6gcxK7jeCQD+mWvE5o+PZZLg52LOY1bxN8X6fsbeLaZsEziLIpgG1wS
         On45LkoFfp8RhSAgO0hXQ9bPBiQEF/nI0HCm7Csv0laVouUlNX1n1Ex20+xVSlhzCJ
         sRd57ZBI+65OW8fVvgurQb7bzEa/LF15gFEoiZWI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 094/663] iwlwifi: pnvm: increment the pointer before checking the TLV
Date:   Mon,  1 Mar 2021 17:05:42 +0100
Message-Id: <20210301161146.382404789@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

[ Upstream commit ff11a8ee2d2d0f78514ac9b42fb50c525ca695c7 ]

If the SKU_ID doesn't match, we don't increment the pointer and keep
checking the same TLV over and over again.

We need to increment the pointer in all situtations, namely if the TLV
is not a SKU_ID, if the SKU_ID matched or if the SKU_ID didn't match.
So we can increment the pointer already before checking for these
conditions to solve the problem.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Fixes: 6972592850c0 ("iwlwifi: read and parse PNVM file")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20210210172142.de94d366f3ff.I9a5a54906cf0f4ec8af981d6066bfd771152ffb9@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/fw/pnvm.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/pnvm.c b/drivers/net/wireless/intel/iwlwifi/fw/pnvm.c
index 1e16f83b402b8..37ce4fe136c5e 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/pnvm.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/pnvm.c
@@ -198,14 +198,14 @@ static int iwl_pnvm_parse(struct iwl_trans *trans, const u8 *data,
 				     le32_to_cpu(sku_id->data[1]),
 				     le32_to_cpu(sku_id->data[2]));
 
+			data += sizeof(*tlv) + ALIGN(tlv_len, 4);
+			len -= ALIGN(tlv_len, 4);
+
 			if (trans->sku_id[0] == le32_to_cpu(sku_id->data[0]) &&
 			    trans->sku_id[1] == le32_to_cpu(sku_id->data[1]) &&
 			    trans->sku_id[2] == le32_to_cpu(sku_id->data[2])) {
 				int ret;
 
-				data += sizeof(*tlv) + ALIGN(tlv_len, 4);
-				len -= ALIGN(tlv_len, 4);
-
 				ret = iwl_pnvm_handle_section(trans, data, len);
 				if (!ret)
 					return 0;
-- 
2.27.0




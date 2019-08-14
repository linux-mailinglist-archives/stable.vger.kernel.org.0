Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E1CC8DB28
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:23:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730012AbfHNRH6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:07:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:57726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730003AbfHNRH6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:07:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 55A9A214DA;
        Wed, 14 Aug 2019 17:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802477;
        bh=7u6y6PJryD4iCbF2IuVqPiFbr3X04F7zJDSfs/jAL1M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lO7CrVCGo+p0ddbYx6lCGvYiAvvkBXoyNZ5Cri8bv5TAZ+/DtfGNsARIDwPjlGoVO
         82A2Ys72JaPTmmzv75sw0X1iqtBD2pXiQYzR1DsSvPPvHojp5Hsh5y52UPbE/0Axmu
         Qazj/Nc6MPiWfmJrNh0sIXKNjQNybVxP9Zbc+5kY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.2 141/144] iwlwifi: mvm: fix an out-of-bound access
Date:   Wed, 14 Aug 2019 19:01:37 +0200
Message-Id: <20190814165805.863457330@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165759.466811854@linuxfoundation.org>
References: <20190814165759.466811854@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit ba3224db78034435e9ff0247277cce7c7bb1756c upstream.

The index for the elements of the ACPI object we dereference
was static. This means that if we called the function twice
we wouldn't start from 3 again, but rather from the latest
index we reached in the previous call.
This was dutifully reported by KASAN.

Fix this.

Cc: stable@vger.kernel.org
Fixes: 6996490501ed ("iwlwifi: mvm: add support for EWRD (Dynamic SAR) ACPI table")
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -753,7 +753,7 @@ static int iwl_mvm_sar_get_ewrd_table(st
 
 	for (i = 0; i < n_profiles; i++) {
 		/* the tables start at element 3 */
-		static int pos = 3;
+		int pos = 3;
 
 		/* The EWRD profiles officially go from 2 to 4, but we
 		 * save them in sar_profiles[1-3] (because we don't



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E77A31F069
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:44:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730766AbfEOLnm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:43:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:38120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731844AbfEOL1O (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:27:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 166BD2166E;
        Wed, 15 May 2019 11:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919633;
        bh=O3jLAS35KOhBoNrBnIE+M3oZ7XyfA1uIaCLqapopw5s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mouAywqLofbfxlTW6EtC+QSX8Yn8ZzwuV8KN8pEG1ykMqKVMQFxtKaU4SDSm+dtb9
         HsIUKPClAUXLAIcGa7Bon5qzt/TmC2HFBRj8J82MKuWiuPnNBU9WWXgKQCnDsb8vaf
         IW7MQjWxq5cZ74QwQevQSUgSNX6As/YG7cQ8V8LI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 028/137] tools/testing/nvdimm: Retain security state after overwrite
Date:   Wed, 15 May 2019 12:55:09 +0200
Message-Id: <20190515090655.330894122@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090651.633556783@linuxfoundation.org>
References: <20190515090651.633556783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 2170a0d53bee1a6c1a4ebd042f99d85aafc6c0ea ]

Overwrite retains the security state after completion of operation.  Fix
nfit_test to reflect this so that the kernel can test the behavior it is
more likely to see in practice.

Fixes: 926f74802cb1 ("tools/testing/nvdimm: Add overwrite support for nfit_test")
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/nvdimm/test/nfit.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
index cad719876ef45..85ffdcfa596b5 100644
--- a/tools/testing/nvdimm/test/nfit.c
+++ b/tools/testing/nvdimm/test/nfit.c
@@ -146,6 +146,7 @@ static int dimm_fail_cmd_code[ARRAY_SIZE(handle)];
 struct nfit_test_sec {
 	u8 state;
 	u8 ext_state;
+	u8 old_state;
 	u8 passphrase[32];
 	u8 master_passphrase[32];
 	u64 overwrite_end_time;
@@ -1100,7 +1101,7 @@ static int nd_intel_test_cmd_overwrite(struct nfit_test *t,
 		return 0;
 	}
 
-	memset(sec->passphrase, 0, ND_INTEL_PASSPHRASE_SIZE);
+	sec->old_state = sec->state;
 	sec->state = ND_INTEL_SEC_STATE_OVERWRITE;
 	dev_dbg(dev, "overwrite progressing.\n");
 	sec->overwrite_end_time = get_jiffies_64() + 5 * HZ;
@@ -1122,7 +1123,8 @@ static int nd_intel_test_cmd_query_overwrite(struct nfit_test *t,
 
 	if (time_is_before_jiffies64(sec->overwrite_end_time)) {
 		sec->overwrite_end_time = 0;
-		sec->state = 0;
+		sec->state = sec->old_state;
+		sec->old_state = 0;
 		sec->ext_state = ND_INTEL_SEC_ESTATE_ENABLED;
 		dev_dbg(dev, "overwrite is complete\n");
 	} else
-- 
2.20.1




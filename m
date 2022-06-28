Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD78A55EEF3
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 22:13:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230092AbiF1UNK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jun 2022 16:13:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229955AbiF1UMC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jun 2022 16:12:02 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C23A5101D5;
        Tue, 28 Jun 2022 13:04:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656446683; x=1687982683;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=u1MSbhZPQtG4XqXlLmpgY30iFg2GTY8fwGcYjkKQXX0=;
  b=Qu57fZcHJ+2lBxcFsVnI58UZTSVQxiF81BQnayGVfwX4EBMPschCrt8K
   Wksz6aEfBfjXMzpdap8Lu2/zirrQtuaGzK9jOk1zGxzTYjWmelQPj9ItJ
   NxAuyl/rg24/ftl2D8pjyqnv59b7a4LR1PP3PQgQ3aZm3yiPzvHUggQt8
   00kZ+r0Cw9FxfnmZtQ9no7xOXWur0/6MdwTrcXSzrx1mylr3tOZwDGIxS
   f/0QWCaCzLGijTFVhlGfSZ2g70PAx4UASQiNc2iVXNTS8y7FtfWZ8ohaK
   TbY2Hzd44J98QPwq4upMyEAHCta7Exu4n6WyD/KbxWdY56lYsRhvJmUYX
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="282930863"
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="282930863"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 13:04:43 -0700
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="658261931"
Received: from vrgatne-mobl.amr.corp.intel.com (HELO vverma7-desk1.intel.com) ([10.212.43.114])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 13:04:42 -0700
From:   Vishal Verma <vishal.l.verma@intel.com>
To:     <linux-cxl@vger.kernel.org>
Cc:     Vishal Verma <vishal.l.verma@intel.com>,
        Abhi Cs <abhi.cs@intel.com>, stable@vger.kernel.org,
        Ira Weiny <ira.weiny@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Alison Schofield <alison.schofield@intel.com>
Subject: [PATCH] cxl/mbox: Fix missing variable payload checks in cmd size validation
Date:   Tue, 28 Jun 2022 14:04:27 -0600
Message-Id: <20220628200427.601714-1-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1560; h=from:subject; bh=u1MSbhZPQtG4XqXlLmpgY30iFg2GTY8fwGcYjkKQXX0=; b=owGbwMvMwCXGf25diOft7jLG02pJDEm74/Zmacls+f7dJOuS5OXtXK9csl+vLyw9Ff1iyp93uZde 1XundZSyMIhxMciKKbL83fOR8Zjc9nyewARHmDmsTCBDGLg4BWAip3Yz/GKeUFS0NP315trVPSc3zZ mY/PDvWaeH+Tld1/apXGj9v9mEkeHyn+pLK3W/XefK2SbZlbP783duw1lbH0TOvDPdd0+waR83AA==
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The conversion of command sizes to unsigned missed a couple of checks
against variable size payloads during command validation, which made all
variable payload commands unconditionally fail. Add the checks back using
the new CXL_VARIABLE_PAYLOAD scheme.

Reported-by: Abhi Cs <abhi.cs@intel.com>
Fixes: 26f89535a5bb ("cxl/mbox: Use type __u32 for mailbox payload sizes")
Cc: <stable@vger.kernel.org>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 drivers/cxl/core/mbox.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
index 40e3ccb2bf3e..d929b89d12a7 100644
--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -355,12 +355,14 @@ static int cxl_to_mem_cmd(struct cxl_mem_command *mem_cmd,
 		return -EBUSY;
 
 	/* Check the input buffer is the expected size */
-	if (info->size_in != send_cmd->in.size)
-		return -ENOMEM;
+	if (info->size_in != CXL_VARIABLE_PAYLOAD)
+		if (info->size_in != send_cmd->in.size)
+			return -ENOMEM;
 
 	/* Check the output buffer is at least large enough */
-	if (send_cmd->out.size < info->size_out)
-		return -ENOMEM;
+	if (info->size_out != CXL_VARIABLE_PAYLOAD)
+		if (send_cmd->out.size < info->size_out)
+			return -ENOMEM;
 
 	*mem_cmd = (struct cxl_mem_command) {
 		.info = {

base-commit: 1985cf58850562e4b960e19d46f0d8f19d6c7cbd
-- 
2.36.1


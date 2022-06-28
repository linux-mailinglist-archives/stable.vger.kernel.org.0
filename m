Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF2FB55F0CC
	for <lists+stable@lfdr.de>; Wed, 29 Jun 2022 00:02:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbiF1WBY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jun 2022 18:01:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230101AbiF1WBW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jun 2022 18:01:22 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C73C23BC6;
        Tue, 28 Jun 2022 15:01:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656453681; x=1687989681;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=NbmPwvqMll5L108yNCJnt3K6AOKe4/adCY0m7n5Bi84=;
  b=fLjXvUJFxGeb5/K2jqkPhKneB9TnMXNbpbI7B54Oz6kUrh1pVC87dkvT
   H+os/DnjNI2NQ/SPe4TiYCi24A+axIpkbwqPkcmTK43Oe/rdhCfD0HVm4
   krAv51p9kDVcueVkhBsiPP4MC7Wt/5IvqoOj2YE32dJWpoLHTXMbNqmsk
   T884cP9zXBR6xJ8OaV59iD7BKT7u8kAKiUFj8enusTt1H/Sv+dllvtR14
   oYlAXtxP22S3T4Jed0PNF6vGOpmRNCf20bxBw7YhKk9z73QqZKdFCUtyl
   D88AdWWsGYkTmeabx69up1naHev9rwo4M+LxxfihPpR4awZK6WCMLIxzT
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="281893711"
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="281893711"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 15:01:21 -0700
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="647098061"
Received: from vrgatne-mobl.amr.corp.intel.com (HELO vverma7-desk1.intel.com) ([10.212.43.114])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 15:01:20 -0700
From:   Vishal Verma <vishal.l.verma@intel.com>
To:     <linux-cxl@vger.kernel.org>
Cc:     <patches@lists.linux.dev>, Vishal Verma <vishal.l.verma@intel.com>,
        stable@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Alison Schofield <alison.schofield@intel.com>,
        Abhi Cs <abhi.cs@intel.com>
Subject: [PATCH v2] cxl/mbox: Fix missing variable payload checks in cmd size validation
Date:   Tue, 28 Jun 2022 16:01:09 -0600
Message-Id: <20220628220109.633564-1-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1838; h=from:subject; bh=NbmPwvqMll5L108yNCJnt3K6AOKe4/adCY0m7n5Bi84=; b=owGbwMvMwCXGf25diOft7jLG02pJDEm7q1TbhTilbQq+72+0XrHppf+5HdOP7Vjp7ljkuqZi45rI KpGNHaUsDGJcDLJiiix/93xkPCa3PZ8nMMERZg4rE8gQBi5OAZhI1zaG/07vbD7+5emJDNlhMEHejf 9H2ZyTkitTfv47xFI3y/L3yo8M/4yu/xZ2L/tYszoviy1zn1dvp7GaPLezyOP8si4vjXU72AA=
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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

Fixes: 26f89535a5bb ("cxl/mbox: Use type __u32 for mailbox payload sizes")
Cc: <stable@vger.kernel.org>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>
Reported-by: Abhi Cs <abhi.cs@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---

Since v1[1]:
- Collect Reviewed-by tags
- Don't use nested if statements, switch to a compount if () instead.
  (Alison)

[1]: https://lore.kernel.org/all/20220628200427.601714-1-vishal.l.verma@intel.com/

 drivers/cxl/core/mbox.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
index 40e3ccb2bf3e..16176b9278b4 100644
--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -355,11 +355,13 @@ static int cxl_to_mem_cmd(struct cxl_mem_command *mem_cmd,
 		return -EBUSY;
 
 	/* Check the input buffer is the expected size */
-	if (info->size_in != send_cmd->in.size)
+	if ((info->size_in != CXL_VARIABLE_PAYLOAD) &&
+	    (info->size_in != send_cmd->in.size))
 		return -ENOMEM;
 
 	/* Check the output buffer is at least large enough */
-	if (send_cmd->out.size < info->size_out)
+	if ((info->size_out != CXL_VARIABLE_PAYLOAD) &&
+	    (send_cmd->out.size < info->size_out))
 		return -ENOMEM;
 
 	*mem_cmd = (struct cxl_mem_command) {

base-commit: 1985cf58850562e4b960e19d46f0d8f19d6c7cbd
-- 
2.36.1


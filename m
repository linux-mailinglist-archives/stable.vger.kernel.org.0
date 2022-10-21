Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D73F9607D2C
	for <lists+stable@lfdr.de>; Fri, 21 Oct 2022 19:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229987AbiJURHJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Oct 2022 13:07:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiJURHI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Oct 2022 13:07:08 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DCAC27E2C3
        for <stable@vger.kernel.org>; Fri, 21 Oct 2022 10:07:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666372028; x=1697908028;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9g7VJPzZR4Tk/JgWT8ugLgg1jxp2wRTDTshTcRCuEvo=;
  b=WFzw04Ao8jfUk3YHHsAH63iHUaYu5+t3o5BwWzwbxG+q8TfwcNI1J1iL
   m1/bV66/6HCheHnHHTgrOgprUzXnf+lSfvuJ9bBcIe8tXO0VYEIV+nlG6
   k77krynU2bDJLkhHITM2YDsXxATSAYcw22L5V/RrUXbb2CqBv2w8NnsMb
   uZy/xSTBnBURagX1ZBwLvQ+GhaZusK6OBxwaXRpcUd0zsPgqqEL8hBnQ2
   IcJfUKVQFJ1mTU3b/ELpluZzExCPpnuhIe8WkbG2212MtgsCJ/xH10kKY
   Hut9EilExE42I1bo6zq5uBstNOUh2JpzoXmXXWGd8e34rPefJLiqzBIp3
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10507"; a="308151183"
X-IronPort-AV: E=Sophos;i="5.95,202,1661842800"; 
   d="scan'208";a="308151183"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2022 10:06:46 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10507"; a="755889203"
X-IronPort-AV: E=Sophos;i="5.95,202,1661842800"; 
   d="scan'208";a="755889203"
Received: from tlkirkha-mobl2.amr.corp.intel.com (HELO guptapa-desk.intel.com) ([10.212.190.207])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2022 10:06:46 -0700
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     scott.d.constable@intel.com, dave.hansen@intel.com,
        johannes@sipsolutions.net, daniel.sneddon@linux.intel.com
Cc:     antonio.gomez.iglesias@linux.intel.com,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH v2 1/2] nospec: Add a generic barrier_nospec()
Date:   Fri, 21 Oct 2022 10:06:39 -0700
Message-Id: <c6d575974d1de8f60bc417c4e801e050cd368bc9.1666371873.git.pawan.kumar.gupta@linux.intel.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <cover.1666371873.git.pawan.kumar.gupta@linux.intel.com>
References: <cover.1666371873.git.pawan.kumar.gupta@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

barrier_nospec() is a speculation barrier with arch dependent
implementation. To be able to use barrier_nospec() in non-architecture
code add a generic version that does nothing. Architectures that don't
have a use case for speculation barrier shouldn't need to define an arch
specific version.

Architectures needing speculation barrier can override the generic
version in their asm/barrier.h.

Cc: <stable@vger.kernel.org>
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
---
 include/linux/nospec.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/nospec.h b/include/linux/nospec.h
index c1e79f72cd89..60e040a5df27 100644
--- a/include/linux/nospec.h
+++ b/include/linux/nospec.h
@@ -60,6 +60,10 @@ static inline unsigned long array_index_mask_nospec(unsigned long index,
 	(typeof(_i)) (_i & _mask);					\
 })
 
+#ifndef barrier_nospec
+#define barrier_nospec()	do { } while (0)
+#endif
+
 /* Speculation control prctl */
 int arch_prctl_spec_ctrl_get(struct task_struct *task, unsigned long which);
 int arch_prctl_spec_ctrl_set(struct task_struct *task, unsigned long which,
-- 
2.37.3


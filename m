Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A7C3646449
	for <lists+stable@lfdr.de>; Wed,  7 Dec 2022 23:52:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbiLGWwa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Dec 2022 17:52:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbiLGWw3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Dec 2022 17:52:29 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE79D66C93;
        Wed,  7 Dec 2022 14:52:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670453548; x=1701989548;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=TiQw9gnA/BtPLA6qK2uRjsuNq7tuXuBWsu83s/9U4YQ=;
  b=iEKwkOWLkCmYz/dzwlu07ZWaKeU/3VioiNQMrDZx3TJTazRB2pl5Enp8
   vARBLDef3QUN02HWJovE09pvs/92+Sfz8OQJb5nVfD66BUoJTGo1+reOv
   SuHv11YUhxHehPv+qPpGoyMkAyyRm7S+OwVZjj+qLwFIqqWEFj3RwNXyV
   7mJ2+Aq6OtcG5aGMU27xX2WVAMj9/unADIXIwx6Q3gteZJLSYlMTrFScb
   NStjp7gADeCQzPc8Ubi01entjwoC3RzUESSNY3+rOimd/fDDEtzHqMmOx
   rVUWZw7f0W0bF2QYRLD38hKH1LeBjdgw7MLDoQdnbqJ2Xs5QGHfUWy1wu
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="300439511"
X-IronPort-AV: E=Sophos;i="5.96,225,1665471600"; 
   d="scan'208";a="300439511"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2022 14:52:27 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="646781154"
X-IronPort-AV: E=Sophos;i="5.96,225,1665471600"; 
   d="scan'208";a="646781154"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2022 14:52:27 -0800
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     fenghua.yu@intel.com, dave.jiang@intel.com, vkoul@kernel.org,
        dmaengine@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH V2 0/3] dmaengine: idxd: Error path fixes
Date:   Wed,  7 Dec 2022 14:52:19 -0800
Message-Id: <cover.1670452419.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Changes since v1:
- V1: https://lore.kernel.org/lkml/cover.1670005163.git.reinette.chatre@intel.com/
- Cover trimmed after obtaining needed information.
- Added Reviewed-by tags.
- cc stable team.
- Please see individual patches for patch specific changes.

Dear Maintainers,

I have been using the IDXD driver to experiment with the upcoming core
changes in support of IMS ([1], [2], [3]). As part of this work I
happened to exercise the error paths within IDXD and encountered
a few issues that are addressed in this series. These changes are
independent from IMS and just aims to make the IDXD driver more
robust against errors.

Your feedback is greatly appreciated.

Reinette

[1] https://lore.kernel.org/lkml/20221111132706.104870257@linutronix.de
[2] https://lore.kernel.org/lkml/20221111131813.914374272@linutronix.dexo
[3] https://lore.kernel.org/lkml/20221111133158.196269823@linutronix.de

Reinette Chatre (3):
  dmaengine: idxd: Let probe fail when workqueue cannot be enabled
  dmaengine: idxd: Prevent use after free on completion memory
  dmaengine: idxd: Do not call DMX TX callbacks during workqueue disable

 drivers/dma/idxd/device.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)


base-commit: 76dcd734eca23168cb008912c0f69ff408905235
-- 
2.34.1


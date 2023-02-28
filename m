Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D243F6A50F1
	for <lists+stable@lfdr.de>; Tue, 28 Feb 2023 03:12:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbjB1CMB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Feb 2023 21:12:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbjB1CMA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Feb 2023 21:12:00 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 631B228D0C
        for <stable@vger.kernel.org>; Mon, 27 Feb 2023 18:11:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677550317; x=1709086317;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=CH4crPJsV7EqrvYa6g0lE9KRqB0M1/QFSQ01jEfNYNw=;
  b=gb6Y1vCBBhpmQftsHgURsxYKXLDuSzLIvjJh9gIBtgxsuOQPWVLGJX70
   3om+x3t9ok3FAPJdywBGOw+1rvUxvDUlv+k8I9jNpNWJaFvgfAdbBdzgx
   Zb8uzJIdcNCsE6IB8GqlhRxoQLPCkmhp+iNmFfDIZVe8zuNXly6V88rCB
   E3naCAPjGyb6KyCqY7ZXT3lGbQ6v7287bxrcXtV/X4v6AyR8Z+aCWPTct
   wK8GNOkhDa9rxfKC3BakiuzUuXJd2Yrf/FJodC18CJiyY32hOQ0Wp82r6
   g3QPWYf3cHvIPhkvx8laS4/ma3yeTMvPhD2YWtf7RAhMr+kUJF83IH78/
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10634"; a="396590497"
X-IronPort-AV: E=Sophos;i="5.98,220,1673942400"; 
   d="scan'208";a="396590497"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 18:11:56 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10634"; a="742804667"
X-IronPort-AV: E=Sophos;i="5.98,220,1673942400"; 
   d="scan'208";a="742804667"
Received: from gsavorni-mobl1.ger.corp.intel.com (HELO intel.com) ([10.249.41.82])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 18:11:53 -0800
From:   Andi Shyti <andi.shyti@linux.intel.com>
To:     intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        stable@vger.kernel.org
Cc:     Matthew Auld <matthew.auld@intel.com>,
        Maciej Patelczyk <maciej.patelczyk@intel.com>,
        Chris Wilson <chris.p.wilson@linux.intel.com>,
        Andi Shyti <andi.shyti@linux.intel.com>,
        Andi Shyti <andi@etezian.org>
Subject: [PATCH v3 0/2] Fix error propagation amongst request
Date:   Tue, 28 Feb 2023 03:11:40 +0100
Message-Id: <20230228021142.1905349-1-andi.shyti@linux.intel.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

This series of two patches fixes the issue introduced in
cf586021642d80 ("drm/i915/gt: Pipelined page migration") where,
as reported by Matt, in a chain of requests an error is reported
only if happens in the last request.

However Chris noticed that without ensuring exclusivity in the
locking we might end up in some deadlock. That's why patch 1
throttles for the ringspace in order to make sure that no one is
holding it.

Version 1 of this patch has been reviewed by matt and this
version is adding Chris exclusive locking.

Thanks Chris for this work.

Andi

Changelog
=========
v1 -> v2
 - Add patch 1 for ensuring exclusive locking of the timeline
 - Reword git commit of patch 2.

Andi Shyti (1):
  drm/i915/gt: Make sure that errors are propagated through request
    chains

Chris Wilson (1):
  drm/i915: Throttle for ringspace prior to taking the timeline mutex

 drivers/gpu/drm/i915/gt/intel_context.c | 41 +++++++++++++++++++++++++
 drivers/gpu/drm/i915/gt/intel_context.h |  2 ++
 drivers/gpu/drm/i915/gt/intel_migrate.c | 39 +++++++++++++++++------
 drivers/gpu/drm/i915/i915_request.c     |  3 ++
 4 files changed, 75 insertions(+), 10 deletions(-)

-- 
2.39.1


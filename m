Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD5C16DF3D4
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 13:36:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230335AbjDLLgC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 07:36:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231434AbjDLLf5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 07:35:57 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C0697292
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 04:35:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681299337; x=1712835337;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=DL3MgYnzKAEXsAUQPyglUiDH5LIQHjqJDKbmsnSxR2c=;
  b=l5XAXa7vw6On4KdkuP+hMx3W0X6G7OkMckKEDATm2pAPAZ7pd781m4nU
   nVX1PCU9VU79znqxMHJ0drKyUqv1yfKY/ZbfRcXx3e1xRlBtL2fbiIwmJ
   a0sLveAFbGb9Xan7FYtiSI7g4LK+Rbx1jlaxunR0nd5/DXBBmPnZGOxjZ
   PQLBS1/TDHiv0rTS2UwvN2AN8pYKPcb4HyYB/tblIyWVEcs4VVdnUZP6Z
   EYhdZaAvSG7nXK0leFAKh3FeN1afTeWFXxG9PfUb09d4+bPyXw0NLtxXM
   h0lHfvd9wGtgJGbuL+Fzv1nZmJUxV706Kdk3Nhg2dL1PX/AvT6WRWpIGm
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="327978205"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="327978205"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 04:33:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="778268708"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="778268708"
Received: from zbiro-mobl.ger.corp.intel.com (HELO intel.com) ([10.251.212.144])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 04:33:51 -0700
From:   Andi Shyti <andi.shyti@linux.intel.com>
To:     intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        stable@vger.kernel.org
Cc:     Matthew Auld <matthew.auld@intel.com>,
        Maciej Patelczyk <maciej.patelczyk@intel.com>,
        Chris Wilson <chris.p.wilson@linux.intel.com>,
        Andrzej Hajda <andrzej.hajda@intel.com>,
        Nirmoy Das <nirmoy.das@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Andi Shyti <andi.shyti@linux.intel.com>,
        Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH v5 0/5] Fix error propagation amongst request
Date:   Wed, 12 Apr 2023 13:33:03 +0200
Message-Id: <20230412113308.812468-1-andi.shyti@linux.intel.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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
v4 -> v5
 - add timeline locking also in the copy operation, which was
   forgottein in v4.
 - rearrange the patches in order to avoid a bisect break.

v3 -> v4
 - In v3 the timeline was being locked, but I forgot that also
   request_create() and request_add() are locking the timeline
   as well. The former does the locking, the latter does the
   unlocking. In order to avoid this extra lock/unlock, we need
   the "_locked" version of the said functions.

v2 -> v3
 - Really lock the timeline before generating all the requests
   until the last.

v1 -> v2
 - Add patch 1 for ensuring exclusive locking of the timeline
 - Reword git commit of patch 2.

Andi Shyti (4):
  drm/i915/gt: Add intel_context_timeline_is_locked helper
  drm/i915: Create the locked version of the request create
  drm/i915: Create the locked version of the request add
  drm/i915/gt: Make sure that errors are propagated through request
    chains

Chris Wilson (1):
  drm/i915: Throttle for ringspace prior to taking the timeline mutex

 drivers/gpu/drm/i915/gt/intel_context.c | 41 ++++++++++++++++++
 drivers/gpu/drm/i915/gt/intel_context.h |  8 ++++
 drivers/gpu/drm/i915/gt/intel_migrate.c | 51 +++++++++++++++++------
 drivers/gpu/drm/i915/i915_request.c     | 55 +++++++++++++++++++------
 drivers/gpu/drm/i915/i915_request.h     |  3 ++
 5 files changed, 133 insertions(+), 25 deletions(-)

-- 
2.39.2


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C8266B0326
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 10:41:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230079AbjCHJlj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 04:41:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbjCHJlh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 04:41:37 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C273B3719
        for <stable@vger.kernel.org>; Wed,  8 Mar 2023 01:41:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678268492; x=1709804492;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=KWpQuz/PUVQftjO9mghDpUWqWM3putIXGV1wXdueqW0=;
  b=Gl5MZS7oM9RoLp7vOywsuDMbnQh1RnrafrxcGKUsDHOrwRIkCvLaMXMr
   XYHzmj/ypSCzxJxf4NCNDZ5/NFg/qSv2l6+8LQsstQgTemr8gBYUM4alF
   Kbl/v1TYSEshqE8PvBx/CWAgMnXjLTuJbfL7oJVWmObBZjulGmv1Ph9Sh
   ti+PzhG9OCto2KNAWY9L4w88dyUp8sd5wMGCppgx0u949mElTXzzhKzvQ
   qOGqVj4SZ45u3g1Jg+cK20R3EDWkBJ0dqptfhhhNWVtQf5oqzYRvbRBx9
   rGdD9s/gBWcfB4zuw0bYN+8i2qM+U/AorqadMAh8s+IfPDd+KfzP44DDx
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="315772712"
X-IronPort-AV: E=Sophos;i="5.98,243,1673942400"; 
   d="scan'208";a="315772712"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2023 01:41:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="709362462"
X-IronPort-AV: E=Sophos;i="5.98,243,1673942400"; 
   d="scan'208";a="709362462"
Received: from gbain-mobl1.ger.corp.intel.com (HELO intel.com) ([10.252.47.108])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2023 01:41:29 -0800
From:   Andi Shyti <andi.shyti@linux.intel.com>
To:     intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        stable@vger.kernel.org
Cc:     Matthew Auld <matthew.auld@intel.com>,
        Maciej Patelczyk <maciej.patelczyk@intel.com>,
        Chris Wilson <chris.p.wilson@linux.intel.com>,
        Gwan-gyeong Mun <gwan-gyeong.mun@intel.com>,
        Andi Shyti <andi.shyti@linux.intel.com>,
        Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH v4 0/5] Fix error propagation amongst request
Date:   Wed,  8 Mar 2023 10:41:01 +0100
Message-Id: <20230308094106.203686-1-andi.shyti@linux.intel.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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

 drivers/gpu/drm/i915/gt/intel_context.c | 41 +++++++++++++++++++
 drivers/gpu/drm/i915/gt/intel_context.h |  8 ++++
 drivers/gpu/drm/i915/gt/intel_migrate.c | 41 ++++++++++++++-----
 drivers/gpu/drm/i915/i915_request.c     | 54 ++++++++++++++++++-------
 drivers/gpu/drm/i915/i915_request.h     |  3 ++
 5 files changed, 122 insertions(+), 25 deletions(-)

-- 
2.39.2


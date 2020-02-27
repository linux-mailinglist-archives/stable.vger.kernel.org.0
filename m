Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02747171D47
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:19:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389937AbgB0OTC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:19:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:59634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388967AbgB0OS7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:18:59 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD52520801;
        Thu, 27 Feb 2020 14:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582813139;
        bh=LGF5TDDcjeJpG25rN3SHM7dpbh0Kw+9Jjbg6p0/ySe4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GjD1shWPU5Nm+N0CZf7IlHQn9vBtt2bXiIkviAZkzcwMfJGi3UlMs55SgXW30y6gL
         VlV+FqUX9knrKdoMwJbpI4tif4l5rieKEJS4WIAYE7twEcWfW5QfnKeC9RMCZn+xXd
         4VSvJKlrKyN2WyN67qjMQduFecrIWr4JfMseAPVk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.5 111/150] drm/i915/selftests: Add a mock i915_vma to the mock_ring
Date:   Thu, 27 Feb 2020 14:37:28 +0100
Message-Id: <20200227132249.151357014@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132232.815448360@linuxfoundation.org>
References: <20200227132232.815448360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 1fdea0cb0dba0d42ffcfb619b349c1a2afa2492e upstream.

Add a i915_vma to the mock_engine/mock_ring so that the core code can
always assume the presence of ring->vma.

Fixes: 8ccfc20a7d56 ("drm/i915/gt: Mark ring->vma as active while pinned")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Reviewed-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200114160030.2468927-1-chris@chris-wilson.co.uk
(cherry picked from commit b63b4feaef7363d2cf46dd76bb6e87e060b2b0de)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/gt/mock_engine.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/gt/mock_engine.c
+++ b/drivers/gpu/drm/i915/gt/mock_engine.c
@@ -59,11 +59,26 @@ static struct intel_ring *mock_ring(stru
 	ring->vaddr = (void *)(ring + 1);
 	atomic_set(&ring->pin_count, 1);
 
+	ring->vma = i915_vma_alloc();
+	if (!ring->vma) {
+		kfree(ring);
+		return NULL;
+	}
+	i915_active_init(&ring->vma->active, NULL, NULL);
+
 	intel_ring_update_space(ring);
 
 	return ring;
 }
 
+static void mock_ring_free(struct intel_ring *ring)
+{
+	i915_active_fini(&ring->vma->active);
+	i915_vma_free(ring->vma);
+
+	kfree(ring);
+}
+
 static struct i915_request *first_request(struct mock_engine *engine)
 {
 	return list_first_entry_or_null(&engine->hw_queue,
@@ -121,7 +136,7 @@ static void mock_context_destroy(struct
 	GEM_BUG_ON(intel_context_is_pinned(ce));
 
 	if (test_bit(CONTEXT_ALLOC_BIT, &ce->flags)) {
-		kfree(ce->ring);
+		mock_ring_free(ce->ring);
 		mock_timeline_unpin(ce->timeline);
 	}
 



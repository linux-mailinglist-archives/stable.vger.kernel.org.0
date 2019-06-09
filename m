Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A30F3AA8B
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:19:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730759AbfFIQtR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:49:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:48708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731428AbfFIQtR (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:49:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4490D206C3;
        Sun,  9 Jun 2019 16:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560098956;
        bh=S74SuA89s3V4anDQnukivwqwDzCaQwnGacnKXxfMN4E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HEaSYtE3qo/egGjgMRulBJG3eWH4lHhRKLytCTNlkThJG0lT2gMZo7Z6cCnsniOHx
         eRlVWjhFc1nNwIFsyve34Losh9v5yevqU/uH+k11kGRoage+cnYdKNiwjlxEo9hzq+
         WMS0mh4Ft8oJGujo3sjSFqLa61jut5j9d/BzWalw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhenyu Wang <zhenyuw@linux.intel.com>,
        Tina Zhang <tina.zhang@intel.com>
Subject: [PATCH 4.19 50/51] drm/i915/gvt: Initialize intel_gvt_gtt_entry in stack
Date:   Sun,  9 Jun 2019 18:42:31 +0200
Message-Id: <20190609164130.939106753@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164127.123076536@linuxfoundation.org>
References: <20190609164127.123076536@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tina Zhang <tina.zhang@intel.com>

commit 387a4c2b55291b37e245c840813bd8a8bd06ed49 upstream.

Stack struct intel_gvt_gtt_entry value needs to be initialized before
being used, as the fields may contain garbage values.

W/o this patch, set_ggtt_entry prints:
-------------------------------------
274.046840: set_ggtt_entry: vgpu1:set ggtt entry 0x9bed8000ffffe900
274.046846: set_ggtt_entry: vgpu1:set ggtt entry 0xe55df001
274.046852: set_ggtt_entry: vgpu1:set ggtt entry 0x9bed8000ffffe900

0x9bed8000 is the stack grabage.

W/ this patch, set_ggtt_entry prints:
------------------------------------
274.046840: set_ggtt_entry: vgpu1:set ggtt entry 0xffffe900
274.046846: set_ggtt_entry: vgpu1:set ggtt entry 0xe55df001
274.046852: set_ggtt_entry: vgpu1:set ggtt entry 0xffffe900

v2:
- Initialize during declaration. (Zhenyu)

Fixes: 7598e8700e9a ("drm/i915/gvt: Missed to cancel dma map for ggtt entries")
Cc: stable@vger.kernel.org # v4.20+
Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
Reviewed-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Signed-off-by: Tina Zhang <tina.zhang@intel.com>
Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/gvt/gtt.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/gvt/gtt.c
+++ b/drivers/gpu/drm/i915/gvt/gtt.c
@@ -2161,7 +2161,8 @@ static int emulate_ggtt_mmio_write(struc
 	struct intel_gvt_gtt_pte_ops *ops = gvt->gtt.pte_ops;
 	unsigned long g_gtt_index = off >> info->gtt_entry_size_shift;
 	unsigned long gma, gfn;
-	struct intel_gvt_gtt_entry e, m;
+	struct intel_gvt_gtt_entry e = {.val64 = 0, .type = GTT_TYPE_GGTT_PTE};
+	struct intel_gvt_gtt_entry m = {.val64 = 0, .type = GTT_TYPE_GGTT_PTE};
 	dma_addr_t dma_addr;
 	int ret;
 
@@ -2237,7 +2238,8 @@ static int emulate_ggtt_mmio_write(struc
 
 	if (ops->test_present(&e)) {
 		gfn = ops->get_pfn(&e);
-		m = e;
+		m.val64 = e.val64;
+		m.type = e.type;
 
 		/* one PTE update may be issued in multiple writes and the
 		 * first write may not construct a valid gfn



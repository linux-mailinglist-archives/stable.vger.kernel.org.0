Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25CF9441842
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:43:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233787AbhKAJpY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:45:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:47848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233968AbhKAJnn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:43:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F8586138D;
        Mon,  1 Nov 2021 09:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758933;
        bh=/KhkdsKapMmW8vh6cfwiHUoygNWE67nyOgLDEfq/r3E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OptbuL/3DrMk2UHAgULt11N8wfeFkJry6LMO1mtUS3wkh+u6VdcJklqGUwbeUP2he
         viljZ5tVEAwsn56aNuZNhhwI6YRvlLAKUahiz8fwGlFh8Scwct+EjNfkESM8+2DmYN
         T2z1GNsNGFq2fKiHAS/UAByVhQEhosnsEqPae4LU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, Dave Airlie <airlied@redhat.com>,
        Jani Nikula <jani.nikula@intel.com>,
        =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@intel.com>
Subject: [PATCH 5.14 044/125] drm/i915: Convert unconditional clflush to drm_clflush_virt_range()
Date:   Mon,  1 Nov 2021 10:16:57 +0100
Message-Id: <20211101082541.517053190@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082533.618411490@linuxfoundation.org>
References: <20211101082533.618411490@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit fcf918ffd3b35e288097036c04af7446b2c6f2f1 upstream.

This one is apparently a "clflush for good measure", so bit more
justification (if you can call it that) than some of the others.
Convert to drm_clflush_virt_range() again so that machines without
clflush will survive the ordeal.

Cc: stable@vger.kernel.org
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Thomas Hellström <thomas.hellstrom@intel.com> #v1
Fixes: 12ca695d2c1e ("drm/i915: Do not share hwsp across contexts any more, v8.")
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20211014090941.12159-3-ville.syrjala@linux.intel.com
Reviewed-by: Dave Airlie <airlied@redhat.com>
(cherry picked from commit af7b6d234eefa30c461cc16912bafb32b9e6141c)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gt/intel_timeline.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/gt/intel_timeline.c
+++ b/drivers/gpu/drm/i915/gt/intel_timeline.c
@@ -225,7 +225,7 @@ void intel_timeline_reset_seqno(const st
 
 	memset(hwsp_seqno + 1, 0, TIMELINE_SEQNO_BYTES - sizeof(*hwsp_seqno));
 	WRITE_ONCE(*hwsp_seqno, tl->seqno);
-	clflush(hwsp_seqno);
+	drm_clflush_virt_range(hwsp_seqno, TIMELINE_SEQNO_BYTES);
 }
 
 void intel_timeline_enter(struct intel_timeline *tl)



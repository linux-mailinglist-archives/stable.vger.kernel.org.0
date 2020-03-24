Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36EFA19104F
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 14:31:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728477AbgCXN1H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 09:27:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:52438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729451AbgCXN1F (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Mar 2020 09:27:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 43140208D6;
        Tue, 24 Mar 2020 13:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585056424;
        bh=R+7RdjaeHHTHyIIQsmbxPDScEFfDDyBu7ZCI06D0i5o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b3sa+WXDODBf/YDQ3hZ/cJe/vzxmck8lovUM5j/JTlirZOoJ8h0pvhQlcntEXYCK+
         DrZFJMbNDY38BXx+hQJLsml5+G+vOjD9F1w3pHHmx8j+oyr6VDpXDUpMKwluyoEPam
         oHMP5cdTHgRqc/JUYINBvFMxkJxEK2+GGdLIwcps=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matt Roper <matthew.d.roper@intel.com>,
        Caz Yokoyama <caz.yokoyama@intel.com>,
        =?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.5 112/119] Revert "drm/i915/tgl: Add extra hdc flush workaround"
Date:   Tue, 24 Mar 2020 14:11:37 +0100
Message-Id: <20200324130818.893795206@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200324130808.041360967@linuxfoundation.org>
References: <20200324130808.041360967@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Caz Yokoyama <caz.yokoyama@intel.com>

commit c09f6b4d0883dfb859c1ddcfb04c3260ef310ce0 upstream.

This reverts commit 36a6b5d964d995b536b1925ec42052ee40ba92c4.

The commit takes care Wa_1604544889 which was fixed on a0 stepping based on
a0 replan. So no SW workaround is required on any stepping now.

Reviewed-by: Matt Roper <matthew.d.roper@intel.com>
Signed-off-by: Caz Yokoyama <caz.yokoyama@intel.com>
Signed-off-by: José Roberto de Souza <jose.souza@intel.com>
Fixes: 36a6b5d964d9 ("drm/i915/tgl: Add extra hdc flush workaround")
Link: https://patchwork.freedesktop.org/patch/msgid/1c751032ce79c80c5485cae315f1a9904ce07cac.1583359940.git.caz.yokoyama@intel.com
(cherry picked from commit 175c4d9b3b9a60b4ea0b8cd034011808c6a03b05)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/gt/intel_lrc.c |   20 --------------------
 1 file changed, 20 deletions(-)

--- a/drivers/gpu/drm/i915/gt/intel_lrc.c
+++ b/drivers/gpu/drm/i915/gt/intel_lrc.c
@@ -3503,26 +3503,6 @@ static int gen12_emit_flush_render(struc
 
 		*cs++ = preparser_disable(false);
 		intel_ring_advance(request, cs);
-
-		/*
-		 * Wa_1604544889:tgl
-		 */
-		if (IS_TGL_REVID(request->i915, TGL_REVID_A0, TGL_REVID_A0)) {
-			flags = 0;
-			flags |= PIPE_CONTROL_CS_STALL;
-			flags |= PIPE_CONTROL_HDC_PIPELINE_FLUSH;
-
-			flags |= PIPE_CONTROL_STORE_DATA_INDEX;
-			flags |= PIPE_CONTROL_QW_WRITE;
-
-			cs = intel_ring_begin(request, 6);
-			if (IS_ERR(cs))
-				return PTR_ERR(cs);
-
-			cs = gen8_emit_pipe_control(cs, flags,
-						    LRC_PPHWSP_SCRATCH_ADDR);
-			intel_ring_advance(request, cs);
-		}
 	}
 
 	return 0;



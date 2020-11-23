Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47B962C0765
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:44:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732483AbgKWMk3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:40:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:53410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732476AbgKWMk2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:40:28 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 88F682065E;
        Mon, 23 Nov 2020 12:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135228;
        bh=PtIckyGK9Lo14vJ0QJc2LFsRuqepbJdyAD5E5lNNooM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wHxxsKMV0ATO0xFcic6G4h0bGmTViafvyb9J18BRf3KvE/H86iauUM1iza4yeTnGi
         7XAPDTk5GqJyeApLTbvdDfqSbz8TTMwQp3NU5HTosS4lvPgo57n96dS5Mz8L+HX3zM
         tHdBFQpooeksnU+58ywEDiauVt8zy+T1eY6+5CFA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        =?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.4 150/158] drm/i915: Handle max_bpc==16
Date:   Mon, 23 Nov 2020 13:22:58 +0100
Message-Id: <20201123121827.167712448@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121819.943135899@linuxfoundation.org>
References: <20201123121819.943135899@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit d2e3fce9ddafe689c6f7cb355f23560637e30b9d upstream.

EDID can declare the maximum supported bpc up to 16,
and apparently there are displays that do so. Currently
we assume 12 bpc is tha max. Fix the assumption and
toss in a MISSING_CASE() for any other value we don't
expect to see.

This fixes modesets with a display with EDID max bpc > 12.
Previously any modeset would just silently fail on platforms
that didn't otherwise limit this via the max_bpc property.
In particular we don't add the max_bpc property to HDMI
ports on gmch platforms, and thus we would see the raw
max_bpc coming from the EDID.

I suppose we could already adjust this to also allow 16bpc,
but seeing as no current platform supports that there is
little point.

Cc: stable@vger.kernel.org
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/2632
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20201110210447.27454-1-ville.syrjala@linux.intel.com
Reviewed-by: José Roberto de Souza <jose.souza@intel.com>
(cherry picked from commit 2ca5a7b85b0c2b97ef08afbd7799b022e29f192e)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/display/intel_display.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/display/intel_display.c
+++ b/drivers/gpu/drm/i915/display/intel_display.c
@@ -11893,10 +11893,11 @@ compute_sink_pipe_bpp(const struct drm_c
 	case 10 ... 11:
 		bpp = 10 * 3;
 		break;
-	case 12:
+	case 12 ... 16:
 		bpp = 12 * 3;
 		break;
 	default:
+		MISSING_CASE(conn_state->max_bpc);
 		return -EINVAL;
 	}
 



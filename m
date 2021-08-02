Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 753063DD9C1
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 16:03:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236609AbhHBODf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 10:03:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:49254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236005AbhHBOBh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 10:01:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F9F361212;
        Mon,  2 Aug 2021 13:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912601;
        bh=ZOMRO6biVS5toGtyQghD1ycIi26I9lYWvf6iOG+fa7E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=um17A4W1yBCeEf7WphPcgXZ7bQrinvYMRG051NukivrVDWlOfp1v0LwdYo75SqZ+A
         qjDgmCqT2VTKT52yhGtkQhDwI8+4f1YtPCFi1o1JDZPbIJSW4Pm6uk4i+kamf9l/qm
         YRdsJidc/Enh7XvcrKl+FBimMZflSOe2UoTBHtsY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Lucas De Marchi <lucas.demarchi@intel.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        =?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 067/104] drm/i915/bios: Fix ports mask
Date:   Mon,  2 Aug 2021 15:45:04 +0200
Message-Id: <20210802134346.212574091@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134344.028226640@linuxfoundation.org>
References: <20210802134344.028226640@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rodrigo Vivi <rodrigo.vivi@intel.com>

[ Upstream commit d7f237df53457cf0cbdb9943b9b7c93a05e2fdb6 ]

PORT_A to PORT_F are regular integers defined in the enum port,
while for_each_port_masked requires a bit mask for the ports.

Current given mask: 0b111
Desired mask: 0b111111

I noticed this while Christoph was reporting a bug found on headless
GVT configuration which bisect blamed commit 3ae04c0c7e63 ("drm/i915/bios:
limit default outputs to ports A through F")

v2: Avoid unnecessary line continuations as pointed by CI and Christoph

Cc: Christoph Hellwig <hch@infradead.org>
Fixes: 3ae04c0c7e63 ("drm/i915/bios: limit default outputs to ports A through F")
Cc: Lucas De Marchi <lucas.demarchi@intel.com>
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Reviewed-by: José Roberto de Souza <jose.souza@intel.com>
Reviewed-by: Lucas De Marchi <lucas.demarchi@intel.com>
Tested-by: Christoph Hellwig <hch@infradead.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20210723095225.562913-1-rodrigo.vivi@intel.com
(cherry picked from commit 9b52aa720168859526bf90d77fa210fc0336f170)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_bios.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/display/intel_bios.c b/drivers/gpu/drm/i915/display/intel_bios.c
index 3d0c035b5e38..04c8d2ff7867 100644
--- a/drivers/gpu/drm/i915/display/intel_bios.c
+++ b/drivers/gpu/drm/i915/display/intel_bios.c
@@ -2130,7 +2130,8 @@ static void
 init_vbt_missing_defaults(struct drm_i915_private *i915)
 {
 	enum port port;
-	int ports = PORT_A | PORT_B | PORT_C | PORT_D | PORT_E | PORT_F;
+	int ports = BIT(PORT_A) | BIT(PORT_B) | BIT(PORT_C) |
+		    BIT(PORT_D) | BIT(PORT_E) | BIT(PORT_F);
 
 	if (!HAS_DDI(i915) && !IS_CHERRYVIEW(i915))
 		return;
-- 
2.30.2




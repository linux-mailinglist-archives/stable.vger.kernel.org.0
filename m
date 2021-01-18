Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ED0C2F9EB9
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 12:51:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390935AbhARLuU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 06:50:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:39118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390474AbhARLqm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:46:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B61B2223E;
        Mon, 18 Jan 2021 11:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970387;
        bh=TwK4LXV9ksWe9H3yLomHFbB0AQGZ3sKDeChMx8KEcVk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ay16qm7oL51WSCN683cznQ6EEUKVApm0ydzoo8P18ePRk61ZpDZ89JiHDRjKrq+p9
         kEjGRB0tKTZcAeT2Cu8zSZa7I9HWac3/iWIcz0rAAx5KcdPSDNOTuqL9zGR0DmyjuO
         /XUvPMJd7GN5WipFruOx1MLDC0+WR6rTAeoDcu9U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vandita Kulkarni <vandita.kulkarni@intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Imre Deak <imre.deak@intel.com>,
        Anshuman Gupta <anshuman.gupta@intel.com>
Subject: [PATCH 5.10 141/152] drm/i915/icl: Fix initing the DSI DSC power refcount during HW readout
Date:   Mon, 18 Jan 2021 12:35:16 +0100
Message-Id: <20210118113359.478599689@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Imre Deak <imre.deak@intel.com>

commit 2af5268180410b874fc06be91a1b2fbb22b1be0c upstream.

For an enabled DSC during HW readout the corresponding power reference
is taken along the CRTC power domain references in
get_crtc_power_domains(). Remove the incorrect get ref from the DSI
encoder hook.

Fixes: 2b68392e638d ("drm/i915/dsi: add support for DSC")
Cc: Vandita Kulkarni <vandita.kulkarni@intel.com>
Cc: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Imre Deak <imre.deak@intel.com>
Reviewed-by: Anshuman Gupta <anshuman.gupta@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20201209153952.3397959-1-imre.deak@intel.com
(cherry picked from commit 3a9ec563a4ff770ae647f6ee539810f1866866c9)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/display/icl_dsi.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/gpu/drm/i915/display/icl_dsi.c
+++ b/drivers/gpu/drm/i915/display/icl_dsi.c
@@ -1585,10 +1585,6 @@ static void gen11_dsi_get_power_domains(
 
 	get_dsi_io_power_domains(i915,
 				 enc_to_intel_dsi(encoder));
-
-	if (crtc_state->dsc.compression_enable)
-		intel_display_power_get(i915,
-					intel_dsc_power_domain(crtc_state));
 }
 
 static bool gen11_dsi_get_hw_state(struct intel_encoder *encoder,



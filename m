Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE4732915E
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:26:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238753AbhCAUYk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:24:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:45736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243192AbhCAUSq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:18:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 932C8653DF;
        Mon,  1 Mar 2021 18:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621786;
        bh=5b4iKmjWzNs2vQjmZVzQPWUC7qWrapYVRu0bD4UUFFU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BgGpMCOGWNPdUHQtrOnKZn5tjbbP0tCeYKihR1Llm0x3RV67HbVUPUQsLLRl7jAAN
         U8+3tp1QHUejtb3dmQTwn/IuvhE9rFYgbbu/HvdSFJQDWb/ZxtAz7uI+9rJ7mJ9Fpm
         D/let5hs79Od6dXFcY6zACqXKskwho7v54E43+XI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        Prathap Kumar Valsan <prathap.kumar.valsan@intel.com>,
        Akeem G Abodunrin <akeem.g.abodunrin@intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.11 644/775] drm/i915/gt: Correct surface base address for renderclear
Date:   Mon,  1 Mar 2021 17:13:32 +0100
Message-Id: <20210301161233.219023205@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 81ce8f04aa96f7f6cae05770f68b5d15be91f5a2 upstream.

The surface_state_base is an offset into the batch, so we need to pass
the correct batch address for STATE_BASE_ADDRESS.

Fixes: 47f8253d2b89 ("drm/i915/gen7: Clear all EU/L3 residual contexts")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Cc: Prathap Kumar Valsan <prathap.kumar.valsan@intel.com>
Cc: Akeem G Abodunrin <akeem.g.abodunrin@intel.com>
Cc: Hans de Goede <hdegoede@redhat.com>
Cc: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Cc: <stable@vger.kernel.org> # v5.7+
Link: https://patchwork.freedesktop.org/patch/msgid/20210210122728.20097-1-chris@chris-wilson.co.uk
(cherry picked from commit 1914911f4aa08ddc05bae71d3516419463e0c567)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gt/gen7_renderclear.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/gt/gen7_renderclear.c
+++ b/drivers/gpu/drm/i915/gt/gen7_renderclear.c
@@ -240,7 +240,7 @@ gen7_emit_state_base_address(struct batc
 	/* general */
 	*cs++ = batch_addr(batch) | BASE_ADDRESS_MODIFY;
 	/* surface */
-	*cs++ = batch_addr(batch) | surface_state_base | BASE_ADDRESS_MODIFY;
+	*cs++ = (batch_addr(batch) + surface_state_base) | BASE_ADDRESS_MODIFY;
 	/* dynamic */
 	*cs++ = batch_addr(batch) | BASE_ADDRESS_MODIFY;
 	/* indirect */



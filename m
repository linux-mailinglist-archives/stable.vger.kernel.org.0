Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDA38226811
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:17:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388217AbgGTQQ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:16:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:58248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388613AbgGTQQy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:16:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2ACA22064B;
        Mon, 20 Jul 2020 16:16:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261813;
        bh=zp+/tj1wGk+aIdCWdyD/6BHJ9SueCc5DLykjfdOmZaY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zUwXfDo5+hiZ+Qqh1zmVrLtnd0gmYL8ZtM1Nq9IMT07FeF6BVyF4XtC1JwyPcVG1k
         cCaiOYQaik1kkH39SgcYSHqRw52OMtViqI9nxFIxm5TfWHZia2dnQrvXoBJiN/cxDQ
         NLRSt45mPn/dNynyn6SVtxZHK9q8pp+FtHekIAtk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Prathap Kumar Valsan <prathap.kumar.valsan@intel.com>,
        Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>,
        Lionel Landwerlin <lionel.g.landwerlin@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.7 244/244] drm/i915/perf: Use GTT when saving/restoring engine GPR
Date:   Mon, 20 Jul 2020 17:38:35 +0200
Message-Id: <20200720152837.447723793@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152825.863040590@linuxfoundation.org>
References: <20200720152825.863040590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>

commit aee62e02c48bd62b9b07f5e297ecfc9aaa964937 upstream.

MI_STORE_REGISTER_MEM and MI_LOAD_REGISTER_MEM need to know which
translation to use when saving restoring the engine general purpose
registers to and from the GT scratch. Since GT scratch is mapped to
ggtt, we need to set an additional bit in the command to use GTT.

Fixes: daed3e44396d17 ("drm/i915/perf: implement active wait for noa configurations")
Suggested-by: Prathap Kumar Valsan <prathap.kumar.valsan@intel.com>
Signed-off-by: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
Reviewed-by: Lionel Landwerlin <lionel.g.landwerlin@intel.com>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Link: https://patchwork.freedesktop.org/patch/msgid/20200709224504.11345-1-chris@chris-wilson.co.uk
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
(cherry picked from commit e43ff99c8deda85234e6233e0f4af6cb09566a37)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_perf.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/i915/i915_perf.c
+++ b/drivers/gpu/drm/i915/i915_perf.c
@@ -1645,6 +1645,7 @@ static u32 *save_restore_register(struct
 	u32 d;
 
 	cmd = save ? MI_STORE_REGISTER_MEM : MI_LOAD_REGISTER_MEM;
+	cmd |= MI_SRM_LRM_GLOBAL_GTT;
 	if (INTEL_GEN(stream->perf->i915) >= 8)
 		cmd++;
 



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBDD2643374
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:36:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234370AbiLETgg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:36:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234285AbiLETgQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:36:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46A4017437
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:32:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2EDE0B81201
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:32:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77D05C433D6;
        Mon,  5 Dec 2022 19:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670268775;
        bh=wS2rbojpk/er2WTDgbuek2AGdd7sLrfue0DR5un57bI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BL6yD3YRPlAcEgEgmVX1IDaPqkD7cDFdfdvsYhQE4msUwLyfxmj4xsrDinVIo8KRT
         RI0zmA2X9FvQRShbiKYXFGEk84pvg+yvA3FxBsuYlgkIAxnVbre+Al022RQMovyXrc
         6cXUTIQVCXds2KfDnBLEL6qI6fktYnrm/XdmXbyA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>,
        Andrzej Hajda <andrzej.hajda@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Subject: [PATCH 5.10 67/92] drm/i915: Never return 0 if not all requests retired
Date:   Mon,  5 Dec 2022 20:10:20 +0100
Message-Id: <20221205190805.724492186@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190803.464934752@linuxfoundation.org>
References: <20221205190803.464934752@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>

commit 12b8b046e4c9de40fa59b6f067d6826f4e688f68 upstream.

Users of intel_gt_retire_requests_timeout() expect 0 return value on
success.  However, we have no protection from passing back 0 potentially
returned by a call to dma_fence_wait_timeout() when it succedes right
after its timeout has expired.

Replace 0 with -ETIME before potentially using the timeout value as return
code, so -ETIME is returned if there are still some requests not retired
after timeout, 0 otherwise.

v3: Use conditional expression, more compact but also better reflecting
    intention standing behind the change.

v2: Move the added lines down so flush_submission() is not affected.

Fixes: f33a8a51602c ("drm/i915: Merge wait_for_timelines with retire_request")
Signed-off-by: Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>
Reviewed-by: Andrzej Hajda <andrzej.hajda@intel.com>
Cc: stable@vger.kernel.org # v5.5+
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221121145655.75141-3-janusz.krzysztofik@linux.intel.com
(cherry picked from commit f301a29f143760ce8d3d6b6a8436d45d3448cde6)
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gt/intel_gt_requests.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/gt/intel_gt_requests.c
+++ b/drivers/gpu/drm/i915/gt/intel_gt_requests.c
@@ -200,7 +200,7 @@ out_active:	spin_lock(&timelines->lock);
 	if (flush_submission(gt, timeout)) /* Wait, there's more! */
 		active_count++;
 
-	return active_count ? timeout : 0;
+	return active_count ? timeout ?: -ETIME : 0;
 }
 
 int intel_gt_wait_for_idle(struct intel_gt *gt, long timeout)



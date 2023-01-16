Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4133C66C4CA
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 16:58:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231706AbjAPP6V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 10:58:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231697AbjAPP6M (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 10:58:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72F5E15543
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 07:58:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 34037B81052
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 15:58:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8227DC433EF;
        Mon, 16 Jan 2023 15:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884688;
        bh=o4WEeZNr3AtdVC13h2nQUpyzbC9ZM0bG1IXc8LVS6Tc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hwtxsHYoUuHsCLTT/QKHjheZ7FwvtH7yO7mFbay3JBdKWS/UAnPOO77C8hpD12eCk
         1z0GK/Tk95WvyFSeatvwpj7cBZcgs5ETYkxkaY4TzgYJPYRfE4xtCYc0kXnkGlsE9P
         N61A+FGh6MYlLEDuWLV6DzRz9ca4+Ba8CEDO+/Ks=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chris Wilson <chris.p.wilson@intel.com>,
        Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>,
        Matt Roper <matthew.d.roper@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 073/183] drm/i915/gt: Cleanup partial engine discovery failures
Date:   Mon, 16 Jan 2023 16:49:56 +0100
Message-Id: <20230116154806.481049471@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
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

From: Chris Wilson <chris.p.wilson@intel.com>

[ Upstream commit 78a033433a5ae4fee85511ee075bc9a48312c79e ]

If we abort driver initialisation in the middle of gt/engine discovery,
some engines will be fully setup and some not. Those incompletely setup
engines only have 'engine->release == NULL' and so will leak any of the
common objects allocated.

v2:
 - Drop the destroy_pinned_context() helper for now.  It's not really
   worth it with just a single callsite at the moment.  (Janusz)

Signed-off-by: Chris Wilson <chris.p.wilson@intel.com>
Cc: Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
Reviewed-by: Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220915232654.3283095-2-matthew.d.roper@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/intel_engine_cs.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_engine_cs.c b/drivers/gpu/drm/i915/gt/intel_engine_cs.c
index 83bfeb872bda..fcbccd8d244e 100644
--- a/drivers/gpu/drm/i915/gt/intel_engine_cs.c
+++ b/drivers/gpu/drm/i915/gt/intel_engine_cs.c
@@ -1343,8 +1343,13 @@ int intel_engines_init(struct intel_gt *gt)
 			return err;
 
 		err = setup(engine);
-		if (err)
+		if (err) {
+			intel_engine_cleanup_common(engine);
 			return err;
+		}
+
+		/* The backend should now be responsible for cleanup */
+		GEM_BUG_ON(engine->release == NULL);
 
 		err = engine_init_common(engine);
 		if (err)
-- 
2.35.1




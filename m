Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E5816AF162
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:43:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbjCGSmw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:42:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233099AbjCGSmZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:42:25 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 938BE123
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:32:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4FCE3CE1C91
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:29:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1013AC433EF;
        Tue,  7 Mar 2023 18:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213776;
        bh=WcbZCsJ8J9LuL+Q8UGYwDq2ZVr+W7WZOWdKqZrNvlh0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XXUJibFp94i0l2neIaV38hETWFsh8ODLqzh1gnVzX0omEquB/Ehscipcc5p7m9iSh
         hEcYx4NbUnF1T48Q33P3PypOCReJNaO0neNQTVbRAyQ+GknKqbHxujgZJdGtjM/KFG
         aY1IcO8RXiitN5w2Drpqm0dtqlOtc2vfaY5S81cc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wayne Lin <Wayne.Lin@amd.com>,
        Harry Wentland <harry.wentland@amd.com>,
        Lyude Paul <lyude@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 616/885] drm/drm_print: correct format problem
Date:   Tue,  7 Mar 2023 17:59:10 +0100
Message-Id: <20230307170029.059020401@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wayne Lin <Wayne.Lin@amd.com>

[ Upstream commit d987150b539271b0394f24c1c648d2846662adb4 ]

[why & how]
__drm_dbg() parameter set format is wrong and not aligned with the
format under CONFIG_DRM_USE_DYNAMIC_DEBUG is on. Fix it.

Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
Signed-off-by: Harry Wentland <harry.wentland@amd.com>
Acked-by: Harry Wentland <harry.wentland@amd.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/drm/drm_print.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/drm/drm_print.h b/include/drm/drm_print.h
index a44fb7ef257f6..094ded23534c7 100644
--- a/include/drm/drm_print.h
+++ b/include/drm/drm_print.h
@@ -521,7 +521,7 @@ __printf(1, 2)
 void __drm_err(const char *format, ...);
 
 #if !defined(CONFIG_DRM_USE_DYNAMIC_DEBUG)
-#define __drm_dbg(fmt, ...)		___drm_dbg(NULL, fmt, ##__VA_ARGS__)
+#define __drm_dbg(cat, fmt, ...)		___drm_dbg(NULL, cat, fmt, ##__VA_ARGS__)
 #else
 #define __drm_dbg(cat, fmt, ...)					\
 	_dynamic_func_call_cls(cat, fmt, ___drm_dbg,			\
-- 
2.39.2




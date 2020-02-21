Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2127C16776B
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:42:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730328AbgBUImI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:42:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:54820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730369AbgBUHzp (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 02:55:45 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69973206ED;
        Fri, 21 Feb 2020 07:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582271744;
        bh=cF0AFVHw8PPABmHKwcOZG09O4STfsB3xpXfX9/LrqXg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VsvmV4x69Bc9+rjQTfnGZysWVHyhpzTUq+cYTNt5aIoK9crJUB0Nxdn6AlOtzrmmr
         uJbh67yWD6ViXYTEar++sg+xYHDvahTwqGOjgJHQXS4PkmQCcNgG/89z8DqUVFU6D2
         TrkEIEJw5UHx44DoixDO0uXcseSJwovjyKocGigA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jun Lei <Jun.Lei@amd.com>,
        Anthony Koo <Anthony.Koo@amd.com>,
        Harry Wentland <harry.wentland@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 283/399] drm/amd/display: fixup DML dependencies
Date:   Fri, 21 Feb 2020 08:40:08 +0100
Message-Id: <20200221072429.453137058@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
References: <20200221072402.315346745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jun Lei <Jun.Lei@amd.com>

[ Upstream commit 34ad0230062c39cdcba564d16d122c0fb467a7d6 ]

[why]
Need to fix DML portability issues to enable SW unit testing around DML

[how]
Move calcs into dc include folder since multiple components reference it
Remove relative paths to external dependencies

Signed-off-by: Jun Lei <Jun.Lei@amd.com>
Reviewed-by: Anthony Koo <Anthony.Koo@amd.com>
Acked-by: Harry Wentland <harry.wentland@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dml/dml_common_defs.c          | 2 +-
 drivers/gpu/drm/amd/display/dc/dml/dml_inline_defs.h          | 2 +-
 drivers/gpu/drm/amd/display/dc/{calcs => inc}/dcn_calc_math.h | 0
 3 files changed, 2 insertions(+), 2 deletions(-)
 rename drivers/gpu/drm/amd/display/dc/{calcs => inc}/dcn_calc_math.h (100%)

diff --git a/drivers/gpu/drm/amd/display/dc/dml/dml_common_defs.c b/drivers/gpu/drm/amd/display/dc/dml/dml_common_defs.c
index b953b02a15121..723af0b2dda04 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dml_common_defs.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dml_common_defs.c
@@ -24,7 +24,7 @@
  */
 
 #include "dml_common_defs.h"
-#include "../calcs/dcn_calc_math.h"
+#include "dcn_calc_math.h"
 
 #include "dml_inline_defs.h"
 
diff --git a/drivers/gpu/drm/amd/display/dc/dml/dml_inline_defs.h b/drivers/gpu/drm/amd/display/dc/dml/dml_inline_defs.h
index eca140da13d82..ded71ea82413d 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dml_inline_defs.h
+++ b/drivers/gpu/drm/amd/display/dc/dml/dml_inline_defs.h
@@ -27,7 +27,7 @@
 #define __DML_INLINE_DEFS_H__
 
 #include "dml_common_defs.h"
-#include "../calcs/dcn_calc_math.h"
+#include "dcn_calc_math.h"
 #include "dml_logger.h"
 
 static inline double dml_min(double a, double b)
diff --git a/drivers/gpu/drm/amd/display/dc/calcs/dcn_calc_math.h b/drivers/gpu/drm/amd/display/dc/inc/dcn_calc_math.h
similarity index 100%
rename from drivers/gpu/drm/amd/display/dc/calcs/dcn_calc_math.h
rename to drivers/gpu/drm/amd/display/dc/inc/dcn_calc_math.h
-- 
2.20.1




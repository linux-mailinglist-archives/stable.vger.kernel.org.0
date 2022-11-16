Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CE1D62C798
	for <lists+stable@lfdr.de>; Wed, 16 Nov 2022 19:26:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234350AbiKPS0u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Nov 2022 13:26:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232851AbiKPS0r (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Nov 2022 13:26:47 -0500
Received: from smtp.gentoo.org (woodpecker.gentoo.org [140.211.166.183])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C19A2A246;
        Wed, 16 Nov 2022 10:26:46 -0800 (PST)
From:   Sam James <sam@gentoo.org>
To:     linux-kernel@vger.kernel.org
Cc:     Sam James <sam@gentoo.org>,
        Andrew Morton <akpm@linux-foundation.org>, trivial@kernel.org,
        stable@vger.kernel.org
Subject: [PATCH] kbuild: Fix -Wimplicit-function-declaration in license_is_gpl_compatible
Date:   Wed, 16 Nov 2022 18:26:34 +0000
Message-Id: <20221116182634.2823136-1-sam@gentoo.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Add missing <string.h> include for strcmp.

Clang 16 makes -Wimplicit-function-declaration an error by default. Unfortunately,
out of tree modules may use this in configure scripts, which means failure
might cause silent miscompilation or misconfiguration.

For more information, see LWN.net [0] or LLVM's Discourse [1], gentoo-dev@ [2],
or the (new) c-std-porting mailing list [3].

[0] https://lwn.net/Articles/913505/
[1] https://discourse.llvm.org/t/configure-script-breakage-with-the-new-werror-implicit-function-declaration/65213
[2] https://archives.gentoo.org/gentoo-dev/message/dd9f2d3082b8b6f8dfbccb0639e6e240
[3] hosted at lists.linux.dev.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: trivial@kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Sam James <sam@gentoo.org>
---
 include/linux/license.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/license.h b/include/linux/license.h
index 7cce390f120b..1c0f28904ed0 100644
--- a/include/linux/license.h
+++ b/include/linux/license.h
@@ -2,6 +2,8 @@
 #ifndef __LICENSE_H
 #define __LICENSE_H
 
+#include <string.h>
+
 static inline int license_is_gpl_compatible(const char *license)
 {
 	return (strcmp(license, "GPL") == 0
-- 
2.38.1


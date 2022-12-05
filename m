Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12C2164329A
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:27:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234160AbiLET1X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:27:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233926AbiLET06 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:26:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9453C26ADB
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:24:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3215C61307
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:24:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 102ACC433C1;
        Mon,  5 Dec 2022 19:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670268244;
        bh=vHGdx5u+prV/YuuMvsrRi6p2qPvbRRYlc+L28ESICNQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uk/dcW5DK5CuOFI/hQkQSbj2v8/2kavd2QTCVw/ccrpKUYR2XhN4zyDFskO5tw8lJ
         ljxTOvb6bdQdvHq9G54hzy67zCogkUekoa/24uy0Cxsebx60ofbgdn73vMH5lPTbuC
         y1dC9//DaNgq82KBwa1uPWAiJidPbnl+dtmsmcEA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sam James <sam@gentoo.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 005/124] kbuild: fix -Wimplicit-function-declaration in license_is_gpl_compatible
Date:   Mon,  5 Dec 2022 20:08:31 +0100
Message-Id: <20221205190808.591386633@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.422385173@linuxfoundation.org>
References: <20221205190808.422385173@linuxfoundation.org>
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

From: Sam James <sam@gentoo.org>

[ Upstream commit 50c697215a8cc22f0e58c88f06f2716c05a26e85 ]

Add missing <linux/string.h> include for strcmp.

Clang 16 makes -Wimplicit-function-declaration an error by default.
Unfortunately, out of tree modules may use this in configure scripts,
which means failure might cause silent miscompilation or misconfiguration.

For more information, see LWN.net [0] or LLVM's Discourse [1], gentoo-dev@ [2],
or the (new) c-std-porting mailing list [3].

[0] https://lwn.net/Articles/913505/
[1] https://discourse.llvm.org/t/configure-script-breakage-with-the-new-werror-implicit-function-declaration/65213
[2] https://archives.gentoo.org/gentoo-dev/message/dd9f2d3082b8b6f8dfbccb0639e6e240
[3] hosted at lists.linux.dev.

[akpm@linux-foundation.org: remember "linux/"]
Link: https://lkml.kernel.org/r/20221116182634.2823136-1-sam@gentoo.org
Signed-off-by: Sam James <sam@gentoo.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/license.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/license.h b/include/linux/license.h
index 7cce390f120b..ad937f57f2cb 100644
--- a/include/linux/license.h
+++ b/include/linux/license.h
@@ -2,6 +2,8 @@
 #ifndef __LICENSE_H
 #define __LICENSE_H
 
+#include <linux/string.h>
+
 static inline int license_is_gpl_compatible(const char *license)
 {
 	return (strcmp(license, "GPL") == 0
-- 
2.35.1




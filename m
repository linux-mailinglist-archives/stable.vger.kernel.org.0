Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 767E8657A26
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:08:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233614AbiL1PIS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:08:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233612AbiL1PIS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:08:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5418C13D71
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:08:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E797EB8172A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:08:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C181C433F0;
        Wed, 28 Dec 2022 15:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240094;
        bh=l4mdijT3DXLoB3FEQAQQT3XWHgMtUjdefbiHKLqvrG4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=neFI0bOapJeH9Ec3k3tPUPBhTRlFjT6pBYhsaOTwPAMyGjiR8XIp+a5RRwQCML7Vg
         DHHqtL7jZla0kJelx9d36qRrzhi+Lyzhq9qRdoEe9apkMivv8dy5B/bHeyNnc+L0ob
         0mNshYEfLU+rWfmFBEYwYtg+02TG+x4wbdciT6Ws=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0117/1073] proc: fixup uptime selftest
Date:   Wed, 28 Dec 2022 15:28:25 +0100
Message-Id: <20221228144331.216765246@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

From: Alexey Dobriyan <adobriyan@gmail.com>

[ Upstream commit 5cc81d5c81af0dee54da9a67a3ebe4be076a13db ]

syscall(3) returns -1 and sets errno on error, unlike "syscall"
instruction.

Systems which have <= 32/64 CPUs are unaffected. Test won't bounce
to all CPUs before completing if there are more of them.

Link: https://lkml.kernel.org/r/Y1bUiT7VRXlXPQa1@p183
Fixes: 1f5bd0547654 ("proc: selftests: test /proc/uptime")
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/proc/proc-uptime-002.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/proc/proc-uptime-002.c b/tools/testing/selftests/proc/proc-uptime-002.c
index e7ceabed7f51..7d0aa22bdc12 100644
--- a/tools/testing/selftests/proc/proc-uptime-002.c
+++ b/tools/testing/selftests/proc/proc-uptime-002.c
@@ -17,6 +17,7 @@
 // while shifting across CPUs.
 #undef NDEBUG
 #include <assert.h>
+#include <errno.h>
 #include <unistd.h>
 #include <sys/syscall.h>
 #include <stdlib.h>
@@ -54,7 +55,7 @@ int main(void)
 		len += sizeof(unsigned long);
 		free(m);
 		m = malloc(len);
-	} while (sys_sched_getaffinity(0, len, m) == -EINVAL);
+	} while (sys_sched_getaffinity(0, len, m) == -1 && errno == EINVAL);
 
 	fd = open("/proc/uptime", O_RDONLY);
 	assert(fd >= 0);
-- 
2.35.1




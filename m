Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA443657D34
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:40:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233536AbiL1Pkg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:40:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233944AbiL1Pkf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:40:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 868D2167FE
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:40:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 246686155B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:40:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39B4EC433D2;
        Wed, 28 Dec 2022 15:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242033;
        bh=7VCj/D8hGGJ+I2TargVpu+S6ndr052GG1Gmqki9ZZvY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iJWe6MAdmEOPBQ86MOJdWPY4bqd9fTEclHdR9ilNTup8PzbaJnKFjusn4geiiKsWZ
         fakHvk0Y6iBcfuUxT9VMAjx3UoKQAs7Y0jcNl6NY1ucU72lgMVltToWO85X9fjtOpW
         4GAizzwsdM/iWudZlaMNDdl+pUP2HZRSH33MELog=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 555/731] powerpc/xmon: Fix -Wswitch-unreachable warning in bpt_cmds
Date:   Wed, 28 Dec 2022 15:41:02 +0100
Message-Id: <20221228144312.625348976@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

From: Gustavo A. R. Silva <gustavoars@kernel.org>

[ Upstream commit 1c4a4a4c8410be4a231a58b23e7a30923ff954ac ]

When building with automatic stack variable initialization, GCC 12
complains about variables defined outside of switch case statements.
Move the variable into the case that uses it, which silences the warning:

arch/powerpc/xmon/xmon.c: In function ‘bpt_cmds’:
arch/powerpc/xmon/xmon.c:1529:13: warning: statement will never be executed [-Wswitch-unreachable]
 1529 |         int mode;
      |             ^~~~

Fixes: 09b6c1129f89 ("powerpc/xmon: Fix compile error with PPC_8xx=y")
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/YySE6FHiOcbWWR+9@work
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/xmon/xmon.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/xmon/xmon.c b/arch/powerpc/xmon/xmon.c
index 8b28ff9d98d1..3c085e1e5232 100644
--- a/arch/powerpc/xmon/xmon.c
+++ b/arch/powerpc/xmon/xmon.c
@@ -1528,9 +1528,9 @@ bpt_cmds(void)
 	cmd = inchar();
 
 	switch (cmd) {
-	static const char badaddr[] = "Only kernel addresses are permitted for breakpoints\n";
-	int mode;
-	case 'd':	/* bd - hardware data breakpoint */
+	case 'd': {	/* bd - hardware data breakpoint */
+		static const char badaddr[] = "Only kernel addresses are permitted for breakpoints\n";
+		int mode;
 		if (xmon_is_ro) {
 			printf(xmon_ro_msg);
 			break;
@@ -1563,6 +1563,7 @@ bpt_cmds(void)
 
 		force_enable_xmon();
 		break;
+	}
 
 	case 'i':	/* bi - hardware instr breakpoint */
 		if (xmon_is_ro) {
-- 
2.35.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79B1D6676EA
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:38:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238150AbjALOiQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:38:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237476AbjALOhn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:37:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA0D81E3CB;
        Thu, 12 Jan 2023 06:27:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 63EFA60A69;
        Thu, 12 Jan 2023 14:27:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C420C433EF;
        Thu, 12 Jan 2023 14:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673533658;
        bh=aUQxVDz3y30kaWOk7AXpRHyrMOSjZ8DJ+ldZR2Fp/4A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=offWMctgTgIzVvDnee89yAdvOxxbzPr1vRa/bS51DS3Al/BaH2g0oDT7jf6sNQ+L7
         nW6ICyWKE90jLeQ+9N1aN8ID46Zeu9AJTxI4f2aAUg7Krxzg1eLdTe+Jy+lWgVkBpb
         MkFRCZXSwNSAUVau16Dzl26StMiD76gMJO6xWe2o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Paul Moore <paul@paul-moore.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        linux-security-module@vger.kernel.org,
        Kees Cook <keescook@chromium.org>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 550/783] LoadPin: Ignore the "contents" argument of the LSM hooks
Date:   Thu, 12 Jan 2023 14:54:26 +0100
Message-Id: <20230112135549.714910796@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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

From: Kees Cook <keescook@chromium.org>

[ Upstream commit 1a17e5b513ceebf21100027745b8731b4728edf7 ]

LoadPin only enforces the read-only origin of kernel file reads. Whether
or not it was a partial read isn't important. Remove the overly
conservative checks so that things like partial firmware reads will
succeed (i.e. reading a firmware header).

Fixes: 2039bda1fa8d ("LSM: Add "contents" flag to kernel_read_file hook")
Cc: Paul Moore <paul@paul-moore.com>
Cc: James Morris <jmorris@namei.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>
Cc: linux-security-module@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Acked-by: Serge Hallyn <serge@hallyn.com>
Tested-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://lore.kernel.org/r/20221209195453.never.494-kees@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/loadpin/loadpin.c | 30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/security/loadpin/loadpin.c b/security/loadpin/loadpin.c
index b12f7d986b1e..5fce105a372d 100644
--- a/security/loadpin/loadpin.c
+++ b/security/loadpin/loadpin.c
@@ -118,21 +118,11 @@ static void loadpin_sb_free_security(struct super_block *mnt_sb)
 	}
 }
 
-static int loadpin_read_file(struct file *file, enum kernel_read_file_id id,
-			     bool contents)
+static int loadpin_check(struct file *file, enum kernel_read_file_id id)
 {
 	struct super_block *load_root;
 	const char *origin = kernel_read_file_id_str(id);
 
-	/*
-	 * If we will not know that we'll be seeing the full contents
-	 * then we cannot trust a load will be complete and unchanged
-	 * off disk. Treat all contents=false hooks as if there were
-	 * no associated file struct.
-	 */
-	if (!contents)
-		file = NULL;
-
 	/* If the file id is excluded, ignore the pinning. */
 	if ((unsigned int)id < ARRAY_SIZE(ignore_read_file_id) &&
 	    ignore_read_file_id[id]) {
@@ -187,9 +177,25 @@ static int loadpin_read_file(struct file *file, enum kernel_read_file_id id,
 	return 0;
 }
 
+static int loadpin_read_file(struct file *file, enum kernel_read_file_id id,
+			     bool contents)
+{
+	/*
+	 * LoadPin only cares about the _origin_ of a file, not its
+	 * contents, so we can ignore the "are full contents available"
+	 * argument here.
+	 */
+	return loadpin_check(file, id);
+}
+
 static int loadpin_load_data(enum kernel_load_data_id id, bool contents)
 {
-	return loadpin_read_file(NULL, (enum kernel_read_file_id) id, contents);
+	/*
+	 * LoadPin only cares about the _origin_ of a file, not its
+	 * contents, so a NULL file is passed, and we can ignore the
+	 * state of "contents".
+	 */
+	return loadpin_check(NULL, (enum kernel_read_file_id) id);
 }
 
 static struct security_hook_list loadpin_hooks[] __lsm_ro_after_init = {
-- 
2.35.1




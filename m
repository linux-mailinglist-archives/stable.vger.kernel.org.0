Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4AFB6B6AD0
	for <lists+stable@lfdr.de>; Sun, 12 Mar 2023 20:56:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbjCLT4n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Mar 2023 15:56:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbjCLT4m (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Mar 2023 15:56:42 -0400
Received: from eggs.gnu.org (eggs.gnu.org [IPv6:2001:470:142:3::10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7562298C0
        for <stable@vger.kernel.org>; Sun, 12 Mar 2023 12:56:39 -0700 (PDT)
Received: from linux-libre.fsfla.org ([209.51.188.54] helo=free.home)
        by eggs.gnu.org with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        (envelope-from <oliva@gnu.org>)
        id 1pbRo5-0004iZ-HP; Sun, 12 Mar 2023 15:56:37 -0400
Received: from livre (livre.home [172.31.160.2])
        by free.home (8.15.2/8.15.2) with ESMTPS id 32CJuN1f924433
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
        Sun, 12 Mar 2023 16:56:25 -0300
From:   Alexandre Oliva <oliva@gnu.org>
To:     intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org
Subject: [PATCH] [i915] avoid infinite retries in GuC/HuC loading
Organization: Free thinker, not speaking for the GNU Project
Date:   Sun, 12 Mar 2023 16:56:23 -0300
Message-ID: <orjzzlhhg8.fsf@lxoliva.fsfla.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.84
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


If two or more suitable entries with the same filename are found in
__uc_fw_auto_select's fw_blobs, and that filename fails to load in the
first attempt and in the retry, when __uc_fw_auto_select is called for
the third time, the coincidence of strings will cause it to clear
file_selected.path at the first hit, so it will return the second hit
over and over again, indefinitely.

Of course this doesn't occur with the pristine blob lists, but a
modified version could run into this, e.g., patching in a duplicate
entry, or (as in our case) disarming blob loading by remapping their
names to "/*(DEBLOBBED)*/", given a toolchain that unifies identical
string literals.

Of course I'm ready to carry a patchlet to avoid this problem
triggered by our (GNU Linux-libre's) intentional changes, but I
figured you might be interested in fail-safing it even in accidental
backporting circumstances.  I realize it's not entirely foolproof: if
the same string appears in two entries separated by a different one,
the infinite loop might still occur.  Catching that even more unlikely
situation seemed too expensive.

Link: https://www.fsfla.org/pipermail/linux-libre/2023-March/003506.html
Cc: intel-gfx@lists.freedesktop.org
Cc: stable@vger.kernel.org # 6.[12].x
Signed-off-by: Alexandre Oliva <lxoliva@fsfla.org>
---
 drivers/gpu/drm/i915/gt/uc/intel_uc_fw.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/gt/uc/intel_uc_fw.c b/drivers/gpu/drm/i915/gt/uc/intel_uc_fw.c
index 9d6f571097e6..2b7564a3ed82 100644
--- a/drivers/gpu/drm/i915/gt/uc/intel_uc_fw.c
+++ b/drivers/gpu/drm/i915/gt/uc/intel_uc_fw.c
@@ -259,7 +259,10 @@ __uc_fw_auto_select(struct drm_i915_private *i915, struct intel_uc_fw *uc_fw)
 				uc_fw->file_selected.path = NULL;
 
 			continue;
-		}
+		} else if (uc_fw->file_wanted.path == blob->path)
+			/* Avoid retrying forever when neighbor
+			   entries point to the same path.  */
+			continue;
 
 		uc_fw->file_selected.path = blob->path;
 		uc_fw->file_wanted.path = blob->path;
-- 
2.25.1


-- 
Alexandre Oliva, happy hacker                https://FSFLA.org/blogs/lxo/
   Free Software Activist                       GNU Toolchain Engineer
Disinformation flourishes because many people care deeply about injustice
but very few check the facts.  Ask me about <https://stallmansupport.org>

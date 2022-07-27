Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01ACC582F86
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242090AbiG0R0v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:26:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242099AbiG0R0B (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:26:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF0317E007
        for <stable@vger.kernel.org>; Wed, 27 Jul 2022 09:46:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7A6DBB821D5
        for <stable@vger.kernel.org>; Wed, 27 Jul 2022 16:46:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABBD2C433C1;
        Wed, 27 Jul 2022 16:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658940383;
        bh=+aATYe2Q8xKTChP7I9LMcEz/l1Q+fQBlrj6RN28eDuw=;
        h=From:To:Cc:Subject:Date:From;
        b=NeA3MQwAA0k+amYqKN5f8gj2cqpfY1kgRW77IaQEMY+nlHKLsen4Xjo2TcXHP1zwm
         bsxM1fnaT6upIzgTXATVX2OeYaEhmU+42Oee8IkzdHM98D6rsAxF3iFbvzlN68Vyxk
         WZzptwL7HxyiKx8DdIrivPjQMgvbUrNz6qnKEDOzgV/JgAgRUTT/AxUos0FV4cidpb
         yHY0JZHw+5KY2V8vwR9tLJFPAVXdtz4LuT3dEC5ns0hzuooQi8RKlllRO+yhEgGSYF
         +z63qiwYLa02zoIyKx3RKSrSRJ9qEzODDw92xCaPplkNYms4XLLzLQ6lbzOAwN21Bd
         rRwsXhvNGJCQg==
From:   Nathan Chancellor <nathan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Daniel Rosenberg <drosen@google.com>, stable@vger.kernel.org,
        llvm@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH 4.9] ion: Make user_ion_handle_put_nolock() a void function
Date:   Wed, 27 Jul 2022 09:46:17 -0700
Message-Id: <20220727164617.980209-1-nathan@kernel.org>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Clang warns:

  drivers/staging/android/ion/ion-ioctl.c:71:6: warning: variable 'ret' is used uninitialized whenever 'if' condition is false [-Wsometimes-uninitialized]
          if (--handle->user_ref_count == 0)
              ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  drivers/staging/android/ion/ion-ioctl.c:74:9: note: uninitialized use occurs here
          return ret;
                 ^~~
  drivers/staging/android/ion/ion-ioctl.c:71:2: note: remove the 'if' if its condition is always true
          if (--handle->user_ref_count == 0)
          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  drivers/staging/android/ion/ion-ioctl.c:69:9: note: initialize the variable 'ret' to silence this warning
          int ret;
                 ^
                  = 0
  1 warning generated.

The return value of user_ion_handle_put_nolock() is not checked in its
one call site in user_ion_free_nolock() so just make
user_ion_handle_put_nolock() return void to remove the warning.

Fixes: a8200613c8c9 ("ion: Protect kref from userspace manipulation")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/staging/android/ion/ion-ioctl.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/android/ion/ion-ioctl.c b/drivers/staging/android/ion/ion-ioctl.c
index a27865b94416..e020a23d05f2 100644
--- a/drivers/staging/android/ion/ion-ioctl.c
+++ b/drivers/staging/android/ion/ion-ioctl.c
@@ -64,14 +64,10 @@ static struct ion_handle *pass_to_user(struct ion_handle *handle)
 }
 
 /* Must hold the client lock */
-static int user_ion_handle_put_nolock(struct ion_handle *handle)
+static void user_ion_handle_put_nolock(struct ion_handle *handle)
 {
-	int ret;
-
 	if (--handle->user_ref_count == 0)
-		ret = ion_handle_put_nolock(handle);
-
-	return ret;
+		ion_handle_put_nolock(handle);
 }
 
 static void user_ion_free_nolock(struct ion_client *client,

base-commit: 65be5f5665a580424a7b1102f1a04c4259c559b5
-- 
2.37.1


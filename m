Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89FE96E91A1
	for <lists+stable@lfdr.de>; Thu, 20 Apr 2023 13:05:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234884AbjDTLFT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Apr 2023 07:05:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234160AbjDTLEP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Apr 2023 07:04:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 748F0902E;
        Thu, 20 Apr 2023 04:03:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 77D2964773;
        Thu, 20 Apr 2023 11:02:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E666AC433A1;
        Thu, 20 Apr 2023 11:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681988540;
        bh=3mEJP8tmz/XW5HcFioTquKyOJJLG48D3oWkCAML/yZA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IhlYi9M9WLOFJoRVAycMcB+S4ThVr3rLXD3XPiFHOAjzLWuIX6OFHZgpC7McmpUEP
         1CgQFafVT2qPjyuiSJD2lubarVZpAZ3hpnjbMfRMogKqvWZPioOptJR4tE3+jZQ3MY
         3BNcd0Z9j+UUYoBxU79XjhoP/nK3HsafIhB0O0cSA0ZeFL/cCMuDm0kerRqMBd3Kuu
         ZtItaIJxD3J9GyV4Uc1ScXubjY+siKe574Qxrz15oU4ATWAmZkcc1BT/vHohtUGCw5
         gicvTnfbkhq0umX8jFT0rtVV6vgDBlOUPhQh0cdslfAslNDiiO6VWOfNk1KDMmdvzf
         hnCu4wZy/YT3A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anh Tuan Phan <tuananhlfc@gmail.com>,
        Christian Brauner <brauner@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, sforshee@kernel.org,
        shuah@kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 6.2 12/17] selftests mount: Fix mount_setattr_test builds failed
Date:   Thu, 20 Apr 2023 07:01:41 -0400
Message-Id: <20230420110148.505779-12-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230420110148.505779-1-sashal@kernel.org>
References: <20230420110148.505779-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anh Tuan Phan <tuananhlfc@gmail.com>

[ Upstream commit f1594bc676579133a3cd906d7d27733289edfb86 ]

When compiling selftests with target mount_setattr I encountered some errors with the below messages:
mount_setattr_test.c: In function ‘mount_setattr_thread’:
mount_setattr_test.c:343:16: error: variable ‘attr’ has initializer but incomplete type
  343 |         struct mount_attr attr = {
      |                ^~~~~~~~~~

These errors might be because of linux/mount.h is not included. This patch resolves that issue.

Signed-off-by: Anh Tuan Phan <tuananhlfc@gmail.com>
Acked-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/mount_setattr/mount_setattr_test.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/mount_setattr/mount_setattr_test.c b/tools/testing/selftests/mount_setattr/mount_setattr_test.c
index 8c5fea68ae677..969647228817b 100644
--- a/tools/testing/selftests/mount_setattr/mount_setattr_test.c
+++ b/tools/testing/selftests/mount_setattr/mount_setattr_test.c
@@ -18,6 +18,7 @@
 #include <grp.h>
 #include <stdbool.h>
 #include <stdarg.h>
+#include <linux/mount.h>
 
 #include "../kselftest_harness.h"
 
-- 
2.39.2


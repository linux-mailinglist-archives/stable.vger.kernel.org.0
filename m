Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50BC86E91FD
	for <lists+stable@lfdr.de>; Thu, 20 Apr 2023 13:08:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235372AbjDTLH3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Apr 2023 07:07:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235249AbjDTLF2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Apr 2023 07:05:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F8BE1B6;
        Thu, 20 Apr 2023 04:04:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 83C3A647E9;
        Thu, 20 Apr 2023 11:03:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1083C4339B;
        Thu, 20 Apr 2023 11:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681988602;
        bh=3mEJP8tmz/XW5HcFioTquKyOJJLG48D3oWkCAML/yZA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sNMXpOoLYab+mH6tLjajH+W3MMxleEs7IfAMZq2DttpzxP8VKsWhBcZlNutgW60lN
         i8+KqiDv2uioy+rEfB+PzoGtH2I5XsOo2ms8RlGhve5DQvi4GRYvM6P03dgwnIc5dc
         1yS5/IpzS1SoWlXQYi6t/mRtzkrMhi8IPBh+vGX//C0HxxV04iYrkhtooFbM4EPhze
         cdReZx8H1EgRNF/gD5JrI1+ppDcrDBS/q8uspmjlSEF9TPFzkClAH3qXqIghHZg/0V
         tdh3Js9cw2tQ6SaBmWEirC/PlxGiqRyjORG9a3LM/jPy6oYm6JyT6NAVrCEJhOxyGL
         m9WknfgsbPxQQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anh Tuan Phan <tuananhlfc@gmail.com>,
        Christian Brauner <brauner@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, sforshee@kernel.org,
        shuah@kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 6/7] selftests mount: Fix mount_setattr_test builds failed
Date:   Thu, 20 Apr 2023 07:03:06 -0400
Message-Id: <20230420110308.506181-6-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230420110308.506181-1-sashal@kernel.org>
References: <20230420110308.506181-1-sashal@kernel.org>
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


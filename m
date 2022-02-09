Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47CCB4AFA08
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 19:33:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238924AbiBISdw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 13:33:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239285AbiBISdu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 13:33:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5939C05CB88;
        Wed,  9 Feb 2022 10:33:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8D4C4B8203D;
        Wed,  9 Feb 2022 18:33:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B3EBC340E7;
        Wed,  9 Feb 2022 18:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644431631;
        bh=qyPfW4IlrBgNepnCTk3sw+8PUobJnB7UBEwn1fAXbqM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TufoHfam+GECG+IvIIl6/yY/PeKZkOY+extUH02Mk55bVef4UKlDB8s8gp2kA1RAE
         kta4GXw56bYlMZugr9ktDrTXb42B/Bwsvs12dh2dEPxdowWhgxEhwvHF5QpZdkNxvV
         4Fr1WAZzPk6QYVwuzToqKwbaGRXj5IT/Ao01OxYGxlyQL8nMg7HyZpON/9OTPvmjoV
         zek6LD0BR5kLLRawCgwqZH7yv3D7RE3osudGLMs+SpqFXG+Z+SObGtP20Yw86nn1wY
         EJVA3+5clR6XQ/oTAH3URCRtz9V/rna8D6cWiYg2vU8Goxmji8AgQVkkWOd1VzrTQD
         w+9ywsgM2hBuw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Micha=C5=82=20Winiarski?= <michal.winiarski@intel.com>,
        Daniel Latypov <dlatypov@google.com>,
        Brendan Higgins <brendanhiggins@google.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com
Subject: [PATCH AUTOSEL 5.16 05/42] kunit: tool: Import missing importlib.abc
Date:   Wed,  9 Feb 2022 13:32:37 -0500
Message-Id: <20220209183335.46545-5-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220209183335.46545-1-sashal@kernel.org>
References: <20220209183335.46545-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michał Winiarski <michal.winiarski@intel.com>

[ Upstream commit 235528072f28b3b0a1446279b7eaddda36dbf743 ]

Python 3.10.0 contains:
9e09849d20 ("bpo-41006: importlib.util no longer imports typing (GH-20938)")

It causes importlib.util to no longer import importlib.abs, which leads
to the following error when trying to use kunit with qemu:
AttributeError: module 'importlib' has no attribute 'abc'. Did you mean: '_abc'?

Add the missing import.

Signed-off-by: Michał Winiarski <michal.winiarski@intel.com>
Reviewed-by: Daniel Latypov <dlatypov@google.com>
Reviewed-by: Brendan Higgins <brendanhiggins@google.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/kunit/kunit_kernel.py | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/kunit/kunit_kernel.py b/tools/testing/kunit/kunit_kernel.py
index 66095568bf327..fae843bf2f0eb 100644
--- a/tools/testing/kunit/kunit_kernel.py
+++ b/tools/testing/kunit/kunit_kernel.py
@@ -6,6 +6,7 @@
 # Author: Felix Guo <felixguoxiuping@gmail.com>
 # Author: Brendan Higgins <brendanhiggins@google.com>
 
+import importlib.abc
 import importlib.util
 import logging
 import subprocess
-- 
2.34.1


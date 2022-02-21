Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93C954BDB85
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234322AbiBUJWj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:22:39 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349208AbiBUJVH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:21:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75E5E3587F;
        Mon, 21 Feb 2022 01:08:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E2FE0608C1;
        Mon, 21 Feb 2022 09:08:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEB04C340E9;
        Mon, 21 Feb 2022 09:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434480;
        bh=6TGHFzWoBF8VCHFHfVRCuz5fx3lT8j5ALTDaaJYk2OE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=upcEKe2OZWe8uiihWbEBmNY5gSBrKMp+7ockfU7Aer/cQhmfawGzRER/zLO6iJ2f7
         s4XinmGMa5+OlCcIxfMFPZm6q2CunFIwsu5FreQarC0yJvG+Y9UGagToXjHaJrnJIL
         g+k0raQ5BRtwnZ8aQTTgTcDKGOvtn+zPad128vlU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Micha=C5=82=20Winiarski?= <michal.winiarski@intel.com>,
        Daniel Latypov <dlatypov@google.com>,
        Brendan Higgins <brendanhiggins@google.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 023/196] kunit: tool: Import missing importlib.abc
Date:   Mon, 21 Feb 2022 09:47:35 +0100
Message-Id: <20220221084931.669379418@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084930.872957717@linuxfoundation.org>
References: <20220221084930.872957717@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 2c6f916ccbafa..0874e512d109b 100644
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




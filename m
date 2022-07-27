Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4D005830E2
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:43:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242987AbiG0Rn3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:43:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242739AbiG0Rm6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:42:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23CD654656;
        Wed, 27 Jul 2022 09:52:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E0E0616D1;
        Wed, 27 Jul 2022 16:52:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B06AC433C1;
        Wed, 27 Jul 2022 16:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940733;
        bh=A4PSEb0B3P0mqsdnh4osQB/Gotdxco+7iYeqMIbckC8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=itvK3J/0WE+cT/J3QsNCX3C6l1QAN07iHuzpUIzj7FjNpPeVLtqstsBdl10oabR0v
         A0kO2B3y0RCPqAQ9aT5dRsbe+bb9qqrZdubCo1rX63lNnC7K/TEvVLX8MaHdjka2m/
         9banBrlOE8hsk5BCjdR2jAHG/cPj46BqIAzHsiQc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Kent Gibson <warthog618@gmail.com>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 128/158] selftests: gpio: fix include path to kernel headers for out of tree builds
Date:   Wed, 27 Jul 2022 18:13:12 +0200
Message-Id: <20220727161026.541816139@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161021.428340041@linuxfoundation.org>
References: <20220727161021.428340041@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kent Gibson <warthog618@gmail.com>

[ Upstream commit f63731e18e8d8350e05b0176e39a76639f6483c7 ]

When building selftests out of the kernel tree the gpio.h the include
path is incorrect and the build falls back to the system includes
which may be outdated.

Add the KHDR_INCLUDES to the CFLAGS to include the gpio.h from the
build tree.

Fixes: 4f4d0af7b2d9 ("selftests: gpio: restore CFLAGS options")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Kent Gibson <warthog618@gmail.com>
Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/gpio/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/gpio/Makefile b/tools/testing/selftests/gpio/Makefile
index 71b306602368..616ed4019655 100644
--- a/tools/testing/selftests/gpio/Makefile
+++ b/tools/testing/selftests/gpio/Makefile
@@ -3,6 +3,6 @@
 TEST_PROGS := gpio-mockup.sh gpio-sim.sh
 TEST_FILES := gpio-mockup-sysfs.sh
 TEST_GEN_PROGS_EXTENDED := gpio-mockup-cdev gpio-chip-info gpio-line-name
-CFLAGS += -O2 -g -Wall -I../../../../usr/include/
+CFLAGS += -O2 -g -Wall -I../../../../usr/include/ $(KHDR_INCLUDES)
 
 include ../lib.mk
-- 
2.35.1




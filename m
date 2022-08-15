Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3269B5945B6
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:01:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344950AbiHOWT5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:19:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350693AbiHOWSN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:18:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8255123CA2;
        Mon, 15 Aug 2022 12:41:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5CB83B80EA8;
        Mon, 15 Aug 2022 19:41:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3EA4C433D6;
        Mon, 15 Aug 2022 19:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592476;
        bh=hwUVotYLPPfsowZItZNAHswZcEHPnU+JPQbbWO55Yh0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VYjiEfsLDucngGw8/pwzs5BOPfNtIpxWP2DQr8FgWaLidTsBdgrDkF6dZrAVy5TWK
         qVaaD//4ORr83zkIN0QC1dPWnyp4j4L792Oj1wr78nxbmnJIUD+R9+l4i5ObqlO9Qd
         CGaX3R4YDK+4/gmrenmMi5LsVKWOiVs7Qrr8Y188=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Christopher Obbard <chris.obbard@collabora.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0763/1095] um: random: Dont initialise hwrng struct with zero
Date:   Mon, 15 Aug 2022 20:02:42 +0200
Message-Id: <20220815180500.829772755@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Christopher Obbard <chris.obbard@collabora.com>

[ Upstream commit 9e70cbd11b03889c92462cf52edb2bd023c798fa ]

Initialising the hwrng struct with zeros causes a
compile-time sparse warning:

 $ ARCH=um make -j10 W=1 C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'
 ...
 CHECK   arch/um/drivers/random.c
 arch/um/drivers/random.c:31:31: sparse: warning: Using plain integer as NULL pointer

Fix the warning by not initialising the hwrng struct
with zeros as it is initialised anyway during module
init.

Fixes: 72d3e093afae ("um: random: Register random as hwrng-core device")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Christopher Obbard <chris.obbard@collabora.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/drivers/random.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/um/drivers/random.c b/arch/um/drivers/random.c
index 433a3f8f2ef3..32b3341fe970 100644
--- a/arch/um/drivers/random.c
+++ b/arch/um/drivers/random.c
@@ -28,7 +28,7 @@
  * protects against a module being loaded twice at the same time.
  */
 static int random_fd = -1;
-static struct hwrng hwrng = { 0, };
+static struct hwrng hwrng;
 static DECLARE_COMPLETION(have_data);
 
 static int rng_dev_read(struct hwrng *rng, void *buf, size_t max, bool block)
-- 
2.35.1




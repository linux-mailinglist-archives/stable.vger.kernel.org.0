Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BCF46582E9
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:43:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234905AbiL1QnQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:43:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234996AbiL1Qmt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:42:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF4591FCC7
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:37:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4283761578
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:36:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58A8CC433D2;
        Wed, 28 Dec 2022 16:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672245398;
        bh=ezD3OB3O7kZpJCovwCHyicXwG+VlHnom3ed48kJ43qQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vl9aUgEkCHX+dA4OVsF3hmFF67PDL2FKtGQ4BEuIUfJMhmX07fG5D9oZLr8KnhCFX
         PbNG1Gl/uPGjWB6AB63Wqki5hSYxye0onk2t3dBcYcmY2/Q9zrVb31W0acBm/uhtkl
         /At0nk29oO3SFhm8SFhwZN38YhPQbKZTAjvIYU6U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Nayna Jain <nayna@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0852/1146] powerpc/pseries: Fix the H_CALL error code in PLPKS driver
Date:   Wed, 28 Dec 2022 15:39:51 +0100
Message-Id: <20221228144353.296743233@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: Nayna Jain <nayna@linux.ibm.com>

[ Upstream commit af223e1728c448073d1e12fe464bf344310edeba ]

PAPR Spec defines H_P1 actually as H_PARAMETER and maps H_ABORTED to
a different numerical value.

Fix the error codes as per PAPR Specification.

Fixes: 2454a7af0f2a ("powerpc/pseries: define driver for Platform KeyStore")
Signed-off-by: Nayna Jain <nayna@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20221106205839.600442-3-nayna@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/hvcall.h      | 3 +--
 arch/powerpc/platforms/pseries/plpks.c | 2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/include/asm/hvcall.h b/arch/powerpc/include/asm/hvcall.h
index 8abae463f6c1..95fd7f9485d5 100644
--- a/arch/powerpc/include/asm/hvcall.h
+++ b/arch/powerpc/include/asm/hvcall.h
@@ -79,7 +79,7 @@
 #define H_NOT_ENOUGH_RESOURCES -44
 #define H_R_STATE       -45
 #define H_RESCINDED     -46
-#define H_P1		-54
+#define H_ABORTED	-54
 #define H_P2		-55
 #define H_P3		-56
 #define H_P4		-57
@@ -100,7 +100,6 @@
 #define H_COP_HW	-74
 #define H_STATE		-75
 #define H_IN_USE	-77
-#define H_ABORTED	-78
 #define H_UNSUPPORTED_FLAG_START	-256
 #define H_UNSUPPORTED_FLAG_END		-511
 #define H_MULTI_THREADS_ACTIVE	-9005
diff --git a/arch/powerpc/platforms/pseries/plpks.c b/arch/powerpc/platforms/pseries/plpks.c
index f4b5b5a64db3..32ce4d780d8f 100644
--- a/arch/powerpc/platforms/pseries/plpks.c
+++ b/arch/powerpc/platforms/pseries/plpks.c
@@ -75,7 +75,7 @@ static int pseries_status_to_err(int rc)
 	case H_FUNCTION:
 		err = -ENXIO;
 		break;
-	case H_P1:
+	case H_PARAMETER:
 	case H_P2:
 	case H_P3:
 	case H_P4:
-- 
2.35.1




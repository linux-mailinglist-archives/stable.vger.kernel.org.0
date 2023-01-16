Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 612BB66CB16
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:10:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234295AbjAPRKe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:10:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbjAPRKN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:10:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B67864345E
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:50:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4933B61050
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E575C433EF;
        Mon, 16 Jan 2023 16:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673887815;
        bh=Pnx/334rTdCwTSr4Ug0TzdTcVaCqC/Wapej3cToWBag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L7jVamSKyUKxDOPoVt6UtWwhLVd50O/m5MjPFRE3pLWQ60DM7iR6XM0tXoM6IFKkZ
         Ng4moGtD4rmY8F3/7Ep8qstVwMv+/AkZgsYtyKlcPeB/KC3BQkjcbv0rhIKdkOV/VY
         oscwUXwJ01P9Kr1L2MWbJSPcqlBtBS+ipnKdueWE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sam Bobroff <sbobroff@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nathan Lynch <nathanl@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 291/521] powerpc/eeh: Fix pseries_eeh_configure_bridge()
Date:   Mon, 16 Jan 2023 16:49:13 +0100
Message-Id: <20230116154900.139434163@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
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

From: Sam Bobroff <sbobroff@linux.ibm.com>

[ Upstream commit 6fa13640aea7bb0760846981aa2da4245307bd26 ]

If a device is hot unplgged during EEH recovery, it's possible for the
RTAS call to ibm,configure-pe in pseries_eeh_configure() to return
parameter error (-3), however negative return values are not checked
for and this leads to an infinite loop.

Fix this by correctly bailing out on negative values.

Signed-off-by: Sam Bobroff <sbobroff@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Reviewed-by: Nathan Lynch <nathanl@linux.ibm.com>
Link: https://lore.kernel.org/r/1b0a6010a647dc915816e44845b64d72066676a7.1588045502.git.sbobroff@linux.ibm.com
Stable-dep-of: 9aafbfa5f57a ("powerpc/pseries/eeh: use correct API for error log size")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/eeh_pseries.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/platforms/pseries/eeh_pseries.c b/arch/powerpc/platforms/pseries/eeh_pseries.c
index 2713d2aa963c..0fc93f7e167d 100644
--- a/arch/powerpc/platforms/pseries/eeh_pseries.c
+++ b/arch/powerpc/platforms/pseries/eeh_pseries.c
@@ -684,6 +684,8 @@ static int pseries_eeh_configure_bridge(struct eeh_pe *pe)
 
 		if (!ret)
 			return ret;
+		if (ret < 0)
+			break;
 
 		/*
 		 * If RTAS returns a delay value that's above 100ms, cut it
@@ -704,7 +706,11 @@ static int pseries_eeh_configure_bridge(struct eeh_pe *pe)
 
 	pr_warn("%s: Unable to configure bridge PHB#%x-PE#%x (%d)\n",
 		__func__, pe->phb->global_number, pe->addr, ret);
-	return ret;
+	/* PAPR defines -3 as "Parameter Error" for this function: */
+	if (ret == -3)
+		return -EINVAL;
+	else
+		return -EIO;
 }
 
 /**
-- 
2.35.1




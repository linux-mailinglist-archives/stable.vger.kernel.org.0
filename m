Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D39C592096
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 17:29:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240358AbiHNP3H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 11:29:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240030AbiHNP2k (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 11:28:40 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 459DABC3C;
        Sun, 14 Aug 2022 08:28:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7EAA7CE0B69;
        Sun, 14 Aug 2022 15:28:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43396C433D7;
        Sun, 14 Aug 2022 15:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660490916;
        bh=GuOmZLylmuX6irrw0+j0dIRNspABPterYfA45dueXJU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gAIVSW2ifNizT1AxJ0YzQnmm1n/rdPKUKulzd7q2YgJDMuykQ2RCbWVSio+sRnQOZ
         ajTSp8+f556A1qk0BxiuNf0zbKOKIVejsIEF7aKXxj30kD3VQcG42lz+OlB9wIcQdf
         8DM+gYReolx46Er2qNA91QKU6vHQbhrREayGlFg2fj+2EC/vVQUHGsxeoA+ZFc93m0
         IGjl/5cfv15ixh/JXrIiQtuBzFnjYouFAx4uNLIF9fHRlmMKNnDd5T6i4jHexP62g4
         4S1V5wpI+2k6pm0v0AirlgPSyhlPy+tsydPvE1/3SahvAiE6TxcBl/zfxNansP3M1r
         HunSnwffgHPzw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Liang He <windhl@126.com>, Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 20/64] usb: host: ohci-ppc-of: Fix refcount leak bug
Date:   Sun, 14 Aug 2022 11:23:53 -0400
Message-Id: <20220814152437.2374207-20-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814152437.2374207-1-sashal@kernel.org>
References: <20220814152437.2374207-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liang He <windhl@126.com>

[ Upstream commit 40a959d7042bb7711e404ad2318b30e9f92c6b9b ]

In ohci_hcd_ppc_of_probe(), of_find_compatible_node() will return
a node pointer with refcount incremented. We should use of_node_put()
when it is not used anymore.

Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Liang He <windhl@126.com>
Link: https://lore.kernel.org/r/20220617034637.4003115-1-windhl@126.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/ohci-ppc-of.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/host/ohci-ppc-of.c b/drivers/usb/host/ohci-ppc-of.c
index 1960b8dfdba5..591f675cc930 100644
--- a/drivers/usb/host/ohci-ppc-of.c
+++ b/drivers/usb/host/ohci-ppc-of.c
@@ -166,6 +166,7 @@ static int ohci_hcd_ppc_of_probe(struct platform_device *op)
 				release_mem_region(res.start, 0x4);
 		} else
 			pr_debug("%s: cannot get ehci offset from fdt\n", __FILE__);
+		of_node_put(np);
 	}
 
 	irq_dispose_mapping(irq);
-- 
2.35.1


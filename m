Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB2CB593D30
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344384AbiHOTnF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:43:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344250AbiHOTjT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:39:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B114D402D1;
        Mon, 15 Aug 2022 11:46:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7439BB8105C;
        Mon, 15 Aug 2022 18:46:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFA0BC433D6;
        Mon, 15 Aug 2022 18:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589215;
        bh=n4ydhLWTwQ0Ro1UivgLERAa8kdCl/YEYoqbe4qCFrL4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nQZKAFJCvxCYiUWlH2BRX4uV6RdA8HkXpoE8YbNVoGues/bOSNDEbJz6FiygMOARp
         kTknTCUFf25IabhioJKUGEJD8fIjD6zJGFuMfJgYP1S+37Iyug7naRxVRSoGMCYaOY
         JhGr25838XIA3G1X8qq0EXyr7/pZHcEOaD7xX4+I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 648/779] powerpc/cell/axon_msi: Fix refcount leak in setup_msi_msg_address
Date:   Mon, 15 Aug 2022 20:04:52 +0200
Message-Id: <20220815180405.070191290@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit df5d4b616ee76abc97e5bd348e22659c2b095b1c ]

of_get_next_parent() returns a node pointer with refcount incremented,
we should use of_node_put() on it when not need anymore.
Add missing of_node_put() in the error path to avoid refcount leak.

Fixes: ce21b3c9648a ("[CELL] add support for MSI on Axon-based Cell systems")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220605065129.63906-1-linmq006@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/cell/axon_msi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/platforms/cell/axon_msi.c b/arch/powerpc/platforms/cell/axon_msi.c
index 82335e364c44..f630693c8de7 100644
--- a/arch/powerpc/platforms/cell/axon_msi.c
+++ b/arch/powerpc/platforms/cell/axon_msi.c
@@ -226,6 +226,7 @@ static int setup_msi_msg_address(struct pci_dev *dev, struct msi_msg *msg)
 	if (!prop) {
 		dev_dbg(&dev->dev,
 			"axon_msi: no msi-address-(32|64) properties found\n");
+		of_node_put(dn);
 		return -ENOENT;
 	}
 
-- 
2.35.1




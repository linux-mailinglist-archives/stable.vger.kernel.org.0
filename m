Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CBE751A9B9
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:18:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356898AbiEDRTJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:19:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357643AbiEDRPJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:15:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6DB75534A
        for <stable@vger.kernel.org>; Wed,  4 May 2022 09:58:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 11326B82795
        for <stable@vger.kernel.org>; Wed,  4 May 2022 16:58:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A90F5C385AF;
        Wed,  4 May 2022 16:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651683527;
        bh=KYuIlRixMRXJ/NR0UmXgTUkR5mDhasieXg47JokMK8E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WZxmWnOzDkhA3ZlAYEJvyG8IIkWUiOQzZaa17yuuHEHSAL8so39pSwCIzomOMQBTT
         YUVsJRmDuMlq+NXc0KJQB5JwtvXHaafAzvjGg2cHAWKSZ/OYJBqRsLoNFHLFanyb7p
         Hd3T7FH3GVFNL0EGfZJdlhNvRtG3KtOfl8WoEMMdZGFUK5eswV428a3aGX77iW3u1e
         UBAVE3UWtOWbK4YUj60QP3dyPNHgUdgJticMrWPRL65yGQsRHfmRgt9SdiVAqmIpW1
         poD7MfnzawVgqvrK5L5SPv9lBZ16IXTEMAREPZPA+iaLZcpkck/WV20RDlOPe7JmUV
         241cBQlTavpaQ==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, pali@kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 5.15 30/30] PCI: aardvark: Update comment about link going down after link-up
Date:   Wed,  4 May 2022 18:57:55 +0200
Message-Id: <20220504165755.30002-31-kabel@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220504165755.30002-1-kabel@kernel.org>
References: <20220504165755.30002-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 92f4ffecc4170ce29e67a1f8d51c168c3de95fb2 upstream.

Update the comment about what happens when link goes down after we have
checked for link-up. If a PIO request is done while link-down, we have
a serious problem.

Link: https://lore.kernel.org/r/20220110015018.26359-23-kabel@kernel.org
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/pci/controller/pci-aardvark.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/controller/pci-aardvark.c b/drivers/pci/controller/pci-aardvark.c
index 669663fb982e..ff45052cf48d 100644
--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -998,8 +998,12 @@ static bool advk_pcie_valid_device(struct advk_pcie *pcie, struct pci_bus *bus,
 		return false;
 
 	/*
-	 * If the link goes down after we check for link-up, nothing bad
-	 * happens but the config access times out.
+	 * If the link goes down after we check for link-up, we have a problem:
+	 * if a PIO request is executed while link-down, the whole controller
+	 * gets stuck in a non-functional state, and even after link comes up
+	 * again, PIO requests won't work anymore, and a reset of the whole PCIe
+	 * controller is needed. Therefore we need to prevent sending PIO
+	 * requests while the link is down.
 	 */
 	if (!pci_is_root_bus(bus) && !advk_pcie_link_up(pcie))
 		return false;
-- 
2.35.1


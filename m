Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F37B5219F9
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:49:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244213AbiEJNwx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:52:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245077AbiEJNrV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:47:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65F53198755;
        Tue, 10 May 2022 06:34:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 258A4B81DAF;
        Tue, 10 May 2022 13:34:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CD97C385A6;
        Tue, 10 May 2022 13:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189696;
        bh=rrzejhvcQXnEC6A7XoE7Mjs1pkvzmQkXpRkj3K43Yow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=he/8xOkZh8jKHIlRNtWvleG8fd7vg2oZFJMVggDYPsrrRAYXNrhK/QoZ4pfNDAeSP
         ZWyXuuoKBZxCT+VBaiN0LaCHWQ/ZW8ipsBOSwanNABMumuMg/gaAGqrjR/pwVPHkDn
         zo7XoAmdAqh+2+9REVqJiQxZpWiFaK4OC+9GGOHg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, pali@kernel.org,
        =?UTF-8?q?Marek=20Beh=FAn?= <kabel@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: [PATCH 5.15 135/135] PCI: aardvark: Update comment about link going down after link-up
Date:   Tue, 10 May 2022 15:08:37 +0200
Message-Id: <20220510130744.266819133@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130740.392653815@linuxfoundation.org>
References: <20220510130740.392653815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Marek Behún" <kabel@kernel.org>

commit 92f4ffecc4170ce29e67a1f8d51c168c3de95fb2 upstream.

Update the comment about what happens when link goes down after we have
checked for link-up. If a PIO request is done while link-down, we have
a serious problem.

Link: https://lore.kernel.org/r/20220110015018.26359-23-kabel@kernel.org
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pci-aardvark.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -998,8 +998,12 @@ static bool advk_pcie_valid_device(struc
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



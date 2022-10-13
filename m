Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 907275FCF45
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 02:16:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbiJMAQp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 20:16:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229803AbiJMAQh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 20:16:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB50AD9949;
        Wed, 12 Oct 2022 17:16:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A676616B3;
        Thu, 13 Oct 2022 00:16:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1FA8C433C1;
        Thu, 13 Oct 2022 00:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665620175;
        bh=1TJHyyfg+QsA6U78R8mxqIahZXicXXqn1XHvFq8xnAo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gbG6Hxi854znHrVZJGk6FwU0Q9cKSuApKlRZHYiFu+tOr/ircj6KIvpOPJBP0v5lW
         6Ko2zJIUQ1qvR5I4f6lY+q9tYSTLDsdkQaYqm6epTKZmL+QA3qhn+Dfi6A1RJ5aXrc
         mSiEE87fImXvXoqiVBJMc6afRurvvUvWO6L5LY6Flvlj4bGvejhcxqJI9WkbkSVSaz
         t/ToZ/u7ztnuCq+O9oqBo5vTkDcq2mmwFmj8GePBK9yb5+UeyqwPVC1MOX2UhhNFyJ
         cxXKL/aJ0Vn2+UvapWQxRdV6mbZVGEVJpOt+/PgrGq4u+SD37/kNXdxSeQDwokitHs
         h/hapkIRm1ZPw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Justin Chen <justinpopo6@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, mathias.nyman@intel.com,
        linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 08/67] usb: host: xhci-plat: suspend/resume clks for brcm
Date:   Wed, 12 Oct 2022 20:14:49 -0400
Message-Id: <20221013001554.1892206-8-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221013001554.1892206-1-sashal@kernel.org>
References: <20221013001554.1892206-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Justin Chen <justinpopo6@gmail.com>

[ Upstream commit c69400b09e471a3f1167adead55a808f0da6534a ]

The xhci_plat_brcm xhci block can enter suspend with clock disabled to save
power and re-enable them on resume. Make use of the XHCI_SUSPEND_RESUME_CLKS
quirk to do so.

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Justin Chen <justinpopo6@gmail.com>
Link: https://lore.kernel.org/r/1660170455-15781-3-git-send-email-justinpopo6@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-plat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
index ef10982ad482..5fb55bf19493 100644
--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -123,7 +123,7 @@ static const struct xhci_plat_priv xhci_plat_renesas_rcar_gen3 = {
 };
 
 static const struct xhci_plat_priv xhci_plat_brcm = {
-	.quirks = XHCI_RESET_ON_RESUME,
+	.quirks = XHCI_RESET_ON_RESUME | XHCI_SUSPEND_RESUME_CLKS,
 };
 
 static const struct of_device_id usb_xhci_of_match[] = {
-- 
2.35.1


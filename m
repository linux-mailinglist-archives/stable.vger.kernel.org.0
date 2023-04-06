Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 423556D9551
	for <lists+stable@lfdr.de>; Thu,  6 Apr 2023 13:33:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237937AbjDFLdK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Apr 2023 07:33:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237423AbjDFLcj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Apr 2023 07:32:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B923193D5;
        Thu,  6 Apr 2023 04:32:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 738B864677;
        Thu,  6 Apr 2023 11:32:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27ADCC433A7;
        Thu,  6 Apr 2023 11:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680780735;
        bh=6ohgnT0gTadcyRL7A8QIlTK6u9RLNeZKhkssa8G7fow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I8MYVqq7gAOzzX4Ow9+nQjPHNTPEo4/NGboYjEbBPeu9IkfZbNpHydVO1Ox7JfjAl
         INIoIrHckDAht73ZWpnMZ7Gj/f7j3ins3YbtUzbgbDT9+labMYQQR02wQuwMPDsLpb
         EdT3q9vjvmOO2WPg/emFDD5lKKYpAnenjGOIcZ8mHWwv7Dkim08DkAfpYpKbPDC3Bp
         vAHntBvcqZVQNt/eE7RLc5fE0aAuAP4vPg/L2BO6aFUy/0Bzt5oh+5bKqPiCVm8Opb
         PHPXiOdubSalOA1FxRdN+dnS7VSyvWE3GtgkMT4lC48p6WchUkdwKqAojsTNf6+fdE
         LSXSV0blOUohQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dongliang Mu <dzm91@hust.edu.cn>,
        "David E . Box" <david.e.box@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, markgross@kernel.org,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 02/17] platform/x86/intel: vsec: Fix a memory leak in intel_vsec_add_aux
Date:   Thu,  6 Apr 2023 07:31:56 -0400
Message-Id: <20230406113211.648424-2-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230406113211.648424-1-sashal@kernel.org>
References: <20230406113211.648424-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dongliang Mu <dzm91@hust.edu.cn>

[ Upstream commit da0ba0ccce54059d6c6b788a75099bfce95126da ]

The first error handling code in intel_vsec_add_aux misses the
deallocation of intel_vsec_dev->resource.

Fix this by adding kfree(intel_vsec_dev->resource) in the error handling
code.

Reviewed-by: David E. Box <david.e.box@linux.intel.com>
Signed-off-by: Dongliang Mu <dzm91@hust.edu.cn>
Link: https://lore.kernel.org/r/20230309040107.534716-4-dzm91@hust.edu.cn
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/vsec.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/intel/vsec.c b/drivers/platform/x86/intel/vsec.c
index bb81b8b1f7e9b..483bb65651665 100644
--- a/drivers/platform/x86/intel/vsec.c
+++ b/drivers/platform/x86/intel/vsec.c
@@ -141,6 +141,7 @@ static int intel_vsec_add_aux(struct pci_dev *pdev, struct intel_vsec_device *in
 
 	ret = ida_alloc(intel_vsec_dev->ida, GFP_KERNEL);
 	if (ret < 0) {
+		kfree(intel_vsec_dev->resource);
 		kfree(intel_vsec_dev);
 		return ret;
 	}
-- 
2.39.2


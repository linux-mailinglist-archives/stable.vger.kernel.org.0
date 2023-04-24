Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D41D36ECDAA
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:25:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232095AbjDXNZb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:25:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232142AbjDXNZa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:25:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BC425FE5
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:25:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 36A8F622B1
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:25:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48407C433EF;
        Mon, 24 Apr 2023 13:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682342727;
        bh=6ohgnT0gTadcyRL7A8QIlTK6u9RLNeZKhkssa8G7fow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0tAgx3jnH7fFY39ZmY8si+REsHdFBkZQolQl/APyu+3x4S9A590elu9/fR42vvP+T
         RzWX6qUJGjtBIC0taluP0JpYz1cov4sAJqlQHUJLrWvPAyk9IOxqlhLMW6qoD2uDUu
         bMTmGV7dIRfS+5ZvPWr/gZWimo9nR5p4/jJRaJ/s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "David E. Box" <david.e.box@linux.intel.com>,
        Dongliang Mu <dzm91@hust.edu.cn>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 34/98] platform/x86/intel: vsec: Fix a memory leak in intel_vsec_add_aux
Date:   Mon, 24 Apr 2023 15:16:57 +0200
Message-Id: <20230424131135.216087786@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131133.829259077@linuxfoundation.org>
References: <20230424131133.829259077@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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




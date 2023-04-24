Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 692FF6ECE65
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:32:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232487AbjDXNcI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:32:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232427AbjDXNby (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:31:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 800167EF9
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:31:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5EF016231E
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:31:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70D97C433D2;
        Mon, 24 Apr 2023 13:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682343077;
        bh=8M/LCCMRDH4FXHIQ8fIJC+eRJ1ubq/crP4lyDGdMpr8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iq5OintsKSM+66M1/9R+G6YyzPGo8O9m5EsDbr1ZGzHolo4jrsTQryEorBzYQw6H6
         kOQgroKHl2Jw/lHvA10SZr9rCxfyGSkAjkDStzdoI4hW5/CH8ZT4qZGonNZKql4Qwa
         w4TAd+SBQWOXWhRci1iiEVhamB/gp96q/pypILYQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "David E. Box" <david.e.box@linux.intel.com>,
        Dongliang Mu <dzm91@hust.edu.cn>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 039/110] platform/x86/intel: vsec: Fix a memory leak in intel_vsec_add_aux
Date:   Mon, 24 Apr 2023 15:17:01 +0200
Message-Id: <20230424131137.616055800@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131136.142490414@linuxfoundation.org>
References: <20230424131136.142490414@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
index 89c5374e33b32..bcbd522d062bf 100644
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




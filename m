Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAF24593E2F
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:44:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345494AbiHOUhO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:37:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346098AbiHOUff (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:35:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E47DE2AE3A;
        Mon, 15 Aug 2022 12:06:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 822E661019;
        Mon, 15 Aug 2022 19:06:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F1A4C433D6;
        Mon, 15 Aug 2022 19:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590402;
        bh=mxljtDHMst5iwqEorc0AT/oDFsf1xLqdqqSlxIcDaPk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zmks4f3fQmOMKXXz5MFXoAmKtXVIFKpn4cQhrs8ygKeZQMY2RGEOZnmN1rbveBpIX
         x9AavJWf7uR091NJcTiNh1uWdClO2ZJuMtOzp2NcFb0vo694FNBzCs32PVFKPq/qu+
         WsWJBfEp15gE3Cnjcyh/8G26GZyQPjYcKX1U4hnI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        John Garry <john.garry@huawei.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0248/1095] bus: hisi_lpc: fix missing platform_device_put() in hisi_lpc_acpi_probe()
Date:   Mon, 15 Aug 2022 19:54:07 +0200
Message-Id: <20220815180440.034340010@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 54872fea6a5ac967ec2272aea525d1438ac6735a ]

In error case in hisi_lpc_acpi_probe() after calling platform_device_add(),
hisi_lpc_acpi_remove() can't release the failed 'pdev', so it will be leak,
call platform_device_put() to fix this problem.
I'v constructed this error case and tested this patch on D05 board.

Fixes: 99c0228d6ff1 ("HISI LPC: Re-Add ACPI child enumeration support")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Acked-by: John Garry <john.garry@huawei.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/hisi_lpc.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/bus/hisi_lpc.c b/drivers/bus/hisi_lpc.c
index 378f5d62a991..e7eaa8784fee 100644
--- a/drivers/bus/hisi_lpc.c
+++ b/drivers/bus/hisi_lpc.c
@@ -503,13 +503,13 @@ static int hisi_lpc_acpi_probe(struct device *hostdev)
 {
 	struct acpi_device *adev = ACPI_COMPANION(hostdev);
 	struct acpi_device *child;
+	struct platform_device *pdev;
 	int ret;
 
 	/* Only consider the children of the host */
 	list_for_each_entry(child, &adev->children, node) {
 		const char *hid = acpi_device_hid(child);
 		const struct hisi_lpc_acpi_cell *cell;
-		struct platform_device *pdev;
 		const struct resource *res;
 		bool found = false;
 		int num_res;
@@ -571,22 +571,24 @@ static int hisi_lpc_acpi_probe(struct device *hostdev)
 
 		ret = platform_device_add_resources(pdev, res, num_res);
 		if (ret)
-			goto fail;
+			goto fail_put_device;
 
 		ret = platform_device_add_data(pdev, cell->pdata,
 					       cell->pdata_size);
 		if (ret)
-			goto fail;
+			goto fail_put_device;
 
 		ret = platform_device_add(pdev);
 		if (ret)
-			goto fail;
+			goto fail_put_device;
 
 		acpi_device_set_enumerated(child);
 	}
 
 	return 0;
 
+fail_put_device:
+	platform_device_put(pdev);
 fail:
 	hisi_lpc_acpi_remove(hostdev);
 	return ret;
-- 
2.35.1




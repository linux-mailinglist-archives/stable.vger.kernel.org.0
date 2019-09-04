Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E911BA902F
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389717AbfIDSIK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:08:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:50856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388808AbfIDSIJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:08:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A5F320870;
        Wed,  4 Sep 2019 18:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620488;
        bh=A6jqfQt1fU2Vf6DkHcpoLkmMml53rNnwKzLsF4280cs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q1ru0Ivwjb31MqRzaO5nRNgD3x5U1NqwJ3f8oOgePsBv6c32YukftHAoMczdqnVap
         CpjLNg+FEhRbDiT88xIh4qs1xOEVVU5f/GGcbU+lt2NX1EMcxstFDZJzCueQRl2nM0
         GlSs1HzK8A/3VQfMQeqGmxVO/vwGPH68AmJhRKxc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Garry <john.garry@huawei.com>,
        Wei Xu <xuwei5@hisilicon.com>
Subject: [PATCH 4.19 76/93] bus: hisi_lpc: Unregister logical PIO range to avoid potential use-after-free
Date:   Wed,  4 Sep 2019 19:54:18 +0200
Message-Id: <20190904175309.655425948@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175302.845828956@linuxfoundation.org>
References: <20190904175302.845828956@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Garry <john.garry@huawei.com>

commit 1b15a5632a809ab57d403fd972ca68785363b654 upstream.

If, after registering a logical PIO range, the driver probe later fails,
the logical PIO range memory will be released automatically.

This causes an issue, in that the logical PIO range is not unregistered
and the released range memory may be later referenced.

Fix by unregistering the logical PIO range.

And since we now unregister the logical PIO range for probe failure, avoid
the special ordering of setting logical PIO range ops, which was the
previous (poor) attempt at a safeguard against this.

Cc: stable@vger.kernel.org
Fixes: adf38bb0b595 ("HISI LPC: Support the LPC host on Hip06/Hip07 with DT bindings")
Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Wei Xu <xuwei5@hisilicon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/bus/hisi_lpc.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/bus/hisi_lpc.c
+++ b/drivers/bus/hisi_lpc.c
@@ -607,24 +607,25 @@ static int hisi_lpc_probe(struct platfor
 	range->fwnode = dev->fwnode;
 	range->flags = LOGIC_PIO_INDIRECT;
 	range->size = PIO_INDIRECT_SIZE;
+	range->hostdata = lpcdev;
+	range->ops = &hisi_lpc_ops;
+	lpcdev->io_host = range;
 
 	ret = logic_pio_register_range(range);
 	if (ret) {
 		dev_err(dev, "register IO range failed (%d)!\n", ret);
 		return ret;
 	}
-	lpcdev->io_host = range;
 
 	/* register the LPC host PIO resources */
 	if (acpi_device)
 		ret = hisi_lpc_acpi_probe(dev);
 	else
 		ret = of_platform_populate(dev->of_node, NULL, NULL, dev);
-	if (ret)
+	if (ret) {
+		logic_pio_unregister_range(range);
 		return ret;
-
-	lpcdev->io_host->hostdata = lpcdev;
-	lpcdev->io_host->ops = &hisi_lpc_ops;
+	}
 
 	io_end = lpcdev->io_host->io_start + lpcdev->io_host->size;
 	dev_info(dev, "registered range [%pa - %pa]\n",



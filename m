Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2E972F1704
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 15:00:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730409AbhAKNGK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:06:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:53778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730378AbhAKNGJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:06:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C2BA321534;
        Mon, 11 Jan 2021 13:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370329;
        bh=ZlaZqciwpjaa/xtYY1uxPbxg1XSwbt48c1KuOl9f+9U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gZRSuIRo1pwre3qkdsvhiHjepBCavvsaZB+16u/ViiW1+w40TpJKbSZC49x3BFsRV
         Cv5mMwAfKIpmjY8vBwr4MYP2AUZ2RLZRNn9pVVCE4MOQwxJwsujzsminePHRs6PflV
         pyMzqFfBTrMC7Dd3Y9ysqRqZvdA53EkvO3MV9ndc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yu Kuai <yukuai3@huawei.com>
Subject: [PATCH 4.14 32/57] usb: chipidea: ci_hdrc_imx: add missing put_device() call in usbmisc_get_init_data()
Date:   Mon, 11 Jan 2021 14:01:51 +0100
Message-Id: <20210111130035.273176904@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130033.715773309@linuxfoundation.org>
References: <20210111130033.715773309@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yu Kuai <yukuai3@huawei.com>

commit 83a43ff80a566de8718dfc6565545a0080ec1fb5 upstream.

if of_find_device_by_node() succeed, usbmisc_get_init_data() doesn't have
a corresponding put_device(). Thus add put_device() to fix the exception
handling for this function implementation.

Fixes: ef12da914ed6 ("usb: chipidea: imx: properly check for usbmisc")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20201117011430.642589-1-yukuai3@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/chipidea/ci_hdrc_imx.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/usb/chipidea/ci_hdrc_imx.c
+++ b/drivers/usb/chipidea/ci_hdrc_imx.c
@@ -134,9 +134,13 @@ static struct imx_usbmisc_data *usbmisc_
 	misc_pdev = of_find_device_by_node(args.np);
 	of_node_put(args.np);
 
-	if (!misc_pdev || !platform_get_drvdata(misc_pdev))
+	if (!misc_pdev)
 		return ERR_PTR(-EPROBE_DEFER);
 
+	if (!platform_get_drvdata(misc_pdev)) {
+		put_device(&misc_pdev->dev);
+		return ERR_PTR(-EPROBE_DEFER);
+	}
 	data->dev = &misc_pdev->dev;
 
 	if (of_find_property(np, "disable-over-current", NULL))



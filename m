Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 547502F166B
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:53:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730672AbhAKNI5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:08:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:56240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730498AbhAKNI4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:08:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B140121973;
        Mon, 11 Jan 2021 13:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370496;
        bh=YJmB7XOQ96ih2KlqU63QE9fb6mMTVB5yzGHsfF2r9Cs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M/wWASlA6oWLVfqM0Zi3ji/X6EXQmRxtA99LIFnIz8Z9EcrzPPWiKyL5BEGJUZSup
         rbiq8HsoeBQGsI97cjE+yMRind4PbRqs6bMmd4NKLnxdPer5N5QrBlvQskvHayC178
         lt0/q2A/uXf660fHPnZ8+vSctwG6tfFotVUG1oNE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yu Kuai <yukuai3@huawei.com>
Subject: [PATCH 4.19 47/77] usb: chipidea: ci_hdrc_imx: add missing put_device() call in usbmisc_get_init_data()
Date:   Mon, 11 Jan 2021 14:01:56 +0100
Message-Id: <20210111130038.672788214@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130036.414620026@linuxfoundation.org>
References: <20210111130036.414620026@linuxfoundation.org>
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
@@ -128,9 +128,13 @@ static struct imx_usbmisc_data *usbmisc_
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



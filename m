Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87D8333BA1F
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:10:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234483AbhCOOIC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:08:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:49058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233772AbhCOOC0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:02:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A74A64E89;
        Mon, 15 Mar 2021 14:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816945;
        bh=iJSUvtsb3maAC8bD3ziwMEJcukoB4xLuWwKSkdd9bH4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UEpyQAhc60J2T9Y73ILbmvujNHp0NpxqwvpwHgkx0BzKhe9xK8n429DjxXS0PF1kc
         q4KbXHAx/AHFNPs1h8SKLlKM6Zxtpa4elvxDG4LvmKPJfoDLROjKq+L72q2d5V/cfS
         p/xUG0s3G0mXJskVZEtGCvtmqYUdJ0kLQttjM+0o=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shile Zhang <shile.zhang@linux.alibaba.com>
Subject: [PATCH 5.11 219/306] misc/pvpanic: Export module FDT device table
Date:   Mon, 15 Mar 2021 14:54:42 +0100
Message-Id: <20210315135515.017729154@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Shile Zhang <shile.zhang@linux.alibaba.com>

commit 65527a51c66f4edfa28602643d7dd4fa366eb826 upstream.

Export the module FDT device table to ensure the FDT compatible strings
are listed in the module alias. This help the pvpanic driver can be
loaded on boot automatically not only the ACPI device, but also the FDT
device.

Fixes: 46f934c9a12fc ("misc/pvpanic: add support to get pvpanic device info FDT")
Signed-off-by: Shile Zhang <shile.zhang@linux.alibaba.com>
Link: https://lore.kernel.org/r/20210218123116.207751-1-shile.zhang@linux.alibaba.com
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/pvpanic.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/misc/pvpanic.c
+++ b/drivers/misc/pvpanic.c
@@ -92,6 +92,7 @@ static const struct of_device_id pvpanic
 	{ .compatible = "qemu,pvpanic-mmio", },
 	{}
 };
+MODULE_DEVICE_TABLE(of, pvpanic_mmio_match);
 
 static const struct acpi_device_id pvpanic_device_ids[] = {
 	{ "QEMU0001", 0 },



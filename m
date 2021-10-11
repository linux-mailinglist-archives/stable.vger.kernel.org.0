Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B15642915D
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:16:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244642AbhJKORj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:17:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:38794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244417AbhJKOPf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:15:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B1A10610EA;
        Mon, 11 Oct 2021 14:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633961136;
        bh=uZpEPWh2gUx07t492kfLO8szb/mGRAv1R1SQVjfgst0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jwPdt8NtBDuv79Z5C6WORxNTdw8dBe/7CEkLl0gDLWNnj0tEqzH3pzUW+LpkUL/fL
         udwxBv7Bd8kKiSIJOjg1kq3Mqgm66o6QYbDNyYUGVCDh6tyOQYDzuVcgh0g9XETL14
         9aa5swqNauOouR5EQ7m949YTDhXLaQJcG57PatwM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jamie Iles <quic_jiles@quicinc.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 26/28] i2c: acpi: fix resource leak in reconfiguration device addition
Date:   Mon, 11 Oct 2021 15:47:16 +0200
Message-Id: <20211011134641.559770745@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134640.711218469@linuxfoundation.org>
References: <20211011134640.711218469@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jamie Iles <quic_jiles@quicinc.com>

[ Upstream commit 6558b646ce1c2a872fe1c2c7cb116f05a2c1950f ]

acpi_i2c_find_adapter_by_handle() calls bus_find_device() which takes a
reference on the adapter which is never released which will result in a
reference count leak and render the adapter unremovable.  Make sure to
put the adapter after creating the client in the same manner that we do
for OF.

Fixes: 525e6fabeae2 ("i2c / ACPI: add support for ACPI reconfigure notifications")
Signed-off-by: Jamie Iles <quic_jiles@quicinc.com>
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
[wsa: fixed title]
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/i2c-core-acpi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/i2c/i2c-core-acpi.c b/drivers/i2c/i2c-core-acpi.c
index 8ba4122fb340..8288cfb44cb2 100644
--- a/drivers/i2c/i2c-core-acpi.c
+++ b/drivers/i2c/i2c-core-acpi.c
@@ -395,6 +395,7 @@ static int i2c_acpi_notify(struct notifier_block *nb, unsigned long value,
 			break;
 
 		i2c_acpi_register_device(adapter, adev, &info);
+		put_device(&adapter->dev);
 		break;
 	case ACPI_RECONFIG_DEVICE_REMOVE:
 		if (!acpi_device_enumerated(adev))
-- 
2.33.0




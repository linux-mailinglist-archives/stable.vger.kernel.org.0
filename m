Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E60B0428EEB
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 15:51:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237824AbhJKNxN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 09:53:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:40464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237527AbhJKNvx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 09:51:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA55E60F21;
        Mon, 11 Oct 2021 13:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960193;
        bh=FT8kaXscQ1VA2HwnfeQ8B32N5crSb2YYTsnin1OriAU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GyLNEM8OxHY0HHYjqVLUuCqFwETU/VEBKTWr4leR9yrakQKeiwxbfFWq0wPQes9sz
         ICEwYEavVu1YooWtnkZanOspspFI1ew66mPZOqwJvBUgOyQirMJI8AXg5fIKEX/gSt
         HD7vJSzMoNUJtGBP+/yweV1gFxDoXAPXZLNcfVdw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jamie Iles <quic_jiles@quicinc.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 46/52] i2c: acpi: fix resource leak in reconfiguration device addition
Date:   Mon, 11 Oct 2021 15:46:15 +0200
Message-Id: <20211011134505.301785724@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134503.715740503@linuxfoundation.org>
References: <20211011134503.715740503@linuxfoundation.org>
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
index c70983780ae7..fe466ee4c49b 100644
--- a/drivers/i2c/i2c-core-acpi.c
+++ b/drivers/i2c/i2c-core-acpi.c
@@ -436,6 +436,7 @@ static int i2c_acpi_notify(struct notifier_block *nb, unsigned long value,
 			break;
 
 		i2c_acpi_register_device(adapter, adev, &info);
+		put_device(&adapter->dev);
 		break;
 	case ACPI_RECONFIG_DEVICE_REMOVE:
 		if (!acpi_device_enumerated(adev))
-- 
2.33.0




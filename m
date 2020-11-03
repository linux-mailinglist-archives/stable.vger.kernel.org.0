Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACEB92A51F7
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:48:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731040AbgKCUpb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:45:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:33828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731036AbgKCUpa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:45:30 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D60AF223EA;
        Tue,  3 Nov 2020 20:45:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436330;
        bh=H8vg+CkTwI8Qs533J24DXE2p4lvFzJ5TfZejmDk0hRQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fVhRqhQzyRk4jtzwGkwQ/W2PSooxTS3PRLcD+ZqLDN01L6iyxETY2tHNahyT7mFn2
         ATM5SQWRxw41HFGqkZuJZ7VBkaRxTEs9HoTz9e9LqmEEM0HZu2UAddo+/51EwhAYQI
         hUH7M3lo1fcuF+7KQqd4Aj12DwejqwK7Iv/fQDt8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hanjun Guo <guohanjun@huawei.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.9 203/391] ACPI: configfs: Add missing config_item_put() to fix refcount leak
Date:   Tue,  3 Nov 2020 21:34:14 +0100
Message-Id: <20201103203400.591849167@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hanjun Guo <guohanjun@huawei.com>

commit 9a2e849fb6de471b82d19989a7944d3b7671793c upstream.

config_item_put() should be called in the drop_item callback, to
decrement refcount for the config item.

Fixes: 772bf1e2878ec ("ACPI: configfs: Unload SSDT on configfs entry removal")
Signed-off-by: Hanjun Guo <guohanjun@huawei.com>
[ rjw: Subject edit ]
Cc: 4.13+ <stable@vger.kernel.org> # 4.13+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/acpi_configfs.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/acpi/acpi_configfs.c
+++ b/drivers/acpi/acpi_configfs.c
@@ -228,6 +228,7 @@ static void acpi_table_drop_item(struct
 
 	ACPI_INFO(("Host-directed Dynamic ACPI Table Unload"));
 	acpi_unload_table(table->index);
+	config_item_put(cfg);
 }
 
 static struct configfs_group_operations acpi_table_group_ops = {



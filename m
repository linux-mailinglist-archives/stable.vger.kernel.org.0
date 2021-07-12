Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D4E33C48EA
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:31:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233808AbhGLGlX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:41:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:33550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237445AbhGLGj2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:39:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 12B9E60FD8;
        Mon, 12 Jul 2021 06:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071712;
        bh=gD4mp4a9Q6gxyCGTWtos+XvRDZiiDOibuXhFg6BVkpI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xBkabBYFI5XOROY/Eln9Aj2E7gaBx+02abb+GkeDpEmavyeWlb31xUIDvsdz9WesI
         pk1OzoIECZOn6IcatAh7JftW8TbNJyuJxEqSNBpqqCjGqM43xVtPhRRGh6y0COokRf
         8iMgDrYxTwiSNPmsGYa3EnJem24uW3j3C+lxirDQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hanjun Guo <guohanjun@huawei.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 186/593] ACPI: bus: Call kobject_put() in acpi_init() error path
Date:   Mon, 12 Jul 2021 08:05:46 +0200
Message-Id: <20210712060903.457722118@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hanjun Guo <guohanjun@huawei.com>

[ Upstream commit 4ac7a817f1992103d4e68e9837304f860b5e7300 ]

Although the system will not be in a good condition or it will not
boot if acpi_bus_init() fails, it is still necessary to put the
kobject in the error path before returning to avoid leaking memory.

Signed-off-by: Hanjun Guo <guohanjun@huawei.com>
[ rjw: Subject and changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/bus.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index 1682f8b454a2..e317214aabec 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -1245,6 +1245,7 @@ static int __init acpi_init(void)
 
 	result = acpi_bus_init();
 	if (result) {
+		kobject_put(acpi_kobj);
 		disable_acpi();
 		return result;
 	}
-- 
2.30.2




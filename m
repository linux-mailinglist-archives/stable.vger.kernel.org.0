Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F165D3C3952
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 01:56:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234264AbhGJX6m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 19:58:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:40812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234090AbhGJX5U (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Jul 2021 19:57:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E1D261416;
        Sat, 10 Jul 2021 23:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625961155;
        bh=twK7smbQ2xhiwNylkjkTv7chyuqvOTm6osPmo7B/YOk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rC4SaNfTVO0HTYBWGawogWiFVxlhJk+OyUhfuu75IJPQCXwQn5f/By899DKxtPpDs
         peJ2J8VwXzzJGSoDzLZPwaZYqcPRmHYEnqZUmCwYcEEvV8udrBNtKQ7wMedCcgJyL0
         EoZVSRZu6AbWXS0Ziu2LznJZNSVfK8gKrWrqfaCVuwlqAa0qy7UwDM/MEoKfSGFNJe
         9GXnVFsaFBN+Q7gO7J3Pqr/W+LjyKp94Jv5JWDkVrJ2DpOOOb25ay0+JswtflLrDl+
         7UnielKKqG28RnFSS5olO7UZ4BZLk5QdCUwQBj3y8eTf1ywad0wFSHOUqfy0flaxyM
         Dip6IAi85a3+w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Liguang Zhang <zhangliguang@linux.alibaba.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 17/21] ACPI: AMBA: Fix resource name in /proc/iomem
Date:   Sat, 10 Jul 2021 19:52:08 -0400
Message-Id: <20210710235212.3222375-17-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710235212.3222375-1-sashal@kernel.org>
References: <20210710235212.3222375-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liguang Zhang <zhangliguang@linux.alibaba.com>

[ Upstream commit 7718629432676b5ebd9a32940782fe297a0abf8d ]

In function amba_handler_attach(), dev->res.name is initialized by
amba_device_alloc. But when address_found is false, dev->res.name is
assigned to null value, which leads to wrong resource name display in
/proc/iomem, "<BAD>" is seen for those resources.

Signed-off-by: Liguang Zhang <zhangliguang@linux.alibaba.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpi_amba.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/acpi/acpi_amba.c b/drivers/acpi/acpi_amba.c
index 7f77c071709a..eb09ee71ceb2 100644
--- a/drivers/acpi/acpi_amba.c
+++ b/drivers/acpi/acpi_amba.c
@@ -70,6 +70,7 @@ static int amba_handler_attach(struct acpi_device *adev,
 		case IORESOURCE_MEM:
 			if (!address_found) {
 				dev->res = *rentry->res;
+				dev->res.name = dev_name(&dev->dev);
 				address_found = true;
 			}
 			break;
-- 
2.30.2


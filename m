Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D80A3BBF28
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 17:29:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232161AbhGEPbi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 11:31:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:56140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232043AbhGEPbZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 11:31:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3543561993;
        Mon,  5 Jul 2021 15:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625498928;
        bh=9IN4mdPOZIJkEmHGxG01aTcoyfS0FNKSFSazwpYZr+I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TcTOVArkECTn5e9EdenMdisWhIjOcibNdquQ5qr0lHJcQhBQEpseht+prGx0QJwbk
         spybsliFrOlnUS+whhQ8W35R7o6/K8R0Xf9ebVCx4o6IUnlKk7xAME5m5a91fHTwMh
         yLLnDqz+VQOE9HjN2FeNoynuaob3z8mtBANpkw3j0njDhDQlE+3EFhNVIwuCvtxyMd
         Y+HjCKBITgaHFJNLSEj/zSPd8hXRP4C2NN5pgynqfAj2U38iYm60skOAu9G1ZJhzI1
         Sk/+HEchNgWs0nbNvLe7vfvsvg0BpAwIkuhSCZpj6CTeDj/7QznvaT9H5nmpDByLTW
         1bFt9ucTWxkUQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hanjun Guo <guohanjun@huawei.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 25/59] ACPI: bus: Call kobject_put() in acpi_init() error path
Date:   Mon,  5 Jul 2021 11:27:41 -0400
Message-Id: <20210705152815.1520546-25-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210705152815.1520546-1-sashal@kernel.org>
References: <20210705152815.1520546-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index a4bd673934c0..44b4f02e2c6d 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -1321,6 +1321,7 @@ static int __init acpi_init(void)
 
 	result = acpi_bus_init();
 	if (result) {
+		kobject_put(acpi_kobj);
 		disable_acpi();
 		return result;
 	}
-- 
2.30.2


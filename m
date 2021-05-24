Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0483738EBD2
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:07:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233641AbhEXPH0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:07:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:37288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234202AbhEXPEL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:04:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B00F6157F;
        Mon, 24 May 2021 14:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867846;
        bh=iFoHbmoRfsF8UqahWydgX8ijJLz5v2TsAOTGswzRmLY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E3pxWey7tBJd7zcOnN6XYBxopeO8lih0iR/KVgI0LmcCl4/4WJ9jkGFxtjj5n7o18
         wSRMo/b4TkYdOARVF76Gtr/vRKtemucRskr7Jo43FwOFt2m2l+48L2PZ7DqfOdUOfP
         tu7xz4i1XQBhFJUHworS8U8OupM1hX3RTwa30VLSfrWNyBhXjJwBgzQg7Q49gDKraC
         LK7YMD5K3LO1Ux/IlaDP1tCDwOcLLjdHv7YcZpXGtxYIpCJe9Kc+LBfHR/K2Vk3+gB
         h1gTV/CqDISD9DNQOdTBb4ZxGDsQDjxyPSnGhzyoKxCklwn9dx14l4pR5iUZWuSHRw
         aAPVDJYiMjmSQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tom Seewald <tseewald@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 05/21] char: hpet: add checks after calling ioremap
Date:   Mon, 24 May 2021 10:50:24 -0400
Message-Id: <20210524145040.2499322-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524145040.2499322-1-sashal@kernel.org>
References: <20210524145040.2499322-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Seewald <tseewald@gmail.com>

[ Upstream commit b11701c933112d49b808dee01cb7ff854ba6a77a ]

The function hpet_resources() calls ioremap() two times, but in both
cases it does not check if ioremap() returned a null pointer. Fix this
by adding null pointer checks and returning an appropriate error.

Signed-off-by: Tom Seewald <tseewald@gmail.com>
Link: https://lore.kernel.org/r/20210503115736.2104747-30-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hpet.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
index 05ca269ddd05..b9935675085c 100644
--- a/drivers/char/hpet.c
+++ b/drivers/char/hpet.c
@@ -977,6 +977,8 @@ static acpi_status hpet_resources(struct acpi_resource *res, void *data)
 	if (ACPI_SUCCESS(status)) {
 		hdp->hd_phys_address = addr.address.minimum;
 		hdp->hd_address = ioremap(addr.address.minimum, addr.address.address_length);
+		if (!hdp->hd_address)
+			return AE_ERROR;
 
 		if (hpet_is_known(hdp)) {
 			iounmap(hdp->hd_address);
@@ -990,6 +992,8 @@ static acpi_status hpet_resources(struct acpi_resource *res, void *data)
 		hdp->hd_phys_address = fixmem32->address;
 		hdp->hd_address = ioremap(fixmem32->address,
 						HPET_RANGE_SIZE);
+		if (!hdp->hd_address)
+			return AE_ERROR;
 
 		if (hpet_is_known(hdp)) {
 			iounmap(hdp->hd_address);
-- 
2.30.2


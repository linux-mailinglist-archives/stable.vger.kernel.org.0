Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEC5E38E951
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 16:47:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233443AbhEXOsl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 10:48:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:54450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233167AbhEXOsM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 10:48:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D0B561376;
        Mon, 24 May 2021 14:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867600;
        bh=H3RWPZJkjVUorJnG3KIjbbaqmQVKkbapPblliMH5WxE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bIKQeTjTiYGnvfn+mr52qxQUF1fyAARnsb5fi5aVkNCbx25D8x+FA10zeEsTZOl9Z
         MJ/OA63ttZp6EPYTl2il7il0FIqnKZbSf1oRE3NpInIE+bXEORHYF3XpZEfifVQALY
         c1Tk4BSaXZU3I8pypm9HgZ9sVpAaGSKFUxzZd/a3uOSakn4D/rrcfl0qv5ynu43FgG
         PbeZ9P69rvZN5aWok/g5zcV3bQjUAuVZJsmMWtBBGepliBdBXLLVux1ZP9aeB+Uy4F
         PxNqCDR+ZP0UYynb/gvVlsHlVy1BvalvNU2sVP7tPfQ+AeTt0ZUxM+h0UtkFEqtJqF
         obE8fFEEiT/rA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tom Seewald <tseewald@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.12 15/63] char: hpet: add checks after calling ioremap
Date:   Mon, 24 May 2021 10:45:32 -0400
Message-Id: <20210524144620.2497249-15-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524144620.2497249-1-sashal@kernel.org>
References: <20210524144620.2497249-1-sashal@kernel.org>
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
index 6f13def6c172..8b55085650ad 100644
--- a/drivers/char/hpet.c
+++ b/drivers/char/hpet.c
@@ -969,6 +969,8 @@ static acpi_status hpet_resources(struct acpi_resource *res, void *data)
 	if (ACPI_SUCCESS(status)) {
 		hdp->hd_phys_address = addr.address.minimum;
 		hdp->hd_address = ioremap(addr.address.minimum, addr.address.address_length);
+		if (!hdp->hd_address)
+			return AE_ERROR;
 
 		if (hpet_is_known(hdp)) {
 			iounmap(hdp->hd_address);
@@ -982,6 +984,8 @@ static acpi_status hpet_resources(struct acpi_resource *res, void *data)
 		hdp->hd_phys_address = fixmem32->address;
 		hdp->hd_address = ioremap(fixmem32->address,
 						HPET_RANGE_SIZE);
+		if (!hdp->hd_address)
+			return AE_ERROR;
 
 		if (hpet_is_known(hdp)) {
 			iounmap(hdp->hd_address);
-- 
2.30.2


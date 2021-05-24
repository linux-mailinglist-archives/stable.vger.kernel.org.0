Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 572F938EC34
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:12:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233236AbhEXPMr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:12:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:40172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233481AbhEXPGO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:06:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 988356162B;
        Mon, 24 May 2021 14:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867873;
        bh=JB+XAR5JtrB+x/U79H63DAkfAF0TATzHm4+NdNpp6qI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sEBwOpA8eYsCV6Dzt+UOAn8vUJ4/47YV1U9xVij3Wx0zBa1hlLYeZvfuO8QNOd0ri
         NzPccWWWa5vJlMorQlL69mZftNCqZbmVPVKimqNUnRUBQDJ4e1zMZNkJ3bLkrMvl2E
         o7+uq2eYJg7AHAp9L3RHKLPURXX//fds3nKWgSexu9sKJipqlLmaVSgpwGPvdUgwYz
         +CIvoD2hcv7bB3SertskbLMXs6I8e+xvQa6Tjw3XK+UVn5WibecJNJ5VivqA+lOHQq
         9Bx7v9DrLfmFULOxxp9xLUTSTRMW5Xz2+liIzASkEWvQ3yVmMTPBWOyinqq1+1SASs
         IVcBCa3YwUsTQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tom Seewald <tseewald@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 05/19] char: hpet: add checks after calling ioremap
Date:   Mon, 24 May 2021 10:50:52 -0400
Message-Id: <20210524145106.2499571-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524145106.2499571-1-sashal@kernel.org>
References: <20210524145106.2499571-1-sashal@kernel.org>
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
index bedfd2412ec1..7975ddd40b35 100644
--- a/drivers/char/hpet.c
+++ b/drivers/char/hpet.c
@@ -976,6 +976,8 @@ static acpi_status hpet_resources(struct acpi_resource *res, void *data)
 	if (ACPI_SUCCESS(status)) {
 		hdp->hd_phys_address = addr.address.minimum;
 		hdp->hd_address = ioremap(addr.address.minimum, addr.address.address_length);
+		if (!hdp->hd_address)
+			return AE_ERROR;
 
 		if (hpet_is_known(hdp)) {
 			iounmap(hdp->hd_address);
@@ -989,6 +991,8 @@ static acpi_status hpet_resources(struct acpi_resource *res, void *data)
 		hdp->hd_phys_address = fixmem32->address;
 		hdp->hd_address = ioremap(fixmem32->address,
 						HPET_RANGE_SIZE);
+		if (!hdp->hd_address)
+			return AE_ERROR;
 
 		if (hpet_is_known(hdp)) {
 			iounmap(hdp->hd_address);
-- 
2.30.2


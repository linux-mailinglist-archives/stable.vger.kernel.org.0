Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F2A938EC4B
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:12:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233560AbhEXPNo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:13:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:40042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234588AbhEXPIK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:08:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 873856108D;
        Mon, 24 May 2021 14:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867896;
        bh=TZ1fnRSoKJRIWFEITTG6TBwaas4R2PbL9JaB0/IamRE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lyy5gEW0wtmWoa70pu3Pny1KXGiVm5IawBLuhn7W2cDS6P7l0nq6qqP9nWJCddoa4
         PJl+gnQVl6arVdrJOGHrbb8LcsnOIFcxXmlOicrBwxCBKLGpzRfpYAivvunEfTYmpp
         0JfwbzZyuQNG4lpqpYrXHWKwHUYp2Utbixn996BajN+Z6F/kqzCSbxuVU7rMdyuZ/j
         GF3GsaPTWzCrB/TDkNyCgRZloSKi9ct2ewzM33s57is4NAkPnvy3bzZRJ3WJxTQUyI
         P//y7+wck0YNB4s6YVFUcRN6ZPwqE/NSsfm6oMxFzjY6k3+SzAc4atNP9u+hZ+CXoU
         uzbz9KKd4091A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tom Seewald <tseewald@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.4 04/16] char: hpet: add checks after calling ioremap
Date:   Mon, 24 May 2021 10:51:18 -0400
Message-Id: <20210524145130.2499829-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524145130.2499829-1-sashal@kernel.org>
References: <20210524145130.2499829-1-sashal@kernel.org>
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
index 5b38d7a8202a..eb205f9173f4 100644
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


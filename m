Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFDCB38EB1B
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:00:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233783AbhEXPAm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:00:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:34440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234202AbhEXO5E (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 10:57:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5042D6144E;
        Mon, 24 May 2021 14:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867757;
        bh=7DCn1g24tfuBhifxLIxCDG9xA8Au61kv3QYF9m3PP5Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k3jJdEdMZsv6aC45Uypoxh8O+YzdUL2I1ynXptne+bfJLQnfp8EEDuzLYGVlKfBxC
         Q/iyavI0qTkdjI56PtUY+MVjccsaYb5x5lhtCf3ru7pXBHJhWpRb8xJBN0b9in/Mx/
         PfT9D+f4DTbu5AIbCDevEU5+SEZsBPwp245eceiQxc78oSy47wJQuP160pSWumv8+p
         jRXXeSp07R4oJwgDP/RXORPgbvTM7ZYgtNyxUVyve4wlbRt37CTOqRgzz/ptghSo3R
         WhB4xPp9hMVd37bDt1aM2C/tMf8vqY1rKelRNBc7BFqFemtTcBXG8KHxUXRMJ7WubB
         todXdIPsm0aYw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tom Seewald <tseewald@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 12/52] char: hpet: add checks after calling ioremap
Date:   Mon, 24 May 2021 10:48:22 -0400
Message-Id: <20210524144903.2498518-12-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524144903.2498518-1-sashal@kernel.org>
References: <20210524144903.2498518-1-sashal@kernel.org>
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
index 3e31740444f1..d390ab5e51d3 100644
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


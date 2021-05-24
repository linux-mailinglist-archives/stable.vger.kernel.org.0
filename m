Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75DBD38EB85
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:04:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233753AbhEXPDz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:03:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:37264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233601AbhEXPBx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:01:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B967613F8;
        Mon, 24 May 2021 14:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867815;
        bh=y6ROu5eN9pQ2wCzIAShtXihvPD7tlVMrdeD5Oy/jc38=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g5Bnkvr1mb6ozF/k3GEZtgiNpF0EHZY/B1HI6bO6OktsPgTIQiL1NOss1VXSvsVsq
         86Yind1kJFTNZQ5MpyS0i5ydKaSQ4jrh9Zjw/qPR57gf7BEvGHqXyL+j4xoCXtZW5X
         d258zRkQOXz4ZpWno0nRrJMxEWszjL9UzOsSo9ZsaMHpGdZOucpyrAFovKQY/iihFk
         y8z/NHodVfZ2MHQMJV8tlaMu9P1HezmzgGfd5ud/kggfEHXAm63HGDFT1VXXupL7j7
         FaQy9o96SM/gU4eRmqHAxow27vspZV9qQ8iSXkxFnVQ1ejhgu3+n3oR/U16JzdrwGX
         Q8/6i95NSqyJQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tom Seewald <tseewald@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 05/25] char: hpet: add checks after calling ioremap
Date:   Mon, 24 May 2021 10:49:48 -0400
Message-Id: <20210524145008.2499049-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524145008.2499049-1-sashal@kernel.org>
References: <20210524145008.2499049-1-sashal@kernel.org>
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
index c0732f032248..68f02318cee3 100644
--- a/drivers/char/hpet.c
+++ b/drivers/char/hpet.c
@@ -975,6 +975,8 @@ static acpi_status hpet_resources(struct acpi_resource *res, void *data)
 	if (ACPI_SUCCESS(status)) {
 		hdp->hd_phys_address = addr.address.minimum;
 		hdp->hd_address = ioremap(addr.address.minimum, addr.address.address_length);
+		if (!hdp->hd_address)
+			return AE_ERROR;
 
 		if (hpet_is_known(hdp)) {
 			iounmap(hdp->hd_address);
@@ -988,6 +990,8 @@ static acpi_status hpet_resources(struct acpi_resource *res, void *data)
 		hdp->hd_phys_address = fixmem32->address;
 		hdp->hd_address = ioremap(fixmem32->address,
 						HPET_RANGE_SIZE);
+		if (!hdp->hd_address)
+			return AE_ERROR;
 
 		if (hpet_is_known(hdp)) {
 			iounmap(hdp->hd_address);
-- 
2.30.2


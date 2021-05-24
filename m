Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61DF838EA45
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 16:53:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233903AbhEXOxn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 10:53:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:55384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233946AbhEXOvi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 10:51:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2CE5D61403;
        Mon, 24 May 2021 14:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867682;
        bh=H3RWPZJkjVUorJnG3KIjbbaqmQVKkbapPblliMH5WxE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KeJia1MpatadjQYRm0ctLifsudd8thHP06qPvRn5jbYQT/9VeJABnLKISkVqHOAWK
         l6qj5g5IjYVAxo1HBga7Qo/pEzIguauubdlgxKt3o/Z6LwPtqbHuRsXFVZDdiT9X93
         HxD+np7is+U2rEMrMNQ4P/eXSHmj352WY575fOZwFxK4ORaaPtK9TvKXf8dQqIRExM
         2EpgQzfZ9W7T8aya/D9KAXKez8mQwNmAkHXxmF4G66CAsz+sP9vy55zok3LDLWr9Ld
         +j/VI5l9Y+qX8sUmRSSFwYRMAAUIZAar9UEp4o3BsoqXIGewj1y/j15t1xKGUCC470
         mSC9u69PgIqaw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tom Seewald <tseewald@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.10 15/62] char: hpet: add checks after calling ioremap
Date:   Mon, 24 May 2021 10:46:56 -0400
Message-Id: <20210524144744.2497894-15-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524144744.2497894-1-sashal@kernel.org>
References: <20210524144744.2497894-1-sashal@kernel.org>
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


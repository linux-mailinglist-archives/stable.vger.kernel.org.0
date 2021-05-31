Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39C03395C13
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:27:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232278AbhEaN1y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:27:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:33678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232289AbhEaNZw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:25:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BAAC3613FE;
        Mon, 31 May 2021 13:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467265;
        bh=JB+XAR5JtrB+x/U79H63DAkfAF0TATzHm4+NdNpp6qI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GVXnIYOs1d0h3jfG+A7xmofD+paA9yGZe8SUuyUhHPBA1mwbQDUs4P9SgavVmWMxv
         JWtoiWEk4JnVxRbseMgLuNlMdapJMjIlJPWIuDAEFJQXzb8yUJYT0vCjp/8tnEV7fS
         9zG7dC/3CjxIcpQrI0Tso4gcGaoKzCdUrmbUo6n0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Seewald <tseewald@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 42/66] char: hpet: add checks after calling ioremap
Date:   Mon, 31 May 2021 15:14:15 +0200
Message-Id: <20210531130637.587949680@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130636.254683895@linuxfoundation.org>
References: <20210531130636.254683895@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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




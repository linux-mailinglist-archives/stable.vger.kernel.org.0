Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CCA5396038
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:22:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233680AbhEaOXe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:23:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:48846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233852AbhEaOVb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:21:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B4B9D619D2;
        Mon, 31 May 2021 13:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468709;
        bh=7DCn1g24tfuBhifxLIxCDG9xA8Au61kv3QYF9m3PP5Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g36brbs3A2HzeNmSbum0j/vloGXGVyzuz8gLXtyjdWY36oTEHGEpntYYegigQDTxh
         tDPbvOx+S3IA2ScnSxysrFRX0VLWfpAtt3TItEfGwsnneubozLr7HGlwD0MVjyJxPm
         pHyGr1eHWaQepfti3A2xFWH4s6ROab8ab9q5wee8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Seewald <tseewald@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 097/177] char: hpet: add checks after calling ioremap
Date:   Mon, 31 May 2021 15:14:14 +0200
Message-Id: <20210531130651.244857013@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130647.887605866@linuxfoundation.org>
References: <20210531130647.887605866@linuxfoundation.org>
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




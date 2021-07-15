Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D64333CA978
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:09:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242386AbhGOTGy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:06:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:39762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242231AbhGOTFw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:05:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 42921613D1;
        Thu, 15 Jul 2021 19:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375745;
        bh=VCbkn5xnj6I8I39UGSdZSENyID19O7Gl0jTqClZXik8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LDSFJJon4MgI6QLCNNmhatcqnu4ScfGXPf7zRFu9hjAf4j9YxjRKBFnqHiJ8zwfp0
         NW5dRfyy7GatFbPoNMvP2gXdIWLFSaTtXHp7oFZDzqthNhaCnQeD/Da+WHU1Um5NIB
         IMKpiHycamcnmKLecqVQAeGQvp6dUih14uLz08+o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 5.12 219/242] PCI: aardvark: Fix checking for PIO Non-posted Request
Date:   Thu, 15 Jul 2021 20:39:41 +0200
Message-Id: <20210715182631.614351427@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182551.731989182@linuxfoundation.org>
References: <20210715182551.731989182@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

commit 8ceeac307a79f68c0d0c72d6e48b82fa424204ec upstream.

PIO_NON_POSTED_REQ for PIO_STAT register is incorrectly defined. Bit 10 in
register PIO_STAT indicates the response is to a non-posted request.

Link: https://lore.kernel.org/r/20210624213345.3617-2-pali@kernel.org
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Marek Behún <kabel@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pci-aardvark.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -57,7 +57,7 @@
 #define   PIO_COMPLETION_STATUS_UR		1
 #define   PIO_COMPLETION_STATUS_CRS		2
 #define   PIO_COMPLETION_STATUS_CA		4
-#define   PIO_NON_POSTED_REQ			BIT(0)
+#define   PIO_NON_POSTED_REQ			BIT(10)
 #define PIO_ADDR_LS				(PIO_BASE_ADDR + 0x8)
 #define PIO_ADDR_MS				(PIO_BASE_ADDR + 0xc)
 #define PIO_WR_DATA				(PIO_BASE_ADDR + 0x10)



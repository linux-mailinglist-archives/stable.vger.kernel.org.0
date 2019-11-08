Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92021F54F3
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:01:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388742AbfKHS5K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 13:57:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:54990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732877AbfKHS5J (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 13:57:09 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE19A2067B;
        Fri,  8 Nov 2019 18:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239429;
        bh=/Pa8HVoB323cD1W289vFzgL2XMK+OOY6vI6FZEtgRXQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ty6vn4oJCuJ00SkN/NuQhMqotRVXHJPqQSSfUQTy7yzaOy+2aFZRy8KddrDmUZWsk
         LKSCSc2k/trAHGL8qdNd0p6r0INNNv94aCPUuIwLyF3OPwCkeNy7PEqeWAmeq91cCt
         +O/h0NNiD6kFoZYUd/ZzZfvB2STxn+Iqjq6oehbY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Thomas Bogendoerfer <tbogendoerfer@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 10/34] scsi: fix kconfig dependency warning related to 53C700_LE_ON_BE
Date:   Fri,  8 Nov 2019 19:50:17 +0100
Message-Id: <20191108174631.033756496@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174618.266472504@linuxfoundation.org>
References: <20191108174618.266472504@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Bogendoerfer <tbogendoerfer@suse.de>

[ Upstream commit 8cbf0c173aa096dda526d1ccd66fc751c31da346 ]

When building a kernel with SCSI_SNI_53C710 enabled, Kconfig warns:

WARNING: unmet direct dependencies detected for 53C700_LE_ON_BE
  Depends on [n]: SCSI_LOWLEVEL [=y] && SCSI [=y] && SCSI_LASI700 [=n]
  Selected by [y]:
  - SCSI_SNI_53C710 [=y] && SCSI_LOWLEVEL [=y] && SNI_RM [=y] && SCSI [=y]

Add the missing depends SCSI_SNI_53C710 to 53C700_LE_ON_BE to fix it.

Link: https://lore.kernel.org/r/20191009151128.32411-1-tbogendoerfer@suse.de
Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 17b1574920fd6..941e3f25b4a9f 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -986,7 +986,7 @@ config SCSI_SNI_53C710
 
 config 53C700_LE_ON_BE
 	bool
-	depends on SCSI_LASI700
+	depends on SCSI_LASI700 || SCSI_SNI_53C710
 	default y
 
 config SCSI_STEX
-- 
2.20.1




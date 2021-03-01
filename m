Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A7FB328E0F
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:24:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241474AbhCATW7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:22:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:44046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241380AbhCATSJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:18:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B91D465163;
        Mon,  1 Mar 2021 17:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618384;
        bh=Aq2exbCTnBIDhLjBvwMCBNoOBrxAJTOKbnbmOO2YrzM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hZQcP+IvoLtDDpI9djA+iq8JiG/wnQevlyrQYCUf+wGEezr+0ojZsxRUOiy9/uqEe
         bFE5rmiAReO8POkGyIlNzq0u+8Uud8h13H7WCqmm6HehpDFvfguJoNLMT0BTjsiD9O
         8thYMwUpRb9VS0vBsn7t7T8xXfhEfTEcOHTY49F4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Phil Elwell <phil@raspberrypi.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 038/663] staging: vchiq: Fix bulk transfers on 64-bit builds
Date:   Mon,  1 Mar 2021 17:04:46 +0100
Message-Id: <20210301161143.675258456@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Phil Elwell <phil@raspberrypi.com>

[ Upstream commit 88753cc19f087abe0d39644b844e67a59cfb5a3d ]

The recent change to the bulk transfer compat function missed the fact
the relevant ioctl command is VCHIQ_IOC_QUEUE_BULK_TRANSMIT32, not
VCHIQ_IOC_QUEUE_BULK_TRANSMIT, as any attempt to send a bulk block
to the VPU would have shown.

Fixes: a4367cd2b231 ("staging: vchiq: convert compat bulk transfer")
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Phil Elwell <phil@raspberrypi.com>
Link: https://lore.kernel.org/r/20210105162030.1415213-3-phil@raspberrypi.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
index 5bc9b394212b8..3d378da119e7a 100644
--- a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
+++ b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
@@ -1714,7 +1714,7 @@ vchiq_compat_ioctl_queue_bulk(struct file *file,
 {
 	struct vchiq_queue_bulk_transfer32 args32;
 	struct vchiq_queue_bulk_transfer args;
-	enum vchiq_bulk_dir dir = (cmd == VCHIQ_IOC_QUEUE_BULK_TRANSMIT) ?
+	enum vchiq_bulk_dir dir = (cmd == VCHIQ_IOC_QUEUE_BULK_TRANSMIT32) ?
 				  VCHIQ_BULK_TRANSMIT : VCHIQ_BULK_RECEIVE;
 
 	if (copy_from_user(&args32, argp, sizeof(args32)))
-- 
2.27.0




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12CBA1213E5
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:07:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729912AbfLPSF6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:05:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:45116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729908AbfLPSF4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:05:56 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1AB7420700;
        Mon, 16 Dec 2019 18:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519555;
        bh=BxTdZxYgTeuImVRignERyKpM/2Y+32BoVtqv/1Rs3O4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kad4U8kDviYEjHshJAtarBaydBco+aoOuLK7VqrtPw1loOCRnQLwGotH1nslDkdqK
         d9FLvIE/t9z/T+dvvBo61RDCmqDSTNMBK1BQ6L+ZqYW6drzjOuxcLS84jR9C3toyRE
         vl0nG6myDkbQ1TpSiRv6JlZ6DwhRAhoM60wOSETo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefano Stabellini <stefanos@xilinx.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 114/140] pvcalls-front: dont return error when the ring is full
Date:   Mon, 16 Dec 2019 18:49:42 +0100
Message-Id: <20191216174818.648692226@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174747.111154704@linuxfoundation.org>
References: <20191216174747.111154704@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefano Stabellini <sstabellini@kernel.org>

[ Upstream commit d90a1ca60a1eccb4383fe203c76223ab4c0799ed ]

When the ring is full, size == array_size. It is not an error condition,
so simply return 0 instead of an error.

Signed-off-by: Stefano Stabellini <stefanos@xilinx.com>
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/pvcalls-front.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/xen/pvcalls-front.c b/drivers/xen/pvcalls-front.c
index 3a144eecb6a72..d7438fdc57061 100644
--- a/drivers/xen/pvcalls-front.c
+++ b/drivers/xen/pvcalls-front.c
@@ -504,8 +504,10 @@ static int __write_ring(struct pvcalls_data_intf *intf,
 	virt_mb();
 
 	size = pvcalls_queued(prod, cons, array_size);
-	if (size >= array_size)
+	if (size > array_size)
 		return -EINVAL;
+	if (size == array_size)
+		return 0;
 	if (len > array_size - size)
 		len = array_size - size;
 
-- 
2.20.1




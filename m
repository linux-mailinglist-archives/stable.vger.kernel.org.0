Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28A13147C0C
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:49:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731809AbgAXJse (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:48:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:48652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730051AbgAXJsd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:48:33 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 50F6420718;
        Fri, 24 Jan 2020 09:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579859312;
        bh=Ir1VPgQ2SWl+B/H40Bpod4gcCNONKz82Gh2fHS0+pWY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m9js7agN2gFh8njrPyT8xJJvYDzg0JrFrX+l0ia+AKYRxvYP+lAlvDtdKrKDMTkfx
         sDkZT+09reEKk9tKvLwo0ZbSTMhwNqAoeCUkHjhC9jdGEZTq3ITVGBL/FObjBkoZIX
         GYyz69TYjvvbqSQ/X4r14R8Bm2pJ3wh+kXwAlDlM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 077/343] tty: ipwireless: Fix potential NULL pointer dereference
Date:   Fri, 24 Jan 2020 10:28:15 +0100
Message-Id: <20200124092930.008635973@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092919.490687572@linuxfoundation.org>
References: <20200124092919.490687572@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 7dd50e205b3348dc7784efbdf85723551de64a25 ]

There is a potential NULL pointer dereference in case
alloc_ctrl_packet() fails and returns NULL.

Fixes: 099dc4fb6265 ("ipwireless: driver for PC Card 3G/UMTS modem")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/ipwireless/hardware.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/tty/ipwireless/hardware.c b/drivers/tty/ipwireless/hardware.c
index a6b8240af6cdd..960e9375a1a9e 100644
--- a/drivers/tty/ipwireless/hardware.c
+++ b/drivers/tty/ipwireless/hardware.c
@@ -1516,6 +1516,8 @@ static void ipw_send_setup_packet(struct ipw_hardware *hw)
 			sizeof(struct ipw_setup_get_version_query_packet),
 			ADDR_SETUP_PROT, TL_PROTOCOLID_SETUP,
 			TL_SETUP_SIGNO_GET_VERSION_QRY);
+	if (!ver_packet)
+		return;
 	ver_packet->header.length = sizeof(struct tl_setup_get_version_qry);
 
 	/*
-- 
2.20.1




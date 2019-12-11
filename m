Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FBF711B01A
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:20:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731598AbfLKPTd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:19:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:48354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731997AbfLKPTc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:19:32 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F0A22073D;
        Wed, 11 Dec 2019 15:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077571;
        bh=y+sKo0ij6T4SNJiMfirmc/ontVwcDmNeYP5GlOnHn68=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OkwORLO87coZ31YMoY5czUJ5hH9/mhfZGP2DmfTqW4uav/1L9INiWGNrn+UrKlXuC
         unWpVtc8VXXpfMV5T602YasBaXb55YsJo9R0Zb/L07sFJzu/1FLdad9Dm6ix69L0uG
         GzzPqmeggG8xF3LOdi1h1JzE/8dZY8UpoDJzkxdI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 089/243] media: cec: report Vendor ID after initialization
Date:   Wed, 11 Dec 2019 16:04:11 +0100
Message-Id: <20191211150345.118157738@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

[ Upstream commit 7f02ac77c768ba2bcdd0ce719c1fca0870ffe2fb ]

The CEC specification requires that the Vendor ID (if any) is reported
after a logical address was claimed.

This was never done, so add support for this.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/cec/cec-adap.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/media/cec/cec-adap.c b/drivers/media/cec/cec-adap.c
index 4a15d53f659ec..dd6f3e6ce0062 100644
--- a/drivers/media/cec/cec-adap.c
+++ b/drivers/media/cec/cec-adap.c
@@ -1437,6 +1437,13 @@ configured:
 			las->log_addr[i],
 			cec_phys_addr_exp(adap->phys_addr));
 		cec_transmit_msg_fh(adap, &msg, NULL, false);
+
+		/* Report Vendor ID */
+		if (adap->log_addrs.vendor_id != CEC_VENDOR_ID_NONE) {
+			cec_msg_device_vendor_id(&msg,
+						 adap->log_addrs.vendor_id);
+			cec_transmit_msg_fh(adap, &msg, NULL, false);
+		}
 	}
 	adap->kthread_config = NULL;
 	complete(&adap->config_completion);
-- 
2.20.1




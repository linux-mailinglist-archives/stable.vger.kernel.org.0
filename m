Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EC4B11B559
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:53:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732224AbfLKPTa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:19:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:48292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732069AbfLKPT3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:19:29 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC59E22527;
        Wed, 11 Dec 2019 15:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077569;
        bh=DblNtOlOXMic2UX+YtMOAQCLq+20Yq5B7SO904kLcQg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ohAz7YmqGd5+uRKfKw/hMla3SWbxX2R9CZWHLzHSlpxX9WMookvS6QKDf17jd+Lbf
         w/pHR+T8EhLOPTD4ZYm6RTRJYnh0GF1WQ6tsAbCbPClKG0bfiC985GfStNq2vdIgCU
         mtOgs0+ilHRzHRgNnpPYhdY3UeOVNdR+kWXoRcXI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        Torbjorn Jansson <torbjorn.jansson@mbox200.swipnet.se>,
        Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 088/243] media: pulse8-cec: return 0 when invalidating the logical address
Date:   Wed, 11 Dec 2019 16:04:10 +0100
Message-Id: <20191211150345.052181393@linuxfoundation.org>
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

From: Hans Verkuil <hverkuil@xs4all.nl>

[ Upstream commit 2e84eb9affac43eeaf834992888b72426a8cd442 ]

Return 0 when invalidating the logical address. The cec core produces
a warning for drivers that do this.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reported-by: Torbjorn Jansson <torbjorn.jansson@mbox200.swipnet.se>
Signed-off-by: Hans Verkuil <hansverk@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/pulse8-cec/pulse8-cec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/pulse8-cec/pulse8-cec.c b/drivers/media/usb/pulse8-cec/pulse8-cec.c
index 350635826aaed..6e3bdd71e273b 100644
--- a/drivers/media/usb/pulse8-cec/pulse8-cec.c
+++ b/drivers/media/usb/pulse8-cec/pulse8-cec.c
@@ -585,7 +585,7 @@ unlock:
 	else
 		pulse8->config_pending = true;
 	mutex_unlock(&pulse8->config_lock);
-	return err;
+	return log_addr == CEC_LOG_ADDR_INVALID ? 0 : err;
 }
 
 static int pulse8_cec_adap_transmit(struct cec_adapter *adap, u8 attempts,
-- 
2.20.1




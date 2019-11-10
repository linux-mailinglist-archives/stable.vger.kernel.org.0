Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1823BF642D
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 03:58:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729655AbfKJC5o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 21:57:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:47266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729400AbfKJC4s (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:56:48 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5425621D82;
        Sun, 10 Nov 2019 02:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573354042;
        bh=FTJPCXRcxDMOJSToYEtqeq6c2U9ZZgf1fojkXraSZa8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tYyDDN4Gkq7VhvlbKkoFee632hy7LO4/lsthpccbMIaw1eNdplslwnpcSWCEGySx2
         nh/VJOduTv7yTNfKxml5KEHuyw0y1AnC50akeJcxGbZNaVwUugzJaAqgcoqgDCryVk
         jaJo4h2z8qCPPrAGK/zOoGXmfAD0ngzX7mDJ+P+8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 054/109] usb: gadget: uvc: configfs: Drop leaked references to config items
Date:   Sat,  9 Nov 2019 21:44:46 -0500
Message-Id: <20191110024541.31567-54-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024541.31567-1-sashal@kernel.org>
References: <20191110024541.31567-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

[ Upstream commit 86f3daed59bceb4fa7981d85e89f63ebbae1d561 ]

Some of the .allow_link() and .drop_link() operations implementations
call config_group_find_item() and then leak the reference to the
returned item. Fix this by dropping those references where needed.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Kieran Bingham <kieran.bingham@ideasonboard.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/uvc_configfs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/gadget/function/uvc_configfs.c b/drivers/usb/gadget/function/uvc_configfs.c
index 844cb738bafd0..fc604439b25a1 100644
--- a/drivers/usb/gadget/function/uvc_configfs.c
+++ b/drivers/usb/gadget/function/uvc_configfs.c
@@ -543,6 +543,7 @@ static int uvcg_control_class_allow_link(struct config_item *src,
 unlock:
 	mutex_unlock(&opts->lock);
 out:
+	config_item_put(header);
 	mutex_unlock(su_mutex);
 	return ret;
 }
@@ -578,6 +579,7 @@ static void uvcg_control_class_drop_link(struct config_item *src,
 unlock:
 	mutex_unlock(&opts->lock);
 out:
+	config_item_put(header);
 	mutex_unlock(su_mutex);
 }
 
@@ -2037,6 +2039,7 @@ static int uvcg_streaming_class_allow_link(struct config_item *src,
 unlock:
 	mutex_unlock(&opts->lock);
 out:
+	config_item_put(header);
 	mutex_unlock(su_mutex);
 	return ret;
 }
@@ -2077,6 +2080,7 @@ static void uvcg_streaming_class_drop_link(struct config_item *src,
 unlock:
 	mutex_unlock(&opts->lock);
 out:
+	config_item_put(header);
 	mutex_unlock(su_mutex);
 }
 
-- 
2.20.1


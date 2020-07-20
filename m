Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57E8222719A
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 23:45:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728601AbgGTVoN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 17:44:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:56560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727906AbgGTViK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 17:38:10 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C92A22CF8;
        Mon, 20 Jul 2020 21:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595281090;
        bh=K/QnzBnxSz8nRtmvwhBj2GIp+N4PtdWh0qolEym6wG4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zUCoVSwu+8TeAppB80QXIm01ceQvLrLO8zSlemGDovOrCPwR5wVYcEfHtHptUu2E8
         jyihYNj7pYUXKsLuhT/OEXau6N8rGhJ0hk2E6yqEKZsWs7jxmBtOfVce/jDqMKAcPZ
         Q1R2PO/jwKt0EhyF5AYE4cWTdwEPJSt2jmk5a4v4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Caiyuan Xie <caiyuan.xie@cn.alps.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 02/34] HID: alps: support devices with report id 2
Date:   Mon, 20 Jul 2020 17:37:35 -0400
Message-Id: <20200720213807.407380-2-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200720213807.407380-1-sashal@kernel.org>
References: <20200720213807.407380-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Caiyuan Xie <caiyuan.xie@cn.alps.com>

[ Upstream commit aa3c439c144f0a465ed1f28f11c772886fb02b35 ]

Add support for devices which that have reports with id == 2

Signed-off-by: Caiyuan Xie <caiyuan.xie@cn.alps.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-alps.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/hid/hid-alps.c b/drivers/hid/hid-alps.c
index b2ad319a74b9a..d33f5abc8f64d 100644
--- a/drivers/hid/hid-alps.c
+++ b/drivers/hid/hid-alps.c
@@ -25,6 +25,7 @@
 
 #define U1_MOUSE_REPORT_ID			0x01 /* Mouse data ReportID */
 #define U1_ABSOLUTE_REPORT_ID		0x03 /* Absolute data ReportID */
+#define U1_ABSOLUTE_REPORT_ID_SECD  0x02 /* FW-PTP Absolute data ReportID */
 #define U1_FEATURE_REPORT_ID		0x05 /* Feature ReportID */
 #define U1_SP_ABSOLUTE_REPORT_ID	0x06 /* Feature ReportID */
 
@@ -368,6 +369,7 @@ static int u1_raw_event(struct alps_dev *hdata, u8 *data, int size)
 	case U1_FEATURE_REPORT_ID:
 		break;
 	case U1_ABSOLUTE_REPORT_ID:
+	case U1_ABSOLUTE_REPORT_ID_SECD:
 		for (i = 0; i < hdata->max_fingers; i++) {
 			u8 *contact = &data[i * 5];
 
-- 
2.25.1


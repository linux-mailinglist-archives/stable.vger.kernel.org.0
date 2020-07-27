Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCCCE22F23A
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:38:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729882AbgG0OKl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:10:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:33742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729898AbgG0OKk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:10:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9FA4E2083E;
        Mon, 27 Jul 2020 14:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859040;
        bh=66bg3+WNh4NSxqZznyJHZ6nazNhXZHVobYkVRGnUTSc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o8diH8EqYlYHtLYNbQlExKidF/wAdgASPcLHNWgU0PdK5muJYEQn31smoiZAEI639
         iSB509oQfCxG7FRjtB1sPpsHLk6O4wQVrKvOHz5l9cUTy6c2fRNOL/HsjD5V9VN1Xe
         1zNJWEQz8OynMGMmlAsCGT+smzHPzSdTFEwehJl8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Caiyuan Xie <caiyuan.xie@cn.alps.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 44/86] HID: alps: support devices with report id 2
Date:   Mon, 27 Jul 2020 16:04:18 +0200
Message-Id: <20200727134916.637405862@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134914.312934924@linuxfoundation.org>
References: <20200727134914.312934924@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 3489f0af7409c..f4cf541d13e08 100644
--- a/drivers/hid/hid-alps.c
+++ b/drivers/hid/hid-alps.c
@@ -29,6 +29,7 @@
 
 #define U1_MOUSE_REPORT_ID			0x01 /* Mouse data ReportID */
 #define U1_ABSOLUTE_REPORT_ID		0x03 /* Absolute data ReportID */
+#define U1_ABSOLUTE_REPORT_ID_SECD  0x02 /* FW-PTP Absolute data ReportID */
 #define U1_FEATURE_REPORT_ID		0x05 /* Feature ReportID */
 #define U1_SP_ABSOLUTE_REPORT_ID	0x06 /* Feature ReportID */
 
@@ -372,6 +373,7 @@ static int u1_raw_event(struct alps_dev *hdata, u8 *data, int size)
 	case U1_FEATURE_REPORT_ID:
 		break;
 	case U1_ABSOLUTE_REPORT_ID:
+	case U1_ABSOLUTE_REPORT_ID_SECD:
 		for (i = 0; i < hdata->max_fingers; i++) {
 			u8 *contact = &data[i * 5];
 
-- 
2.25.1




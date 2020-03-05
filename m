Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB37117ABF9
	for <lists+stable@lfdr.de>; Thu,  5 Mar 2020 18:19:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727577AbgCERRJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Mar 2020 12:17:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:43052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728362AbgCERQF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Mar 2020 12:16:05 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0478221556;
        Thu,  5 Mar 2020 17:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583428564;
        bh=J85lqaQD9OGYndtDzxv2WWgBhOaomQ24YPQtU2M8UXw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TgJ6VrrfKw2cfDSzu5pKI7GDGHDneg6sHPL7CDPVs68e8pEyRCdW0Ac08xR3kPN7E
         4xdAJ6LCvwMw+suWCmOxClP1TKWQLVX18miVW+C+SOmoZpizWwVol3CI9+ru9oeRiE
         GkC2AJTySY0ypjocwhiIWHbS7K902mTWQZavTcgk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johan Korsnes <jkorsnes@cisco.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Armando Visconti <armando.visconti@st.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 04/12] HID: core: increase HID report buffer size to 8KiB
Date:   Thu,  5 Mar 2020 12:15:51 -0500
Message-Id: <20200305171559.30422-4-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200305171559.30422-1-sashal@kernel.org>
References: <20200305171559.30422-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Korsnes <jkorsnes@cisco.com>

[ Upstream commit 84a4062632462c4320704fcdf8e99e89e94c0aba ]

We have a HID touch device that reports its opens and shorts test
results in HID buffers of size 8184 bytes. The maximum size of the HID
buffer is currently set to 4096 bytes, causing probe of this device to
fail. With this patch we increase the maximum size of the HID buffer to
8192 bytes, making device probe and acquisition of said buffers succeed.

Signed-off-by: Johan Korsnes <jkorsnes@cisco.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Armando Visconti <armando.visconti@st.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/hid.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/hid.h b/include/linux/hid.h
index 04bdf5477ec51..eda06f7ee84af 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -453,7 +453,7 @@ struct hid_report_enum {
 };
 
 #define HID_MIN_BUFFER_SIZE	64		/* make sure there is at least a packet size of space */
-#define HID_MAX_BUFFER_SIZE	4096		/* 4kb */
+#define HID_MAX_BUFFER_SIZE	8192		/* 8kb */
 #define HID_CONTROL_FIFO_SIZE	256		/* to init devices with >100 reports */
 #define HID_OUTPUT_FIFO_SIZE	64
 
-- 
2.20.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69B1C17AD14
	for <lists+stable@lfdr.de>; Thu,  5 Mar 2020 18:24:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726269AbgCERNR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Mar 2020 12:13:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:38598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726048AbgCERNQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Mar 2020 12:13:16 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 42F1120870;
        Thu,  5 Mar 2020 17:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583428395;
        bh=lPR4tM2lxTRYCqhAC1uOU15vHUXtv4mO9yS8yOPjzbI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oG8jCEU3Dm3x3V/h7/70/OMEUx01kX3+Yvz8Ex942DTiqLfhJtx+16QO5kHYnOF5i
         l4xXDPKGWhVszGH1tnVItN256sOW1sAkvRldh5JuoIGYlnAEeflNwrZi2826p2fvln
         6MWIZuuHIWCY/rymzAiqc/d2mOd8TWgfgyRmM+Zk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johan Korsnes <jkorsnes@cisco.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Armando Visconti <armando.visconti@st.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 04/67] HID: core: increase HID report buffer size to 8KiB
Date:   Thu,  5 Mar 2020 12:12:05 -0500
Message-Id: <20200305171309.29118-4-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200305171309.29118-1-sashal@kernel.org>
References: <20200305171309.29118-1-sashal@kernel.org>
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
index cd41f209043f6..875f71132b142 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -492,7 +492,7 @@ struct hid_report_enum {
 };
 
 #define HID_MIN_BUFFER_SIZE	64		/* make sure there is at least a packet size of space */
-#define HID_MAX_BUFFER_SIZE	4096		/* 4kb */
+#define HID_MAX_BUFFER_SIZE	8192		/* 8kb */
 #define HID_CONTROL_FIFO_SIZE	256		/* to init devices with >100 reports */
 #define HID_OUTPUT_FIFO_SIZE	64
 
-- 
2.20.1


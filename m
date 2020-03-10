Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C3D417FC5E
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:20:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730264AbgCJNHJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:07:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:52774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730914AbgCJNHI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:07:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B25220873;
        Tue, 10 Mar 2020 13:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845626;
        bh=m7Jrelza+8EYqkODYBgcHkbKKrnlY5Kmoixt9gZZAXQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uA5eSpCYj7g6AxhMQmNcKnwxA1zWiLHchl6krALi/fglBrFuIbK6UD4/vfSu6GvSG
         cO/gztbVHFB82AFBdONlBT3VrWTFX9Umaq1xkEBpMgcJGeCJLglGDeeu2yEm31cqvR
         xnzZbvjYSfDx53WhqtkASEVl70V4Qk14ExVBX4no=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Korsnes <jkorsnes@cisco.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Armando Visconti <armando.visconti@st.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 4.14 041/126] HID: core: increase HID report buffer size to 8KiB
Date:   Tue, 10 Mar 2020 13:41:02 +0100
Message-Id: <20200310124206.965633061@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310124203.704193207@linuxfoundation.org>
References: <20200310124203.704193207@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Korsnes <jkorsnes@cisco.com>

commit 84a4062632462c4320704fcdf8e99e89e94c0aba upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/hid.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -477,7 +477,7 @@ struct hid_report_enum {
 };
 
 #define HID_MIN_BUFFER_SIZE	64		/* make sure there is at least a packet size of space */
-#define HID_MAX_BUFFER_SIZE	4096		/* 4kb */
+#define HID_MAX_BUFFER_SIZE	8192		/* 8kb */
 #define HID_CONTROL_FIFO_SIZE	256		/* to init devices with >100 reports */
 #define HID_OUTPUT_FIFO_SIZE	64
 



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9559320660B
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:51:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388471AbgFWVgm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 17:36:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:50742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388736AbgFWUJg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:09:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 34E5C206C3;
        Tue, 23 Jun 2020 20:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592942975;
        bh=FHSj8TZnsz1D0Yt76ksismIfOCjetZenOZ7Njffc0GY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pFLwTmCWEx15iwZdlMn7gMTDpydBwRLy6hBrkYyvCrlvvx3R5Q+Dhrl7qFP1tC24N
         nmOYxnrAyqSPHaq7+vozj9ZxU054lGB7mgy7nCw2kOLDj19irz61quEF/r+YrTo+m1
         VkugAZNYVI0EArVw6+2idVIxIre+t1lNPX5fnJW0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Omer Shpigelman <oshpigelman@habana.ai>,
        Oded Gabbay <oded.gabbay@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 210/477] habanalabs: increase timeout during reset
Date:   Tue, 23 Jun 2020 21:53:27 +0200
Message-Id: <20200623195417.506979844@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oded Gabbay <oded.gabbay@gmail.com>

[ Upstream commit 7a65ee046b2238e053f6ebb610e1a082cfc49490 ]

When doing training, the DL framework (e.g. tensorflow) performs hundreds
of thousands of memory allocations and mappings. In case the driver needs
to perform hard-reset during training, the driver kills the application and
unmaps all those memory allocations. Unfortunately, because of that large
amount of mappings, the driver isn't able to do that in the current timeout
(5 seconds). Therefore, increase the timeout significantly to 30 seconds
to avoid situation where the driver resets the device with active mappings,
which sometime can cause a kernel bug.

BTW, it doesn't mean we will spend all the 30 seconds because the reset
thread checks every one second if the unmap operation is done.

Reviewed-by: Omer Shpigelman <oshpigelman@habana.ai>
Signed-off-by: Oded Gabbay <oded.gabbay@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/habanalabs/habanalabs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/habanalabs/habanalabs.h b/drivers/misc/habanalabs/habanalabs.h
index 31ebcf9458fe1..a6dd8e6ca594c 100644
--- a/drivers/misc/habanalabs/habanalabs.h
+++ b/drivers/misc/habanalabs/habanalabs.h
@@ -23,7 +23,7 @@
 
 #define HL_MMAP_CB_MASK			(0x8000000000000000ull >> PAGE_SHIFT)
 
-#define HL_PENDING_RESET_PER_SEC	5
+#define HL_PENDING_RESET_PER_SEC	30
 
 #define HL_DEVICE_TIMEOUT_USEC		1000000 /* 1 s */
 
-- 
2.25.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 603A3FA296
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:05:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730850AbfKMCBt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 21:01:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:57998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730880AbfKMCBt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 21:01:49 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5394A206B6;
        Wed, 13 Nov 2019 02:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610509;
        bh=NCLa/CmFT/n4HyVaQnIGfgA6wAxspxSXxhBEMczoqUQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yD4Po7pjTtYRTNrYs04sBpoKDFf8OUgjFPDcWLOIdEeXcJ8I1wWlT1m1qFTVTOS3n
         BJ2kPotdjn7wgxIlcbxUM6lgYj5fwhFVWYy8SZX7hnX6QRxFnwXKeX4yuvGcEmVQ9U
         50NoPH7zX3GQJSjwUO/QeEydY70DbNIU8iWHTL7g=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-doc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 11/48] mei: samples: fix a signedness bug in amt_host_if_call()
Date:   Tue, 12 Nov 2019 21:00:54 -0500
Message-Id: <20191113020131.13356-11-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113020131.13356-1-sashal@kernel.org>
References: <20191113020131.13356-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 185647813cac080453cb73a2e034a8821049f2a7 ]

"out_buf_sz" needs to be signed for the error handling to work.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/misc-devices/mei/mei-amt-version.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/misc-devices/mei/mei-amt-version.c b/Documentation/misc-devices/mei/mei-amt-version.c
index 57d0d871dcf71..33e67bd1dc343 100644
--- a/Documentation/misc-devices/mei/mei-amt-version.c
+++ b/Documentation/misc-devices/mei/mei-amt-version.c
@@ -370,7 +370,7 @@ static uint32_t amt_host_if_call(struct amt_host_if *acmd,
 			unsigned int expected_sz)
 {
 	uint32_t in_buf_sz;
-	uint32_t out_buf_sz;
+	ssize_t out_buf_sz;
 	ssize_t written;
 	uint32_t status;
 	struct amt_host_if_resp_header *msg_hdr;
-- 
2.20.1


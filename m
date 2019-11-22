Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27318106C8F
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 11:53:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727887AbfKVKxT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:53:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:37654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729794AbfKVKxT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:53:19 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 215AD20656;
        Fri, 22 Nov 2019 10:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574419997;
        bh=/ocGoJgUZnU/MR4jKC+MPYAL4fHXHIMop3CtzsQDJYY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H9T8XcSTEEi3hnzBcMNVOsnx2D0bpokzGbC8quPikNRjXxP/nqKefGv/wg84x9U3d
         cxLktvQ9vqCVlVz62smJLFP3wCy1rFzxoiY1hC9Z2lIrCUtHLRGSrUfud37vRgYld8
         w741kqmnq18etXJLZ9Gh91p/3PeV/PNVdr+t2Kr0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 036/122] mei: samples: fix a signedness bug in amt_host_if_call()
Date:   Fri, 22 Nov 2019 11:28:09 +0100
Message-Id: <20191122100751.460721675@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100722.177052205@linuxfoundation.org>
References: <20191122100722.177052205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
 samples/mei/mei-amt-version.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/samples/mei/mei-amt-version.c b/samples/mei/mei-amt-version.c
index bb9988914a563..32234481ad7db 100644
--- a/samples/mei/mei-amt-version.c
+++ b/samples/mei/mei-amt-version.c
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




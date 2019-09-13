Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCD8BB1FDC
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:47:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388529AbfIMNJc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:09:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:34106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388524AbfIMNJa (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:09:30 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DBAA720CC7;
        Fri, 13 Sep 2019 13:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380169;
        bh=p2OG/25OntIVnTzVIz2+SUyWxOBIql0bEaDlV5Vj7Nc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PN7aJngVSBVqykgBBLB7nzSkkOBrfdxf/ALhUEuo6tDPXaIZPUzka4ytnI0Wv6CHl
         FJhiw4h22XJRA09CcEo2yHsh029bOQtvmh4Sow4A9K3lQ0icVcbsDb8X6tVCrFnHgm
         j9DZz0odvb/Pe8L7GUuAflysL4qZoVeYs+CTM6vE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Thomas Hellstrom <thellstrom@vmware.com>
Subject: [PATCH 4.9 04/14] drm/vmwgfx: Fix double free in vmw_recv_msg()
Date:   Fri, 13 Sep 2019 14:06:57 +0100
Message-Id: <20190913130443.808362056@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130440.264749443@linuxfoundation.org>
References: <20190913130440.264749443@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 08b0c891605acf727e43e3e03a25857d3e789b61 upstream.

We recently added a kfree() after the end of the loop:

	if (retries == RETRIES) {
		kfree(reply);
		return -EINVAL;
	}

There are two problems.  First the test is wrong and because retries
equals RETRIES if we succeed on the last iteration through the loop.
Second if we fail on the last iteration through the loop then the kfree
is a double free.

When you're reading this code, please note the break statement at the
end of the while loop.  This patch changes the loop so that if it's not
successful then "reply" is NULL and we can test for that afterward.

Cc: <stable@vger.kernel.org>
Fixes: 6b7c3b86f0b6 ("drm/vmwgfx: fix memory leak when too many retries have occurred")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Thomas Hellstrom <thellstrom@vmware.com>
Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/vmwgfx/vmwgfx_msg.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/vmwgfx/vmwgfx_msg.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_msg.c
@@ -264,7 +264,7 @@ static int vmw_recv_msg(struct rpc_chann
 
 		if ((HIGH_WORD(ebx) & MESSAGE_STATUS_SUCCESS) == 0) {
 			kfree(reply);
-
+			reply = NULL;
 			if ((HIGH_WORD(ebx) & MESSAGE_STATUS_CPT) != 0) {
 				/* A checkpoint occurred. Retry. */
 				continue;
@@ -288,7 +288,7 @@ static int vmw_recv_msg(struct rpc_chann
 
 		if ((HIGH_WORD(ecx) & MESSAGE_STATUS_SUCCESS) == 0) {
 			kfree(reply);
-
+			reply = NULL;
 			if ((HIGH_WORD(ecx) & MESSAGE_STATUS_CPT) != 0) {
 				/* A checkpoint occurred. Retry. */
 				continue;
@@ -300,10 +300,8 @@ static int vmw_recv_msg(struct rpc_chann
 		break;
 	}
 
-	if (retries == RETRIES) {
-		kfree(reply);
+	if (!reply)
 		return -EINVAL;
-	}
 
 	*msg_len = reply_len;
 	*msg     = reply;



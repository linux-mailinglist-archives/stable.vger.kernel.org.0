Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6563AB1E81
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388825AbfIMNKv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:10:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:35648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388817AbfIMNKr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:10:47 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64902206BB;
        Fri, 13 Sep 2019 13:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380247;
        bh=p2OG/25OntIVnTzVIz2+SUyWxOBIql0bEaDlV5Vj7Nc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yb3ti1xl1QQtrFStmVEwBZiK/07T43LeaiufwktavLA0ALXXMclbCV7D+mwbBb0ba
         NluT1Nx44EXDdfoj1NmaQfUusqxJlBM52t/r/Bcs52fo8rXLyu6tu3Y86HPcwZVQnZ
         jYZlfb6GX3eln6TP+HkApa8188elLkbHXKp0XCjk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Thomas Hellstrom <thellstrom@vmware.com>
Subject: [PATCH 4.14 05/21] drm/vmwgfx: Fix double free in vmw_recv_msg()
Date:   Fri, 13 Sep 2019 14:06:58 +0100
Message-Id: <20190913130503.441739156@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130501.285837292@linuxfoundation.org>
References: <20190913130501.285837292@linuxfoundation.org>
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



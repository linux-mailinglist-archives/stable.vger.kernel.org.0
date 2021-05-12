Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F1AA37C917
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:45:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238041AbhELQO7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:14:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:33530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239471AbhELQIH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:08:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ABB3E61C5D;
        Wed, 12 May 2021 15:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833905;
        bh=5FuBqSD19wnWL9dtOWbJXlNsmSn2q4qJMKNNnd+cPj0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ovfUmRBcof8wU6P8OpDz4zjJ5ApzWd5VrcKxiPf6Vjz5nZrqiovO7q5Yv9nbkvcWw
         i1Wkm+rIL/mR4QmzwX0dq+Q0fQZbdUk8mET+Jnb6+oIAzIRVouqYjw/FSR+lTWoOuv
         iL3wz6FMxGBHMG6Rnf6oTDwIQONkpGo+hhofJA8A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Andrea Parri <parri.andrea@gmail.com>,
        Wei Liu <wei.liu@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 291/601] Drivers: hv: vmbus: Use after free in __vmbus_open()
Date:   Wed, 12 May 2021 16:46:08 +0200
Message-Id: <20210512144837.386158716@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 3e9bf43f7f7a46f21ec071cb47be92d0874c48da ]

The "open_info" variable is added to the &vmbus_connection.chn_msg_list,
but the error handling frees "open_info" without removing it from the
list.  This will result in a use after free.  First remove it from the
list, and then free it.

Fixes: 6f3d791f3006 ("Drivers: hv: vmbus: Fix rescind handling issues")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Andrea Parri <parri.andrea@gmail.com>
Link: https://lore.kernel.org/r/YHV3XLCot6xBS44r@mwanda
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/channel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
index 6fb0c76bfbf8..a59ab2f3d68e 100644
--- a/drivers/hv/channel.c
+++ b/drivers/hv/channel.c
@@ -653,7 +653,7 @@ static int __vmbus_open(struct vmbus_channel *newchannel,
 
 	if (newchannel->rescind) {
 		err = -ENODEV;
-		goto error_free_info;
+		goto error_clean_msglist;
 	}
 
 	err = vmbus_post_msg(open_msg,
-- 
2.30.2




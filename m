Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9A0E34C98E
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:33:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233989AbhC2IaN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:30:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:47284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234627AbhC2I2u (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:28:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 70B1161582;
        Mon, 29 Mar 2021 08:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006530;
        bh=aHHX94pO+/nv5v+FslfTPdu/pYAxmkK4mU+H8BMjvnQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EB8VkCYKVeV+g7Z1mSvMpqfAQB20Xy8bB7R8W2ZbUt5rfuPmTjh1p9KX59/3s8I4t
         +oiNZkaG7zCI+EeNRB22ht83kLfWa+eBX1yqPBSwueXgkPMOd9YVY5heyNmhP+WbI2
         W2DuLznvGPNL9FQkEW86ggYF+e7zlNStnCr85PD0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tomer Tayar <ttayar@habana.ai>,
        Oded Gabbay <ogabbay@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 035/254] habanalabs: Call put_pid() when releasing control device
Date:   Mon, 29 Mar 2021 09:55:51 +0200
Message-Id: <20210329075634.303375780@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tomer Tayar <ttayar@habana.ai>

[ Upstream commit 27ac5aada024e0821c86540ad18f37edadd77d5e ]

The refcount of the "hl_fpriv" structure is not used for the control
device, and thus hl_hpriv_put() is not called when releasing this
device.
This results with no call to put_pid(), so add it explicitly in
hl_device_release_ctrl().

Signed-off-by: Tomer Tayar <ttayar@habana.ai>
Reviewed-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/habanalabs/common/device.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/misc/habanalabs/common/device.c b/drivers/misc/habanalabs/common/device.c
index 69d04eca767f..6785329eee27 100644
--- a/drivers/misc/habanalabs/common/device.c
+++ b/drivers/misc/habanalabs/common/device.c
@@ -117,6 +117,8 @@ static int hl_device_release_ctrl(struct inode *inode, struct file *filp)
 	list_del(&hpriv->dev_node);
 	mutex_unlock(&hdev->fpriv_list_lock);
 
+	put_pid(hpriv->taskpid);
+
 	kfree(hpriv);
 
 	return 0;
-- 
2.30.1




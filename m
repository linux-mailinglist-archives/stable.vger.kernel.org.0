Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4422C2E4019
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:48:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502711AbgL1OWn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:22:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:58350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502710AbgL1OWm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:22:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 05FC920791;
        Mon, 28 Dec 2020 14:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165322;
        bh=W2UfboFIBBwVqsbsKmolmBBBDU6+SkyFSE/U0tqttb0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ghEiBcV/WGCriMEiVvGLi0E+8nN198cK+De4coqaCPfnLjmGsnciE6/d4zrUBgjMl
         XKCFYlPzPCUO8Rkz/tgWgEC7ndGtHWORmVxm8vDTBD74eCGklnbMEnyP27UwSnrrT1
         JssY9f+avlI0cyMvtNyGFm4VvLnyrGpnYJnUWRAI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 492/717] vhost scsi: fix error return code in vhost_scsi_set_endpoint()
Date:   Mon, 28 Dec 2020 13:48:10 +0100
Message-Id: <20201228125044.537408192@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Changzhong <zhangchangzhong@huawei.com>

[ Upstream commit 2e1139d613c7fb0956e82f72a8281c0a475ad4f8 ]

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Fixes: 25b98b64e284 ("vhost scsi: alloc cmds per vq instead of session")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Link: https://lore.kernel.org/r/1607071411-33484-1-git-send-email-zhangchangzhong@huawei.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/scsi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 6ff8a50966915..4ce9f00ae10e8 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -1643,7 +1643,8 @@ vhost_scsi_set_endpoint(struct vhost_scsi *vs,
 			if (!vhost_vq_is_setup(vq))
 				continue;
 
-			if (vhost_scsi_setup_vq_cmds(vq, vq->num))
+			ret = vhost_scsi_setup_vq_cmds(vq, vq->num);
+			if (ret)
 				goto destroy_vq_cmds;
 		}
 
-- 
2.27.0




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D965811B742
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 17:06:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729228AbfLKPMg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:12:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:34396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731184AbfLKPMg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:12:36 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E4F8208C3;
        Wed, 11 Dec 2019 15:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077155;
        bh=i6bwU4k5km/tQMwuOoi84zsapnp/3wetQ4uiUCbzzic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MrTYt0YBJEjq32nw0oatJyGlzimt58qyJWDfQkeDbv0ZdWS7ANbq+x61CIOOyV4rb
         Jo0btyV5/mvzvO5/toIt2R59sdAogoXI+MOXEic83+ZhrpYvneQQxMa7B/VE5i7pX/
         H+03RRqxA3j2Tl6yIpcZcQsjKAbNd3nHkpzZnoco=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kbuild test robot <lkp@intel.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Dongsheng Yang <dongsheng.yang@easystack.cn>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 036/105] rbd: silence bogus uninitialized warning in rbd_object_map_update_finish()
Date:   Wed, 11 Dec 2019 16:05:25 +0100
Message-Id: <20191211150234.019427732@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150221.153659747@linuxfoundation.org>
References: <20191211150221.153659747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilya Dryomov <idryomov@gmail.com>

[ Upstream commit 633739b2fedb6617d782ca252797b7a8ad754347 ]

Some versions of gcc (so far 6.3 and 7.4) throw a warning:

  drivers/block/rbd.c: In function 'rbd_object_map_callback':
  drivers/block/rbd.c:2124:21: warning: 'current_state' may be used uninitialized in this function [-Wmaybe-uninitialized]
        (current_state == OBJECT_EXISTS && state == OBJECT_EXISTS_CLEAN))
  drivers/block/rbd.c:2092:23: note: 'current_state' was declared here
    u8 state, new_state, current_state;
                          ^~~~~~~~~~~~~

It's bogus because all current_state accesses are guarded by
has_current_state.

Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Reviewed-by: Dongsheng Yang <dongsheng.yang@easystack.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/rbd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index c8fb886aebd4e..64e364c4a0fb8 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -2089,7 +2089,7 @@ static int rbd_object_map_update_finish(struct rbd_obj_request *obj_req,
 	struct rbd_device *rbd_dev = obj_req->img_request->rbd_dev;
 	struct ceph_osd_data *osd_data;
 	u64 objno;
-	u8 state, new_state, current_state;
+	u8 state, new_state, uninitialized_var(current_state);
 	bool has_current_state;
 	void *p;
 
-- 
2.20.1




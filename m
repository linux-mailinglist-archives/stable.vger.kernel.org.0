Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 819F3272E42
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:48:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729672AbgIUQrf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:47:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:54440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729005AbgIUQrb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:47:31 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1574E23888;
        Mon, 21 Sep 2020 16:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706850;
        bh=Ray2J6C8mERMExn2q2zrvN1rf5Syki7FidK41Exo1BY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SVq5+JJ4dX4L2+Aue1NXl/H0WITPaPXpQdMpl05E/78T8LvoU3rzmB4vQhkWVW6pK
         864eWzFMn+qXArjzqIvyMr297tJipfIYEASSCFc9fiTwR8aPfImhG93MJeorNklXJ1
         sH3wurpJvwNG3T1lu7hGBt+jqtdtdjZk01lYbFQM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>, Yi Zhang <yi.zhang@redhat.com>
Subject: [PATCH 5.8 118/118] nvme-loop: set ctrl state connecting after init
Date:   Mon, 21 Sep 2020 18:28:50 +0200
Message-Id: <20200921162041.875934225@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162036.324813383@linuxfoundation.org>
References: <20200921162036.324813383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>

commit 64d452b3560b7a55277c8d9ef0a8635e62136580 upstream.

When creating a loop controller (ctrl) in nvme_loop_create_ctrl() ->
nvme_init_ctrl() we set the ctrl state to NVME_CTRL_NEW.

Prior to [1] NVME_CTRL_NEW state was allowed in nvmf_check_ready() for
fabrics command type connect. Now, this fails in the following code path
for fabrics connect command when creating admin queue :-

nvme_loop_create_ctrl()
 nvme_loo_configure_admin_queue()
  nvmf_connect_admin_queue()
   __nvme_submit_sync_cmd()
    blk_execute_rq()
      nvme_loop_queue_rq()
	nvmf_check_ready()

# echo  "transport=loop,nqn=fs" > /dev/nvme-fabrics
[ 6047.741327] nvmet: adding nsid 1 to subsystem fs
[ 6048.756430] nvme nvme1: Connect command failed, error wo/DNR bit: 880

We need to set the ctrl state to NVME_CTRL_CONNECTING after :-
nvme_loop_create_ctrl()
 nvme_init_ctrl()
so that the above mentioned check for nvmf_check_ready() will return
true.

This patch sets the ctrl state to connecting after we init the ctrl in
nvme_loop_create_ctrl()
 nvme_init_ctrl() .

[1] commit aa63fa6776a7 ("nvme-fabrics: allow to queue requests for live queues")

Fixes: aa63fa6776a7 ("nvme-fabrics: allow to queue requests for live queues")
Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Tested-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Yi Zhang <yi.zhang@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/nvme/target/loop.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/nvme/target/loop.c
+++ b/drivers/nvme/target/loop.c
@@ -583,6 +583,9 @@ static struct nvme_ctrl *nvme_loop_creat
 	if (ret)
 		goto out_put_ctrl;
 
+	changed = nvme_change_ctrl_state(&ctrl->ctrl, NVME_CTRL_CONNECTING);
+	WARN_ON_ONCE(!changed);
+
 	ret = -ENOMEM;
 
 	ctrl->ctrl.sqsize = opts->queue_size - 1;



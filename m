Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB241A906F
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:37:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389420AbfIDSJm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:09:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:52986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389648AbfIDSJl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:09:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5388123401;
        Wed,  4 Sep 2019 18:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620579;
        bh=p/nQELJb3Vcn6YZ8nNI5an9tx+JnNv2LeYrgboM6e0w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UmQRaSK7tGHLN4NS6LdlZShLA47rYPan2JzjBZvXi6pQk1PPYJPJqWA9kTwryjktw
         ewGLJlSVvrwLcEngWbJ9Q9gjMb8s1ce0CQ0ktOKtcVXKSV9jui7mgylI4/ivyxPR6w
         f4lgMB+diks8aT8qh+qsvuLgx38H4UNcCovgrgO0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Logan Gunthorpe <logang@deltatee.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Max Gurtovoy <maxg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 009/143] nvmet: Fix use-after-free bug when a port is removed
Date:   Wed,  4 Sep 2019 19:52:32 +0200
Message-Id: <20190904175314.494544766@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175314.206239922@linuxfoundation.org>
References: <20190904175314.206239922@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 3aed86731ee2b23e4dc4d2c6d943d33992cd551b ]

When a port is removed through configfs, any connected controllers
are still active and can still send commands. This causes a
use-after-free bug which is detected by KASAN for any admin command
that dereferences req->port (like in nvmet_execute_identify_ctrl).

To fix this, disconnect all active controllers when a subsystem is
removed from a port. This ensures there are no active controllers
when the port is eventually removed.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Max Gurtovoy <maxg@mellanox.com>
Reviewed-by : Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/configfs.c |  1 +
 drivers/nvme/target/core.c     | 12 ++++++++++++
 drivers/nvme/target/nvmet.h    |  3 +++
 3 files changed, 16 insertions(+)

diff --git a/drivers/nvme/target/configfs.c b/drivers/nvme/target/configfs.c
index 08dd5af357f7c..3854363118ccf 100644
--- a/drivers/nvme/target/configfs.c
+++ b/drivers/nvme/target/configfs.c
@@ -673,6 +673,7 @@ static void nvmet_port_subsys_drop_link(struct config_item *parent,
 
 found:
 	list_del(&p->entry);
+	nvmet_port_del_ctrls(port, subsys);
 	nvmet_port_disc_changed(port, subsys);
 
 	if (list_empty(&port->subsystems))
diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
index 7734a6acff851..e4db9a4411681 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -277,6 +277,18 @@ void nvmet_unregister_transport(const struct nvmet_fabrics_ops *ops)
 }
 EXPORT_SYMBOL_GPL(nvmet_unregister_transport);
 
+void nvmet_port_del_ctrls(struct nvmet_port *port, struct nvmet_subsys *subsys)
+{
+	struct nvmet_ctrl *ctrl;
+
+	mutex_lock(&subsys->lock);
+	list_for_each_entry(ctrl, &subsys->ctrls, subsys_entry) {
+		if (ctrl->port == port)
+			ctrl->ops->delete_ctrl(ctrl);
+	}
+	mutex_unlock(&subsys->lock);
+}
+
 int nvmet_enable_port(struct nvmet_port *port)
 {
 	const struct nvmet_fabrics_ops *ops;
diff --git a/drivers/nvme/target/nvmet.h b/drivers/nvme/target/nvmet.h
index c25d88fc9dec8..b6b0d483e0c50 100644
--- a/drivers/nvme/target/nvmet.h
+++ b/drivers/nvme/target/nvmet.h
@@ -415,6 +415,9 @@ void nvmet_port_send_ana_event(struct nvmet_port *port);
 int nvmet_register_transport(const struct nvmet_fabrics_ops *ops);
 void nvmet_unregister_transport(const struct nvmet_fabrics_ops *ops);
 
+void nvmet_port_del_ctrls(struct nvmet_port *port,
+			  struct nvmet_subsys *subsys);
+
 int nvmet_enable_port(struct nvmet_port *port);
 void nvmet_disable_port(struct nvmet_port *port);
 
-- 
2.20.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C45972FA285
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 15:07:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392630AbhAROFk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 09:05:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:39194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390661AbhARLpq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:45:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3333D221EC;
        Mon, 18 Jan 2021 11:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970290;
        bh=bGkiAyrGP+LqiNT7ssqGgwF3IBEiHHbMKS5OrY9DF2M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eWeWdar69uWbf+LE/A78molWIb0RZwGlD9s7U8KZzZcR2mpcGyVqBbMisZ6C4s29i
         0HPGvFHQnSoYP5ZJ2hZ6u79dlIvn8PJgGNztkdI43aK6Q4zHi5Ob3m07PU43xdFIL6
         cH6VnJLX9orlje9FRqMojMJSK8010U1rpq99Qa2A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5.10 118/152] nvme: dont intialize hwmon for discovery controllers
Date:   Mon, 18 Jan 2021 12:34:53 +0100
Message-Id: <20210118113358.385071813@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sagi Grimberg <sagi@grimberg.me>

commit 5ab25a32cd90ce561ac28b9302766e565d61304c upstream.

Discovery controllers usually don't support smart log page command.
So when we connect to the discovery controller we see this warning:
nvme nvme0: Failed to read smart log (error 24577)
nvme nvme0: new ctrl: NQN "nqn.2014-08.org.nvmexpress.discovery", addr 192.168.123.1:8009
nvme nvme0: Removing ctrl: NQN "nqn.2014-08.org.nvmexpress.discovery"

Introduce a new helper to understand if the controller is a discovery
controller and use this helper to skip nvme_init_hwmon (also use it in
other places that we check if the controller is a discovery controller).

Fixes: 400b6a7b13a3 ("nvme: Add hardware monitoring support")
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/nvme/host/core.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2802,6 +2802,11 @@ static const struct attribute_group *nvm
 	NULL,
 };
 
+static inline bool nvme_discovery_ctrl(struct nvme_ctrl *ctrl)
+{
+	return ctrl->opts && ctrl->opts->discovery_nqn;
+}
+
 static bool nvme_validate_cntlid(struct nvme_subsystem *subsys,
 		struct nvme_ctrl *ctrl, struct nvme_id_ctrl *id)
 {
@@ -2821,7 +2826,7 @@ static bool nvme_validate_cntlid(struct
 		}
 
 		if ((id->cmic & NVME_CTRL_CMIC_MULTI_CTRL) ||
-		    (ctrl->opts && ctrl->opts->discovery_nqn))
+		    nvme_discovery_ctrl(ctrl))
 			continue;
 
 		dev_err(ctrl->device,
@@ -3090,7 +3095,7 @@ int nvme_init_identify(struct nvme_ctrl
 			goto out_free;
 		}
 
-		if (!ctrl->opts->discovery_nqn && !ctrl->kas) {
+		if (!nvme_discovery_ctrl(ctrl) && !ctrl->kas) {
 			dev_err(ctrl->device,
 				"keep-alive support is mandatory for fabrics\n");
 			ret = -EINVAL;
@@ -3130,7 +3135,7 @@ int nvme_init_identify(struct nvme_ctrl
 	if (ret < 0)
 		return ret;
 
-	if (!ctrl->identified) {
+	if (!ctrl->identified && !nvme_discovery_ctrl(ctrl)) {
 		ret = nvme_hwmon_init(ctrl);
 		if (ret < 0)
 			return ret;



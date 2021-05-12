Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 074FA37C977
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:47:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235014AbhELQTR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:19:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:33532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239647AbhELQKe (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:10:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3268B6199D;
        Wed, 12 May 2021 15:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834020;
        bh=8pP1A/Z3joP6tttW7rxRtM+CVLi3bhO0g6klcO9ZeIQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KR+9stuCoMRcbiMFIScgB4dyVSVJeBILlNpKdKmuM9jTpCySOxRc/8mJOZuiduDk1
         56CDrMqcl9cQcsNEtVaU7EEs9eciHijDTNW79cE08rK5Ji+y6ffpczz5tQucalWwGh
         LKrcl7PsuOHQ942iAJtlQ8wtQ54FzgGM5nbbc5ts=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 379/601] HSI: core: fix resource leaks in hsi_add_client_from_dt()
Date:   Wed, 12 May 2021 16:47:36 +0200
Message-Id: <20210512144840.276193850@linuxfoundation.org>
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

[ Upstream commit 5c08b0f75575648032f309a6f58294453423ed93 ]

If some of the allocations fail between the dev_set_name() and the
device_register() then the name will not be freed.  Fix this by
moving dev_set_name() directly in front of the call to device_register().

Fixes: a2aa24734d9d ("HSI: Add common DT binding for HSI client devices")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hsi/hsi_core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/hsi/hsi_core.c b/drivers/hsi/hsi_core.c
index c3fb5beb846e..ec90713564e3 100644
--- a/drivers/hsi/hsi_core.c
+++ b/drivers/hsi/hsi_core.c
@@ -210,8 +210,6 @@ static void hsi_add_client_from_dt(struct hsi_port *port,
 	if (err)
 		goto err;
 
-	dev_set_name(&cl->device, "%s", name);
-
 	err = hsi_of_property_parse_mode(client, "hsi-mode", &mode);
 	if (err) {
 		err = hsi_of_property_parse_mode(client, "hsi-rx-mode",
@@ -293,6 +291,7 @@ static void hsi_add_client_from_dt(struct hsi_port *port,
 	cl->device.release = hsi_client_release;
 	cl->device.of_node = client;
 
+	dev_set_name(&cl->device, "%s", name);
 	if (device_register(&cl->device) < 0) {
 		pr_err("hsi: failed to register client: %s\n", name);
 		put_device(&cl->device);
-- 
2.30.2




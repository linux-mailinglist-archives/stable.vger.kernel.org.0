Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8176531D84
	for <lists+stable@lfdr.de>; Sat,  1 Jun 2019 15:30:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729445AbfFAN3Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Jun 2019 09:29:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:57436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729500AbfFAN0y (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 1 Jun 2019 09:26:54 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 01A57273C3;
        Sat,  1 Jun 2019 13:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559395613;
        bh=OGBA0B3m5sN0CGLqsT+uM6B3105oqsPh40TEuaQMLlE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WOHlz6GofkNFb0tHrIHBv7kv9UySeOgT7wp+W3KCP0xEtO60w63j3Y06EA99BeSym
         si43n6cYSvL0C2bKQ4GtnY/2HkaWMstv1pAhTvMhkGMbUj/+Y3XZ3oH+2NV4VSlyos
         5HM/ZO0+B7TEdjLsoqKFp7lEEjAUcB88yfhyToTU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Enrico Granata <egranata@chromium.org>,
        Jett Rink <jettrink@chromium.org>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.4 30/56] platform/chrome: cros_ec_proto: check for NULL transfer function
Date:   Sat,  1 Jun 2019 09:25:34 -0400
Message-Id: <20190601132600.27427-30-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190601132600.27427-1-sashal@kernel.org>
References: <20190601132600.27427-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Enrico Granata <egranata@chromium.org>

[ Upstream commit 94d4e7af14a1170e34cf082d92e4c02de9e9fb88 ]

As new transfer mechanisms are added to the EC codebase, they may
not support v2 of the EC protocol.

If the v3 initial handshake transfer fails, the kernel will try
and call cmd_xfer as a fallback. If v2 is not supported, cmd_xfer
will be NULL, and the code will end up causing a kernel panic.

Add a check for NULL before calling the transfer function, along
with a helpful comment explaining how one might end up in this
situation.

Signed-off-by: Enrico Granata <egranata@chromium.org>
Reviewed-by: Jett Rink <jettrink@chromium.org>
Signed-off-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/chrome/cros_ec_proto.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/platform/chrome/cros_ec_proto.c b/drivers/platform/chrome/cros_ec_proto.c
index a0b8c8a8c3231..5c285f2b3a650 100644
--- a/drivers/platform/chrome/cros_ec_proto.c
+++ b/drivers/platform/chrome/cros_ec_proto.c
@@ -66,6 +66,17 @@ static int send_command(struct cros_ec_device *ec_dev,
 	else
 		xfer_fxn = ec_dev->cmd_xfer;
 
+	if (!xfer_fxn) {
+		/*
+		 * This error can happen if a communication error happened and
+		 * the EC is trying to use protocol v2, on an underlying
+		 * communication mechanism that does not support v2.
+		 */
+		dev_err_once(ec_dev->dev,
+			     "missing EC transfer API, cannot send command\n");
+		return -EIO;
+	}
+
 	ret = (*xfer_fxn)(ec_dev, msg);
 	if (msg->result == EC_RES_IN_PROGRESS) {
 		int i;
-- 
2.20.1


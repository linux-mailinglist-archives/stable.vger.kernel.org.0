Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAC8429BF08
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:01:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1814822AbgJ0Q7x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 12:59:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:44824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1793952AbgJ0PJV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:09:21 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A62E20657;
        Tue, 27 Oct 2020 15:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811361;
        bh=B7P7RTZKOunuboMRiYpUL2hPjTSrlkCVL3xQowpL4mg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=luGgbeLhYNQHi0rpGglut8M9vNPp0OqYT2QDkgIFkyKA90TLqu7msiB9RssM18D/3
         h+gkIsxI995dKp16YEQBV5WEumeKdEl7es3ohhdbXgXHmryrmR7BzGDRhwFn9WvFlG
         Ddb8iPlUZX3zHWsTw8BFsm9rqiHeeYEd/cpRZmtI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gwendal Grignou <gwendal@chromium.org>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 465/633] platform/chrome: cros_ec_lightbar: Reduce ligthbar get version command
Date:   Tue, 27 Oct 2020 14:53:28 +0100
Message-Id: <20201027135544.545291490@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gwendal Grignou <gwendal@chromium.org>

[ Upstream commit 1e7913ff5f9f1b73146ad8522958bd266f22a510 ]

By default, the lightbar commands are set to the biggest lightbar command
and response. That length is greater than 128 bytes and may not work on
all machines. But all EC are probed for lightbar by sending a get version
request. Set that request size precisely.

Before the command would be:

  cros_ec_cmd: version: 0, command: EC_CMD_LIGHTBAR_CMD, outsize: 194, insize: 128, result: 0

Afer:

  cros_ec_cmd: version: 0, command: EC_CMD_LIGHTBAR_CMD, outsize: 1, insize: 8, result: 0

Fixes: a841178445bb7 ("mfd: cros_ec: Use a zero-length array for command data")
Signed-off-by: Gwendal Grignou <gwendal@chromium.org>
Signed-off-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/chrome/cros_ec_lightbar.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/platform/chrome/cros_ec_lightbar.c b/drivers/platform/chrome/cros_ec_lightbar.c
index b59180bff5a3e..ef61298c30bdd 100644
--- a/drivers/platform/chrome/cros_ec_lightbar.c
+++ b/drivers/platform/chrome/cros_ec_lightbar.c
@@ -116,6 +116,8 @@ static int get_lightbar_version(struct cros_ec_dev *ec,
 
 	param = (struct ec_params_lightbar *)msg->data;
 	param->cmd = LIGHTBAR_CMD_VERSION;
+	msg->outsize = sizeof(param->cmd);
+	msg->result = sizeof(resp->version);
 	ret = cros_ec_cmd_xfer_status(ec->ec_dev, msg);
 	if (ret < 0) {
 		ret = 0;
-- 
2.25.1




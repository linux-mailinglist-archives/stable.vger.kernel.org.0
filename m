Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F3234988F7
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 19:52:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343537AbiAXSwF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 13:52:05 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:49716 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343581AbiAXSvB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 13:51:01 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8385561500;
        Mon, 24 Jan 2022 18:51:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40CEAC340E5;
        Mon, 24 Jan 2022 18:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643050261;
        bh=ltfBF/t0KEK7VJPJMB0V8iusdFPJKGVQeC+PLK7eJGQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yoM/w3laACBOuB7BhhLs1kSVlLYchWKnfjI0ebsFOjhzF6Uua1BKllnjJ7Hkko6we
         PrgxEt94D3UuHz9mgH9No2UQDcSlSpRLo3bHhOwtmlwUYAWOmYKhRS7OfT7it+k01G
         KHX8/KY8NX0eJH8nCEkmr4DUlhpdlizw03X56h/U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chengfeng Ye <cyeaa@connect.ust.hk>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 062/114] HSI: core: Fix return freed object in hsi_new_client
Date:   Mon, 24 Jan 2022 19:42:37 +0100
Message-Id: <20220124183929.023202219@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183927.095545464@linuxfoundation.org>
References: <20220124183927.095545464@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chengfeng Ye <cyeaa@connect.ust.hk>

[ Upstream commit a1ee1c08fcd5af03187dcd41dcab12fd5b379555 ]

cl is freed on error of calling device_register, but this
object is return later, which will cause uaf issue. Fix it
by return NULL on error.

Signed-off-by: Chengfeng Ye <cyeaa@connect.ust.hk>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hsi/hsi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hsi/hsi.c b/drivers/hsi/hsi.c
index 55e36fcd7ff35..e1080f005a19e 100644
--- a/drivers/hsi/hsi.c
+++ b/drivers/hsi/hsi.c
@@ -115,6 +115,7 @@ struct hsi_client *hsi_new_client(struct hsi_port *port,
 	if (device_register(&cl->device) < 0) {
 		pr_err("hsi: failed to register client: %s\n", info->name);
 		put_device(&cl->device);
+		goto err;
 	}
 
 	return cl;
-- 
2.34.1




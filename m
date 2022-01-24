Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F89C498C4E
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:22:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349867AbiAXTVp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:21:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347799AbiAXTSn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:18:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6085C09425D;
        Mon, 24 Jan 2022 11:07:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 914EDB81238;
        Mon, 24 Jan 2022 19:07:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC477C340E5;
        Mon, 24 Jan 2022 19:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643051235;
        bh=5AK/ZD+OO4TiPDAZvOFjQFvLrOlNWLTVM/ikSQ8BP24=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wAQ3nMD06A5xCYTnsdKmPFybpr6iAVcg+LwqCmi+/Vodo4+TmiSgUmjMRDQ7Xidju
         QIV0oR11+uWjeMNPwlWOmh/YILuaxLBiHIy0SoYDBP2PcIAYqRQanseyqOFChcepQ3
         OljslQ4sAsHCaApRjChy5jW75Sxiu6vChzR/J/4s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chengfeng Ye <cyeaa@connect.ust.hk>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 097/186] HSI: core: Fix return freed object in hsi_new_client
Date:   Mon, 24 Jan 2022 19:42:52 +0100
Message-Id: <20220124183940.237290348@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183937.101330125@linuxfoundation.org>
References: <20220124183937.101330125@linuxfoundation.org>
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
 drivers/hsi/hsi_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hsi/hsi_core.c b/drivers/hsi/hsi_core.c
index 71895da63810b..daf2de837a30a 100644
--- a/drivers/hsi/hsi_core.c
+++ b/drivers/hsi/hsi_core.c
@@ -115,6 +115,7 @@ struct hsi_client *hsi_new_client(struct hsi_port *port,
 	if (device_register(&cl->device) < 0) {
 		pr_err("hsi: failed to register client: %s\n", info->name);
 		put_device(&cl->device);
+		goto err;
 	}
 
 	return cl;
-- 
2.34.1




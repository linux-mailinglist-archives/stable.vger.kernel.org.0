Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55BC949A363
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:03:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2366297AbiAXXwf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:52:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1845911AbiAXXNz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:13:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C482C067A71;
        Mon, 24 Jan 2022 13:19:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ECA06B80FA1;
        Mon, 24 Jan 2022 21:19:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26A26C340E4;
        Mon, 24 Jan 2022 21:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059196;
        bh=4oYtsRdFJt3wVgx1zVbt/5z4Ff6BZH8Q/KvrbYGrPQ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ytk/ZkDHJDbflDRDf2bJqNcFzit6MO/bEePrWIzkrmq+o0tSSGo4eE+wSQYldBVfX
         aAyfZ398kfEMEOUSf1vg989oK+JD6y0SfEvxdRKhDVnFLdWdzYv7YIwPU5ENTKSgxj
         p7BxQ+HO1bpB1OEmMfA+i6vzm3k0q8rtgnZ5hBts=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jassi Brar <jassisinghbrar@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0535/1039] mailbox: pcc: Avoid using the uninitialized variable dev
Date:   Mon, 24 Jan 2022 19:38:44 +0100
Message-Id: <20220124184143.265198128@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sudeep Holla <sudeep.holla@arm.com>

[ Upstream commit 960c4056aadcf61983f8eaac159927a052f8cf01 ]

Smatch static checker warns:

  |  drivers/mailbox/pcc.c:292 pcc_mbox_request_channel()
  |  error: uninitialized symbol 'dev'.

Fix the same by using pr_err instead of dev_err as the variable 'dev'
is uninitialized at that stage.

Fixes: ce028702ddbc ("mailbox: pcc: Move bulk of PCCT parsing into pcc_mbox_probe")
Cc: Jassi Brar <jassisinghbrar@gmail.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/pcc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mailbox/pcc.c b/drivers/mailbox/pcc.c
index 887a3704c12ec..e0a1ab3861f0d 100644
--- a/drivers/mailbox/pcc.c
+++ b/drivers/mailbox/pcc.c
@@ -289,7 +289,7 @@ pcc_mbox_request_channel(struct mbox_client *cl, int subspace_id)
 	pchan = chan_info + subspace_id;
 	chan = pchan->chan.mchan;
 	if (IS_ERR(chan) || chan->cl) {
-		dev_err(dev, "Channel not found for idx: %d\n", subspace_id);
+		pr_err("Channel not found for idx: %d\n", subspace_id);
 		return ERR_PTR(-EBUSY);
 	}
 	dev = chan->mbox->dev;
-- 
2.34.1




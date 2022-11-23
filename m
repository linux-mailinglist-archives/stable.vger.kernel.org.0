Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A82DA635864
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:56:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236981AbiKWJ4r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:56:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237088AbiKWJzb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:55:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A414116A84
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:50:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E5FA861B60
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:50:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2074C433C1;
        Wed, 23 Nov 2022 09:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669197055;
        bh=B0AW1hsMGJ8AgDIiJUP5914otSO628nzhtGXcIdINt8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W87/ffMycie0ZgQK7zkmV2b4TSzTc9efh3sVfDTUfDhhZSU613BPabSossXYyOYUW
         Q3Nwj+i+kTB34BRPU3Xb5mzhzZ6XUH8Z3vMasZLXUiqXX8lxXtv/s4D4dAm9uc+zLU
         2rDLZr+dVSpRgFADcQ+MCet/FO1VAI67PDyklfxo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 186/314] nvmet: fix a memory leak in nvmet_auth_set_key
Date:   Wed, 23 Nov 2022 09:50:31 +0100
Message-Id: <20221123084633.994267774@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sagi Grimberg <sagi@grimberg.me>

[ Upstream commit 0a52566279b4ee65ecd2503d7b7342851f84755c ]

When changing dhchap secrets we need to release the old
secrets as well.

kmemleak complaint:
--
unreferenced object 0xffff8c7f44ed8180 (size 64):
  comm "check", pid 7304, jiffies 4295686133 (age 72034.246s)
  hex dump (first 32 bytes):
    44 48 48 43 2d 31 3a 30 30 3a 4c 64 4c 4f 64 71  DHHC-1:00:LdLOdq
    79 56 69 67 77 48 55 32 6d 5a 59 4c 7a 35 59 38  yVigwHU2mZYLz5Y8
  backtrace:
    [<00000000b6fc5071>] kstrdup+0x2e/0x60
    [<00000000f0f4633f>] 0xffffffffc0e07ee6
    [<0000000053006c05>] 0xffffffffc0dff783
    [<00000000419ae922>] configfs_write_iter+0xb1/0x120
    [<000000008183c424>] vfs_write+0x2be/0x3c0
    [<000000009005a2a5>] ksys_write+0x5f/0xe0
    [<00000000cd495c89>] do_syscall_64+0x38/0x90
    [<00000000f2a84ac5>] entry_SYSCALL_64_after_hwframe+0x63/0xcd

Fixes: db1312dd9548 ("nvmet: implement basic In-Band Authentication")
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/auth.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/nvme/target/auth.c b/drivers/nvme/target/auth.c
index c4113b43dbfe..4dcddcf95279 100644
--- a/drivers/nvme/target/auth.c
+++ b/drivers/nvme/target/auth.c
@@ -45,9 +45,11 @@ int nvmet_auth_set_key(struct nvmet_host *host, const char *secret,
 	if (!dhchap_secret)
 		return -ENOMEM;
 	if (set_ctrl) {
+		kfree(host->dhchap_ctrl_secret);
 		host->dhchap_ctrl_secret = strim(dhchap_secret);
 		host->dhchap_ctrl_key_hash = key_hash;
 	} else {
+		kfree(host->dhchap_secret);
 		host->dhchap_secret = strim(dhchap_secret);
 		host->dhchap_key_hash = key_hash;
 	}
-- 
2.35.1




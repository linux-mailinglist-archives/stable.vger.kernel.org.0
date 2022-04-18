Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 052E1505257
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:43:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239555AbiDRMlq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:41:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240689AbiDRMja (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:39:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1815412AEF;
        Mon, 18 Apr 2022 05:30:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB4F760FB6;
        Mon, 18 Apr 2022 12:30:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B217FC385A8;
        Mon, 18 Apr 2022 12:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650285011;
        bh=qwIOE+fxbtogB1kDF6uX/hsJ/sFljR0FKIcKVrSQsB0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=od9bJdb8cxdOadKM71PUo6KajvBDmXFkDU+fAz3JTkvJhb0zjn3fL1R5DmZ3wDcA4
         jak3MPl5paMDEFSAX/Vo0qV5LNhaqoVSENivVfMcnKgdFYBBqDkN5HWyH3IBcSLZ1J
         B1nRR2B/N1FIF6hSvny3DFSfnlMukERZrMmm2kqY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+03e3e228510223dabd34@syzkaller.appspotmail.com,
        Karsten Graul <kgraul@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 078/189] net/smc: Fix NULL pointer dereference in smc_pnet_find_ib()
Date:   Mon, 18 Apr 2022 14:11:38 +0200
Message-Id: <20220418121202.722855729@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121200.312988959@linuxfoundation.org>
References: <20220418121200.312988959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Karsten Graul <kgraul@linux.ibm.com>

[ Upstream commit d22f4f977236f97e01255a80bca2ea93a8094fc8 ]

dev_name() was called with dev.parent as argument but without to
NULL-check it before.
Solve this by checking the pointer before the call to dev_name().

Fixes: af5f60c7e3d5 ("net/smc: allow PCI IDs as ib device names in the pnet table")
Reported-by: syzbot+03e3e228510223dabd34@syzkaller.appspotmail.com
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/smc_pnet.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/smc/smc_pnet.c b/net/smc/smc_pnet.c
index 707615809e5a..79ee0618d919 100644
--- a/net/smc/smc_pnet.c
+++ b/net/smc/smc_pnet.c
@@ -310,8 +310,9 @@ static struct smc_ib_device *smc_pnet_find_ib(char *ib_name)
 	list_for_each_entry(ibdev, &smc_ib_devices.list, list) {
 		if (!strncmp(ibdev->ibdev->name, ib_name,
 			     sizeof(ibdev->ibdev->name)) ||
-		    !strncmp(dev_name(ibdev->ibdev->dev.parent), ib_name,
-			     IB_DEVICE_NAME_MAX - 1)) {
+		    (ibdev->ibdev->dev.parent &&
+		     !strncmp(dev_name(ibdev->ibdev->dev.parent), ib_name,
+			     IB_DEVICE_NAME_MAX - 1))) {
 			goto out;
 		}
 	}
-- 
2.35.1




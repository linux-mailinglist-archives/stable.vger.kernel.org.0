Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC4D65053CD
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:01:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240368AbiDRNDi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:03:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240959AbiDRNCY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:02:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EA9E2657B;
        Mon, 18 Apr 2022 05:42:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D1468611E4;
        Mon, 18 Apr 2022 12:42:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79BE5C385A7;
        Mon, 18 Apr 2022 12:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650285746;
        bh=J5eHbvebqrWRc0sHdHjG1uKkhFIrhUmPDEPwc1laYe8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AS7ZScNpPrckkDOf+nD76GYHRX1slISceMBT6qw1ClEmLpC1s923WJDb8RIx15bzx
         WuNjlS30YsixglcIaWqQb295vq4rbRk33nyyuhv8rLFu8ELA/8TGb8nnfR7auMF1og
         rlItnTsfp+MQ0jENcZhjx0U55qr80Ae0/tNHY9A0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+03e3e228510223dabd34@syzkaller.appspotmail.com,
        Karsten Graul <kgraul@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 11/63] net/smc: Fix NULL pointer dereference in smc_pnet_find_ib()
Date:   Mon, 18 Apr 2022 14:13:08 +0200
Message-Id: <20220418121134.905009513@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121134.149115109@linuxfoundation.org>
References: <20220418121134.149115109@linuxfoundation.org>
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
index 571e6d84da3b..660608202f28 100644
--- a/net/smc/smc_pnet.c
+++ b/net/smc/smc_pnet.c
@@ -295,8 +295,9 @@ static struct smc_ib_device *smc_pnet_find_ib(char *ib_name)
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




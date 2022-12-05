Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DC426431F8
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:22:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233797AbiLETWq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:22:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234077AbiLETWZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:22:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E4BB26AE5
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:18:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98056B81201
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:18:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B8A3C433C1;
        Mon,  5 Dec 2022 19:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670267894;
        bh=7sSqe3IBM70XTeWjKt4Wi3emGXuXEMslK8B6LAbHqew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ASNaSU4y6IZ9tLExAU+m5T3zCMm8dV9tz78q1SWUXr8ZkAl3RGKgA/r1+iNx4V1fT
         /Pfon/spZJzF/oPq3z6x7qZmAslS9l5bouf/llIMk1vvxDIBSK1DdasRWa8Y4Z1c7J
         xxtqc9txGy2tOrtL+mkRTGHH7WyukXJ4l9lk2IQ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+43475bf3cfbd6e41f5b7@syzkaller.appspotmail.com,
        Lin Ma <linma@zju.edu.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 013/105] nfc/nci: fix race with opening and closing
Date:   Mon,  5 Dec 2022 20:08:45 +0100
Message-Id: <20221205190803.575621063@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190803.124472741@linuxfoundation.org>
References: <20221205190803.124472741@linuxfoundation.org>
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

From: Lin Ma <linma@zju.edu.cn>

[ Upstream commit 0ad6bded175e829c2ca261529c9dce39a32a042d ]

Previously we leverage NCI_UNREG and the lock inside nci_close_device to
prevent the race condition between opening a device and closing a
device. However, it still has problem because a failed opening command
will erase the NCI_UNREG flag and allow another opening command to
bypass the status checking.

This fix corrects that by making sure the NCI_UNREG is held.

Reported-by: syzbot+43475bf3cfbd6e41f5b7@syzkaller.appspotmail.com
Fixes: 48b71a9e66c2 ("NFC: add NCI_UNREG flag to eliminate the race")
Signed-off-by: Lin Ma <linma@zju.edu.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/nfc/nci/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
index 0580e5326641..66608e6c5b0e 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -542,7 +542,7 @@ static int nci_open_device(struct nci_dev *ndev)
 		skb_queue_purge(&ndev->tx_q);
 
 		ndev->ops->close(ndev);
-		ndev->flags = 0;
+		ndev->flags &= BIT(NCI_UNREG);
 	}
 
 done:
-- 
2.35.1




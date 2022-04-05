Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 042514F3584
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242166AbiDEIhE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:37:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239018AbiDEITo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:19:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 615AC75E50;
        Tue,  5 Apr 2022 01:10:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B8319608C0;
        Tue,  5 Apr 2022 08:09:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFCAFC385A0;
        Tue,  5 Apr 2022 08:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146199;
        bh=jRuCT5omAFi2LWBQ7waYygaem40XsMiPNfLmN5riCA0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vb1jWRP9Ar6kqxoryY+2nWAEUM6fGzLroa4Wt6/8/ubmQUagK41K7Z2pXtC55F4hC
         bCJe++p8tdJWhtqxAg4tf6BTN/s7qWAPA+DnelQNpjqrQEAQEj0irt9ofqNNa2YFBP
         di0Q8x0SDD7mlPoQC/iw84+lvmTDWvSc+ALdh5pc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0629/1126] Bluetooth: hci_sync: fix undefined return of hci_disconnect_all_sync()
Date:   Tue,  5 Apr 2022 09:22:56 +0200
Message-Id: <20220405070426.099142773@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Rix <trix@redhat.com>

[ Upstream commit 8cd3c55c629efd91e5f2b3e89d850575c5b90d47 ]

clang static analysis reports this problem
hci_sync.c:4428:2: warning: Undefined or garbage value
  returned to caller
        return err;
        ^~~~~~~~~~

If there are no connections this function is a noop but
err is never set and a false error could be reported.
Return 0 as other hci_* functions do.

Fixes: 182ee45da083 ("Bluetooth: hci_sync: Rework hci_suspend_notifier")
Signed-off-by: Tom Rix <trix@redhat.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sync.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 5e93f37c2e04..405d48c3e63e 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -4432,7 +4432,7 @@ static int hci_disconnect_all_sync(struct hci_dev *hdev, u8 reason)
 			return err;
 	}
 
-	return err;
+	return 0;
 }
 
 /* This function perform power off HCI command sequence as follows:
-- 
2.34.1




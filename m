Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7864158DF1B
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 20:33:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344204AbiHISdM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 14:33:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344146AbiHISad (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 14:30:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EE4A33E3C;
        Tue,  9 Aug 2022 11:10:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CBC86B818A5;
        Tue,  9 Aug 2022 18:08:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B851C43470;
        Tue,  9 Aug 2022 18:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660068498;
        bh=7LfGCkVyeoRC8AJERvMQ5FbN5wqrWZU+sE8GTZfe3iA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mYY0jyTHDZWnXuysAtcWrbzqXSxUjWRwD8yrT3gkKCZrZjBcmZ7C9FsHU5nhClnAQ
         9JGdx0vTHsxxYpbGN/i12wgwsafTvP485RdYNYV9AeJo96sqIRWpoBJRKAgD5BjE9P
         wvzerabZ8nDdLmV6p7Ija5OqVNsfH2jj/cf/Z444=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sai Teja Aluvala <quic_saluvala@quicinc.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 5.19 09/21] Bluetooth: hci_qca: Return wakeup for qca_wakeup
Date:   Tue,  9 Aug 2022 20:01:01 +0200
Message-Id: <20220809175513.634063761@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220809175513.345597655@linuxfoundation.org>
References: <20220809175513.345597655@linuxfoundation.org>
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

From: Sai Teja Aluvala <quic_saluvala@quicinc.com>

commit bde63e9effd3a6ba384707c62abe46c32d22f665 upstream.

This fixes the return value of qca_wakeup(), since
.wakeup work inversely with original .prevent_wake.

Fixes: 4539ca67fe8ed (Bluetooth: Rename driver .prevent_wake to .wakeup)
Signed-off-by: Sai Teja Aluvala <quic_saluvala@quicinc.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/hci_qca.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -1588,7 +1588,7 @@ static bool qca_wakeup(struct hci_dev *h
 	wakeup = device_may_wakeup(hu->serdev->ctrl->dev.parent);
 	bt_dev_dbg(hu->hdev, "wakeup status : %d", wakeup);
 
-	return !wakeup;
+	return wakeup;
 }
 
 static int qca_regulator_init(struct hci_uart *hu)



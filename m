Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02CBA681001
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 14:58:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236795AbjA3N6o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 08:58:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236796AbjA3N6j (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 08:58:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8426339CFE
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 05:58:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 02737B81178
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 13:58:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F0DFC433A1;
        Mon, 30 Jan 2023 13:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087095;
        bh=HZVFNpMOWJv3yLxPlUKn8djyllpXl4Pt4CvQn+3kMQw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZM2HtJ1enSsvtctEVBYygySV20XQZrcHptifFk1EVIW2oBnq0yHq2rppu+UDjsyN5
         92tpiaRhRnLetUaxJdcWe6UDHfAJVpUAZ5I/KtG1aYWQWWsZAPOF/0ZfaQvXCZN5q/
         3fyeHxhcafjcVPCiBbvnMfuajCBjWjTUCM/k9oeo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Udipto Goswami <quic_ugoswami@quicinc.com>,
        Krishna Kurapati <quic_kriskura@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 095/313] usb: gadget: f_fs: Prevent race during ffs_ep0_queue_wait
Date:   Mon, 30 Jan 2023 14:48:50 +0100
Message-Id: <20230130134341.058002410@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Udipto Goswami <quic_ugoswami@quicinc.com>

[ Upstream commit 6a19da111057f69214b97c62fb0ac59023970850 ]

While performing fast composition switch, there is a possibility that the
process of ffs_ep0_write/ffs_ep0_read get into a race condition
due to ep0req being freed up from functionfs_unbind.

Consider the scenario that the ffs_ep0_write calls the ffs_ep0_queue_wait
by taking a lock &ffs->ev.waitq.lock. However, the functionfs_unbind isn't
bounded so it can go ahead and mark the ep0req to NULL, and since there
is no NULL check in ffs_ep0_queue_wait we will end up in use-after-free.

Fix this by making a serialized execution between the two functions using
a mutex_lock(ffs->mutex).

Fixes: ddf8abd25994 ("USB: f_fs: the FunctionFS driver")
Signed-off-by: Udipto Goswami <quic_ugoswami@quicinc.com>
Tested-by: Krishna Kurapati <quic_kriskura@quicinc.com>
Link: https://lore.kernel.org/r/20221215052906.8993-2-quic_ugoswami@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/f_fs.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index 73dc10a77cde..bb6fe1f3a29d 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -279,6 +279,9 @@ static int __ffs_ep0_queue_wait(struct ffs_data *ffs, char *data, size_t len)
 	struct usb_request *req = ffs->ep0req;
 	int ret;
 
+	if (!req)
+		return -EINVAL;
+
 	req->zero     = len < le16_to_cpu(ffs->ev.setup.wLength);
 
 	spin_unlock_irq(&ffs->ev.waitq.lock);
@@ -1892,10 +1895,12 @@ static void functionfs_unbind(struct ffs_data *ffs)
 	ENTER();
 
 	if (!WARN_ON(!ffs->gadget)) {
+		mutex_lock(&ffs->mutex);
 		usb_ep_free_request(ffs->gadget->ep0, ffs->ep0req);
 		ffs->ep0req = NULL;
 		ffs->gadget = NULL;
 		clear_bit(FFS_FL_BOUND, &ffs->flags);
+		mutex_unlock(&ffs->mutex);
 		ffs_data_put(ffs);
 	}
 }
-- 
2.39.0




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B2DB68967D
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:32:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233550AbjBCK1P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:27:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233549AbjBCK0n (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:26:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0403226CDF
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 02:26:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C0846B8287A
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 10:26:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26435C4339B;
        Fri,  3 Feb 2023 10:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675419967;
        bh=WrJZLxKAsJXSnZu3DJ31XWez5Jk7/4u3NLjiqEq4ilM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cS8W573iihMKhzUYy1hfUBdJ22tx+bd3rH0B9G89hVZbK4MPTq2Eyh9lUi9RBra8E
         CkMp7CYA/P7g44bTGXPF16u+2Ti++mzTLPIAvHxjvh+jAgC8IVN+iU38ecbJFA7QHY
         Go91L0vH1B2LhxQxsuLyYwWhuf0aGOWyr5zZBKVw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Udipto Goswami <quic_ugoswami@quicinc.com>,
        Krishna Kurapati <quic_kriskura@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 037/134] usb: gadget: f_fs: Ensure ep0req is dequeued before free_request
Date:   Fri,  3 Feb 2023 11:12:22 +0100
Message-Id: <20230203101025.525246578@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101023.832083974@linuxfoundation.org>
References: <20230203101023.832083974@linuxfoundation.org>
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

[ Upstream commit ce405d561b020e5a46340eb5146805a625dcacee ]

As per the documentation, function usb_ep_free_request guarantees
the request will not be queued or no longer be re-queued (or
otherwise used). However, with the current implementation it
doesn't make sure that the request in ep0 isn't reused.

Fix this by dequeuing the ep0req on functionfs_unbind before
freeing the request to align with the definition.

Fixes: ddf8abd25994 ("USB: f_fs: the FunctionFS driver")
Signed-off-by: Udipto Goswami <quic_ugoswami@quicinc.com>
Tested-by: Krishna Kurapati <quic_kriskura@quicinc.com>
Link: https://lore.kernel.org/r/20221215052906.8993-3-quic_ugoswami@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/f_fs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index 3b7323233b39..431ab6d07497 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -1903,6 +1903,8 @@ static void functionfs_unbind(struct ffs_data *ffs)
 	ENTER();
 
 	if (!WARN_ON(!ffs->gadget)) {
+		/* dequeue before freeing ep0req */
+		usb_ep_dequeue(ffs->gadget->ep0, ffs->ep0req);
 		mutex_lock(&ffs->mutex);
 		usb_ep_free_request(ffs->gadget->ep0, ffs->ep0req);
 		ffs->ep0req = NULL;
-- 
2.39.0




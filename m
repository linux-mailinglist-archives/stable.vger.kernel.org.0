Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50C8A65EBD5
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 14:04:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233867AbjAENDj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 08:03:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234100AbjAENCx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 08:02:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B41F5BA1B
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 05:02:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0899561A10
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 13:02:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10ABCC433D2;
        Thu,  5 Jan 2023 13:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672923768;
        bh=LHKzsuFm8y8p9cVz/J/ekceKBaGAZIjXjlI+RkKOwy4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=awaGypmGcRA1HN7APV0ybqocWVDJMCZeDIZ5R9aVhDTzOVomQ1SEG0oY8AAjfqiR+
         +5dDodeS4bKosV2iJqYdbOBT0P54wiQ/6PGhPjUsiAfsdAyduvS/wBePQdOFLfFFkq
         hj7/LRmbS3QSxleM7s5NG1hkfYaT69F4WSZTq1F4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Artem Chernyshev <artem.chernyshev@red-soft.ru>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Vishnu Dasa <vdasa@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 096/251] net: vmw_vsock: vmci: Check memcpy_from_msg()
Date:   Thu,  5 Jan 2023 13:53:53 +0100
Message-Id: <20230105125339.205540258@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230105125334.727282894@linuxfoundation.org>
References: <20230105125334.727282894@linuxfoundation.org>
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

From: Artem Chernyshev <artem.chernyshev@red-soft.ru>

[ Upstream commit 44aa5a6dba8283bfda28b1517af4de711c5652a4 ]

vmci_transport_dgram_enqueue() does not check the return value
of memcpy_from_msg().  If memcpy_from_msg() fails, it is possible that
uninitialized memory contents are sent unintentionally instead of user's
message in the datagram to the destination.  Return with an error if
memcpy_from_msg() fails.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 0f7db23a07af ("vmci_transport: switch ->enqeue_dgram, ->enqueue_stream and ->dequeue_stream to msghdr")
Signed-off-by: Artem Chernyshev <artem.chernyshev@red-soft.ru>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Reviewed-by: Vishnu Dasa <vdasa@vmware.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/vmw_vsock/vmci_transport.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/vmw_vsock/vmci_transport.c b/net/vmw_vsock/vmci_transport.c
index c09efcdf72d2..d096ef9d1c89 100644
--- a/net/vmw_vsock/vmci_transport.c
+++ b/net/vmw_vsock/vmci_transport.c
@@ -1738,7 +1738,11 @@ static int vmci_transport_dgram_enqueue(
 	if (!dg)
 		return -ENOMEM;
 
-	memcpy_from_msg(VMCI_DG_PAYLOAD(dg), msg, len);
+	err = memcpy_from_msg(VMCI_DG_PAYLOAD(dg), msg, len);
+	if (err) {
+		kfree(dg);
+		return err;
+	}
 
 	dg->dst = vmci_make_handle(remote_addr->svm_cid,
 				   remote_addr->svm_port);
-- 
2.35.1




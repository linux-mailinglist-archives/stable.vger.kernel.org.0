Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BC2B66C751
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:29:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233265AbjAPQ3s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:29:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233194AbjAPQ3a (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:29:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C63E36FED
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:17:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E2585B80DC7
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:17:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44065C433D2;
        Mon, 16 Jan 2023 16:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673885866;
        bh=dkvm24n1VWONjGB24pR3Dyxqk6lDePwdw0Rd2eU6cUE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vsny2COpj1Z4mPlJhxbUIIg46wDFSrAh6BjjZ7frfh4+7yt5hOQ3GWjSKrZZlVZRf
         d5Q1QDSHd2DONnLlCsW/wyfSuVWmiHKiOfb0kNCoTh87M8sXsyilMpf15vpMZY032K
         1IfvpiyXueUkNESCtaTbWztSm3Hi3Kw/oidv52HU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Artem Chernyshev <artem.chernyshev@red-soft.ru>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Vishnu Dasa <vdasa@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 213/658] net: vmw_vsock: vmci: Check memcpy_from_msg()
Date:   Mon, 16 Jan 2023 16:45:01 +0100
Message-Id: <20230116154919.205352469@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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
index aaabcd84268a..85488e19dffc 100644
--- a/net/vmw_vsock/vmci_transport.c
+++ b/net/vmw_vsock/vmci_transport.c
@@ -1725,7 +1725,11 @@ static int vmci_transport_dgram_enqueue(
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




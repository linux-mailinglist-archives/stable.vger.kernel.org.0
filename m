Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E3A0540B7D
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:29:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350671AbiFGS30 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:29:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351659AbiFGSYy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:24:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1794BEABA9;
        Tue,  7 Jun 2022 10:54:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B09E36159C;
        Tue,  7 Jun 2022 17:54:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4B9DC34115;
        Tue,  7 Jun 2022 17:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654624463;
        bh=GQF/q+GBPN0LQWcKw7/iuxVdHzsQarKQIrtWpvX9WAo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gYqvcIykbZQLEbbWiCii/uJ8RRexnw/5ORSfr9mIHmHom0pobjiZAPrNLtbR63qsU
         X8LNUE6Ma+W+tSt9wKlpSZgBUZOpkquBuieZw6oHLt+EfGXme2ftQOQfDo4uWaovLr
         E39UZt78BscdHZFTZimx0Wdc9mT75CWjQDWt4NvAZntG8H6PjfH5bAcBTFMGHTtv6h
         tXFQEDSOxTh1RbFP3pacAs2ssy4QnRzz6OI3DJ+MFoARln6qmhSQ6nizxnbD+gCX2w
         OlFdDUWjGwLdNjD/tmP3k3SjGJhdKPOcR85xqNLE6h27tgefvXxEmMXbyl+CA35ekA
         +NOkzy/eGGvGg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hyunchul Lee <hyc.lee@gmail.com>, Yufan Chen <wiz.chen@gmail.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, sfrench@samba.org,
        linux-cifs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 32/60] ksmbd: smbd: fix connection dropped issue
Date:   Tue,  7 Jun 2022 13:52:29 -0400
Message-Id: <20220607175259.478835-32-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220607175259.478835-1-sashal@kernel.org>
References: <20220607175259.478835-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hyunchul Lee <hyc.lee@gmail.com>

[ Upstream commit 5366afc4065075a4456941fbd51c33604d631ee5 ]

When there are bursty connection requests,
RDMA connection event handler is deferred and
Negotiation requests are received even if
connection status is NEW.

To handle it, set the status to CONNECTED
if Negotiation requests are received.

Reported-by: Yufan Chen <wiz.chen@gmail.com>
Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
Tested-by: Yufan Chen <wiz.chen@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/transport_rdma.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ksmbd/transport_rdma.c b/fs/ksmbd/transport_rdma.c
index ba5a22bc2e6d..d3b60b833a81 100644
--- a/fs/ksmbd/transport_rdma.c
+++ b/fs/ksmbd/transport_rdma.c
@@ -569,6 +569,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 		}
 		t->negotiation_requested = true;
 		t->full_packet_received = true;
+		t->status = SMB_DIRECT_CS_CONNECTED;
 		enqueue_reassembly(t, recvmsg, 0);
 		wake_up_interruptible(&t->wait_status);
 		break;
-- 
2.35.1


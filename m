Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91A0C6CC2D3
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:49:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233394AbjC1OtH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:49:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233396AbjC1Oso (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:48:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D893E078
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:48:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 00E846182C
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:47:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14C0FC433D2;
        Tue, 28 Mar 2023 14:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680014870;
        bh=0IUXgK7/dHVxPwjwJoaOsFqx+zR1jF+V2KTemtsJvCw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uqTXL9Z0yywfOcCzgRA5ydfBtC/1U8jnDod43vXDusrdGVc/z7r54RYao4/gRpwty
         QbyHLLlyBXSlplqx41nqQbKJazZHFK6iNtyjTwrzpjr1ptIYfY/IlswagA4LhLXUtq
         uZYMmkauNhMosmUaTgUo87vOkipK0AkSYN/a9wic=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Geert Uytterhoeven <geert@linux-m68k.org>,
        Caleb Sander <csander@purestorage.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 083/240] nvme-tcp: fix nvme_tcp_term_pdu to match spec
Date:   Tue, 28 Mar 2023 16:40:46 +0200
Message-Id: <20230328142623.241867278@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Caleb Sander <csander@purestorage.com>

[ Upstream commit aa01c67de5926fdb276793180564f172c55fb0d7 ]

The FEI field of C2HTermReq/H2CTermReq is 4 bytes but not 4-byte-aligned
in the NVMe/TCP specification (it is located at offset 10 in the PDU).
Split it into two 16-bit integers in struct nvme_tcp_term_pdu
so no padding is inserted. There should also be 10 reserved bytes after.
There are currently no users of this type.

Fixes: fc221d05447aa6db ("nvme-tcp: Add protocol header")
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Caleb Sander <csander@purestorage.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/nvme-tcp.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/nvme-tcp.h b/include/linux/nvme-tcp.h
index 75470159a194d..57ebe1267f7fb 100644
--- a/include/linux/nvme-tcp.h
+++ b/include/linux/nvme-tcp.h
@@ -115,8 +115,9 @@ struct nvme_tcp_icresp_pdu {
 struct nvme_tcp_term_pdu {
 	struct nvme_tcp_hdr	hdr;
 	__le16			fes;
-	__le32			fei;
-	__u8			rsvd[8];
+	__le16			feil;
+	__le16			feiu;
+	__u8			rsvd[10];
 };
 
 /**
-- 
2.39.2




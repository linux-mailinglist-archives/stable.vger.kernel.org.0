Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5706680FCA
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 14:57:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236729AbjA3N5H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 08:57:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236673AbjA3N45 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 08:56:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DDE539CD8
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 05:56:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A808161016
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 13:56:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC795C433EF;
        Mon, 30 Jan 2023 13:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087015;
        bh=9WRNRg/svYTCI+j8TrDYna3d/yvEpheTY4RyPdgAuxs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CFLxXwvyk99nYAjtdVxfC1zQv5ce2VOdcbuJUO11T54uywMD23yBP3SdVN26vLyWT
         GycBxOWOcT5uO7lRUa0O2kT1cVbNSszt081oNUoCP6yfz3NqUXNlpR1Eb6INss/AlU
         DuekIbC8Nmu2+Hbl17KHjDxc0k3zhyRbFiZ0vQIA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Daisuke Matsuda <matsuda-daisuke@fujitsu.com>,
        Li Zhijian <lizhijian@fujitsu.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 042/313] RDMA/rxe: Prevent faulty rkey generation
Date:   Mon, 30 Jan 2023 14:47:57 +0100
Message-Id: <20230130134338.649935752@linuxfoundation.org>
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

From: Daisuke Matsuda <matsuda-daisuke@fujitsu.com>

[ Upstream commit 1aefe5c177c1922119afb4ee443ddd6ac3140b37 ]

If you create MRs more than 0x10000 times after loading the module,
responder starts to reply NAKs for RDMA/Atomic operations because of rkey
violation detected in check_rkey(). The root cause is that rkeys are
incremented each time a new MR is created and the value overflows into the
range reserved for MWs.

This commit also increases the value of RXE_MAX_MW that has been limited
unlike other parameters.

Fixes: 0994a1bcd5f7 ("RDMA/rxe: Bump up default maximum values used via uverbs")
Link: https://lore.kernel.org/r/20221220080848.253785-2-matsuda-daisuke@fujitsu.com
Signed-off-by: Daisuke Matsuda <matsuda-daisuke@fujitsu.com>
Tested-by: Li Zhijian <lizhijian@fujitsu.com>
Reviewed-by: Li Zhijian <lizhijian@fujitsu.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_param.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_param.h b/drivers/infiniband/sw/rxe/rxe_param.h
index 86c7a8bf3cbb..fa41009ce8a9 100644
--- a/drivers/infiniband/sw/rxe/rxe_param.h
+++ b/drivers/infiniband/sw/rxe/rxe_param.h
@@ -91,11 +91,11 @@ enum rxe_device_param {
 	RXE_MAX_SRQ			= DEFAULT_MAX_VALUE - RXE_MIN_SRQ_INDEX,
 
 	RXE_MIN_MR_INDEX		= 0x00000001,
-	RXE_MAX_MR_INDEX		= DEFAULT_MAX_VALUE,
-	RXE_MAX_MR			= DEFAULT_MAX_VALUE - RXE_MIN_MR_INDEX,
-	RXE_MIN_MW_INDEX		= 0x00010001,
-	RXE_MAX_MW_INDEX		= 0x00020000,
-	RXE_MAX_MW			= 0x00001000,
+	RXE_MAX_MR_INDEX		= DEFAULT_MAX_VALUE >> 1,
+	RXE_MAX_MR			= RXE_MAX_MR_INDEX - RXE_MIN_MR_INDEX,
+	RXE_MIN_MW_INDEX		= RXE_MAX_MR_INDEX + 1,
+	RXE_MAX_MW_INDEX		= DEFAULT_MAX_VALUE,
+	RXE_MAX_MW			= RXE_MAX_MW_INDEX - RXE_MIN_MW_INDEX,
 
 	RXE_MAX_PKT_PER_ACK		= 64,
 
-- 
2.39.0




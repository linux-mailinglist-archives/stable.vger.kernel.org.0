Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36AD7628052
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:05:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237773AbiKNNFE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:05:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237766AbiKNNFD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:05:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE5452A273
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:05:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6BBAF6116E
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:05:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A359C433D6;
        Mon, 14 Nov 2022 13:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668431100;
        bh=s4W4fwJdRilC4O81TMR/g7E7VZx+4jvI1Er/F/4ZOC8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KTdSBOZxxeRu69d0oRnhC2xOjU1+vUcuGE+S9RujhCmYoQeNXT0ByIEDfzv2VVvH/
         ka5dE21uCwVfIFIvhmKbQPaFBBZMP58VgFB+54O2wYvHXbgVKIBWbItQBWCNxsTl63
         4fir4eb5Cue1OK58dD1eoVFLEyh63hQe02Xs8c1w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhengchao Shao <shaozhengchao@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 100/190] cxgb4vf: shut down the adapter when t4vf_update_port_info() failed in cxgb4vf_open()
Date:   Mon, 14 Nov 2022 13:45:24 +0100
Message-Id: <20221114124503.070820325@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
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

From: Zhengchao Shao <shaozhengchao@huawei.com>

[ Upstream commit c6092ea1e6d7bd12acd881f6aa2b5054cd70e096 ]

When t4vf_update_port_info() failed in cxgb4vf_open(), resources applied
during adapter goes up are not cleared. Fix it. Only be compiled, not be
tested.

Fixes: 18d79f721e0a ("cxgb4vf: Update port information in cxgb4vf_open()")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Link: https://lore.kernel.org/r/20221109012100.99132-1-shaozhengchao@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
index c2822e635f89..40bb473ec3c8 100644
--- a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
@@ -858,7 +858,7 @@ static int cxgb4vf_open(struct net_device *dev)
 	 */
 	err = t4vf_update_port_info(pi);
 	if (err < 0)
-		return err;
+		goto err_unwind;
 
 	/*
 	 * Note that this interface is up and start everything up ...
-- 
2.35.1




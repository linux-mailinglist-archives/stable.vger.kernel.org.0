Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DAFE6ECDA0
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:25:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232174AbjDXNZL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:25:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232122AbjDXNZJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:25:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B1B599
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:25:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9BF02622A3
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:25:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD62EC433EF;
        Mon, 24 Apr 2023 13:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682342701;
        bh=tQmjXt9Cc7Z6kWHWMyjev3Vj4rxIBivhPAu7q7T9ULg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=def8QW0hmtUy7LaS1e2Shf/E5kHXhKfarQAxZYGdow7lJqYg8t0+zf/ajMFPqScQc
         p9/F6Ae9wQRbXenBY4QCcmhBQGX3JTP8zGRLIHnzoHkmi+5Xr+zSh2yO8OLUT6eh7G
         oRnjESzv7V/zabCCpkciOhyFG2bIhVdkg4rEJ+N0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
        Ido Schimmel <idosch@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        Natalia Petrova <n.petrova@fintech.ru>
Subject: [PATCH 6.1 25/98] mlxfw: fix null-ptr-deref in mlxfw_mfa2_tlv_next()
Date:   Mon, 24 Apr 2023 15:16:48 +0200
Message-Id: <20230424131134.873374777@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131133.829259077@linuxfoundation.org>
References: <20230424131133.829259077@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikita Zhandarovich <n.zhandarovich@fintech.ru>

[ Upstream commit c0e73276f0fcbbd3d4736ba975d7dc7a48791b0c ]

Function mlxfw_mfa2_tlv_multi_get() returns NULL if 'tlv' in
question does not pass checks in mlxfw_mfa2_tlv_payload_get(). This
behaviour may lead to NULL pointer dereference in 'multi->total_len'.
Fix this issue by testing mlxfw_mfa2_tlv_multi_get()'s return value
against NULL.

Found by Linux Verification Center (linuxtesting.org) with static
analysis tool SVACE.

Fixes: 410ed13cae39 ("Add the mlxfw module for Mellanox firmware flash process")
Co-developed-by: Natalia Petrova <n.petrova@fintech.ru>
Signed-off-by: Nikita Zhandarovich <n.zhandarovich@fintech.ru>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://lore.kernel.org/r/20230417120718.52325-1-n.zhandarovich@fintech.ru
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxfw/mlxfw_mfa2_tlv_multi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxfw/mlxfw_mfa2_tlv_multi.c b/drivers/net/ethernet/mellanox/mlxfw/mlxfw_mfa2_tlv_multi.c
index 017d68f1e1232..972c571b41587 100644
--- a/drivers/net/ethernet/mellanox/mlxfw/mlxfw_mfa2_tlv_multi.c
+++ b/drivers/net/ethernet/mellanox/mlxfw/mlxfw_mfa2_tlv_multi.c
@@ -31,6 +31,8 @@ mlxfw_mfa2_tlv_next(const struct mlxfw_mfa2_file *mfa2_file,
 
 	if (tlv->type == MLXFW_MFA2_TLV_MULTI_PART) {
 		multi = mlxfw_mfa2_tlv_multi_get(mfa2_file, tlv);
+		if (!multi)
+			return NULL;
 		tlv_len = NLA_ALIGN(tlv_len + be16_to_cpu(multi->total_len));
 	}
 
-- 
2.39.2




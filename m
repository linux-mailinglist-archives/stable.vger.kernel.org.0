Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85BD351A67C
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 18:52:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353740AbiEDQzv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 12:55:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354378AbiEDQyT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 12:54:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B403C48E65;
        Wed,  4 May 2022 09:49:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 23088B82554;
        Wed,  4 May 2022 16:49:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97C74C385A4;
        Wed,  4 May 2022 16:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651682962;
        bh=7UGrPbkL3mYLsjzscYcZE/zfktti2BswDX5yf8bg4RM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2MJMpZ+JP8qk6wRFR4KHBJRMtSdLl4LUHagS+EX42joG0SoFGkG7MjFUfl51YX7gO
         KsRlo9cwm29Ne0Oc2DZCs2KPhpKWO7cN3DaIjuKi4irjJu3Ngj00tElDIe5xJHkeRY
         J6qDUDLaWkOX+w+vkXcOWG57o5iBOZMX7QDFyIyU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Mikityanskiy <maximmi@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 64/84] tls: Skip tls_append_frag on zero copy size
Date:   Wed,  4 May 2022 18:44:45 +0200
Message-Id: <20220504152932.352464759@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504152927.744120418@linuxfoundation.org>
References: <20220504152927.744120418@linuxfoundation.org>
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

From: Maxim Mikityanskiy <maximmi@nvidia.com>

[ Upstream commit a0df71948e9548de819a6f1da68f5f1742258a52 ]

Calling tls_append_frag when max_open_record_len == record->len might
add an empty fragment to the TLS record if the call happens to be on the
page boundary. Normally tls_append_frag coalesces the zero-sized
fragment to the previous one, but not if it's on page boundary.

If a resync happens then, the mlx5 driver posts dump WQEs in
tx_post_resync_dump, and the empty fragment may become a data segment
with byte_count == 0, which will confuse the NIC and lead to a CQE
error.

This commit fixes the described issue by skipping tls_append_frag on
zero size to avoid adding empty fragments. The fix is not in the driver,
because an empty fragment is hardly the desired behavior.

Fixes: e8f69799810c ("net/tls: Add generic NIC offload infrastructure")
Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://lore.kernel.org/r/20220426154949.159055-1-maximmi@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_device.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index 0f034c3bc37d..abb93f7343c5 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -470,11 +470,13 @@ static int tls_push_data(struct sock *sk,
 		copy = min_t(size_t, size, (pfrag->size - pfrag->offset));
 		copy = min_t(size_t, copy, (max_open_record_len - record->len));
 
-		rc = tls_device_copy_data(page_address(pfrag->page) +
-					  pfrag->offset, copy, msg_iter);
-		if (rc)
-			goto handle_error;
-		tls_append_frag(record, pfrag, copy);
+		if (copy) {
+			rc = tls_device_copy_data(page_address(pfrag->page) +
+						  pfrag->offset, copy, msg_iter);
+			if (rc)
+				goto handle_error;
+			tls_append_frag(record, pfrag, copy);
+		}
 
 		size -= copy;
 		if (!size) {
-- 
2.35.1




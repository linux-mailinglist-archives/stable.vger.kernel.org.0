Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D854758696F
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 14:02:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232774AbiHAMCa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 08:02:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233745AbiHAMBq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 08:01:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A33743E4B;
        Mon,  1 Aug 2022 04:53:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C2346B81163;
        Mon,  1 Aug 2022 11:53:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D275C433D6;
        Mon,  1 Aug 2022 11:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659354822;
        bh=RrVXgdvfQtwSt4RGJnS3IJQPKE/wnM+B5zyTBr4hOo8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ELpb/MT1KfLmBhSIxfjNVkIbV4RgPW8GgU27aGSDLVjdne6zNq6zotU2Nz3slU7i9
         HUc/mM0nhOfAa99ddOzNWKSlHimCxBk5U0vb1IemldagZkePfv7n8TZY4mVy+Vieiq
         a11PRgQLHoML6QxMSAArfIM4jI48Qa6N3OxaOkLM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Mikityanskiy <maximmi@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 32/69] net/tls: Remove the context from the list in tls_device_down
Date:   Mon,  1 Aug 2022 13:46:56 +0200
Message-Id: <20220801114135.810497549@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220801114134.468284027@linuxfoundation.org>
References: <20220801114134.468284027@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

commit f6336724a4d4220c89a4ec38bca84b03b178b1a3 upstream.

tls_device_down takes a reference on all contexts it's going to move to
the degraded state (software fallback). If sk_destruct runs afterwards,
it can reduce the reference counter back to 1 and return early without
destroying the context. Then tls_device_down will release the reference
it took and call tls_device_free_ctx. However, the context will still
stay in tls_device_down_list forever. The list will contain an item,
memory for which is released, making a memory corruption possible.

Fix the above bug by properly removing the context from all lists before
any call to tls_device_free_ctx.

Fixes: 3740651bf7e2 ("tls: Fix context leak on tls_device_down")
Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tls/tls_device.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -1351,8 +1351,13 @@ static int tls_device_down(struct net_de
 		 * by tls_device_free_ctx. rx_conf and tx_conf stay in TLS_HW.
 		 * Now release the ref taken above.
 		 */
-		if (refcount_dec_and_test(&ctx->refcount))
+		if (refcount_dec_and_test(&ctx->refcount)) {
+			/* sk_destruct ran after tls_device_down took a ref, and
+			 * it returned early. Complete the destruction here.
+			 */
+			list_del(&ctx->list);
 			tls_device_free_ctx(ctx);
+		}
 	}
 
 	up_write(&device_offload_lock);



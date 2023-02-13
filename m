Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B99E3694A25
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 16:05:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231430AbjBMPFF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 10:05:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231435AbjBMPEu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 10:04:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E59B1E1DB
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 07:04:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BE1DDB81256
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 15:04:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FA8FC433EF;
        Mon, 13 Feb 2023 15:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300681;
        bh=kqsj8GBwo3z2c6F2QSkJYt1xH92vpxSTSaPaCIOJuf8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hffq1VkETljg4woxaqoDt1EAk7fRTQ0gUd17VVMW4F8Com9g8WrCdc8Wzw+mtELBD
         EnMqqpVGcXn4UmkpZBIvPwVI9me/GP5tz2dn2Y6LFRHoqwAHUc4KCzfnc8VTGzhTPd
         ZgstBp9l2pm6GTa/4mpowel+ONqIfU5n6h67jWPA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Eric Dumazet <edumazet@google.com>,
        Dmitry Safonov <dima@arista.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 108/139] xfrm/compat: prevent potential spectre v1 gadget in xfrm_xlate32_attr()
Date:   Mon, 13 Feb 2023 15:50:53 +0100
Message-Id: <20230213144751.579995433@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144745.696901179@linuxfoundation.org>
References: <20230213144745.696901179@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit b6ee896385380aa621102e8ea402ba12db1cabff ]

  int type = nla_type(nla);

  if (type > XFRMA_MAX) {
            return -EOPNOTSUPP;
  }

@type is then used as an array index and can be used
as a Spectre v1 gadget.

  if (nla_len(nla) < compat_policy[type].len) {

array_index_nospec() can be used to prevent leaking
content of kernel memory to malicious users.

Fixes: 5106f4a8acff ("xfrm/compat: Add 32=>64-bit messages translator")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Dmitry Safonov <dima@arista.com>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Reviewed-by: Dmitry Safonov <dima@arista.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_compat.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/xfrm/xfrm_compat.c b/net/xfrm/xfrm_compat.c
index 12405aa5bce84..8cbf45a8bcdc2 100644
--- a/net/xfrm/xfrm_compat.c
+++ b/net/xfrm/xfrm_compat.c
@@ -5,6 +5,7 @@
  * Based on code and translator idea by: Florian Westphal <fw@strlen.de>
  */
 #include <linux/compat.h>
+#include <linux/nospec.h>
 #include <linux/xfrm.h>
 #include <net/xfrm.h>
 
@@ -437,6 +438,7 @@ static int xfrm_xlate32_attr(void *dst, const struct nlattr *nla,
 		NL_SET_ERR_MSG(extack, "Bad attribute");
 		return -EOPNOTSUPP;
 	}
+	type = array_index_nospec(type, XFRMA_MAX + 1);
 	if (nla_len(nla) < compat_policy[type].len) {
 		NL_SET_ERR_MSG(extack, "Attribute bad length");
 		return -EOPNOTSUPP;
-- 
2.39.0




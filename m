Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3A4F694A46
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 16:06:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231469AbjBMPF7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 10:05:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229986AbjBMPF6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 10:05:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBF3D1DB8D
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 07:05:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 511DF6115B
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 15:05:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64229C433EF;
        Mon, 13 Feb 2023 15:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300751;
        bh=pRAFlcwQSv7P+/yxBg7PGzKKAbAVtwwAvtiFsm3hwPs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PcIS1wajv++Pi8VffeAV0nDR9LB7jcPRSiG/N5aOi87yqhbgO+ClyEr1XP8jmn0YK
         6xoHgh9vknV1LnoP8TwDLWehWrKfeRRylBZ3aupLKku2+eefLw9dgIdh5OpUhp88H5
         8EEN4fgZpB5n4MosaCxAkLbUixV6nNaJSRvC01kM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Anastasia Belova <abelova@astralinux.ru>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 106/139] xfrm: compat: change expression for switch in xfrm_xlate64
Date:   Mon, 13 Feb 2023 15:50:51 +0100
Message-Id: <20230213144751.459622776@linuxfoundation.org>
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

From: Anastasia Belova <abelova@astralinux.ru>

[ Upstream commit eb6c59b735aa6cca77cdbb59cc69d69a0d63d986 ]

Compare XFRM_MSG_NEWSPDINFO (value from netlink
configuration messages enum) with nlh_src->nlmsg_type
instead of nlh_src->nlmsg_type - XFRM_MSG_BASE.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 4e9505064f58 ("net/xfrm/compat: Copy xfrm_spdattr_type_t atributes")
Signed-off-by: Anastasia Belova <abelova@astralinux.ru>
Acked-by: Dmitry Safonov <0x7f454c46@gmail.com>
Tested-by: Dmitry Safonov <0x7f454c46@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_compat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_compat.c b/net/xfrm/xfrm_compat.c
index a0f62fa02e06e..12405aa5bce84 100644
--- a/net/xfrm/xfrm_compat.c
+++ b/net/xfrm/xfrm_compat.c
@@ -302,7 +302,7 @@ static int xfrm_xlate64(struct sk_buff *dst, const struct nlmsghdr *nlh_src)
 	nla_for_each_attr(nla, attrs, len, remaining) {
 		int err;
 
-		switch (type) {
+		switch (nlh_src->nlmsg_type) {
 		case XFRM_MSG_NEWSPDINFO:
 			err = xfrm_nla_cpy(dst, nla, nla_len(nla));
 			break;
-- 
2.39.0




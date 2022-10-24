Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE1760A56D
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:25:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233462AbiJXMYv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:24:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233549AbiJXMXs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:23:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 887C6237ED;
        Mon, 24 Oct 2022 04:59:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC43D61252;
        Mon, 24 Oct 2022 11:59:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE7DBC433D6;
        Mon, 24 Oct 2022 11:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612788;
        bh=OYkkBGYFwO3XqTSXEnulGFuXbO6MZt4+eTDcMl83zT4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e+GGKs9YeUZRtEMf8DLY5nmad7yt+S6SMTyierEy/FJYDk+wd8gpN4Mc8RXuv11Gz
         a0dOQh6XvSaB2ZhvKqmUnUrvCwfORInSF51nBCpMFO5rW4a6AGqM9ppn681njlNiwy
         Ag8I6MFC1jd205J72pgjRkuP6xyMCO66rK7dfvTs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+a236dd8e9622ed8954a3@syzkaller.appspotmail.com,
        Xin Long <lucien.xin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 088/229] sctp: handle the error returned from sctp_auth_asoc_init_active_key
Date:   Mon, 24 Oct 2022 13:30:07 +0200
Message-Id: <20221024113001.902489012@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112959.085534368@linuxfoundation.org>
References: <20221024112959.085534368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 022152aaebe116a25c39818a07e175a8cd3c1e11 ]

When it returns an error from sctp_auth_asoc_init_active_key(), the
active_key is actually not updated. The old sh_key will be freeed
while it's still used as active key in asoc. Then an use-after-free
will be triggered when sending patckets, as found by syzbot:

  sctp_auth_shkey_hold+0x22/0xa0 net/sctp/auth.c:112
  sctp_set_owner_w net/sctp/socket.c:132 [inline]
  sctp_sendmsg_to_asoc+0xbd5/0x1a20 net/sctp/socket.c:1863
  sctp_sendmsg+0x1053/0x1d50 net/sctp/socket.c:2025
  inet_sendmsg+0x99/0xe0 net/ipv4/af_inet.c:819
  sock_sendmsg_nosec net/socket.c:714 [inline]
  sock_sendmsg+0xcf/0x120 net/socket.c:734

This patch is to fix it by not replacing the sh_key when it returns
errors from sctp_auth_asoc_init_active_key() in sctp_auth_set_key().
For sctp_auth_set_active_key(), old active_key_id will be set back
to asoc->active_key_id when the same thing happens.

Fixes: 58acd1009226 ("sctp: update active_key for asoc when old key is being replaced")
Reported-by: syzbot+a236dd8e9622ed8954a3@syzkaller.appspotmail.com
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/auth.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/net/sctp/auth.c b/net/sctp/auth.c
index 9e0c98df20da..9cf61a18098a 100644
--- a/net/sctp/auth.c
+++ b/net/sctp/auth.c
@@ -886,12 +886,17 @@ int sctp_auth_set_key(struct sctp_endpoint *ep,
 	}
 
 	list_del_init(&shkey->key_list);
-	sctp_auth_shkey_release(shkey);
 	list_add(&cur_key->key_list, sh_keys);
 
-	if (asoc && asoc->active_key_id == auth_key->sca_keynumber)
-		sctp_auth_asoc_init_active_key(asoc, GFP_KERNEL);
+	if (asoc && asoc->active_key_id == auth_key->sca_keynumber &&
+	    sctp_auth_asoc_init_active_key(asoc, GFP_KERNEL)) {
+		list_del_init(&cur_key->key_list);
+		sctp_auth_shkey_release(cur_key);
+		list_add(&shkey->key_list, sh_keys);
+		return -ENOMEM;
+	}
 
+	sctp_auth_shkey_release(shkey);
 	return 0;
 }
 
@@ -920,8 +925,13 @@ int sctp_auth_set_active_key(struct sctp_endpoint *ep,
 		return -EINVAL;
 
 	if (asoc) {
+		__u16  active_key_id = asoc->active_key_id;
+
 		asoc->active_key_id = key_id;
-		sctp_auth_asoc_init_active_key(asoc, GFP_KERNEL);
+		if (sctp_auth_asoc_init_active_key(asoc, GFP_KERNEL)) {
+			asoc->active_key_id = active_key_id;
+			return -ENOMEM;
+		}
 	} else
 		ep->active_key_id = key_id;
 
-- 
2.35.1




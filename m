Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 203766E63BB
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:43:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231942AbjDRMm7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:42:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231949AbjDRMmt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:42:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A426D1561A
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:42:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5EEEC63339
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:42:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 729CCC4339B;
        Tue, 18 Apr 2023 12:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821756;
        bh=0mt26iVTqwPUcTu9GZ1KJp1Pi0NpaixLhjWQmQt46oA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lVpoMD1FGqvoFf541GnREt06kcUtChE57mFTvO82y7cuoCzFbK/KtcFTGRVKrvoZu
         5gbPZJrnD70z42/28RAbvwIXGu3/NhaTI1kFIvBoBw/ssx6+Gc3O2Zxq/uidCwe/Nw
         LFMtu6uNIOPvNAYpARejw4v+RYHzZFy4GxvGSGl0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, stable@kernel.org,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Min Li <lm0963hack@gmail.com>
Subject: [PATCH 6.1 012/134] Bluetooth: L2CAP: Fix use-after-free in l2cap_disconnect_{req,rsp}
Date:   Tue, 18 Apr 2023 14:21:08 +0200
Message-Id: <20230418120313.425293208@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.001025904@linuxfoundation.org>
References: <20230418120313.001025904@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

commit a2a9339e1c9deb7e1e079e12e27a0265aea8421a upstream.

Similar to commit d0be8347c623 ("Bluetooth: L2CAP: Fix use-after-free
caused by l2cap_chan_put"), just use l2cap_chan_hold_unless_zero to
prevent referencing a channel that is about to be destroyed.

Cc: stable@kernel.org
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Min Li <lm0963hack@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/l2cap_core.c |   24 ++++++------------------
 1 file changed, 6 insertions(+), 18 deletions(-)

--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -4652,33 +4652,27 @@ static inline int l2cap_disconnect_req(s
 
 	BT_DBG("scid 0x%4.4x dcid 0x%4.4x", scid, dcid);
 
-	mutex_lock(&conn->chan_lock);
-
-	chan = __l2cap_get_chan_by_scid(conn, dcid);
+	chan = l2cap_get_chan_by_scid(conn, dcid);
 	if (!chan) {
-		mutex_unlock(&conn->chan_lock);
 		cmd_reject_invalid_cid(conn, cmd->ident, dcid, scid);
 		return 0;
 	}
 
-	l2cap_chan_hold(chan);
-	l2cap_chan_lock(chan);
-
 	rsp.dcid = cpu_to_le16(chan->scid);
 	rsp.scid = cpu_to_le16(chan->dcid);
 	l2cap_send_cmd(conn, cmd->ident, L2CAP_DISCONN_RSP, sizeof(rsp), &rsp);
 
 	chan->ops->set_shutdown(chan);
 
+	mutex_lock(&conn->chan_lock);
 	l2cap_chan_del(chan, ECONNRESET);
+	mutex_unlock(&conn->chan_lock);
 
 	chan->ops->close(chan);
 
 	l2cap_chan_unlock(chan);
 	l2cap_chan_put(chan);
 
-	mutex_unlock(&conn->chan_lock);
-
 	return 0;
 }
 
@@ -4698,33 +4692,27 @@ static inline int l2cap_disconnect_rsp(s
 
 	BT_DBG("dcid 0x%4.4x scid 0x%4.4x", dcid, scid);
 
-	mutex_lock(&conn->chan_lock);
-
-	chan = __l2cap_get_chan_by_scid(conn, scid);
+	chan = l2cap_get_chan_by_scid(conn, scid);
 	if (!chan) {
 		mutex_unlock(&conn->chan_lock);
 		return 0;
 	}
 
-	l2cap_chan_hold(chan);
-	l2cap_chan_lock(chan);
-
 	if (chan->state != BT_DISCONN) {
 		l2cap_chan_unlock(chan);
 		l2cap_chan_put(chan);
-		mutex_unlock(&conn->chan_lock);
 		return 0;
 	}
 
+	mutex_lock(&conn->chan_lock);
 	l2cap_chan_del(chan, 0);
+	mutex_unlock(&conn->chan_lock);
 
 	chan->ops->close(chan);
 
 	l2cap_chan_unlock(chan);
 	l2cap_chan_put(chan);
 
-	mutex_unlock(&conn->chan_lock);
-
 	return 0;
 }
 



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6C5259395F
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245711AbiHOTJy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:09:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245713AbiHOTID (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:08:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 851ED101EF;
        Mon, 15 Aug 2022 11:35:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B1B9360FFD;
        Mon, 15 Aug 2022 18:35:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB0A4C433C1;
        Mon, 15 Aug 2022 18:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588535;
        bh=F95PSIpBk6avvNgsm9Kq89di+aGOxNqnEsA06KSo27c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IVUlc8fl8YoVehIDzBW58z3wE2Xxj9NY3UkC/OyLFdP19xsTy8m7GMNx16HVkyB29
         EPwulJz6jxqaSQ2eJInWcLx9EOhq93Wb9HVsmxKhBHZ351Zhy7eA+OZyOzBx6BAO7E
         s5JpnoisnOkUG5mDjurHSRxOkFAMPgj5k6vdA10Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nilesh Javali <njavali@marvell.com>,
        Mike Christie <michael.christie@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 435/779] scsi: iscsi: Allow iscsi_if_stop_conn() to be called from kernel
Date:   Mon, 15 Aug 2022 20:01:19 +0200
Message-Id: <20220815180355.880296578@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Christie <michael.christie@oracle.com>

[ Upstream commit 3328333b47f4163504267440ec0a36087a407a5f ]

iscsi_if_stop_conn() is only called from the userspace interface but in a
subsequent commit we will want to call it from the kernel interface to
allow drivers like qedi to remove sessions from inside the kernel during
shutdown. This removes the iscsi_uevent code from iscsi_if_stop_conn() so we
can call it in a new helper.

Link: https://lore.kernel.org/r/20220616222738.5722-3-michael.christie@oracle.com
Tested-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_transport_iscsi.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 5947b9d5746e..671a03b80c30 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -2283,16 +2283,8 @@ static void iscsi_if_disconnect_bound_ep(struct iscsi_cls_conn *conn,
 	}
 }
 
-static int iscsi_if_stop_conn(struct iscsi_transport *transport,
-			      struct iscsi_uevent *ev)
+static int iscsi_if_stop_conn(struct iscsi_cls_conn *conn, int flag)
 {
-	int flag = ev->u.stop_conn.flag;
-	struct iscsi_cls_conn *conn;
-
-	conn = iscsi_conn_lookup(ev->u.stop_conn.sid, ev->u.stop_conn.cid);
-	if (!conn)
-		return -EINVAL;
-
 	ISCSI_DBG_TRANS_CONN(conn, "iscsi if conn stop.\n");
 	/*
 	 * If this is a termination we have to call stop_conn with that flag
@@ -3739,7 +3731,12 @@ static int iscsi_if_transport_conn(struct iscsi_transport *transport,
 	case ISCSI_UEVENT_DESTROY_CONN:
 		return iscsi_if_destroy_conn(transport, ev);
 	case ISCSI_UEVENT_STOP_CONN:
-		return iscsi_if_stop_conn(transport, ev);
+		conn = iscsi_conn_lookup(ev->u.stop_conn.sid,
+					 ev->u.stop_conn.cid);
+		if (!conn)
+			return -EINVAL;
+
+		return iscsi_if_stop_conn(conn, ev->u.stop_conn.flag);
 	}
 
 	/*
-- 
2.35.1




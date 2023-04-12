Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B92BB6DEE36
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:41:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230486AbjDLIlI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:41:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231231AbjDLIkI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:40:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14AA07698
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:39:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E946C62FEE
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:38:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0596BC433EF;
        Wed, 12 Apr 2023 08:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681288695;
        bh=LvIrxnNgrbGbZzqtv/0d2T63F1ujuXg0Ff0fKsN2nFs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cdwqfmhH/yXuxBqDv4J/YVSoHHtwNDGHsRpoYfbZlJ9yeRokwU2fa1MyKL7BIpHlV
         Pg8whCtDwqOjbagoLmkFEnkphenLxeHSK25MHz+MdT3B1IKp1BHMaEmwwrBbEcnYE+
         ws5/5yDsgxpZJuI+zdC1eSXjxinIxyqLLJv4KNJY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhong Jinghua <zhongjinghua@huawei.com>,
        Mike Christie <michael.christie@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 75/93] scsi: iscsi_tcp: Check that sock is valid before iscsi_set_param()
Date:   Wed, 12 Apr 2023 10:34:16 +0200
Message-Id: <20230412082826.296311238@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082823.045155996@linuxfoundation.org>
References: <20230412082823.045155996@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhong Jinghua <zhongjinghua@huawei.com>

[ Upstream commit 48b19b79cfa37b1e50da3b5a8af529f994c08901 ]

The validity of sock should be checked before assignment to avoid incorrect
values. Commit 57569c37f0ad ("scsi: iscsi: iscsi_tcp: Fix null-ptr-deref
while calling getpeername()") introduced this change which may lead to
inconsistent values of tcp_sw_conn->sendpage and conn->datadgst_en.

Fix the issue by moving the position of the assignment.

Fixes: 57569c37f0ad ("scsi: iscsi: iscsi_tcp: Fix null-ptr-deref while calling getpeername()")
Signed-off-by: Zhong Jinghua <zhongjinghua@huawei.com>
Link: https://lore.kernel.org/r/20230329071739.2175268-1-zhongjinghua@huaweicloud.com
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/iscsi_tcp.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 5943360041907..fe705b8bf4643 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -767,13 +767,12 @@ static int iscsi_sw_tcp_conn_set_param(struct iscsi_cls_conn *cls_conn,
 		iscsi_set_param(cls_conn, param, buf, buflen);
 		break;
 	case ISCSI_PARAM_DATADGST_EN:
-		iscsi_set_param(cls_conn, param, buf, buflen);
-
 		mutex_lock(&tcp_sw_conn->sock_lock);
 		if (!tcp_sw_conn->sock) {
 			mutex_unlock(&tcp_sw_conn->sock_lock);
 			return -ENOTCONN;
 		}
+		iscsi_set_param(cls_conn, param, buf, buflen);
 		tcp_sw_conn->sendpage = conn->datadgst_en ?
 			sock_no_sendpage : tcp_sw_conn->sock->ops->sendpage;
 		mutex_unlock(&tcp_sw_conn->sock_lock);
-- 
2.39.2




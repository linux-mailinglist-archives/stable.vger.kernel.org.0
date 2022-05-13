Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 621C652645B
	for <lists+stable@lfdr.de>; Fri, 13 May 2022 16:30:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380964AbiEMO3Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 May 2022 10:29:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380956AbiEMO1d (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 May 2022 10:27:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 005CA5E751;
        Fri, 13 May 2022 07:27:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8E6C162155;
        Fri, 13 May 2022 14:27:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A68FC34100;
        Fri, 13 May 2022 14:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652452049;
        bh=sq81QGVFmgwEXyTV9tn2A2eomrsrJjkZ0LhxQElS6oM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KjOOgPcrL8dKnYexrL4irYkNQ4rc9unCDNm44+9jmFCtWE8EXtMdbdqlBXJvNqNNH
         RZmMo8fUn/VsLWjZcQWlxmKwYAKeyKuIXfztvzk6/E9HfbAe8+to8y2UU8+Ijd9bCS
         H+UXbLYNCx0DVP97m0T8zzbTNzVDdCHx8MMVvt90=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Philipp Reisner <philipp.reisner@linbit.com>,
        Lars Ellenberg <lars.ellenberg@linbit.com>,
        Jens Axboe <axboe@kernel.dk>, drbd-dev@lists.linbit.com,
        linux-block@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 5.10 03/10] block: drbd: drbd_nl: Make conversion to enum drbd_ret_code explicit
Date:   Fri, 13 May 2022 16:23:47 +0200
Message-Id: <20220513142228.405740832@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220513142228.303546319@linuxfoundation.org>
References: <20220513142228.303546319@linuxfoundation.org>
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

From: Lee Jones <lee.jones@linaro.org>

commit 1f1e87b4dc4598eac57a69868534b92d65e47e82 upstream.

Fixes the following W=1 kernel build warning(s):

 from drivers/block/drbd/drbd_nl.c:24:
 drivers/block/drbd/drbd_nl.c: In function ‘drbd_adm_set_role’:
 drivers/block/drbd/drbd_nl.c:793:11: warning: implicit conversion from ‘enum drbd_state_rv’ to ‘enum drbd_ret_code’ [-Wenum-conversion]
 drivers/block/drbd/drbd_nl.c:795:11: warning: implicit conversion from ‘enum drbd_state_rv’ to ‘enum drbd_ret_code’ [-Wenum-conversion]
 drivers/block/drbd/drbd_nl.c: In function ‘drbd_adm_attach’:
 drivers/block/drbd/drbd_nl.c:1965:10: warning: implicit conversion from ‘enum drbd_state_rv’ to ‘enum drbd_ret_code’ [-Wenum-conversion]
 drivers/block/drbd/drbd_nl.c: In function ‘drbd_adm_connect’:
 drivers/block/drbd/drbd_nl.c:2690:10: warning: implicit conversion from ‘enum drbd_state_rv’ to ‘enum drbd_ret_code’ [-Wenum-conversion]
 drivers/block/drbd/drbd_nl.c: In function ‘drbd_adm_disconnect’:
 drivers/block/drbd/drbd_nl.c:2803:11: warning: implicit conversion from ‘enum drbd_state_rv’ to ‘enum drbd_ret_code’ [-Wenum-conversion]

Cc: Philipp Reisner <philipp.reisner@linbit.com>
Cc: Lars Ellenberg <lars.ellenberg@linbit.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Cc: linux-block@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Link: https://lore.kernel.org/r/20210312105530.2219008-8-lee.jones@linaro.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Cc: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/drbd/drbd_nl.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -790,9 +790,11 @@ int drbd_adm_set_role(struct sk_buff *sk
 	mutex_lock(&adm_ctx.resource->adm_mutex);
 
 	if (info->genlhdr->cmd == DRBD_ADM_PRIMARY)
-		retcode = drbd_set_role(adm_ctx.device, R_PRIMARY, parms.assume_uptodate);
+		retcode = (enum drbd_ret_code)drbd_set_role(adm_ctx.device,
+						R_PRIMARY, parms.assume_uptodate);
 	else
-		retcode = drbd_set_role(adm_ctx.device, R_SECONDARY, 0);
+		retcode = (enum drbd_ret_code)drbd_set_role(adm_ctx.device,
+						R_SECONDARY, 0);
 
 	mutex_unlock(&adm_ctx.resource->adm_mutex);
 	genl_lock();
@@ -1962,7 +1964,7 @@ int drbd_adm_attach(struct sk_buff *skb,
 	drbd_flush_workqueue(&connection->sender_work);
 
 	rv = _drbd_request_state(device, NS(disk, D_ATTACHING), CS_VERBOSE);
-	retcode = rv;  /* FIXME: Type mismatch. */
+	retcode = (enum drbd_ret_code)rv;
 	drbd_resume_io(device);
 	if (rv < SS_SUCCESS)
 		goto fail;
@@ -2687,7 +2689,8 @@ int drbd_adm_connect(struct sk_buff *skb
 	}
 	rcu_read_unlock();
 
-	retcode = conn_request_state(connection, NS(conn, C_UNCONNECTED), CS_VERBOSE);
+	retcode = (enum drbd_ret_code)conn_request_state(connection,
+					NS(conn, C_UNCONNECTED), CS_VERBOSE);
 
 	conn_reconfig_done(connection);
 	mutex_unlock(&adm_ctx.resource->adm_mutex);
@@ -2800,7 +2803,7 @@ int drbd_adm_disconnect(struct sk_buff *
 	mutex_lock(&adm_ctx.resource->adm_mutex);
 	rv = conn_try_disconnect(connection, parms.force_disconnect);
 	if (rv < SS_SUCCESS)
-		retcode = rv;  /* FIXME: Type mismatch. */
+		retcode = (enum drbd_ret_code)rv;
 	else
 		retcode = NO_ERROR;
 	mutex_unlock(&adm_ctx.resource->adm_mutex);



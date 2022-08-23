Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D366D59D3CC
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 10:23:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241812AbiHWIJ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:09:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241809AbiHWIJO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:09:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D191B659ED;
        Tue, 23 Aug 2022 01:06:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5B6DAB81C19;
        Tue, 23 Aug 2022 08:06:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAA09C433D6;
        Tue, 23 Aug 2022 08:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661241960;
        bh=UCYycxyPUwO1hHOBKfBA1QUnk84cOVlOhcqdGlDU2ck=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KQ5ryCgSdJ757V5sgqtAeAiDWYQ3Co0t1gtWo+nTqzKvJ8AKD3ZyfiSk3lEN2Tb2m
         0MClVyAEgMopoq+CPz6lnUU0Gy/tS5PgJIRH3C47M42kCZPkqsfv7xbVuFx3NdTOTg
         6TA4iE3r230oolEQ8Kg2XORSOW4gXW43yflS2dGc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.19 006/365] rds: add missing barrier to release_refill
Date:   Tue, 23 Aug 2022 09:58:27 +0200
Message-Id: <20220823080118.421576569@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
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

From: Mikulas Patocka <mpatocka@redhat.com>

commit 9f414eb409daf4f778f011cf8266d36896bb930b upstream.

The functions clear_bit and set_bit do not imply a memory barrier, thus it
may be possible that the waitqueue_active function (which does not take
any locks) is moved before clear_bit and it could miss a wakeup event.

Fix this bug by adding a memory barrier after clear_bit.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rds/ib_recv.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/rds/ib_recv.c
+++ b/net/rds/ib_recv.c
@@ -363,6 +363,7 @@ static int acquire_refill(struct rds_con
 static void release_refill(struct rds_connection *conn)
 {
 	clear_bit(RDS_RECV_REFILL, &conn->c_flags);
+	smp_mb__after_atomic();
 
 	/* We don't use wait_on_bit()/wake_up_bit() because our waking is in a
 	 * hot path and finding waiters is very rare.  We don't want to walk



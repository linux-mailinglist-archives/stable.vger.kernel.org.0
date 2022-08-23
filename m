Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8847C59D5A9
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:10:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242894AbiHWI1H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:27:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243281AbiHWIYP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:24:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5371F26E8;
        Tue, 23 Aug 2022 01:13:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B16D8B81C20;
        Tue, 23 Aug 2022 08:13:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76D4BC433C1;
        Tue, 23 Aug 2022 08:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242407;
        bh=2YyPwhEPNlXy6bkw80TQrnvTxmp42HXmghTdlFH98xE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AnbFxEB8ara9zZEBaSoKm2cvdmgInE2wm1UTuX73u0XwzlBveORA5kgrsokDBJBQi
         RofvVj7/5SODyypMC9BOztnBN+mN/5M5qYxCempiNhInvz/hE9lut5tqyRRnbGU/CQ
         jXREonfl5BCRwmeQeuSvRih+47QB99DG4fcTpkEk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 067/101] rds: add missing barrier to release_refill
Date:   Tue, 23 Aug 2022 10:03:40 +0200
Message-Id: <20220823080037.128726077@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080034.579196046@linuxfoundation.org>
References: <20220823080034.579196046@linuxfoundation.org>
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
@@ -356,6 +356,7 @@ static int acquire_refill(struct rds_con
 static void release_refill(struct rds_connection *conn)
 {
 	clear_bit(RDS_RECV_REFILL, &conn->c_flags);
+	smp_mb__after_atomic();
 
 	/* We don't use wait_on_bit()/wake_up_bit() because our waking is in a
 	 * hot path and finding waiters is very rare.  We don't want to walk



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D11C651A92C
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:16:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356198AbiEDRRV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:17:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356274AbiEDRL4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:11:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 601754B85D;
        Wed,  4 May 2022 09:57:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EDBF6B827A4;
        Wed,  4 May 2022 16:57:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99A8CC385A5;
        Wed,  4 May 2022 16:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683457;
        bh=6Elx0oXf8pbyDQpAEzwHlIxpEwN9MDAQQX+4yMGajzg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eqUpLq8v88kBcvpOnmbmzWzKv601k56rkdbRMguzY1eyZkGItsh+yRDV1xihFZEnZ
         FGikyi3fuwi7Zi2HusVlqOKXx8mqn2WcorjZhP74IDgR6UI9LUtQLozvIp2/1vt26k
         +ZItnTfrl6AutsNHoaYYrWlfaEyzhli0HevmV82M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Rossi <nathan@nathanrossi.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>, Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 132/225] net: dsa: mv88e6xxx: Fix port_hidden_wait to account for port_base_addr
Date:   Wed,  4 May 2022 18:46:10 +0200
Message-Id: <20220504153122.110919171@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153110.096069935@linuxfoundation.org>
References: <20220504153110.096069935@linuxfoundation.org>
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

From: Nathan Rossi <nathan@nathanrossi.com>

[ Upstream commit 24cbdb910bb62b5be3865275e5682be1a7708c0f ]

The other port_hidden functions rely on the port_read/port_write
functions to access the hidden control port. These functions apply the
offset for port_base_addr where applicable. Update port_hidden_wait to
use the port_wait_bit so that port_base_addr offsets are accounted for
when waiting for the busy bit to change.

Without the offset the port_hidden_wait function would timeout on
devices that have a non-zero port_base_addr (e.g. MV88E6141), however
devices that have a zero port_base_addr would operate correctly (e.g.
MV88E6390).

Fixes: 609070133aff ("net: dsa: mv88e6xxx: update code operating on hidden registers")
Signed-off-by: Nathan Rossi <nathan@nathanrossi.com>
Reviewed-by: Marek Behún <kabel@kernel.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/20220425070454.348584-1-nathan@nathanrossi.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/port_hidden.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/port_hidden.c b/drivers/net/dsa/mv88e6xxx/port_hidden.c
index b49d05f0e117..7a9f9ff6dedf 100644
--- a/drivers/net/dsa/mv88e6xxx/port_hidden.c
+++ b/drivers/net/dsa/mv88e6xxx/port_hidden.c
@@ -40,8 +40,9 @@ int mv88e6xxx_port_hidden_wait(struct mv88e6xxx_chip *chip)
 {
 	int bit = __bf_shf(MV88E6XXX_PORT_RESERVED_1A_BUSY);
 
-	return mv88e6xxx_wait_bit(chip, MV88E6XXX_PORT_RESERVED_1A_CTRL_PORT,
-				  MV88E6XXX_PORT_RESERVED_1A, bit, 0);
+	return mv88e6xxx_port_wait_bit(chip,
+				       MV88E6XXX_PORT_RESERVED_1A_CTRL_PORT,
+				       MV88E6XXX_PORT_RESERVED_1A, bit, 0);
 }
 
 int mv88e6xxx_port_hidden_read(struct mv88e6xxx_chip *chip, int block, int port,
-- 
2.35.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 919A056FB45
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:27:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232254AbiGKJ1q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:27:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232255AbiGKJ1J (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:27:09 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDE65643D7;
        Mon, 11 Jul 2022 02:15:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 95D16CE125A;
        Mon, 11 Jul 2022 09:15:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80893C34115;
        Mon, 11 Jul 2022 09:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657530935;
        bh=RZqVaIfm4vVNEO6ke1jAxHBE44MuH8z1nMRH0nnAEFA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hTubfGU+f/PnnG0BWGTmv7CazD0RNFiZSo6PPcKh9ZIXqKyHh7M2EhWml1TyY09/O
         fYuwIH6RI3ssK+KglccabsE+ykuLnjQWatdjiW0s2vMZtqjKtxh9vdWmUcyJ+0xvy8
         b2WeFwVfAmJ3lBSQ2A2NthrOd6wRbREbKtJOWhhc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Torin Cooper-Bennun <torin@maxiluxsystems.com>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.18 008/112] can: m_can: m_can_chip_config(): actually enable internal timestamping
Date:   Mon, 11 Jul 2022 11:06:08 +0200
Message-Id: <20220711090549.788707971@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090549.543317027@linuxfoundation.org>
References: <20220711090549.543317027@linuxfoundation.org>
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

From: Marc Kleine-Budde <mkl@pengutronix.de>

commit 5b12933de4e76ec164031c18ce8e0904abf530d7 upstream.

In commit df06fd678260 ("can: m_can: m_can_chip_config(): enable and
configure internal timestamps") the timestamping in the m_can core
should be enabled. In peripheral mode, the RX'ed CAN frames, TX
compete frames and error events are sorted by the timestamp.

The above mentioned commit however forgot to enable the timestamping.
Add the missing bits to enable the timestamp counter to the write of
the Timestamp Counter Configuration register.

Link: https://lore.kernel.org/all/20220612212708.4081756-1-mkl@pengutronix.de
Fixes: df06fd678260 ("can: m_can: m_can_chip_config(): enable and configure internal timestamps")
Cc: <stable@vger.kernel.org> # 5.13
Cc: Torin Cooper-Bennun <torin@maxiluxsystems.com>
Reviewed-by: Chandrasekar Ramakrishnan <rcsekar@samsung.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/m_can/m_can.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1360,7 +1360,9 @@ static void m_can_chip_config(struct net
 	/* enable internal timestamp generation, with a prescalar of 16. The
 	 * prescalar is applied to the nominal bit timing
 	 */
-	m_can_write(cdev, M_CAN_TSCC, FIELD_PREP(TSCC_TCP_MASK, 0xf));
+	m_can_write(cdev, M_CAN_TSCC,
+		    FIELD_PREP(TSCC_TCP_MASK, 0xf) |
+		    FIELD_PREP(TSCC_TSS_MASK, TSCC_TSS_INTERNAL));
 
 	m_can_config_endisable(cdev, false);
 



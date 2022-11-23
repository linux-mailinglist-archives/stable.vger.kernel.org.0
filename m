Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2CFF635927
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 11:07:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236571AbiKWKGP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 05:06:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236730AbiKWKFR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 05:05:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58112122968
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:56:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 51521B81EF0
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:56:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A51FC433C1;
        Wed, 23 Nov 2022 09:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669197365;
        bh=uq07HycUuh2aczJEPzhjUVLluB6NOHBwxU9ddSm4wSQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0KKNAn1bB0LJqFwAKIIlzexFHEcfh8OfnP9CGSz12J50MyTiGG62u/ZVtaRGqK7BH
         fjMKzWOhuSyu1FAtvlZdBxbLo9BN80aP6uaBxBKlVjqd0HKbQW9usSOdJoZAVoOTlu
         H3ckYyN6jE0fsmKG5/Wq8olZijfmsuryWWyBdHZI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, stable <stable@kernel.org>,
        Sven Peter <sven@svenpeter.dev>,
        Eric Curtin <ecurtin@redhat.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        =?UTF-8?q?Guido=20G=C3=BCnther?= <agx@sigxcpu.org>
Subject: [PATCH 6.0 243/314] usb: typec: tipd: Prevent uninitialized event{1,2} in IRQ handler
Date:   Wed, 23 Nov 2022 09:51:28 +0100
Message-Id: <20221123084636.496667105@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Peter <sven@svenpeter.dev>

commit 6d8fc203b28ff8f6115fbe5eaf584de8b824f4fa upstream.

If reading TPS_REG_INT_EVENT1/2 fails in the interrupt handler event1
and event2 may be uninitialized when they are used to determine
IRQ_HANDLED vs. IRQ_NONE in the error path.

Fixes: c7260e29dd20 ("usb: typec: tipd: Add short-circuit for no irqs")
Fixes: 45188f27b3d0 ("usb: typec: tipd: Add support for Apple CD321X")
Cc: stable <stable@kernel.org>
Signed-off-by: Sven Peter <sven@svenpeter.dev>
Reviewed-by: Eric Curtin <ecurtin@redhat.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Guido Günther <agx@sigxcpu.org>
Link: https://lore.kernel.org/r/20221102161542.30669-1-sven@svenpeter.dev
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tipd/core.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/usb/typec/tipd/core.c
+++ b/drivers/usb/typec/tipd/core.c
@@ -474,7 +474,7 @@ static void tps6598x_handle_plug_event(s
 static irqreturn_t cd321x_interrupt(int irq, void *data)
 {
 	struct tps6598x *tps = data;
-	u64 event;
+	u64 event = 0;
 	u32 status;
 	int ret;
 
@@ -519,8 +519,8 @@ err_unlock:
 static irqreturn_t tps6598x_interrupt(int irq, void *data)
 {
 	struct tps6598x *tps = data;
-	u64 event1;
-	u64 event2;
+	u64 event1 = 0;
+	u64 event2 = 0;
 	u32 status;
 	int ret;
 



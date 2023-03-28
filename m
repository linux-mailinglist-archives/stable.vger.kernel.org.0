Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F1176CC302
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:50:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233370AbjC1Oul (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:50:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233380AbjC1Ou0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:50:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3851DBE5
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:49:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A1DF7B81BBF
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:49:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A808C433EF;
        Tue, 28 Mar 2023 14:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680014985;
        bh=4JbvwgLsdez8/IaGYiQmqfm5rp3xYPNMDHGBv9/YG58=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=clkqUZSNJ7rzQio6LiO6piyO+FRudBleu/TP+/yxfKd/evNS29gwIM3dza8LWWTcO
         VUczGRRRFpBkE84UqauZ2/ooG6tBwL1iJGMaUCs2KIVbXlDuadg5wV4QfGyRXp0NG0
         jbBcuJmsawFDmC/EA4M2ZHV3DFzS4wqw8UuSubOc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sanju Mehta <Sanju.Mehta@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.2 124/240] thunderbolt: Use const qualifier for `ring_interrupt_index`
Date:   Tue, 28 Mar 2023 16:41:27 +0200
Message-Id: <20230328142624.949517970@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mario Limonciello <mario.limonciello@amd.com>

commit 1716efdb07938bd6510e1127d02012799112c433 upstream.

`ring_interrupt_index` doesn't change the data for `ring` so mark it as
const. This is needed by the following patch that disables interrupt
auto clear for rings.

Cc: Sanju Mehta <Sanju.Mehta@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/nhi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/thunderbolt/nhi.c
+++ b/drivers/thunderbolt/nhi.c
@@ -46,7 +46,7 @@
 #define QUIRK_AUTO_CLEAR_INT	BIT(0)
 #define QUIRK_E2E		BIT(1)
 
-static int ring_interrupt_index(struct tb_ring *ring)
+static int ring_interrupt_index(const struct tb_ring *ring)
 {
 	int bit = ring->hop;
 	if (!ring->is_tx)



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7525D6D4810
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:25:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233283AbjDCOZi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:25:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233278AbjDCOZh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:25:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EE0D2C9F1
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:25:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D2D0FB81C02
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:25:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28A82C433D2;
        Mon,  3 Apr 2023 14:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680531933;
        bh=A/YgkIZQQ3bPcVHXO/nMr0aaznJLscKiIXuvpsPOu2k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DS+YPBUsSwUaHtKGB3aZkI5S4BlUVRkJgx2yObgH+vN6QxeOYt+oAaStPYj2jY+u+
         ai+n/tBa8q+b/pwwJVpA9F/pS1voQcbLpbxb3BSEJ2HZHyGP4KVEeXOwD7xbRZi9KV
         44YOMhBwxBkHIa1QNlXZpOvmD0hR3EMkpeLZ6IoY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sanju Mehta <Sanju.Mehta@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 5.10 063/173] thunderbolt: Use const qualifier for `ring_interrupt_index`
Date:   Mon,  3 Apr 2023 16:07:58 +0200
Message-Id: <20230403140416.499791738@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140414.174516815@linuxfoundation.org>
References: <20230403140414.174516815@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
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
@@ -36,7 +36,7 @@
 
 #define NHI_MAILBOX_TIMEOUT	500 /* ms */
 
-static int ring_interrupt_index(struct tb_ring *ring)
+static int ring_interrupt_index(const struct tb_ring *ring)
 {
 	int bit = ring->hop;
 	if (!ring->is_tx)



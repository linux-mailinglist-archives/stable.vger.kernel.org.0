Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF884E768D
	for <lists+stable@lfdr.de>; Fri, 25 Mar 2022 16:14:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350841AbiCYPPg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 11:15:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376866AbiCYPNl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 11:13:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A5C8DAFFC;
        Fri, 25 Mar 2022 08:10:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2BD0E61BE3;
        Fri, 25 Mar 2022 15:10:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38508C340E9;
        Fri, 25 Mar 2022 15:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648221033;
        bh=3b2YyzuEymIDBagrwfR8/oyH70FEObzEZOwyEn3t3To=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LvXA3mN3YyC1THcyX+ayaBh3SygNJiWw05Dx8AwrMUlSl3ozpMyemZ2vtYD2ZCQDo
         hBo/GF0zNk8dmbRV0MvY2j+buzo23P+tGc6MxawbkqvwxDYOe3JA62+ywb6fiVpYa1
         iq/EB0Li787Ky65izbL5q87cx0AvX+zksAfvQxNE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wen Gong <wgong@codeaurora.org>,
        Brian Norris <briannorris@chromium.org>,
        Kalle Valo <quic_kvalo@quicinc.com>
Subject: [PATCH 5.10 33/38] Revert "ath: add support for special 0x0 regulatory domain"
Date:   Fri, 25 Mar 2022 16:05:17 +0100
Message-Id: <20220325150420.697040647@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220325150419.757836392@linuxfoundation.org>
References: <20220325150419.757836392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Norris <briannorris@chromium.org>

commit 1ec7ed5163c70a0d040150d2279f932c7e7c143f upstream.

This reverts commit 2dc016599cfa9672a147528ca26d70c3654a5423.

Users are reporting regressions in regulatory domain detection and
channel availability.

The problem this was trying to resolve was fixed in firmware anyway:

    QCA6174 hw3.0: sdio-4.4.1: add firmware.bin_WLAN.RMH.4.4.1-00042
    https://github.com/kvalo/ath10k-firmware/commit/4d382787f0efa77dba40394e0bc604f8eff82552

Link: https://bbs.archlinux.org/viewtopic.php?id=254535
Link: http://lists.infradead.org/pipermail/ath10k/2020-April/014871.html
Link: http://lists.infradead.org/pipermail/ath10k/2020-May/015152.html
Link: https://lore.kernel.org/all/1c160dfb-6ccc-b4d6-76f6-4364e0adb6dd@reox.at/
Fixes: 2dc016599cfa ("ath: add support for special 0x0 regulatory domain")
Cc: <stable@vger.kernel.org>
Cc: Wen Gong <wgong@codeaurora.org>
Signed-off-by: Brian Norris <briannorris@chromium.org>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20200527165718.129307-1-briannorris@chromium.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/regd.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/net/wireless/ath/regd.c
+++ b/drivers/net/wireless/ath/regd.c
@@ -666,14 +666,14 @@ ath_regd_init_wiphy(struct ath_regulator
 
 /*
  * Some users have reported their EEPROM programmed with
- * 0x8000 or 0x0 set, this is not a supported regulatory
- * domain but since we have more than one user with it we
- * need a solution for them. We default to 0x64, which is
- * the default Atheros world regulatory domain.
+ * 0x8000 set, this is not a supported regulatory domain
+ * but since we have more than one user with it we need
+ * a solution for them. We default to 0x64, which is the
+ * default Atheros world regulatory domain.
  */
 static void ath_regd_sanitize(struct ath_regulatory *reg)
 {
-	if (reg->current_rd != COUNTRY_ERD_FLAG && reg->current_rd != 0)
+	if (reg->current_rd != COUNTRY_ERD_FLAG)
 		return;
 	printk(KERN_DEBUG "ath: EEPROM regdomain sanitized\n");
 	reg->current_rd = 0x64;



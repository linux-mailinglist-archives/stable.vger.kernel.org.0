Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4596459D36B
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 10:22:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241420AbiHWIIm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:08:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240692AbiHWIIT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:08:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 137536C749;
        Tue, 23 Aug 2022 01:05:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AD482B81C20;
        Tue, 23 Aug 2022 08:04:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11559C433D6;
        Tue, 23 Aug 2022 08:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661241898;
        bh=ebnfDSkc3i9z/lwNs5Ai2x4+rScZFdUP3PM9DzhZcnQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wiHVaxPdaorKR/B/6r/bCwOGdg3fkEodkKncvsYfoiYllT+G1OFJy4DIihPlTN0PY
         cJSsJwZl3QSCWk3mNAJKfU50CmqX1yhxwXMHBesIn2KxjLgvSNvVCZAbI8LAqIif30
         qfahGZmG37Q/kIr1Yu4O1yLgD22rYgyEoBQT6iBk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Harald Freudenberger <freude@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
Subject: [PATCH 5.19 013/365] s390/ap: fix crash on older machines based on QCI info missing
Date:   Tue, 23 Aug 2022 09:58:34 +0200
Message-Id: <20220823080118.735404651@linuxfoundation.org>
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

From: Harald Freudenberger <freude@linux.ibm.com>

commit 0fef40be5d1f8e7af3d61e8827a63c5862cd99f7 upstream.

On older z series machines (z12 and older) there is no QCI info
available. The AP code took care of this and the AP bus scan then
switched to simple probing via TAPQ.

With commit
283915850a44 ("s390/ap: notify drivers on config changed and scan complete callbacks")
some code was introduced which silently assumed that the QCI info is
always available. However, with KVM simulating an older machine (z12)
the result was a kernel crash. Funnily the same crash does not happen
on LPAR - maybe because NULL is a valid pointer and reading some data
from address 0 also works fine.

This fix now improves the code to be aware that the QCI instruction
may not be available on older machines and thus the two pointers to
QCI info structs may simple be NULL.

However, on a machine not providing the QCI info the two callbacks to
the zcrypt device drivers on_config_changed() and on_scan_complete()
provide parameters which are pointers to a QCI info struct.
These both callbacks are NOT served if there is no QCI info available.
The only consumer of these callbacks is the vfio device driver. This
driver only supports CEX4 and higher. All physical machines which are
able to provide CEX4 cards have QCI support available. So there is
no sense in for example fill the QCI info struct by hand with looping
over cards and queues and TAPQ each APQN.

Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
Cc: stable@vger.kernel.org
Fixes: 283915850a44 ("s390/ap: notify drivers on config changed and scan complete callbacks")
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/crypto/ap_bus.c |    3 +++
 drivers/s390/crypto/ap_bus.h |    4 ++++
 2 files changed, 7 insertions(+)

--- a/drivers/s390/crypto/ap_bus.c
+++ b/drivers/s390/crypto/ap_bus.c
@@ -2068,6 +2068,9 @@ static inline void ap_scan_adapter(int a
  */
 static bool ap_get_configuration(void)
 {
+	if (!ap_qci_info)	/* QCI not supported */
+		return false;
+
 	memcpy(ap_qci_info_old, ap_qci_info, sizeof(*ap_qci_info));
 	ap_fetch_qci_info(ap_qci_info);
 
--- a/drivers/s390/crypto/ap_bus.h
+++ b/drivers/s390/crypto/ap_bus.h
@@ -148,12 +148,16 @@ struct ap_driver {
 	/*
 	 * Called at the start of the ap bus scan function when
 	 * the crypto config information (qci) has changed.
+	 * This callback is not invoked if there is no AP
+	 * QCI support available.
 	 */
 	void (*on_config_changed)(struct ap_config_info *new_config_info,
 				  struct ap_config_info *old_config_info);
 	/*
 	 * Called at the end of the ap bus scan function when
 	 * the crypto config information (qci) has changed.
+	 * This callback is not invoked if there is no AP
+	 * QCI support available.
 	 */
 	void (*on_scan_complete)(struct ap_config_info *new_config_info,
 				 struct ap_config_info *old_config_info);



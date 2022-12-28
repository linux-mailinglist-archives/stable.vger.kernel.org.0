Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33E01657A20
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:08:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233541AbiL1PII (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:08:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233605AbiL1PIH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:08:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D50613D71
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:08:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 38861B81719
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:08:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4A6DC433EF;
        Wed, 28 Dec 2022 15:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240084;
        bh=yQi0KKFy++VnQxeN1EaZEtnH9V/nrQBt/zrBPeiXXF4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RaJoyB9ZBUzo9oEFBz1tT+cE5Xo6CZXMonlUZ1D7LLLr/5+3znzfovOmpW/OoiBww
         wtIuRrR+/uI7ysLapYYEsrxPSedCPj5MLYjvq6fzSGrxn6mOaK4JSBWymUhied7fvp
         dKFCfAMIH2eeQL5sz3Q0a7EgT7n3YQ2kLOyVRJ2o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Barnab=C3=A1s=20P=C5=91cze?= <pobrn@protonmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0116/1073] timerqueue: Use rb_entry_safe() in timerqueue_getnext()
Date:   Wed, 28 Dec 2022 15:28:24 +0100
Message-Id: <20221228144331.189719533@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

From: Barnabás Pőcze <pobrn@protonmail.com>

[ Upstream commit 2f117484329b233455ee278f2d9b0a4356835060 ]

When `timerqueue_getnext()` is called on an empty timer queue, it will
use `rb_entry()` on a NULL pointer, which is invalid. Fix that by using
`rb_entry_safe()` which handles NULL pointers.

This has not caused any issues so far because the offset of the `rb_node`
member in `timerqueue_node` is 0, so `rb_entry()` is essentially a no-op.

Fixes: 511885d7061e ("lib/timerqueue: Rely on rbtree semantics for next timer")
Signed-off-by: Barnabás Pőcze <pobrn@protonmail.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20221114195421.342929-1-pobrn@protonmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/timerqueue.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/timerqueue.h b/include/linux/timerqueue.h
index 93884086f392..adc80e29168e 100644
--- a/include/linux/timerqueue.h
+++ b/include/linux/timerqueue.h
@@ -35,7 +35,7 @@ struct timerqueue_node *timerqueue_getnext(struct timerqueue_head *head)
 {
 	struct rb_node *leftmost = rb_first_cached(&head->rb_root);
 
-	return rb_entry(leftmost, struct timerqueue_node, node);
+	return rb_entry_safe(leftmost, struct timerqueue_node, node);
 }
 
 static inline void timerqueue_init(struct timerqueue_node *node)
-- 
2.35.1




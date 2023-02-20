Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9432A69CDE8
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:54:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232517AbjBTNyH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:54:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232516AbjBTNyG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:54:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7DC51DB89
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:54:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 90526B80D1F
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:54:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E488CC433D2;
        Mon, 20 Feb 2023 13:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676901239;
        bh=aML26oZ34ikXf0VDcOrKjwMUxcqeUXxSKuWmja9cbEg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b6daRmY3F6BZmXqdms/hUK3LRvhNbIUfGcv9oXf62L+yDDB5Y3IONKWukb2IYgwDZ
         p9yOt5w5LMuPKFFZH/YaV7KAGh0htj5LrZKo0H/kV7IDkH7oySPtWQbSwZ630vU7qA
         ua5q4KIrOES62sPRfeCA2BJv5ROill6fX8omxGVU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dan Carpenter <error27@gmail.com>,
        Simon Horman <simon.horman@corigine.com>,
        Kees Cook <keescook@chromium.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 82/83] net: sched: sch: Fix off by one in htb_activate_prios()
Date:   Mon, 20 Feb 2023 14:36:55 +0100
Message-Id: <20230220133556.604507547@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133553.669025851@linuxfoundation.org>
References: <20230220133553.669025851@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <error27@gmail.com>

commit 9cec2aaffe969f2a3e18b5ec105fc20bb908e475 upstream.

The > needs be >= to prevent an out of bounds access.

Fixes: de5ca4c3852f ("net: sched: sch: Bounds check priority")
Signed-off-by: Dan Carpenter <error27@gmail.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/Y+D+KN18FQI2DKLq@kili
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_htb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -429,7 +429,7 @@ static void htb_activate_prios(struct ht
 		while (m) {
 			unsigned int prio = ffz(~m);
 
-			if (WARN_ON_ONCE(prio > ARRAY_SIZE(p->inner.clprio)))
+			if (WARN_ON_ONCE(prio >= ARRAY_SIZE(p->inner.clprio)))
 				break;
 			m &= ~(1 << prio);
 



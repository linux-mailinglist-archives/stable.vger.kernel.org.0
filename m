Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5478E60422A
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 12:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234459AbiJSK4a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 06:56:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234500AbiJSKz4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 06:55:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C72EA164BEF;
        Wed, 19 Oct 2022 03:27:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A4751B824B5;
        Wed, 19 Oct 2022 09:10:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09AC8C433D7;
        Wed, 19 Oct 2022 09:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170629;
        bh=Q7nL0WEUtaTUZsGTu8PhNbsvfvjXK7qqWWgILZtc6rQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XGFDHqgxLKOeq0qN+lTbz+LsweL4Uu+I3W1WLuxtq0GKMQhtFQ0ytQQPvJZtt5pAq
         l/CRLhCOEFGURDoQXQSMtC71w3j5HjRMYYk9uN31UuW6w9ikLR4JEQJuShj+/0Me1P
         b23VSmH9Q0g58PYaxQBydGKNKKZKhbZi2ShUW0Pc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Gaul <gaul@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 727/862] r8152: Rate limit overflow messages
Date:   Wed, 19 Oct 2022 10:33:34 +0200
Message-Id: <20221019083322.055021094@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Gaul <gaul@gaul.org>

[ Upstream commit 93e2be344a7db169b7119de21ac1bf253b8c6907 ]

My system shows almost 10 million of these messages over a 24-hour
period which pollutes my logs.

Signed-off-by: Andrew Gaul <gaul@google.com>
Link: https://lore.kernel.org/r/20221002034128.2026653-1-gaul@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/r8152.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 688905ea0a6d..e7b0b59e2bc8 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -1874,7 +1874,9 @@ static void intr_callback(struct urb *urb)
 			   "Stop submitting intr, status %d\n", status);
 		return;
 	case -EOVERFLOW:
-		netif_info(tp, intr, tp->netdev, "intr status -EOVERFLOW\n");
+		if (net_ratelimit())
+			netif_info(tp, intr, tp->netdev,
+				   "intr status -EOVERFLOW\n");
 		goto resubmit;
 	/* -EPIPE:  should clear the halt */
 	default:
-- 
2.35.1




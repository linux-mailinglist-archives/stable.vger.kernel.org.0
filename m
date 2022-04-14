Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74FB0500F96
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 15:31:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232000AbiDNNdb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:33:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244808AbiDNN2I (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:28:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC42898F65;
        Thu, 14 Apr 2022 06:20:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2F91CB82982;
        Thu, 14 Apr 2022 13:20:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B252C385A1;
        Thu, 14 Apr 2022 13:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649942454;
        bh=kDceHqvyArUPANotiiYKKyfdr6f/z/Gql7fVtwkyhwU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IJgW5Ld6LKWMM1Fm1EVszlh7SPuLcO0oJcUAUsQOBwFbG7BMVEcnjMvOBDcrkYsvg
         gpYeRa4S5lHgr1NjBt3dW8mWNVnaFPwMdo/TY6qU1XeyrQJa6pcQIFEHrLeKrL21hI
         gnriTlIIREUhzGKMZHEuQBLuIWlTye4Lz2jDJh9M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anssi Hannula <anssi.hannula@bitwise.fi>,
        Michael Kelley <mikelley@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 141/338] hv_balloon: rate-limit "Unhandled message" warning
Date:   Thu, 14 Apr 2022 15:10:44 +0200
Message-Id: <20220414110842.918803617@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110838.883074566@linuxfoundation.org>
References: <20220414110838.883074566@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Anssi Hannula <anssi.hannula@bitwise.fi>

[ Upstream commit 1d7286729aa616772be334eb908e11f527e1e291 ]

For a couple of times I have encountered a situation where

  hv_balloon: Unhandled message: type: 12447

is being flooded over 1 million times per second with various values,
filling the log and consuming cycles, making debugging difficult.

Add rate limiting to the message.

Most other Hyper-V drivers already have similar rate limiting in their
message callbacks.

The cause of the floods in my case was probably fixed by 96d9d1fa5cd5
("Drivers: hv: balloon: account for vmbus packet header in
max_pkt_size").

Fixes: 9aa8b50b2b3d ("Drivers: hv: Add Hyper-V balloon driver")
Signed-off-by: Anssi Hannula <anssi.hannula@bitwise.fi>
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Link: https://lore.kernel.org/r/20220222141400.98160-1-anssi.hannula@bitwise.fi
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/hv_balloon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hv/hv_balloon.c b/drivers/hv/hv_balloon.c
index e5fc719a34e7..d442a8d2332e 100644
--- a/drivers/hv/hv_balloon.c
+++ b/drivers/hv/hv_balloon.c
@@ -1548,7 +1548,7 @@ static void balloon_onchannelcallback(void *context)
 			break;
 
 		default:
-			pr_warn("Unhandled message: type: %d\n", dm_hdr->type);
+			pr_warn_ratelimited("Unhandled message: type: %d\n", dm_hdr->type);
 
 		}
 	}
-- 
2.34.1




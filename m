Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BCC8579F2E
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 15:11:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243257AbiGSNL3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 09:11:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243275AbiGSNKc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 09:10:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EF3366AEF;
        Tue, 19 Jul 2022 05:29:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 89BEB60F15;
        Tue, 19 Jul 2022 12:28:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E35FC385A2;
        Tue, 19 Jul 2022 12:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233734;
        bh=qx4xm5yB/uhM5uj3Y8fS4RBO/otc/xo2/h0TR2koJiY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z7MBPhbjNK0x10Cg+tD6W9yjcBiF0Q4tlslGHSp4hdKVNm3Z8yqSOtng6RdhhV2CW
         FO4n6LXhanXI5QnbX2a2ujQS8SGacuF2X3C9NowXC7mbhZZRg8FaZv/c8ITcoDICQl
         Z3O93rDFFz33cQGJj15RAnXMAM42pnUNdAzJUaDY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Krowiak <akrowiak@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
Subject: [PATCH 5.18 223/231] s390/ap: fix error handling in __verify_queue_reservations()
Date:   Tue, 19 Jul 2022 13:55:08 +0200
Message-Id: <20220719114732.468219291@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Krowiak <akrowiak@linux.ibm.com>

commit 2f23256c0ea20627c91ea2d468cda945f68c3395 upstream.

The AP bus's __verify_queue_reservations function increments the ref count
for the device driver passed in as a parameter, but fails to decrement it
before returning control to the caller. This will prevents any subsequent
removal of the module.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
Reported-by: Tony Krowiak <akrowiak@linux.ibm.com>
Reviewed-by: Harald Freudenberger <freude@linux.ibm.com>
Fixes: 4f8206b88286 ("s390/ap: driver callback to indicate resource in use")
Link: https://lore.kernel.org/r/20220706222619.602094-1-akrowiak@linux.ibm.com
Cc: stable@vger.kernel.org
[agordeev@linux.ibm.com fixed description, added Fixes and Link]
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/crypto/ap_bus.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/s390/crypto/ap_bus.c
+++ b/drivers/s390/crypto/ap_bus.c
@@ -1410,7 +1410,7 @@ static int __verify_queue_reservations(s
 	if (ap_drv->in_use) {
 		rc = ap_drv->in_use(ap_perms.apm, newaqm);
 		if (rc)
-			return -EBUSY;
+			rc = -EBUSY;
 	}
 
 	/* release the driver's module */



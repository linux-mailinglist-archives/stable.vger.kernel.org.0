Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DA276ECDC8
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:26:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232216AbjDXN0n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:26:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232215AbjDXN0n (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:26:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14C625FF6;
        Mon, 24 Apr 2023 06:26:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A2FF5622CE;
        Mon, 24 Apr 2023 13:26:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BE3DC433D2;
        Mon, 24 Apr 2023 13:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682342801;
        bh=ja7S2LB0OvCCmqEw1nb05oddZS4SuYkfKzmpFaLMeMI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f7vopkuhuP2LPBCUCLwmQWfaa5ll3CoooBgJpBsI91RoRnvedvQSmWtwjtjD4Tm77
         MIfHnEctQSXWG/dT3tp3oStXFMbCWydB4858ZcATMyXMaW+9QQx2r8rJEmPE28MvjR
         Uhi/FLSOezQORozYyAlpvkZWNhNM/IbcqGbpcAbo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Maxim Levitsky <maximlevitsky@gmail.com>,
        Alex Dubov <oakad@yahoo.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Kay Sievers <kay.sievers@vrfy.org>, linux-mmc@vger.kernel.org,
        stable <stable@kernel.org>,
        Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Subject: [PATCH 6.1 63/98] memstick: fix memory leak if card device is never registered
Date:   Mon, 24 Apr 2023 15:17:26 +0200
Message-Id: <20230424131136.297640211@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131133.829259077@linuxfoundation.org>
References: <20230424131133.829259077@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 4b6d621c9d859ff89e68cebf6178652592676013 upstream.

When calling dev_set_name() memory is allocated for the name for the
struct device.  Once that structure device is registered, or attempted
to be registerd, with the driver core, the driver core will handle
cleaning up that memory when the device is removed from the system.

Unfortunatly for the memstick code, there is an error path that causes
the struct device to never be registered, and so the memory allocated in
dev_set_name will be leaked.  Fix that leak by manually freeing it right
before the memory for the device is freed.

Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Alex Dubov <oakad@yahoo.com>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Hans de Goede <hdegoede@redhat.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-mmc@vger.kernel.org
Fixes: 0252c3b4f018 ("memstick: struct device - replace bus_id with dev_name(), dev_set_name()")
Cc: stable <stable@kernel.org>
Co-developed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Co-developed-by: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Signed-off-by: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Link: https://lore.kernel.org/r/20230401200327.16800-1-gregkh@linuxfoundation.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/memstick/core/memstick.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/memstick/core/memstick.c
+++ b/drivers/memstick/core/memstick.c
@@ -410,6 +410,7 @@ static struct memstick_dev *memstick_all
 	return card;
 err_out:
 	host->card = old_card;
+	kfree_const(card->dev.kobj.name);
 	kfree(card);
 	return NULL;
 }
@@ -468,8 +469,10 @@ static void memstick_check(struct work_s
 				put_device(&card->dev);
 				host->card = NULL;
 			}
-		} else
+		} else {
+			kfree_const(card->dev.kobj.name);
 			kfree(card);
+		}
 	}
 
 out_power_off:



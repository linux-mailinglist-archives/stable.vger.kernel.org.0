Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D1F95488BD
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:02:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244547AbiFMK0p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 06:26:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242862AbiFMKZN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 06:25:13 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03DD520F56;
        Mon, 13 Jun 2022 03:19:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 684C0CE1171;
        Mon, 13 Jun 2022 10:19:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AD33C36B07;
        Mon, 13 Jun 2022 10:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655115569;
        bh=rqe1LHISFnnv3Z/S7gTCTi4SI/ic37tYHlVQ+3h2UqU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tBgW3YJxeoKAgWB94JMOsMkA9QhPV630OtdV2K0FrSR/DQFIrG5yYIokRdEym01U0
         IcEPtPaReXGHo4U+dXfPFR4Ll46+s6xS1KFQGHo1mZq1PBQ4cBSDE6CnnNACOgcLLq
         Q2BLWnGyhJjkvMRph3akpP3JhhXrQwxa2SRNvstk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 121/167] firmware: dmi-sysfs: Fix memory leak in dmi_sysfs_register_handle
Date:   Mon, 13 Jun 2022 12:09:55 +0200
Message-Id: <20220613094909.163627244@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094840.720778945@linuxfoundation.org>
References: <20220613094840.720778945@linuxfoundation.org>
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

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 660ba678f9998aca6db74f2dd912fa5124f0fa31 ]

kobject_init_and_add() takes reference even when it fails.
According to the doc of kobject_init_and_add()

   If this function returns an error, kobject_put() must be called to
   properly clean up the memory associated with the object.

Fix this issue by calling kobject_put().

Fixes: 948af1f0bbc8 ("firmware: Basic dmi-sysfs support")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://lore.kernel.org/r/20220511071421.9769-1-linmq006@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/dmi-sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/dmi-sysfs.c b/drivers/firmware/dmi-sysfs.c
index ef76e5eecf0b..37f76daa2b3d 100644
--- a/drivers/firmware/dmi-sysfs.c
+++ b/drivers/firmware/dmi-sysfs.c
@@ -601,7 +601,7 @@ static void __init dmi_sysfs_register_handle(const struct dmi_header *dh,
 				    "%d-%d", dh->type, entry->instance);
 
 	if (*ret) {
-		kfree(entry);
+		kobject_put(&entry->kobj);
 		return;
 	}
 
-- 
2.35.1




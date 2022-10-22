Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3157A6088A3
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233593AbiJVIU1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:20:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233740AbiJVITQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:19:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EED42DF454;
        Sat, 22 Oct 2022 00:58:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 766FD60B1B;
        Sat, 22 Oct 2022 07:48:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 893BEC433D7;
        Sat, 22 Oct 2022 07:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424894;
        bh=c2ft1Iae6NDuIB9gttmxUKDBTR38ExvWyk+Gc+BZs0A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ffnpsx5W0lH/6U6JuEs0dYEn/YVGKRvdrFlZYF7Q3ujX9pPOS7NG6stBi+36KWqXx
         GeR4sQ52ChsWrDhTiOJRXV7a+/TF+L6oioZI+PGbLSQ4B8HI1LwpuMqGiIPjJ3agof
         hgFQrEtPng34IjSmqKUhl/D94D+dOjOJW44Iykpo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Prashant Malani <pmalani@chromium.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Tzung-Bi Shih <tzungbi@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 316/717] platform/chrome: cros_ec_typec: Correct alt mode index
Date:   Sat, 22 Oct 2022 09:23:15 +0200
Message-Id: <20221022072508.049503779@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Prashant Malani <pmalani@chromium.org>

[ Upstream commit 4e477663e396f48c5cfc5f2d75d4b514f409516a ]

Alt mode indices used by USB PD (Power Delivery) start with 1, not 0.

Update the alt mdoe registration code to factor this in to the alt mode
descriptor.

Fixes: de0f49487db3 ("platform/chrome: cros_ec_typec: Register partner altmodes")
Signed-off-by: Prashant Malani <pmalani@chromium.org>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Tzung-Bi Shih <tzungbi@kernel.org>
Link: https://lore.kernel.org/r/20220819190807.1275937-3-pmalani@chromium.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/chrome/cros_ec_typec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/chrome/cros_ec_typec.c b/drivers/platform/chrome/cros_ec_typec.c
index 7cb2e35c4ded..1305a22a8831 100644
--- a/drivers/platform/chrome/cros_ec_typec.c
+++ b/drivers/platform/chrome/cros_ec_typec.c
@@ -669,7 +669,7 @@ static int cros_typec_register_altmodes(struct cros_typec_data *typec, int port_
 		for (j = 0; j < sop_disc->svids[i].mode_count; j++) {
 			memset(&desc, 0, sizeof(desc));
 			desc.svid = sop_disc->svids[i].svid;
-			desc.mode = j;
+			desc.mode = j + 1;
 			desc.vdo = sop_disc->svids[i].mode_vdo[j];
 
 			if (is_partner)
-- 
2.35.1




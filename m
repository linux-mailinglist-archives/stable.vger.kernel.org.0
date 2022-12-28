Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF53765788E
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:52:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233001AbiL1Owh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:52:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233114AbiL1OwH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:52:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1982612746
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:51:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3588EB8171F
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:51:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A0E3C433F0;
        Wed, 28 Dec 2022 14:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239095;
        bh=rBw+hqrqGPPUypED3G4ai2j3oE1EYez865ycweTOg8s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PKgVz2g+dS/g3F+qLKCR9E7gTsrX/xPxaoI655W+svf316jzzs56RqcuUqqWC/Bta
         VMNw1oiyBJqAdUe5LtPCb0n3oxn9BCE7h7YJtOkwDrKpyUHhRl+Wa/9UFBRVuibRXa
         Oqk8k4wD8I6Fiu0+9yg3TcYcY7r368oG6rESefM4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Prashant Malani <pmalani@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 127/731] platform/chrome: cros_ec_typec: Cleanup switch handle return paths
Date:   Wed, 28 Dec 2022 15:33:54 +0100
Message-Id: <20221228144300.231893112@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

From: Prashant Malani <pmalani@chromium.org>

[ Upstream commit 66fe238a9bcc158f75ddecf976d1ce7efe20f713 ]

Some of the return paths for the cros_typec_get_switch_handles()
aren't necessary. Clean up the return paths to only undo the handle
get's which succeeded.

Signed-off-by: Prashant Malani <pmalani@chromium.org>
Link: https://lore.kernel.org/r/20220711072333.2064341-9-pmalani@chromium.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 9a8aadcf0b45 ("platform/chrome: cros_ec_typec: zero out stale pointers")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/chrome/cros_ec_typec.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/chrome/cros_ec_typec.c b/drivers/platform/chrome/cros_ec_typec.c
index aadb8d237aef..d63be2b3d10e 100644
--- a/drivers/platform/chrome/cros_ec_typec.c
+++ b/drivers/platform/chrome/cros_ec_typec.c
@@ -156,12 +156,10 @@ static int cros_typec_get_switch_handles(struct cros_typec_port *port,
 	return 0;
 
 role_sw_err:
-	usb_role_switch_put(port->role_sw);
-ori_sw_err:
 	typec_switch_put(port->ori_sw);
-mux_err:
+ori_sw_err:
 	typec_mux_put(port->mux);
-
+mux_err:
 	return -ENODEV;
 }
 
-- 
2.35.1




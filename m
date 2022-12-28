Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0355657ADC
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:15:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233113AbiL1PPo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:15:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232995AbiL1PPk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:15:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF25E13E04
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:15:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6CB3BB816D9
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:15:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF1B6C433EF;
        Wed, 28 Dec 2022 15:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240537;
        bh=Mh7Iu9p6n+1zJIb6xZi19HETjBy9hXzuQapIFL17wgA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DNgoRoarLK3rBrBo0LquTk1vly18FGJGROB9uyhmbO+KWo3leGJ82hTeDOOtmr9IV
         1bb+SV2H2iXYGQb7rMi6km/pCyLUS/WbFxNsIgI5Jf0RC0zNNGEmLagDSy1CZYZn64
         HKrbrh2fuWbFjOv9uMdP45ftd+2ohhx2a3OT+Ab4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Victor Ding <victording@chromium.org>,
        Prashant Malani <pmalani@chromium.org>,
        Tzung-Bi Shih <tzungbi@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0172/1073] platform/chrome: cros_ec_typec: zero out stale pointers
Date:   Wed, 28 Dec 2022 15:29:20 +0100
Message-Id: <20221228144332.685249709@linuxfoundation.org>
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

From: Victor Ding <victording@chromium.org>

[ Upstream commit 9a8aadcf0b459c1257b9477fd6402e1d5952ae07 ]

`cros_typec_get_switch_handles` allocates four pointers when obtaining
type-c switch handles. These pointers are all freed if failing to obtain
any of them; therefore, pointers in `port` become stale. The stale
pointers eventually cause use-after-free or double free in later code
paths. Zeroing out all pointer fields after freeing to eliminate these
stale pointers.

Fixes: f28adb41dab4 ("platform/chrome: cros_ec_typec: Register Type C switches")
Fixes: 1a8912caba02 ("platform/chrome: cros_ec_typec: Get retimer handle")
Signed-off-by: Victor Ding <victording@chromium.org>
Acked-by: Prashant Malani <pmalani@chromium.org>
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Link: https://lore.kernel.org/r/20221207093924.v2.1.I1864b6a7ee98824118b93677868d22d3750f439b@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/chrome/cros_ec_typec.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/platform/chrome/cros_ec_typec.c b/drivers/platform/chrome/cros_ec_typec.c
index 00208ffbe2e7..a54bf964521f 100644
--- a/drivers/platform/chrome/cros_ec_typec.c
+++ b/drivers/platform/chrome/cros_ec_typec.c
@@ -168,10 +168,13 @@ static int cros_typec_get_switch_handles(struct cros_typec_port *port,
 
 role_sw_err:
 	typec_switch_put(port->ori_sw);
+	port->ori_sw = NULL;
 ori_sw_err:
 	typec_retimer_put(port->retimer);
+	port->retimer = NULL;
 retimer_sw_err:
 	typec_mux_put(port->mux);
+	port->mux = NULL;
 mux_err:
 	return -ENODEV;
 }
-- 
2.35.1




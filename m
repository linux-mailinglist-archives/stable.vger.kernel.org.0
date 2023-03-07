Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73DE86AF2D7
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:56:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233338AbjCGS46 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:56:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233311AbjCGS4n (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:56:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7922FCB669
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:44:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 48C2EB819DB
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:28:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DB40C433EF;
        Tue,  7 Mar 2023 18:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213699;
        bh=c9U5+zjEEfnJ+GJrBvDYLOqr8/0PM90ddpJhhT8lThQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HbJchuyxy2GPNOoVSrx4AmCh8LCLKjIJXyw7VWHxysemA0HrqHzJq9/KEbLI+s6Ej
         O3N3vCi3n7EzhEcq13Xi2nqKnQQQtQiRc9c6ikgnYNBhcQNTKOniECrG7wR2xRIJEs
         ogNc69I/K14GaeBS0MBtGWFaLY7tYqgrBfQA20OE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Moshe Shemesh <moshe@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 590/885] devlink: Fix TP_STRUCT_entry in trace of devlink health report
Date:   Tue,  7 Mar 2023 17:58:44 +0100
Message-Id: <20230307170028.016751977@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Moshe Shemesh <moshe@nvidia.com>

[ Upstream commit d0ab772c1f1558af84f3293a52e9e886e08e0754 ]

Fix a bug in trace point definition for devlink health report, as
TP_STRUCT_entry of reporter_name should get reporter_name and not msg.

Note no fixes tag as this is a harmless bug as both reporter_name and
msg are strings and TP_fast_assign for this entry is correct.

Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/events/devlink.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/trace/events/devlink.h b/include/trace/events/devlink.h
index 24969184c5348..77ff7cfc6049a 100644
--- a/include/trace/events/devlink.h
+++ b/include/trace/events/devlink.h
@@ -88,7 +88,7 @@ TRACE_EVENT(devlink_health_report,
 		__string(bus_name, devlink_to_dev(devlink)->bus->name)
 		__string(dev_name, dev_name(devlink_to_dev(devlink)))
 		__string(driver_name, devlink_to_dev(devlink)->driver->name)
-		__string(reporter_name, msg)
+		__string(reporter_name, reporter_name)
 		__string(msg, msg)
 	),
 
-- 
2.39.2




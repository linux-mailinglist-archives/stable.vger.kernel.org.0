Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D48C6A309C
	for <lists+stable@lfdr.de>; Sun, 26 Feb 2023 15:51:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbjBZOvR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 09:51:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230012AbjBZOuo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 09:50:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C9DE166CE;
        Sun, 26 Feb 2023 06:48:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B2CF5B80BA8;
        Sun, 26 Feb 2023 14:48:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79577C433EF;
        Sun, 26 Feb 2023 14:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677422918;
        bh=83ccAweo86lpMlZWG7+crZEdsHj8UrM2V8ywetn9K3w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V1JPVtnUKZ/B80TDAVLanN0cWCkQ//kgbWEZi8UeNmruzVkUr9l5ZiPzjfN6ntB5p
         W0GMujW2QCmGTB76qJ6At4h8mE0vr2Yyus1fdlsWIk5vUIzTAO8R+FyH+6KWZbFC5s
         sU1Pod5p6NgAMhdQ2cZFquJOnSts81GXH3CCMeQqK2HBu8lT5JhhuhRiKcrRkzBFOe
         D2yvS1HBbUVfn/RElmfyidYKB9JrHDC+SOEzwu61SNOdhZFGKpo7VSNqScMiEM0VOx
         SpQ3fDjyMAgA9AVj4tN+X0BHj4s0aX4jn2l03DZPXxOX6C7wvDzkG5OAOJkcIDRehi
         IWN/Z/qOszdAA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Moshe Shemesh <moshe@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, rostedt@goodmis.org,
        mhiramat@kernel.org, idosch@nvidia.com,
        linux-trace-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 48/49] devlink: Fix TP_STRUCT_entry in trace of devlink health report
Date:   Sun, 26 Feb 2023 09:46:48 -0500
Message-Id: <20230226144650.826470-48-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230226144650.826470-1-sashal@kernel.org>
References: <20230226144650.826470-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
2.39.0


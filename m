Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E156480387
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 20:03:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231795AbhL0TDs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 14:03:48 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:39072 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231755AbhL0TDs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 14:03:48 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E2BB61159;
        Mon, 27 Dec 2021 19:03:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC631C36AE7;
        Mon, 27 Dec 2021 19:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640631827;
        bh=3WKmSonnl1XSUm/bIhq79dd3uWLrJ0bg5iLYC5CZJks=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qmFmzqkDaMZIYaLtwdVSaulSYXwlZELcgGwKQeQDsiVWFrYjoSNeBGF25hWHst3Sm
         FsAiVsms2dQsXgT87ViUy099Av5RvLmwHrI8xjIR/iCAEE9PB2nDehE/QanH7zRJqM
         +njbSVvbAbOqsIyFtUcl8G2Mtsw/l+n65RGhXCEAkGgUev5GKljcMJ7WXNUpVq+uSl
         XWyBiYCEGhduBjVwI6x/Kw9YrGPjbck/8/FNCpkQzJkwe4eAPdyAgZO4VhQ3sR+Rid
         vBZfEZLIzFXpHL8mErACcUZC+lJr/n+18O3NC6knFiFP++K7SZRqMQXLQY+UGqWC/E
         ir70jgGaCV7NA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeff LaBundy <jeff@labundy.com>, kernel test robot <lkp@intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 03/26] Input: iqs626a - prohibit inlining of channel parsing functions
Date:   Mon, 27 Dec 2021 14:03:04 -0500
Message-Id: <20211227190327.1042326-3-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227190327.1042326-1-sashal@kernel.org>
References: <20211227190327.1042326-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeff LaBundy <jeff@labundy.com>

[ Upstream commit e1f5e848209a1b51ccae50721b27684c6f9d978f ]

Some automated builds report a stack frame size in excess of 2 kB for
iqs626_probe(); the culprit appears to be the call to iqs626_parse_prop().

To solve this problem, specify noinline_for_stack for all of the
iqs626_parse_*() helper functions which are called inside a for loop
within iqs626_parse_prop().

As a result, a build with '-Wframe-larger-than' as low as 512 is free of
any such warnings.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Jeff LaBundy <jeff@labundy.com>
Link: https://lore.kernel.org/r/20211129004104.453930-1-jeff@labundy.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/misc/iqs626a.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/input/misc/iqs626a.c b/drivers/input/misc/iqs626a.c
index d57e996732cf4..23b5dd9552dcc 100644
--- a/drivers/input/misc/iqs626a.c
+++ b/drivers/input/misc/iqs626a.c
@@ -456,9 +456,10 @@ struct iqs626_private {
 	unsigned int suspend_mode;
 };
 
-static int iqs626_parse_events(struct iqs626_private *iqs626,
-			       const struct fwnode_handle *ch_node,
-			       enum iqs626_ch_id ch_id)
+static noinline_for_stack int
+iqs626_parse_events(struct iqs626_private *iqs626,
+		    const struct fwnode_handle *ch_node,
+		    enum iqs626_ch_id ch_id)
 {
 	struct iqs626_sys_reg *sys_reg = &iqs626->sys_reg;
 	struct i2c_client *client = iqs626->client;
@@ -604,9 +605,10 @@ static int iqs626_parse_events(struct iqs626_private *iqs626,
 	return 0;
 }
 
-static int iqs626_parse_ati_target(struct iqs626_private *iqs626,
-				   const struct fwnode_handle *ch_node,
-				   enum iqs626_ch_id ch_id)
+static noinline_for_stack int
+iqs626_parse_ati_target(struct iqs626_private *iqs626,
+			const struct fwnode_handle *ch_node,
+			enum iqs626_ch_id ch_id)
 {
 	struct iqs626_sys_reg *sys_reg = &iqs626->sys_reg;
 	struct i2c_client *client = iqs626->client;
@@ -885,9 +887,10 @@ static int iqs626_parse_trackpad(struct iqs626_private *iqs626,
 	return 0;
 }
 
-static int iqs626_parse_channel(struct iqs626_private *iqs626,
-				const struct fwnode_handle *ch_node,
-				enum iqs626_ch_id ch_id)
+static noinline_for_stack int
+iqs626_parse_channel(struct iqs626_private *iqs626,
+		     const struct fwnode_handle *ch_node,
+		     enum iqs626_ch_id ch_id)
 {
 	struct iqs626_sys_reg *sys_reg = &iqs626->sys_reg;
 	struct i2c_client *client = iqs626->client;
-- 
2.34.1


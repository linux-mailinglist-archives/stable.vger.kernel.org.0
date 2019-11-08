Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68685F46D7
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 12:45:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391149AbfKHLpg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 06:45:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:32806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391143AbfKHLpg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:45:36 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BFA7020656;
        Fri,  8 Nov 2019 11:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213535;
        bh=yghk864Qu3p4uLxrXvRwD8kPFl/idh9sgYH6Bz1/LXI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ossi6c4sD42EguPxfVJ1YFdSrECduH7BwUqI/+CaYb5DrEhj+d3Bmtxwi+btXVGJq
         XRh6rmMqHAQKmqJZfdNLFOEvFvOqdZ68uwJo+AqBIGqeSP7x5vUHkzFNCOUX8ZePp+
         TEPXyWCDJgu0OnOPl5JbYkwoNTNGAd5I9m9cuPKI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Banajit Goswami <bgoswami@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 098/103] component: fix loop condition to call unbind() if bind() fails
Date:   Fri,  8 Nov 2019 06:43:03 -0500
Message-Id: <20191108114310.14363-98-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108114310.14363-1-sashal@kernel.org>
References: <20191108114310.14363-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Banajit Goswami <bgoswami@codeaurora.org>

[ Upstream commit bdae566d5d9733b6e32b378668b84eadf28a94d4 ]

During component_bind_all(), if bind() fails for any
particular component associated with a master, unbind()
should be called for all previous components in that
master's match array, whose bind() might have completed
successfully. As per the current logic, if bind() fails
for the component at position 'n' in the master's match
array, it would start calling unbind() from component in
'n'th position itself and work backwards, and will always
skip calling unbind() for component in 0th position in the
master's match array.
Fix this by updating the loop condition, and the logic to
refer to the components in master's match array, so that
unbind() is called for all components starting from 'n-1'st
position in the array, until (and including) component in
0th position.

Signed-off-by: Banajit Goswami <bgoswami@codeaurora.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/component.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/base/component.c b/drivers/base/component.c
index 89b032f2ffd22..08da6160e94dd 100644
--- a/drivers/base/component.c
+++ b/drivers/base/component.c
@@ -461,9 +461,9 @@ int component_bind_all(struct device *master_dev, void *data)
 		}
 
 	if (ret != 0) {
-		for (; i--; )
-			if (!master->match->compare[i].duplicate) {
-				c = master->match->compare[i].component;
+		for (; i > 0; i--)
+			if (!master->match->compare[i - 1].duplicate) {
+				c = master->match->compare[i - 1].component;
 				component_unbind(c, master, data);
 			}
 	}
-- 
2.20.1


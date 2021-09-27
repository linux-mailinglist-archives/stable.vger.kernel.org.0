Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AC58419B2B
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:14:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236468AbhI0RPx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:15:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:56358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235871AbhI0ROg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:14:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4447D61362;
        Mon, 27 Sep 2021 17:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762625;
        bh=DBHRgJEr/2D6Bw5rELvKRtFWdt7jdM6yQlWdM3okMJ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2k2QIe96Br/u72rJlg8MpXcqxPDW4VWRplZtzd+g8BOzkmnH0aQK0SpmcNco8Qu0S
         JItRMLwafvwMclQltyw+nccSmSJENUpznaD2GNz7J9Vqbw/SiJUGkyDD8SU8uhX4Th
         /dUz4s3WYJ9B41DqxO69zCxn+b0p8fQey6nbjD4Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 062/103] thermal/core: Potential buffer overflow in thermal_build_list_of_policies()
Date:   Mon, 27 Sep 2021 19:02:34 +0200
Message-Id: <20210927170227.922523104@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170225.702078779@linuxfoundation.org>
References: <20210927170225.702078779@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 1bb30b20b49773369c299d4d6c65227201328663 ]

After printing the list of thermal governors, then this function prints
a newline character.  The problem is that "size" has not been updated
after printing the last governor.  This means that it can write one
character (the NUL terminator) beyond the end of the buffer.

Get rid of the "size" variable and just use "PAGE_SIZE - count" directly.

Fixes: 1b4f48494eb2 ("thermal: core: group functions related to governor handling")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20210916131342.GB25094@kili
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/thermal_core.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index e669f83faa3c..17de8a9b991e 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -224,15 +224,14 @@ int thermal_build_list_of_policies(char *buf)
 {
 	struct thermal_governor *pos;
 	ssize_t count = 0;
-	ssize_t size = PAGE_SIZE;
 
 	mutex_lock(&thermal_governor_lock);
 
 	list_for_each_entry(pos, &thermal_governor_list, governor_list) {
-		size = PAGE_SIZE - count;
-		count += scnprintf(buf + count, size, "%s ", pos->name);
+		count += scnprintf(buf + count, PAGE_SIZE - count, "%s ",
+				   pos->name);
 	}
-	count += scnprintf(buf + count, size, "\n");
+	count += scnprintf(buf + count, PAGE_SIZE - count, "\n");
 
 	mutex_unlock(&thermal_governor_lock);
 
-- 
2.33.0




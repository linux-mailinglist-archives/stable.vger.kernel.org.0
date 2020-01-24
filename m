Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBD62147E08
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 11:12:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388880AbgAXKFQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 05:05:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:41808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730108AbgAXKFP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 05:05:15 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B8B9521556;
        Fri, 24 Jan 2020 10:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579860315;
        bh=6zeeZ8IgLeM03yWrB5LLE1huLtNbGlXSeaUqlbeLSNI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0nhOeKPsu4Rhf9E1/QCFEZeZ6eitazUnnGS1nKQ0NBOcOUU76JgsgYEPFQ2nxgX6c
         Gs4yNPBTstnhFN8uBSYrIQQXpeDg52IACgS4XrxWsvgK9vs5OF3m/VWlZe5R5jRUMM
         6iWsV7UIakgZa/mgCYD8YfIcGRTAFMrAcDs59wZA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Rui Miguel Silva <rmfrfs@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 288/343] staging: greybus: light: fix a couple double frees
Date:   Fri, 24 Jan 2020 10:31:46 +0100
Message-Id: <20200124092957.907577314@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092919.490687572@linuxfoundation.org>
References: <20200124092919.490687572@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 329101244f214952606359d254ae883b7109e1a5 ]

The problem is in gb_lights_request_handler().  If we get a request to
change the config then we release the light with gb_lights_light_release()
and re-allocated it.  However, if the allocation fails part way through
then we call gb_lights_light_release() again.  This can lead to a couple
different double frees where we haven't cleared out the original values:

	gb_lights_light_v4l2_unregister(light);
	...
	kfree(light->channels);
	kfree(light->name);

I also made a small change to how we set "light->channels_count = 0;".
The original code handled this part fine and did not cause a use after
free but it was sort of complicated to read.

Fixes: 2870b52bae4c ("greybus: lights: add lights implementation")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Rui Miguel Silva <rmfrfs@gmail.com>
Link: https://lore.kernel.org/r/20190829122839.GA20116@mwanda
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/greybus/light.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/greybus/light.c b/drivers/staging/greybus/light.c
index 0f538b8c3a076..4e7575147775d 100644
--- a/drivers/staging/greybus/light.c
+++ b/drivers/staging/greybus/light.c
@@ -1103,21 +1103,21 @@ static void gb_lights_channel_release(struct gb_channel *channel)
 static void gb_lights_light_release(struct gb_light *light)
 {
 	int i;
-	int count;
 
 	light->ready = false;
 
-	count = light->channels_count;
-
 	if (light->has_flash)
 		gb_lights_light_v4l2_unregister(light);
+	light->has_flash = false;
 
-	for (i = 0; i < count; i++) {
+	for (i = 0; i < light->channels_count; i++)
 		gb_lights_channel_release(&light->channels[i]);
-		light->channels_count--;
-	}
+	light->channels_count = 0;
+
 	kfree(light->channels);
+	light->channels = NULL;
 	kfree(light->name);
+	light->name = NULL;
 }
 
 static void gb_lights_release(struct gb_lights *glights)
-- 
2.20.1




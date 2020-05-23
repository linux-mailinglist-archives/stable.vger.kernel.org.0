Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C983E1DF9AD
	for <lists+stable@lfdr.de>; Sat, 23 May 2020 19:33:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388223AbgEWRd3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 May 2020 13:33:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387665AbgEWRdN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 May 2020 13:33:13 -0400
Received: from mo6-p02-ob.smtp.rzone.de (mo6-p02-ob.smtp.rzone.de [IPv6:2a01:238:20a:202:5302::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89BECC08C5C0;
        Sat, 23 May 2020 10:33:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1590255191;
        s=strato-dkim-0002; d=goldelico.com;
        h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=iGg8/prgUoeOR6lnau4lx4rMI7jQxFMO2Su2hEl3N+M=;
        b=q6QU98itgkjUqk2JlG4FXuMcAFOdf82h4UxRxEEBJCI/TY+amGksjmRhJrrpKUuk+x
        R0w0E5K/ex9xliJO1Q548q7W8spKJk6I1HxkadBOAGlChQXUi9X3FBdG7FHWMhCoA18r
        /3TCjp93xXw+AeQNob8InFBkaAf/2ETbD9vExSQN0PT9tnImDY8WrqVAYjcLmeR2+deT
        A+OM8H9WCbNkhHzyCsMkG/tTzRpmynUJhwhstXFFLnQe5kamOisE//ASzIYhLTmLT+9g
        YY5lIGbg2IsbizccfQ8JDARqBfVgMrqgy4F8eE5Up1IHjJaeH1pR5B+FW0jxDUJq5UW4
        qB0A==
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMhflhwDubTJ9o19MtK65S+//9m1YB9g="
X-RZG-CLASS-ID: mo00
Received: from iMac.fritz.box
        by smtp.strato.de (RZmta 46.7.0 AUTH)
        with ESMTPSA id D0a7c0w4NHX0Fac
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Sat, 23 May 2020 19:33:00 +0200 (CEST)
From:   "H. Nikolaus Schaller" <hns@goldelico.com>
To:     Evgeniy Polyakov <zbr@ioremap.net>,
        "H. Nikolaus Schaller" <hns@goldelico.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        YueHaibing <yuehaibing@huawei.com>,
        Tony Lindgren <tony@atomide.com>
Cc:     linux-kernel@vger.kernel.org, kernel@pyra-handheld.com,
        letux-kernel@openphoenux.org, linux-omap@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH 2/4] w1: omap-hdq: fix return value to be -1 if there is a timeout
Date:   Sat, 23 May 2020 19:32:55 +0200
Message-Id: <b2c2192b461fbb9b8e9bea4ad514a49557a7210b.1590255176.git.hns@goldelico.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1590255176.git.hns@goldelico.com>
References: <cover.1590255176.git.hns@goldelico.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

omap_w1_read_byte() should return -1 (or 0xff) in case of
error (e.g. missing battery).

The code accidentially overwrites the variable ret and not val,
which is returned. So it will return the initial value 0 instead
of -1.

Fixes: 27d13da8782a ("w1: omap-hdq: Simplify driver with PM runtime autosuspend")
Cc: stable@vger.kernel.org # v5.6+
Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
---
 drivers/w1/masters/omap_hdq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/w1/masters/omap_hdq.c b/drivers/w1/masters/omap_hdq.c
index d363e2a89fdfc4..9f9ec108b189e2 100644
--- a/drivers/w1/masters/omap_hdq.c
+++ b/drivers/w1/masters/omap_hdq.c
@@ -464,7 +464,7 @@ static u8 omap_w1_read_byte(void *_hdq)
 
 	ret = hdq_read_byte(hdq_data, &val);
 	if (ret)
-		ret = -1;
+		val = -1;
 
 	pm_runtime_mark_last_busy(hdq_data->dev);
 	pm_runtime_put_autosuspend(hdq_data->dev);
-- 
2.26.2


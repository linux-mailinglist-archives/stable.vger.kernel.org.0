Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8A4C20DE40
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 23:52:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727018AbgF2UX5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:23:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:37058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732557AbgF2TZa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:25:30 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57C69253F9;
        Mon, 29 Jun 2020 15:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593445344;
        bh=iP1gvP2wcog21wU62DHuRmBJpMwxw/tfhY0+y8VJY7Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1HZjGBlLqDE8otOf+atEWMRj5qqGm7xJkrLdpBcN/u07F6ag8goVOQ6qJXpO8SgmX
         e2Pqeh71M2S5V66bMj9KQhxC+Gr88StjrsjttlCF726u2PnqFKTo5eULdcMVUwQUmM
         F+A8lz9GF05HeXr9q/SjItPKyaP3khKZOyo+5/2g=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Michael Ira Krufky <mkrufky@linuxtv.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.9 102/191] media: dvb_frontend: get rid of get_property() callback
Date:   Mon, 29 Jun 2020 11:38:38 -0400
Message-Id: <20200629154007.2495120-103-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629154007.2495120-1-sashal@kernel.org>
References: <20200629154007.2495120-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.229-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.229-rc1
X-KernelTest-Deadline: 2020-07-01T15:39+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab@s-opensource.com>

commit 8f8a19fcc1a89b83d0ab6d7cf2bcdd272dbd4334 upstream

Only lg2160 implement gets_property, but there's no need for that,
as no other driver calls this callback, as get_frontend() does the
same, and set_frontend() also calls lg2160 get_frontend().

So, get rid of it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Reviewed-by: Michael Ira Krufky <mkrufky@linuxtv.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/dvb-core/dvb_frontend.c |  9 +--------
 drivers/media/dvb-core/dvb_frontend.h |  3 ---
 drivers/media/dvb-frontends/lg2160.c  | 14 --------------
 3 files changed, 1 insertion(+), 25 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 7eeb5d302c9c5..97c825f97b15e 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -1306,7 +1306,7 @@ static int dtv_property_process_get(struct dvb_frontend *fe,
 				    struct dtv_property *tvp,
 				    struct file *file)
 {
-	int r, ncaps;
+	int ncaps;
 
 	switch(tvp->cmd) {
 	case DTV_ENUM_DELSYS:
@@ -1517,13 +1517,6 @@ static int dtv_property_process_get(struct dvb_frontend *fe,
 		return -EINVAL;
 	}
 
-	/* Allow the frontend to override outgoing properties */
-	if (fe->ops.get_property) {
-		r = fe->ops.get_property(fe, tvp);
-		if (r < 0)
-			return r;
-	}
-
 	dtv_property_dump(fe, false, tvp);
 
 	return 0;
diff --git a/drivers/media/dvb-core/dvb_frontend.h b/drivers/media/dvb-core/dvb_frontend.h
index fb6e84811504d..57cedbe5c2c79 100644
--- a/drivers/media/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb-core/dvb_frontend.h
@@ -399,8 +399,6 @@ struct dtv_frontend_properties;
  * @analog_ops:		pointer to struct analog_demod_ops
  * @set_property:	callback function to allow the frontend to validade
  *			incoming properties. Should not be used on new drivers.
- * @get_property:	callback function to allow the frontend to override
- *			outcoming properties. Should not be used on new drivers.
  */
 struct dvb_frontend_ops {
 
@@ -463,7 +461,6 @@ struct dvb_frontend_ops {
 	struct analog_demod_ops analog_ops;
 
 	int (*set_property)(struct dvb_frontend* fe, struct dtv_property* tvp);
-	int (*get_property)(struct dvb_frontend* fe, struct dtv_property* tvp);
 };
 
 #ifdef __DVB_CORE__
diff --git a/drivers/media/dvb-frontends/lg2160.c b/drivers/media/dvb-frontends/lg2160.c
index f51a3a0b3949a..1b640651531d0 100644
--- a/drivers/media/dvb-frontends/lg2160.c
+++ b/drivers/media/dvb-frontends/lg2160.c
@@ -1052,16 +1052,6 @@ static int lg216x_get_frontend(struct dvb_frontend *fe,
 	return ret;
 }
 
-static int lg216x_get_property(struct dvb_frontend *fe,
-			       struct dtv_property *tvp)
-{
-	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-
-	return (DTV_ATSCMH_FIC_VER == tvp->cmd) ?
-		lg216x_get_frontend(fe, c) : 0;
-}
-
-
 static int lg2160_set_frontend(struct dvb_frontend *fe)
 {
 	struct lg216x_state *state = fe->demodulator_priv;
@@ -1372,8 +1362,6 @@ static struct dvb_frontend_ops lg2160_ops = {
 	.init                 = lg216x_init,
 	.sleep                = lg216x_sleep,
 #endif
-	.get_property         = lg216x_get_property,
-
 	.set_frontend         = lg2160_set_frontend,
 	.get_frontend         = lg216x_get_frontend,
 	.get_tune_settings    = lg216x_get_tune_settings,
@@ -1400,8 +1388,6 @@ static struct dvb_frontend_ops lg2161_ops = {
 	.init                 = lg216x_init,
 	.sleep                = lg216x_sleep,
 #endif
-	.get_property         = lg216x_get_property,
-
 	.set_frontend         = lg2160_set_frontend,
 	.get_frontend         = lg216x_get_frontend,
 	.get_tune_settings    = lg216x_get_tune_settings,
-- 
2.25.1


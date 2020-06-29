Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A620320D72B
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:06:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730961AbgF2T1f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 15:27:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:37018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732662AbgF2TZn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:25:43 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E056925403;
        Mon, 29 Jun 2020 15:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593445351;
        bh=xPMuZO5O/Jy6Op+1E1+PCul+bO+Kwo+5tm/LDP35Ixs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hA0cy/JW0Q6G3iQoZ19x1C0t796SnQTPnBkNGiu/x4I6c3LhxYp207cHqb3gr8PQk
         4l5fU1g6faUbFM2yYoD5tLs5YSTTPyts5SunNg87Dnj7UjOt38Oku+37gmwwjrzxey
         c5AAmC+/z3nABDH11XHQNhT0TC5nHdfGmHx+E7kM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Shuah Khan <shuahkg@osg.samsung.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.9 109/191] media: dvb_frontend: get rid of property cache's state
Date:   Mon, 29 Jun 2020 11:38:45 -0400
Message-Id: <20200629154007.2495120-110-sashal@kernel.org>
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

commit ef2cc27cf860b79874e9fde1419dd67c3372e41c upstream

In the past, I guess the idea was to use state in order to
allow an autofush logic. However, in the current code, it is
used only for debug messages, on a poor man's solution, as
there's already a debug message to indicate when the properties
got flushed.

So, just get rid of it for good.

Reviewed-by: Shuah Khan <shuahkg@osg.samsung.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/dvb-core/dvb_frontend.c | 20 ++++++--------------
 drivers/media/dvb-core/dvb_frontend.h |  5 -----
 2 files changed, 6 insertions(+), 19 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 5b06ac91420ff..a7ba8e200b677 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -932,8 +932,6 @@ static int dvb_frontend_clear_cache(struct dvb_frontend *fe)
 	memset(c, 0, offsetof(struct dtv_frontend_properties, strength));
 	c->delivery_system = delsys;
 
-	c->state = DTV_CLEAR;
-
 	dev_dbg(fe->dvb->device, "%s: Clearing cache for delivery system %d\n",
 			__func__, c->delivery_system);
 
@@ -1760,13 +1758,13 @@ static int dtv_property_process_set(struct dvb_frontend *fe,
 		dvb_frontend_clear_cache(fe);
 		break;
 	case DTV_TUNE:
-		/* interpret the cache of data, build either a traditional frontend
-		 * tunerequest so we can pass validation in the FE_SET_FRONTEND
-		 * ioctl.
+		/*
+		 * Use the cached Digital TV properties to tune the
+		 * frontend
 		 */
-		c->state = tvp->cmd;
-		dev_dbg(fe->dvb->device, "%s: Finalised property cache\n",
-				__func__);
+		dev_dbg(fe->dvb->device,
+			"%s: Setting the frontend from property cache\n",
+			__func__);
 
 		r = dtv_set_frontend(fe);
 		break;
@@ -1915,7 +1913,6 @@ static int dvb_frontend_ioctl(struct file *file, unsigned int cmd, void *parg)
 {
 	struct dvb_device *dvbdev = file->private_data;
 	struct dvb_frontend *fe = dvbdev->priv;
-	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
 	int err;
 
@@ -1935,7 +1932,6 @@ static int dvb_frontend_ioctl(struct file *file, unsigned int cmd, void *parg)
 		return -EPERM;
 	}
 
-	c->state = DTV_UNDEFINED;
 	err = dvb_frontend_handle_ioctl(file, cmd, parg);
 
 	up(&fepriv->sem);
@@ -2119,10 +2115,6 @@ static int dvb_frontend_handle_ioctl(struct file *file,
 			}
 			(tvp + i)->result = err;
 		}
-
-		if (c->state == DTV_TUNE)
-			dev_dbg(fe->dvb->device, "%s: Property cache is full, tuning\n", __func__);
-
 		kfree(tvp);
 		break;
 	}
diff --git a/drivers/media/dvb-core/dvb_frontend.h b/drivers/media/dvb-core/dvb_frontend.h
index f852f0a49f422..8a6267ad56d69 100644
--- a/drivers/media/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb-core/dvb_frontend.h
@@ -615,11 +615,6 @@ struct dtv_frontend_properties {
 	struct dtv_fe_stats	post_bit_count;
 	struct dtv_fe_stats	block_error;
 	struct dtv_fe_stats	block_count;
-
-	/* private: */
-	/* Cache State */
-	u32			state;
-
 };
 
 #define DVB_FE_NO_EXIT  0
-- 
2.25.1


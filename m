Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6412201362
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:01:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392302AbgFSQA7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 12:00:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:44348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392019AbgFSPNs (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:13:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 17FF72158C;
        Fri, 19 Jun 2020 15:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579627;
        bh=eCK/xj4hbKqq01/VVQSl0jOGuyqqRgI06S7nEiPHvTo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mmSckPvZ1GeVTgiCTorj3/X8U17aHIrepcvq354C3k+2G7uod5yjqf6RIP3YxOVSg
         Hv1pa7K34Ks7WvD3AwxFBzRlsgBw5Hdm/QJB5fkM+SwXWKCE4C3lwwOGaLJ9sh8MeH
         1R3QlHYIMM5fRzCXVTEP/SE7gigmP4HM1PAYusd4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Benoit Parrot <bparrot@ti.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.4 206/261] media: ov5640: fix use of destroyed mutex
Date:   Fri, 19 Jun 2020 16:33:37 +0200
Message-Id: <20200619141659.773726947@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141649.878808811@linuxfoundation.org>
References: <20200619141649.878808811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tomi Valkeinen <tomi.valkeinen@ti.com>

commit bfcba38d95a0aed146a958a84a2177af1459eddc upstream.

v4l2_ctrl_handler_free() uses hdl->lock, which in ov5640 driver is set
to sensor's own sensor->lock. In ov5640_remove(), the driver destroys the
sensor->lock first, and then calls v4l2_ctrl_handler_free(), resulting
in the use of the destroyed mutex.

Fix this by calling moving the mutex_destroy() to the end of the cleanup
sequence, as there's no need to destroy the mutex as early as possible.

Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: stable@vger.kernel.org # v4.14+
Reviewed-by: Benoit Parrot <bparrot@ti.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/i2c/ov5640.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -3068,8 +3068,8 @@ static int ov5640_probe(struct i2c_clien
 free_ctrls:
 	v4l2_ctrl_handler_free(&sensor->ctrls.handler);
 entity_cleanup:
-	mutex_destroy(&sensor->lock);
 	media_entity_cleanup(&sensor->sd.entity);
+	mutex_destroy(&sensor->lock);
 	return ret;
 }
 
@@ -3079,9 +3079,9 @@ static int ov5640_remove(struct i2c_clie
 	struct ov5640_dev *sensor = to_ov5640_dev(sd);
 
 	v4l2_async_unregister_subdev(&sensor->sd);
-	mutex_destroy(&sensor->lock);
 	media_entity_cleanup(&sensor->sd.entity);
 	v4l2_ctrl_handler_free(&sensor->ctrls.handler);
+	mutex_destroy(&sensor->lock);
 
 	return 0;
 }



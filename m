Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5ED30192813
	for <lists+stable@lfdr.de>; Wed, 25 Mar 2020 13:20:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727275AbgCYMUL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Mar 2020 08:20:11 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:42132 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727137AbgCYMUL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Mar 2020 08:20:11 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 02PCK8ai063515;
        Wed, 25 Mar 2020 07:20:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1585138808;
        bh=HVTSXMIwZpVCubTilDBdhYSPhm3IUZFIotzyKC7APK0=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=qUKL51BZYVciw2chUBkV2gZcrjdGK+rts4LPGaLijGa52V8ZyaK7fxxwjQvh3iyzd
         IgE+1RjJ0X4bIyP5FaLcdbscof2+R5jL8NOgO295HZbHdD1W+gg8f9KBdrThz8gsxO
         AU5MevI0udeufbE8i229s4w4RS/dB8O5sKVL0tZE=
Received: from DFLE100.ent.ti.com (dfle100.ent.ti.com [10.64.6.21])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 02PCK829019629
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 25 Mar 2020 07:20:08 -0500
Received: from DFLE102.ent.ti.com (10.64.6.23) by DFLE100.ent.ti.com
 (10.64.6.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Wed, 25
 Mar 2020 07:20:07 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE102.ent.ti.com
 (10.64.6.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Wed, 25 Mar 2020 07:20:07 -0500
Received: from deskari.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 02PCK5XZ037237;
        Wed, 25 Mar 2020 07:20:06 -0500
From:   Tomi Valkeinen <tomi.valkeinen@ti.com>
To:     <linux-media@vger.kernel.org>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Benoit Parrot <bparrot@ti.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC:     Tomi Valkeinen <tomi.valkeinen@ti.com>, <stable@vger.kernel.org>
Subject: [PATCH v3] media: ov5640: fix use of destroyed mutex
Date:   Wed, 25 Mar 2020 14:20:00 +0200
Message-ID: <20200325122000.26531-1-tomi.valkeinen@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200313131948.13803-1-tomi.valkeinen@ti.com>
References: <20200313131948.13803-1-tomi.valkeinen@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---

Added reviewed-by from Benoit
Added stable version

 drivers/media/i2c/ov5640.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index 854031f0b64a..2fe4a7ac0592 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -3093,8 +3093,8 @@ static int ov5640_probe(struct i2c_client *client)
 free_ctrls:
 	v4l2_ctrl_handler_free(&sensor->ctrls.handler);
 entity_cleanup:
-	mutex_destroy(&sensor->lock);
 	media_entity_cleanup(&sensor->sd.entity);
+	mutex_destroy(&sensor->lock);
 	return ret;
 }
 
@@ -3104,9 +3104,9 @@ static int ov5640_remove(struct i2c_client *client)
 	struct ov5640_dev *sensor = to_ov5640_dev(sd);
 
 	v4l2_async_unregister_subdev(&sensor->sd);
-	mutex_destroy(&sensor->lock);
 	media_entity_cleanup(&sensor->sd.entity);
 	v4l2_ctrl_handler_free(&sensor->ctrls.handler);
+	mutex_destroy(&sensor->lock);
 
 	return 0;
 }
-- 
Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki.
Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki


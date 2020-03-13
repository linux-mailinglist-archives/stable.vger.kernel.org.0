Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AB8718427C
	for <lists+stable@lfdr.de>; Fri, 13 Mar 2020 09:23:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726365AbgCMIXN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Mar 2020 04:23:13 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:39856 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726310AbgCMIXN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Mar 2020 04:23:13 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 02D8N9Ig073136;
        Fri, 13 Mar 2020 03:23:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1584087789;
        bh=g8TOPqbAbMz+FTxhaillOh4xnBaj0rIl94rlAcKQJ/A=;
        h=From:To:CC:Subject:Date;
        b=qEcARGHTzysj3YfopmuajBaZd43U8jH6CwVeeWCVmMKo3m++Qn0q5n5JWbqjkCEA8
         vNxp+YZnoZm1lmwdGE/uvmMRXS+lwAoAqxLpcfuhewO+/qGuhsUrEDESdARso3dsoR
         ppolVIIc3euHoU1iteCfEmsWl9vjBi4agaRA/C+o=
Received: from DFLE110.ent.ti.com (dfle110.ent.ti.com [10.64.6.31])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 02D8N9g0027809;
        Fri, 13 Mar 2020 03:23:09 -0500
Received: from DFLE105.ent.ti.com (10.64.6.26) by DFLE110.ent.ti.com
 (10.64.6.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Fri, 13
 Mar 2020 03:23:09 -0500
Received: from localhost.localdomain (10.64.41.19) by DFLE105.ent.ti.com
 (10.64.6.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Fri, 13 Mar 2020 03:23:08 -0500
Received: from deskari.lan (ileax41-snat.itg.ti.com [10.172.224.153])
        by localhost.localdomain (8.15.2/8.15.2) with ESMTP id 02D8N6h1107901;
        Fri, 13 Mar 2020 03:23:07 -0500
From:   Tomi Valkeinen <tomi.valkeinen@ti.com>
To:     Steve Longerbeam <slongerbeam@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        <linux-media@vger.kernel.org>, Benoit Parrot <bparrot@ti.com>
CC:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        <stable@vger.kernel.org>
Subject: [PATCH] media: ov5640: fix use of destroyed mutex
Date:   Fri, 13 Mar 2020 10:22:58 +0200
Message-ID: <20200313082258.6930-1-tomi.valkeinen@ti.com>
X-Mailer: git-send-email 2.17.1
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

Fix this by calling v4l2_ctrl_handler_free() before mutex_destroy().

Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: stable@vger.kernel.org
---
 drivers/media/i2c/ov5640.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index 854031f0b64a..64511de4eea8 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -3104,9 +3104,9 @@ static int ov5640_remove(struct i2c_client *client)
 	struct ov5640_dev *sensor = to_ov5640_dev(sd);
 
 	v4l2_async_unregister_subdev(&sensor->sd);
+	v4l2_ctrl_handler_free(&sensor->ctrls.handler);
 	mutex_destroy(&sensor->lock);
 	media_entity_cleanup(&sensor->sd.entity);
-	v4l2_ctrl_handler_free(&sensor->ctrls.handler);
 
 	return 0;
 }
-- 
Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki.
Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAEC31133F1
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:21:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728738AbfLDSUp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:20:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:58526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729950AbfLDSHu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 13:07:50 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CBBD320674;
        Wed,  4 Dec 2019 18:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575482869;
        bh=MWk4AQ2+jYOB29Ok4FHSgOcoisrRJU+A2AKBEoWaLeU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jAzaupUc78orKBgsxaswk8ra6e2W4Gt+fMFiXvKKwjagJ/6XVPaC2raQd86xDsfq5
         viCxT+T+7VtOe6Naj0IbRBLdMsAEqZ9m9sqBZpSYhWyjN5ijjQ16YZN1bc7eeDIqM+
         7dYq6WyQSAprQJdl+f7+mgfwjKPsnTJXZCeJYBUk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Eugen Hristev <eugen.hristev@microchip.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.14 167/209] media: atmel: atmel-isc: fix asd memory allocation
Date:   Wed,  4 Dec 2019 18:56:19 +0100
Message-Id: <20191204175334.976840781@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204175321.609072813@linuxfoundation.org>
References: <20191204175321.609072813@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eugen Hristev <eugen.hristev@microchip.com>

commit 1e4e25c4959c10728fbfcc6a286f9503d32dfe02 upstream.

The subsystem will free the asd memory on notifier cleanup, if the asd is
added to the notifier.
However the memory is freed using kfree.
Thus, we cannot allocate the asd using devm_*
This can lead to crashes and problems.
To test this issue, just return an error at probe, but cleanup the
notifier beforehand.

Fixes: 106267444f ("[media] atmel-isc: add the Image Sensor Controller code")

Signed-off-by: Eugen Hristev <eugen.hristev@microchip.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/platform/atmel/atmel-isc.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/media/platform/atmel/atmel-isc.c
+++ b/drivers/media/platform/atmel/atmel-isc.c
@@ -1722,8 +1722,11 @@ static int isc_parse_dt(struct device *d
 			break;
 		}
 
-		subdev_entity->asd = devm_kzalloc(dev,
-				     sizeof(*subdev_entity->asd), GFP_KERNEL);
+		/* asd will be freed by the subsystem once it's added to the
+		 * notifier list
+		 */
+		subdev_entity->asd = kzalloc(sizeof(*subdev_entity->asd),
+					     GFP_KERNEL);
 		if (subdev_entity->asd == NULL) {
 			of_node_put(rem);
 			ret = -ENOMEM;
@@ -1859,6 +1862,7 @@ static int atmel_isc_probe(struct platfo
 						   &subdev_entity->notifier);
 		if (ret) {
 			dev_err(dev, "fail to register async notifier\n");
+			kfree(subdev_entity->asd);
 			goto cleanup_subdev;
 		}
 



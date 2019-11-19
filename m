Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E265D101308
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:21:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727464AbfKSFVi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:21:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:36700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727453AbfKSFVi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:21:38 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A62BA22318;
        Tue, 19 Nov 2019 05:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574140896;
        bh=/RL5+Jx60ZVLTmjkwS/KLZJ0viMUy5T3HsSrVHwRTwI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zZsz8NlFWpe1LoA0T2eHep+bOJUp6k/AwgL7Pj1sNtZ6Vtzf+HED0uGvYVmGI6r5x
         Vp9To2hncnBzSiWftC69GYHEA7JXlJHHwyips/rGz/+k2eAi0xCp6ap4Mpzi50S+ZH
         9zmpNZQHFbmNoQ1h5MEzUse0G68/9XYFz7Xsu6NQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Duggan <aduggan@synaptics.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.3 23/48] Input: synaptics-rmi4 - do not consume more data than we have (F11, F12)
Date:   Tue, 19 Nov 2019 06:19:43 +0100
Message-Id: <20191119051006.344947808@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119050946.745015350@linuxfoundation.org>
References: <20191119050946.745015350@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Duggan <aduggan@synaptics.com>

commit 5d40d95e7e64756cc30606c2ba169271704d47cb upstream.

Currently, rmi_f11_attention() and rmi_f12_attention() functions update
the attn_data data pointer and size based on the size of the expected
size of the attention data. However, if the actual valid data in the
attn buffer is less then the expected value then the updated data
pointer will point to memory beyond the end of the attn buffer. Using
the calculated valid_bytes instead will prevent this from happening.

Signed-off-by: Andrew Duggan <aduggan@synaptics.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20191025002527.3189-3-aduggan@synaptics.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/rmi4/rmi_f11.c |    4 ++--
 drivers/input/rmi4/rmi_f12.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/input/rmi4/rmi_f11.c
+++ b/drivers/input/rmi4/rmi_f11.c
@@ -1284,8 +1284,8 @@ static irqreturn_t rmi_f11_attention(int
 			valid_bytes = f11->sensor.attn_size;
 		memcpy(f11->sensor.data_pkt, drvdata->attn_data.data,
 			valid_bytes);
-		drvdata->attn_data.data += f11->sensor.attn_size;
-		drvdata->attn_data.size -= f11->sensor.attn_size;
+		drvdata->attn_data.data += valid_bytes;
+		drvdata->attn_data.size -= valid_bytes;
 	} else {
 		error = rmi_read_block(rmi_dev,
 				data_base_addr, f11->sensor.data_pkt,
--- a/drivers/input/rmi4/rmi_f12.c
+++ b/drivers/input/rmi4/rmi_f12.c
@@ -212,8 +212,8 @@ static irqreturn_t rmi_f12_attention(int
 			valid_bytes = sensor->attn_size;
 		memcpy(sensor->data_pkt, drvdata->attn_data.data,
 			valid_bytes);
-		drvdata->attn_data.data += sensor->attn_size;
-		drvdata->attn_data.size -= sensor->attn_size;
+		drvdata->attn_data.data += valid_bytes;
+		drvdata->attn_data.size -= valid_bytes;
 	} else {
 		retval = rmi_read_block(rmi_dev, f12->data_addr,
 					sensor->data_pkt, sensor->pkt_size);



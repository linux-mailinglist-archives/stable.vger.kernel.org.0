Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C79D13FD5E
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:26:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730958AbgAPXZH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:25:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:54534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729946AbgAPXZG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:25:06 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F6B22075B;
        Thu, 16 Jan 2020 23:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217105;
        bh=m8xS/QdXqDzMIWCYpmKHpbVJ73ewjXOb5tJMfMZoxEI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cMPq7UJ24ApHpcc0QY5lT9iFVROdYZYYyTHoSorUL3K9L2jQT2rL5ImHJJhN1jSJ6
         OusxBWdT3VrnVIzbZVW5M9G6jjBR4tPGCbzmJBvph7v50hAOFCa5CIAK3XEkMd2Nu8
         gbr+efKwZVv0D+hFgtcvHzlrJodPtoLEDmL8+jRc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: [PATCH 5.4 150/203] media: rcar-vin: Fix incorrect return statement in rvin_try_format()
Date:   Fri, 17 Jan 2020 00:17:47 +0100
Message-Id: <20200116231758.004486179@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

commit a0862a40364e2f87109317e31c51c9d7bc89e33f upstream.

While refactoring code the return statement became corrupted, fix it by
returning the correct return code.

Reported-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Fixes: 897e371389e77514 ("media: rcar-vin: simplify how formats are set and reset"
Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/platform/rcar-vin/rcar-v4l2.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
@@ -208,6 +208,7 @@ static int rvin_try_format(struct rvin_d
 	ret = v4l2_subdev_call(sd, pad, set_fmt, pad_cfg, &format);
 	if (ret < 0 && ret != -ENOIOCTLCMD)
 		goto done;
+	ret = 0;
 
 	v4l2_fill_pix_format(pix, &format.format);
 
@@ -242,7 +243,7 @@ static int rvin_try_format(struct rvin_d
 done:
 	v4l2_subdev_free_pad_config(pad_cfg);
 
-	return 0;
+	return ret;
 }
 
 static int rvin_querycap(struct file *file, void *priv,



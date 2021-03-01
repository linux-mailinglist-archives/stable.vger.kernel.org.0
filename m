Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 806133291AE
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:32:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243476AbhCAUaZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:30:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:48286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243321AbhCAUXy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:23:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D24B665402;
        Mon,  1 Mar 2021 18:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621929;
        bh=HWH2mT8EBuU3SvawlmtLYIXl5D5rjbZ2+5FmiCq8ADQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j7L8XdU9tBXGPkIOOULaX5VC1Smsr2ROhOYDtlUx9fv4PBucPjVgzhAMimA81BiL3
         tB6a9LrT1+VFGHrP8mOp7UwyxUP67jpn3UH5jTYeGw3WfIjuSMU49z5gGV1Cz45fHa
         YT8HS88KuMoxNbWd8jMIphnQ2CClgd8XjayOQbHc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.11 665/775] media: i2c: max9286: fix access to unallocated memory
Date:   Mon,  1 Mar 2021 17:13:53 +0100
Message-Id: <20210301161234.243363035@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>

commit e88ccf09e79cf33cac40316ba69c820d9eebc82b upstream.

The asd allocated with v4l2_async_notifier_add_fwnode_subdev() must be
of size max9286_asd, otherwise access to max9286_asd->source will go to
unallocated memory.

Fixes: 86d37bf31af6 ("media: i2c: max9286: Allocate v4l2_async_subdev dynamically")
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Cc: stable@vger.kernel.org # v5.10+
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Tested-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/max9286.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/i2c/max9286.c
+++ b/drivers/media/i2c/max9286.c
@@ -580,7 +580,7 @@ static int max9286_v4l2_notifier_registe
 
 		asd = v4l2_async_notifier_add_fwnode_subdev(&priv->notifier,
 							    source->fwnode,
-							    sizeof(*asd));
+							    sizeof(struct max9286_asd));
 		if (IS_ERR(asd)) {
 			dev_err(dev, "Failed to add subdev for source %u: %ld",
 				i, PTR_ERR(asd));



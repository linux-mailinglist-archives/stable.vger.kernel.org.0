Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91241CAD71
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:48:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390153AbfJCRlu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 13:41:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:40588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731065AbfJCP56 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 11:57:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 824E821848;
        Thu,  3 Oct 2019 15:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570118277;
        bh=hitQ1mfnHXHFIbbLDqW+Nr4SjYwep00BuZcM0jTnrT4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tA1D6d7lERqhsvuanOKhM9u5kbrSQHpiGIVmOJLNAsJAaUX1XCHZNGtF2olBGVcuJ
         u1oCoTbkaDP0RX61ul8e4AW6nabVuZVmXVTC1YWfguVFDTBMVVyfnotagvfIm9luAp
         zQHreOsQUGdislqtRU/A8cW+avX8KwY6Of39ofYA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 54/99] media: omap3isp: Dont set streaming state on random subdevs
Date:   Thu,  3 Oct 2019 17:53:17 +0200
Message-Id: <20191003154322.690737905@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154252.297991283@linuxfoundation.org>
References: <20191003154252.297991283@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sakari Ailus <sakari.ailus@linux.intel.com>

[ Upstream commit 7ef57be07ac146e70535747797ef4aee0f06e9f9 ]

The streaming state should be set to the first upstream sub-device only,
not everywhere, for a sub-device driver itself knows how to best control
the streaming state of its own upstream sub-devices.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/omap3isp/isp.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 136ea1848701d..f41e0d08de93e 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -917,6 +917,10 @@ static int isp_pipeline_enable(struct isp_pipeline *pipe,
 					s_stream, mode);
 			pipe->do_propagation = true;
 		}
+
+		/* Stop at the first external sub-device. */
+		if (subdev->dev != isp->dev)
+			break;
 	}
 
 	return 0;
@@ -1031,6 +1035,10 @@ static int isp_pipeline_disable(struct isp_pipeline *pipe)
 				isp->crashed |= 1U << subdev->entity.id;
 			failure = -ETIMEDOUT;
 		}
+
+		/* Stop at the first external sub-device. */
+		if (subdev->dev != isp->dev)
+			break;
 	}
 
 	return failure;
-- 
2.20.1




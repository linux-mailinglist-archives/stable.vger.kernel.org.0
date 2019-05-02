Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE43711C87
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 17:22:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726268AbfEBPWB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 11:22:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:37126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726406AbfEBPWA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 11:22:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3577D20656;
        Thu,  2 May 2019 15:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556810519;
        bh=NGXnUeEoQn0xz+HwCm3UodpSHg9illXVVlssyEU3wj8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sr8+eU98MyKFVENjQJhr/jYqk4/tymGTetuMkbf6DSQ6zLlmfh2HRu3xoz3jqccp2
         tL9H9Eu/hU2tFxjtgGl0/cKmSow+tptSMtIGRiXTK+k/7AtoQe9LvtsBJCHV5EDcJn
         V4qCyG0BiGotoArI8XaqHqBMT2L9X0D+f4ezR4Tk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>
Subject: [PATCH 4.9 03/32] media: vivid: check if the cec_adapter is valid
Date:   Thu,  2 May 2019 17:20:49 +0200
Message-Id: <20190502143316.137488919@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190502143314.649935114@linuxfoundation.org>
References: <20190502143314.649935114@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans Verkuil <hverkuil@xs4all.nl>

commit ed356f110403f6acc64dcbbbfdc38662ab9b06c2 upstream.

If CEC is not enabled for the vivid driver, then the adap pointer is NULL
and 'adap->phys_addr' will fail.

Cc: <stable@vger.kernel.org>      # for v4.12 and up
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
[ Naresh: Fixed rebase conflict ]
Signed-off-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/platform/vivid/vivid-vid-common.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/media/platform/vivid/vivid-vid-common.c
+++ b/drivers/media/platform/vivid/vivid-vid-common.c
@@ -841,6 +841,7 @@ int vidioc_g_edid(struct file *file, voi
 	if (edid->start_block + edid->blocks > dev->edid_blocks)
 		edid->blocks = dev->edid_blocks - edid->start_block;
 	memcpy(edid->edid, dev->edid, edid->blocks * 128);
-	cec_set_edid_phys_addr(edid->edid, edid->blocks * 128, adap->phys_addr);
+	if (adap)
+		cec_set_edid_phys_addr(edid->edid, edid->blocks * 128, adap->phys_addr);
 	return 0;
 }



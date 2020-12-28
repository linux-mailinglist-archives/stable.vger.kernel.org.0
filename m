Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 857652E6721
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:22:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732321AbgL1QUi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 11:20:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:41874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732287AbgL1NNo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:13:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A9429206ED;
        Mon, 28 Dec 2020 13:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161183;
        bh=eIVMUBNkTv4M0R1fszy82xARhHHZegL4HKM13ZAbDIQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tLn12beDGqanOe4fOp221dMGFM6Au8id+G+eHazQYfGds5BWpD1kvoWTZ/GHzMdPP
         l/MPSswAeRVv7Nz4NV9GoDNaPOCurYTESQFQ5dSu5T4ibbBagkjopevFXFHNr5Giy4
         wZnyx4ic8tJTR3Eu3A/Kh2mDjCS2LMfdQKwY1Fmg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 129/242] media: saa7146: fix array overflow in vidioc_s_audio()
Date:   Mon, 28 Dec 2020 13:48:54 +0100
Message-Id: <20201228124911.049823128@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124904.654293249@linuxfoundation.org>
References: <20201228124904.654293249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 8e4d86e241cf035d6d3467cd346e7ce490681937 ]

The "a->index" value comes from the user via the ioctl.  The problem is
that the shift can wrap resulting in setting "mxb->cur_audinput" to an
invalid value, which later results in an array overflow.

Fixes: 6680427791c9 ("[media] mxb: fix audio handling")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/saa7146/mxb.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/media/pci/saa7146/mxb.c b/drivers/media/pci/saa7146/mxb.c
index 930218cc2de19..2e7bd82282caa 100644
--- a/drivers/media/pci/saa7146/mxb.c
+++ b/drivers/media/pci/saa7146/mxb.c
@@ -652,16 +652,17 @@ static int vidioc_s_audio(struct file *file, void *fh, const struct v4l2_audio *
 	struct mxb *mxb = (struct mxb *)dev->ext_priv;
 
 	DEB_D("VIDIOC_S_AUDIO %d\n", a->index);
-	if (mxb_inputs[mxb->cur_input].audioset & (1 << a->index)) {
-		if (mxb->cur_audinput != a->index) {
-			mxb->cur_audinput = a->index;
-			tea6420_route(mxb, a->index);
-			if (mxb->cur_audinput == 0)
-				mxb_update_audmode(mxb);
-		}
-		return 0;
+	if (a->index >= 32 ||
+	    !(mxb_inputs[mxb->cur_input].audioset & (1 << a->index)))
+		return -EINVAL;
+
+	if (mxb->cur_audinput != a->index) {
+		mxb->cur_audinput = a->index;
+		tea6420_route(mxb, a->index);
+		if (mxb->cur_audinput == 0)
+			mxb_update_audmode(mxb);
 	}
-	return -EINVAL;
+	return 0;
 }
 
 #ifdef CONFIG_VIDEO_ADV_DEBUG
-- 
2.27.0




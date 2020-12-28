Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92BD02E6920
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:47:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728212AbgL1QpJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 11:45:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:53240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728837AbgL1M4u (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 07:56:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 794E3229C6;
        Mon, 28 Dec 2020 12:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160170;
        bh=0C+GYIfeZWybqBTy4yX7z13bK34Q9hixK18jECqWek8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EzDXmltsFVBeOyF0aBHYG9geZeb6w0bD+nZX28Ha8gcv/h3/HtHvRHCIfQPGqr8KX
         1oVPQhlwyJqJpaxJdVjmTOEuK9GoUCLB+Vx81uHbfyhLDIL7zG2bQ8q4BJg00sq2k0
         S+j+MgKo1dQDa8vl1HA58sWsCi83YrDKorUDZFXU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 063/132] media: saa7146: fix array overflow in vidioc_s_audio()
Date:   Mon, 28 Dec 2020 13:49:07 +0100
Message-Id: <20201228124849.500961047@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124846.409999325@linuxfoundation.org>
References: <20201228124846.409999325@linuxfoundation.org>
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
index 0ca1e07ae7837..868af73c5536a 100644
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




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D068CF11B9
	for <lists+stable@lfdr.de>; Wed,  6 Nov 2019 10:07:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727506AbfKFJHt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Nov 2019 04:07:49 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:43043 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726843AbfKFJHt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Nov 2019 04:07:49 -0500
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue009 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MIdW9-1igtkS0UiL-00EZgr; Wed, 06 Nov 2019 10:07:37 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, stable@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Andy Gross <agross@kernel.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        linux-media@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] media: venus: remove invalid compat_ioctl32 handler
Date:   Wed,  6 Nov 2019 10:06:54 +0100
Message-Id: <20191106090731.3152446-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:8RmDx4hHYVaGCRLB35n3qdiZOzUXcVe0+StcVe0UHvHpojc5T/4
 uzsWV9aOL+uHX72YbQa8qjbMgaBFg4cUcIuX3JwFT33wd+hDOHw0Gxu/AACyXMMPHDpO3qS
 e8SezUBQFDXhSY4USnlbekvkOTc1byAB440qbxJg6rA8EyNETSc1rU5kjdE6LCJiVl742X9
 hLCFCuyKLHCV6f6MIz+NA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:0e6MMvLXfls=:4/MvFiPhzD2v4dq4ei/GqJ
 upkwO1ea9eMllyQ5KzkyyMTYbb60gFwFTEtrz+i1c2gBGOvyvCLOHIHEiLQ4mc7grzJgOnLo5
 cLAI7xO9iOjJ+TLiYYsar95qpgCMbdpilVzPE5D4fAObNbjO6NbZxxKafvpaZebU/5FSGCy1R
 xsL/R0rjvdeRtCL/vRMRkiCr2+sbjYeYyQwtbTdATCP2+ZYLAMNgNux4U8+DbWB53HQHTsOL/
 yvvZx3Ib7IVG5Nl24s1cKtUNMIpPuakHOail8qcrPP4agnnQvtCcOCJLSPxK+75uo1sdlrtMN
 Hiz3h44usxXP9FjoU7DQi5/CgdKCEON9JSrsa/Ngw/rnHk+KARie5v6/I7Lfgtf4lsgiM2QXI
 iP5RScn8nQ+z48MBPpJCBsRqDGUWU04DPfosdtLeQXwoPCigrATip1eSK4DnGDYVC7Z2U2NLK
 MWHX5Auc8oQxCompC2le/breqc7FgdOj/tE9eVK/REyPzUblOwYse1MY2Pujs+ftFwt5JDVXX
 IlRu+bxvfhCaGYLK8S7q7YpBMkf3UA99ulViCXC8ZxVAv0T0+UXQ5JScvXisuCGnT1cUUTyFG
 tAi6dhVwDpJMUQcJZG/4rNfO9v7u1BO3h+w3ajKJ3P8XtpNgfFLwBlkgvT676IdMPntGQj2oy
 ueso2NPqA7MP8javvvaTs5CZg1uxO8z8ej+5qhqLCycAH9FaXkGrkQcbaZYeKcrjPDbRftAHe
 wIEkudc61tT8/Cu7fbETvo5oYwjjPvFMWlOcqzAtjH+ZA1wQFeS+BDTzIZ/219dljJ/3/donI
 HhB0FZo5AKnKawpGrRG/p1broZNesSc/6l466L377Bzj7tUJBkqWFeIPsPjmminibnprfgbbi
 QBpI7ZPdm/tcrJr3FH7w==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

v4l2_compat_ioctl32() is the function that calls into
v4l2_file_operations->compat_ioctl32(), so setting that back to the same
function leads to a trivial endless loop, followed by a kernel
stack overrun.

Remove the incorrect assignment.

Cc: stable@vger.kernel.org
Fixes: 7472c1c69138 ("[media] media: venus: vdec: add video decoder files")
Fixes: aaaa93eda64b ("[media] media: venus: venc: add video encoder files")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/platform/qcom/venus/vdec.c | 3 ---
 drivers/media/platform/qcom/venus/venc.c | 3 ---
 2 files changed, 6 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/vdec.c b/drivers/media/platform/qcom/venus/vdec.c
index 7f4660555ddb..59ae7a1e63bc 100644
--- a/drivers/media/platform/qcom/venus/vdec.c
+++ b/drivers/media/platform/qcom/venus/vdec.c
@@ -1412,9 +1412,6 @@ static const struct v4l2_file_operations vdec_fops = {
 	.unlocked_ioctl = video_ioctl2,
 	.poll = v4l2_m2m_fop_poll,
 	.mmap = v4l2_m2m_fop_mmap,
-#ifdef CONFIG_COMPAT
-	.compat_ioctl32 = v4l2_compat_ioctl32,
-#endif
 };
 
 static int vdec_probe(struct platform_device *pdev)
diff --git a/drivers/media/platform/qcom/venus/venc.c b/drivers/media/platform/qcom/venus/venc.c
index 1b7fb2d5887c..30028ceb548b 100644
--- a/drivers/media/platform/qcom/venus/venc.c
+++ b/drivers/media/platform/qcom/venus/venc.c
@@ -1235,9 +1235,6 @@ static const struct v4l2_file_operations venc_fops = {
 	.unlocked_ioctl = video_ioctl2,
 	.poll = v4l2_m2m_fop_poll,
 	.mmap = v4l2_m2m_fop_mmap,
-#ifdef CONFIG_COMPAT
-	.compat_ioctl32 = v4l2_compat_ioctl32,
-#endif
 };
 
 static int venc_probe(struct platform_device *pdev)
-- 
2.20.0


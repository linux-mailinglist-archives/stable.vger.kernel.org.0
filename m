Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3EFB32899F
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:03:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237664AbhCASBO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:01:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:49708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237436AbhCARyI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:54:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E575C6534A;
        Mon,  1 Mar 2021 17:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620674;
        bh=QWPzJz6EnngoEbpoa1atJPevpbzJNmbk1Zc4XZlRtaY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k14onjjVjaTOk94SH0HBfHaWNgMUp8Zr6b/QTbhnHp0wuOs15GfYMnNKWmX20+hzp
         4mHmNZDSVKWJhBWjv83xo4lKPszgtxrhqVTcAyIte9R47ZtF79z/Y4J2cwEYzTmLVj
         8yXs9N5qi4tzMZZlcMrtIkstbRxY/xXrjbMrthqk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Robert Foss <robert.foss@linaro.org>,
        Andrey Konovalov <andrey.konovalov@linaro.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 198/775] media: camss: Fix signedness bug in video_enum_fmt()
Date:   Mon,  1 Mar 2021 17:06:06 +0100
Message-Id: <20210301161211.428978664@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit b00481bdca2d77fdae5f71517c09fd3b30eba57d ]

This test has a problem because we want to know if "k" is -1 or a
positive value less than "f->index".  But the "f->index" variable is a
u32 so if "k == -1" then -1 gets type promoted to UINT_MAX which is
larger than "f->index".  I've added an explicit test to check for -1.

Fixes: a3d412d4b9f3 ("media: Revert "media: camss: Make use of V4L2_CAP_IO_MC"")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Robert Foss <robert.foss@linaro.org>
Reviewed-by: Andrey Konovalov <andrey.konovalov@linaro.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/camss/camss-video.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/qcom/camss/camss-video.c b/drivers/media/platform/qcom/camss/camss-video.c
index bd9334af1c734..2fa3214775d58 100644
--- a/drivers/media/platform/qcom/camss/camss-video.c
+++ b/drivers/media/platform/qcom/camss/camss-video.c
@@ -579,7 +579,7 @@ static int video_enum_fmt(struct file *file, void *fh, struct v4l2_fmtdesc *f)
 			break;
 	}
 
-	if (k < f->index)
+	if (k == -1 || k < f->index)
 		/*
 		 * All the unique pixel formats matching the arguments
 		 * have been enumerated (k >= 0 and f->index > 0), or
-- 
2.27.0




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17757147C8E
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:53:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731553AbgAXJwx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:52:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:54980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731453AbgAXJww (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:52:52 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9FB3F214AF;
        Fri, 24 Jan 2020 09:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579859572;
        bh=xXGaGt40muQ8U38q6p3gSYtJgcyk8X9X5aajcz93LKE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K7oYcHWNvLOhGdnHdJcsNKDGpqHqR3bknBXqJmkkmgaUTuAt/VpsPqg1fgM7ztG0u
         3QWmuW+b8GzBpqS/fECZzG2OW6mB0ILmpAHU43gKRArNATpOOayIl5BgXyVjXYpUqr
         oHMlMbRNKQkarTsZBbqqmfDvuErSJ57swuMHejH8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 146/343] media: wl128x: Fix an error code in fm_download_firmware()
Date:   Fri, 24 Jan 2020 10:29:24 +0100
Message-Id: <20200124092939.226091473@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092919.490687572@linuxfoundation.org>
References: <20200124092919.490687572@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit ef4bb63dc1f7213c08e13f6943c69cd27f69e4a3 ]

We forgot to set "ret" on this error path.

Fixes: e8454ff7b9a4 ("[media] drivers:media:radio: wl128x: FM Driver Common sources")

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/radio/wl128x/fmdrv_common.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/radio/wl128x/fmdrv_common.c b/drivers/media/radio/wl128x/fmdrv_common.c
index 26895ae42fcf4..2d20d908e2803 100644
--- a/drivers/media/radio/wl128x/fmdrv_common.c
+++ b/drivers/media/radio/wl128x/fmdrv_common.c
@@ -1271,8 +1271,9 @@ static int fm_download_firmware(struct fmdev *fmdev, const u8 *fw_name)
 
 		switch (action->type) {
 		case ACTION_SEND_COMMAND:	/* Send */
-			if (fmc_send_cmd(fmdev, 0, 0, action->data,
-						action->size, NULL, NULL))
+			ret = fmc_send_cmd(fmdev, 0, 0, action->data,
+					   action->size, NULL, NULL);
+			if (ret)
 				goto rel_fw;
 
 			cmd_cnt++;
-- 
2.20.1




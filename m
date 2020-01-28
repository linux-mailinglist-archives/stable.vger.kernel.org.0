Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 770D114B6EE
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:10:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727300AbgA1OJn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:09:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:58190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727414AbgA1OJm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:09:42 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3FFFA24695;
        Tue, 28 Jan 2020 14:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220581;
        bh=hGE2T1G6lPIGWI7NEOMKzgp80gd/lwiRHwpdPFENheY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PzyQmWuuPoR1NHNUE2EoCbisL5KUDr8gFrxbwZ7AsI1pAJa0fhvpQHX+RjsoTaoQO
         slpCz3YN90RNDMaZV2hCDyfgpcr5IP3/nYhvMavsWAp1H4cvzZKRjEAE8QPR6YjzEK
         0DgKhWXc0TbQ+Mw4rWjFJLaoi6HFwIXVtomgmJvI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 063/183] media: wl128x: Fix an error code in fm_download_firmware()
Date:   Tue, 28 Jan 2020 15:04:42 +0100
Message-Id: <20200128135836.297556746@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135829.486060649@linuxfoundation.org>
References: <20200128135829.486060649@linuxfoundation.org>
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
index 51639a3f7abe4..0cee10cca0e57 100644
--- a/drivers/media/radio/wl128x/fmdrv_common.c
+++ b/drivers/media/radio/wl128x/fmdrv_common.c
@@ -1278,8 +1278,9 @@ static int fm_download_firmware(struct fmdev *fmdev, const u8 *fw_name)
 
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




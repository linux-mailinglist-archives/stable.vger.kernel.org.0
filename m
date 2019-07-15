Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94EE7697D8
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 17:13:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731771AbfGONtk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 09:49:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:33946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731768AbfGONtj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 09:49:39 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3C2420651;
        Mon, 15 Jul 2019 13:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563198579;
        bh=5ctXPbqLhnzjA82zzM+P5ypMCtc2pbYr38HOAX2NH6A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rr56TrdvRQCg8CcJFkJaoa5CR/I70yI8e8LFBQ0bw1Dc1K8MPFvJtijGv/0FGNOuv
         W1jaT3zHBhV1cJug3zE8k13gXjUfHT18sSvPy0Tg7PKHCYB+Ub8uUPl81s81qTgliq
         8YtuDmxxP6gGUDv/srelPPRpsvEGec7brlVwTlpw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans Verkuil <hverkuil@xs4all.nl>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 050/249] media: mc-device.c: don't memset __user pointer contents
Date:   Mon, 15 Jul 2019 09:43:35 -0400
Message-Id: <20190715134655.4076-50-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715134655.4076-1-sashal@kernel.org>
References: <20190715134655.4076-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans Verkuil <hverkuil@xs4all.nl>

[ Upstream commit 518fa4e0e0da97ea2e17c95ab57647ce748a96e2 ]

You can't memset the contents of a __user pointer. Instead, call copy_to_user to
copy links.reserved (which is zeroed) to the user memory.

This fixes this sparse warning:

SPARSE:drivers/media/mc/mc-device.c drivers/media/mc/mc-device.c:521:16:  warning: incorrect type in argument 1 (different address spaces)

Fixes: f49308878d720 ("media: media_device_enum_links32: clean a reserved field")

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Reviewed-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/media-device.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index b9bb4904bba1..e19df5165e78 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -510,8 +510,9 @@ static long media_device_enum_links32(struct media_device *mdev,
 	if (ret)
 		return ret;
 
-	memset(ulinks->reserved, 0, sizeof(ulinks->reserved));
-
+	if (copy_to_user(ulinks->reserved, links.reserved,
+			 sizeof(ulinks->reserved)))
+		return -EFAULT;
 	return 0;
 }
 
-- 
2.20.1


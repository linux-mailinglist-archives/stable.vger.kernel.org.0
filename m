Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C573F2EEF9
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:51:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732016AbfE3Dvc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:51:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:56670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732020AbfE3DTq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:19:46 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 83B3F247F7;
        Thu, 30 May 2019 03:19:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186386;
        bh=z2r8VEfhDv9zNBaQYC726fsNdOFlBHXcU//bG1jCdYE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MfPizdvP4UAHgtRHWyG1Oczp4te5rQcvgZvSawVMZn9BEY5E05UpTnYjQJ40TZTDh
         3aMlATm6URksF37YrDx9V0lC4HPqGqxQqEzim5czL1ho6EA1qYR7nWX/l0NDJMcDlj
         nkxUnSrRFWFv2HWt/178UpjT4LuPmTzztNshflPY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chengguang Xu <cgxu519@gmx.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 155/193] chardev: add additional check for minor range overlap
Date:   Wed, 29 May 2019 20:06:49 -0700
Message-Id: <20190530030509.856072918@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030446.953835040@linuxfoundation.org>
References: <20190530030446.953835040@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit de36e16d1557a0b6eb328bc3516359a12ba5c25c ]

Current overlap checking cannot correctly handle
a case which is baseminor < existing baseminor &&
baseminor + minorct > existing baseminor + minorct.

Signed-off-by: Chengguang Xu <cgxu519@gmx.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/char_dev.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/char_dev.c b/fs/char_dev.c
index a65e4a56318ca..20ce45c7c57c7 100644
--- a/fs/char_dev.c
+++ b/fs/char_dev.c
@@ -159,6 +159,12 @@ __register_chrdev_region(unsigned int major, unsigned int baseminor,
 			ret = -EBUSY;
 			goto out;
 		}
+
+		if (new_min < old_min && new_max > old_max) {
+			ret = -EBUSY;
+			goto out;
+		}
+
 	}
 
 	cd->next = *cp;
-- 
2.20.1




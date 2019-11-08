Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6045FF47DF
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 12:53:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391064AbfKHLxP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 06:53:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:34940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390515AbfKHLqw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:46:52 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4FA5F218AE;
        Fri,  8 Nov 2019 11:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213612;
        bh=7t+zd6ApZDLHyDBXxaHnsvqdU5V0/DfKsl898ThufDs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M46XlYmndMDZSK6sl1pRCC5UR0lUxcvk5+hoI/DscbEK9aPjTtIpSTlwGDIBMvevO
         15L58qs9EX74DBAgY7dh0tZdMcwJaDO9yzDGhIteF3UK7+GMGDLu/Nz0/oWhjyNa72
         rf7MaVqv7pL/u9D/J5P9U6mQ7+bUZWL+PyS07ck8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lao Wei <zrlw@qq.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 47/64] media: fix: media: pci: meye: validate offset to avoid arbitrary access
Date:   Fri,  8 Nov 2019 06:45:28 -0500
Message-Id: <20191108114545.15351-47-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108114545.15351-1-sashal@kernel.org>
References: <20191108114545.15351-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lao Wei <zrlw@qq.com>

[ Upstream commit eac7230fdb4672c2cb56f6a01a1744f562c01f80 ]

Motion eye video4linux driver for Sony Vaio PictureBook desn't validate user-controlled parameter
'vma->vm_pgoff', a malicious process might access all of kernel memory from user space by trying
pass different arbitrary address.
Discussion: http://www.openwall.com/lists/oss-security/2018/07/06/1

Signed-off-by: Lao Wei <zrlw@qq.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/meye/meye.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/meye/meye.c b/drivers/media/pci/meye/meye.c
index ba887e8e1b171..a85c5199ccd30 100644
--- a/drivers/media/pci/meye/meye.c
+++ b/drivers/media/pci/meye/meye.c
@@ -1469,7 +1469,7 @@ static int meye_mmap(struct file *file, struct vm_area_struct *vma)
 	unsigned long page, pos;
 
 	mutex_lock(&meye.lock);
-	if (size > gbuffers * gbufsize) {
+	if (size > gbuffers * gbufsize || offset > gbuffers * gbufsize - size) {
 		mutex_unlock(&meye.lock);
 		return -EINVAL;
 	}
-- 
2.20.1


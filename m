Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B978ABA905
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:51:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395452AbfIVTKj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 15:10:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:33482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394922AbfIVS6n (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:58:43 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D2F921479;
        Sun, 22 Sep 2019 18:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178722;
        bh=+kaR1zmgN9/ZjOajslj+EK8Owr5UV0N8gNh6ajQirMo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eD57q4u6FepZA57LZzsGRqG5LG5LZ0/VHdBFI9JowuByEWX7YvmD6lkxKMSKxi/wC
         5+R2mm3/y/cfvKJoQypMxDUh/XL/nY0bNdKXdB8oR+W4i6FacP4ekEBBukGB3kMEgP
         ip/U9PbqTZ1CZHbrhMnreC8RslLlFK8Z9ARbGYsU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 54/89] media: cec-notifier: clear cec_adap in cec_notifier_unregister
Date:   Sun, 22 Sep 2019 14:56:42 -0400
Message-Id: <20190922185717.3412-54-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922185717.3412-1-sashal@kernel.org>
References: <20190922185717.3412-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

[ Upstream commit 14d5511691e5290103bc480998bc322e68f139d4 ]

If cec_notifier_cec_adap_unregister() is called before
cec_unregister_adapter() then everything is OK (and this is the
case today). But if it is the other way around, then
cec_notifier_unregister() is called first, and that doesn't
set n->cec_adap to NULL.

So if e.g. cec_notifier_set_phys_addr() is called after
cec_notifier_unregister() but before cec_unregister_adapter()
then n->cec_adap points to an unregistered and likely deleted
cec adapter. So just set n->cec_adap->notifier and n->cec_adap
to NULL for rubustness.

Eventually cec_notifier_unregister will disappear and this will
be simplified substantially.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/cec/cec-notifier.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/cec/cec-notifier.c b/drivers/media/cec/cec-notifier.c
index 08b619d0ea1ef..cd04499df4892 100644
--- a/drivers/media/cec/cec-notifier.c
+++ b/drivers/media/cec/cec-notifier.c
@@ -130,6 +130,8 @@ void cec_notifier_unregister(struct cec_notifier *n)
 {
 	mutex_lock(&n->lock);
 	n->callback = NULL;
+	n->cec_adap->notifier = NULL;
+	n->cec_adap = NULL;
 	mutex_unlock(&n->lock);
 	cec_notifier_put(n);
 }
-- 
2.20.1


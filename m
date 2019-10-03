Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A08DCACDD
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:47:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730886AbfJCRay (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 13:30:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:60372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730776AbfJCQKs (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:10:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 290E020865;
        Thu,  3 Oct 2019 16:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570119047;
        bh=wNr6pegQhACiQ4qzoUw117XMXI00XuVxmvoZN5YDoVM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N85YpfA7kJz17bmDrXS2pALRrN8V57Hio7xYDffJLDmi/98v4D+4Vzvp3OiYr3rfy
         ykJ9JDZk7O4Ij6zbfJsUBz931mjvpLtMGOyS6XP92iXUcy0vZMguTBFp46M1zZigW4
         WPW6Wo4wzKUlU7JgKVy4poqDB34CPrwqYMyiH80g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wenwen Wang <wenwen@cs.uga.edu>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 106/185] media: saa7146: add cleanup in hexium_attach()
Date:   Thu,  3 Oct 2019 17:53:04 +0200
Message-Id: <20191003154502.905323119@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154437.541662648@linuxfoundation.org>
References: <20191003154437.541662648@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wenwen Wang <wenwen@cs.uga.edu>

[ Upstream commit 42e64117d3b4a759013f77bbcf25ab6700e55de7 ]

If saa7146_register_device() fails, no cleanup is executed, leading to
memory/resource leaks. To fix this issue, perform necessary cleanup work
before returning the error.

Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/saa7146/hexium_gemini.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/pci/saa7146/hexium_gemini.c b/drivers/media/pci/saa7146/hexium_gemini.c
index 934332f1fd8e6..a527d86b93a77 100644
--- a/drivers/media/pci/saa7146/hexium_gemini.c
+++ b/drivers/media/pci/saa7146/hexium_gemini.c
@@ -304,6 +304,9 @@ static int hexium_attach(struct saa7146_dev *dev, struct saa7146_pci_extension_d
 	ret = saa7146_register_device(&hexium->video_dev, dev, "hexium gemini", VFL_TYPE_GRABBER);
 	if (ret < 0) {
 		pr_err("cannot register capture v4l2 device. skipping.\n");
+		saa7146_vv_release(dev);
+		i2c_del_adapter(&hexium->i2c_adapter);
+		kfree(hexium);
 		return ret;
 	}
 
-- 
2.20.1




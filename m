Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E19062F1C1
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729604AbfE3EPh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:15:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:40694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730551AbfE3DP6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:15:58 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7AF8123D83;
        Thu, 30 May 2019 03:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186158;
        bh=bDXiMGFvmldpxTxfhq4JdbAQvsgjlZNGG0/Vu9YG5q8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mFjfQryXEpRivxSIweygtTA9VeeAlGXit18/iLdWo9eCXz21iu7EcQi6ztAHPXHNm
         BXMdWYllxAoCQmBSFYy3Fj4YG4fYxlrNowOifpuMWx9WlfCFra6rKhcrmjhgW95kLy
         j+3+fWgWxwd5mV04TtJjIuEv66qrkWeHmfAfzYDw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 307/346] media: go7007: avoid clang frame overflow warning with KASAN
Date:   Wed, 29 May 2019 20:06:20 -0700
Message-Id: <20190530030556.388152878@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.363386121@linuxfoundation.org>
References: <20190530030540.363386121@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit ed713a4a1367aca5c0f2f329579465db00c17995 ]

clang-8 warns about one function here when KASAN is enabled, even
without the 'asan-stack' option:

drivers/media/usb/go7007/go7007-fw.c:1551:5: warning: stack frame size of 2656 bytes in function

I have reported this issue in the llvm bugzilla, but to make
it work with the clang-8 release, a small annotation is still
needed.

Link: https://bugs.llvm.org/show_bug.cgi?id=38809

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
[hverkuil-cisco@xs4all.nl: fix checkpatch warning]
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/go7007/go7007-fw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/go7007/go7007-fw.c b/drivers/media/usb/go7007/go7007-fw.c
index 24f5b615dc7af..dfa9f899d0c25 100644
--- a/drivers/media/usb/go7007/go7007-fw.c
+++ b/drivers/media/usb/go7007/go7007-fw.c
@@ -1499,8 +1499,8 @@ static int modet_to_package(struct go7007 *go, __le16 *code, int space)
 	return cnt;
 }
 
-static int do_special(struct go7007 *go, u16 type, __le16 *code, int space,
-			int *framelen)
+static noinline_for_stack int do_special(struct go7007 *go, u16 type,
+					 __le16 *code, int space, int *framelen)
 {
 	switch (type) {
 	case SPECIAL_FRM_HEAD:
-- 
2.20.1




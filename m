Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFE8F37C97A
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:47:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235328AbhELQTe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:19:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:33672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239657AbhELQKh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:10:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 68ECA61D3D;
        Wed, 12 May 2021 15:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834031;
        bh=Ozu9cEeXhF61Qpn+h1v9T2VD9/RN7qGoiRsqkULblKk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mAQrj2tfKmo0Do4KroP5LMCqAbOL4nmvTsX2JOPJkViJmscLxQDwjKyWttwlNYQb8
         RXYToArVC9ZPxDAd+Xgi64Xy/o/mSu8WStw8MaGgQEU6JBjsw8jZvdrhgZAYU7YkGs
         6f/h17+Pgz9ymVPwzqbcj2zG3mfCmSlvfkTLeVYs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dima Stepanov <dmitrii.stepanov@ionos.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Jack Wang <jinpu.wang@ionos.com>,
        Gioh Kim <gi-oh.kim@cloud.ionos.com>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 383/601] block/rnbd-clt-sysfs: Remove copy buffer overlap in rnbd_clt_get_path_name
Date:   Wed, 12 May 2021 16:47:40 +0200
Message-Id: <20210512144840.405033709@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dima Stepanov <dmitrii.stepanov@cloud.ionos.com>

[ Upstream commit 3db7cf55d532a15ea26b4a14e8f8729ccd96fd22 ]

cppcheck report the following error:
  rnbd/rnbd-clt-sysfs.c:522:36: error: The variable 'buf' is used both
  as a parameter and as destination in snprintf(). The origin and
  destination buffers overlap. Quote from glibc (C-library)
  documentation
  (http://www.gnu.org/software/libc/manual/html_mono/libc.html#Formatted-Output-Functions):
  "If copying takes place between objects that overlap as a result of a
  call to sprintf() or snprintf(), the results are undefined."
  [sprintfOverlappingData]
Fix it by initializing the buf variable in the first snprintf call.

Fixes: 91f4acb2801c ("block/rnbd-clt: support mapping two devices")
Signed-off-by: Dima Stepanov <dmitrii.stepanov@ionos.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Gioh Kim <gi-oh.kim@cloud.ionos.com>
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Link: https://lore.kernel.org/r/20210419073722.15351-19-gi-oh.kim@ionos.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/rnbd/rnbd-clt-sysfs.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/block/rnbd/rnbd-clt-sysfs.c b/drivers/block/rnbd/rnbd-clt-sysfs.c
index 526c77cd7a50..49ad400a5225 100644
--- a/drivers/block/rnbd/rnbd-clt-sysfs.c
+++ b/drivers/block/rnbd/rnbd-clt-sysfs.c
@@ -483,11 +483,7 @@ static int rnbd_clt_get_path_name(struct rnbd_clt_dev *dev, char *buf,
 	while ((s = strchr(pathname, '/')))
 		s[0] = '!';
 
-	ret = snprintf(buf, len, "%s", pathname);
-	if (ret >= len)
-		return -ENAMETOOLONG;
-
-	ret = snprintf(buf, len, "%s@%s", buf, dev->sess->sessname);
+	ret = snprintf(buf, len, "%s@%s", pathname, dev->sess->sessname);
 	if (ret >= len)
 		return -ENAMETOOLONG;
 
-- 
2.30.2




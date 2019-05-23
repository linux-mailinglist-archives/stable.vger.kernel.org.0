Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C312C2895A
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388129AbfEWTe5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:34:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:39550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391153AbfEWT1U (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:27:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF84F2186A;
        Thu, 23 May 2019 19:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639640;
        bh=4wgxF1YFp5FyaQGTZ3L+A80LKvSHjmr7i8d7XrTzsD0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wyZFv3yTRbZKX+TwM+fC9Qx4A+nQS08R77wgGBvGPdy8INBiy377o0IWPlFOWqBmi
         k3/jKZC+tYmVgul2wKR4XHiUBi2V4kR2Q9OwJeiYGudlvnWs7KRuBD4x8X8Sk6RabC
         a33WdY3hyV+Rk3Xjwpw+neIBiWAJwGBXZyX4HD54=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guoqing Jiang <gqjiang@suse.com>,
        Christoph Hellwig <hch@lst.de>,
        Song Liu <songliubraving@fb.com>
Subject: [PATCH 5.1 040/122] md: add a missing endianness conversion in check_sb_changes
Date:   Thu, 23 May 2019 21:06:02 +0200
Message-Id: <20190523181710.068992771@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181705.091418060@linuxfoundation.org>
References: <20190523181705.091418060@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit ed4d0a4ea11e19863952ac6a7cea3bbb27ccd452 upstream.

The on-disk value is little endian and we need to convert it to
native endian before storing the value in the in-core structure.

Fixes: 7564beda19b36 ("md-cluster/raid10: support add disk under grow mode")
Cc: <stable@vger.kernel.org> # 4.20+
Acked-by: Guoqing Jiang <gqjiang@suse.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/md.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9229,7 +9229,7 @@ static void check_sb_changes(struct mdde
 		 * reshape is happening in the remote node, we need to
 		 * update reshape_position and call start_reshape.
 		 */
-		mddev->reshape_position = sb->reshape_position;
+		mddev->reshape_position = le64_to_cpu(sb->reshape_position);
 		if (mddev->pers->update_reshape_pos)
 			mddev->pers->update_reshape_pos(mddev);
 		if (mddev->pers->start_reshape)



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D25B724B3FB
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 11:55:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728244AbgHTJzC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:55:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:37832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730178AbgHTJy6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:54:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98CED2067C;
        Thu, 20 Aug 2020 09:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597917298;
        bh=yyE+nWCDLiFzg8TXH1V6lIX1NecfxIOE1OLjTtT2LvM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vAiD96o9i+qGerl6vfacZ5LV+BcZhGFO5LmGoJ/TOHH2XQcz3teMGB3/Oo2lAx8jw
         e/maAU4iw9SYlD5dvgTTiuU4/q0uNWHVY4ZNjSrxntS7k2cOOFkNzSl6aeoPcBK9PW
         XB7OjNqAzHYfGDUXxhrjezTKZ12k7JKrFghhpZ9c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 73/92] Input: sentelic - fix error return when fsp_reg_write fails
Date:   Thu, 20 Aug 2020 11:21:58 +0200
Message-Id: <20200820091541.476797643@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091537.490965042@linuxfoundation.org>
References: <20200820091537.490965042@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit ea38f06e0291986eb93beb6d61fd413607a30ca4 ]

Currently when the call to fsp_reg_write fails -EIO is not being returned
because the count is being returned instead of the return value in retval.
Fix this by returning the value in retval instead of count.

Addresses-Coverity: ("Unused value")
Fixes: fc69f4a6af49 ("Input: add new driver for Sentelic Finger Sensing Pad")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Link: https://lore.kernel.org/r/20200603141218.131663-1-colin.king@canonical.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/mouse/sentelic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/mouse/sentelic.c b/drivers/input/mouse/sentelic.c
index 1d6010d463e2c..022a8cb58a066 100644
--- a/drivers/input/mouse/sentelic.c
+++ b/drivers/input/mouse/sentelic.c
@@ -454,7 +454,7 @@ static ssize_t fsp_attr_set_setreg(struct psmouse *psmouse, void *data,
 
 	fsp_reg_write_enable(psmouse, false);
 
-	return count;
+	return retval;
 }
 
 PSMOUSE_DEFINE_WO_ATTR(setreg, S_IWUSR, NULL, fsp_attr_set_setreg);
-- 
2.25.1




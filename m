Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDD613A95B
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:10:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388321AbfFIRCw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 13:02:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:40996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388302AbfFIRCw (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 13:02:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81FCE206DF;
        Sun,  9 Jun 2019 17:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099772;
        bh=zXy8nO5A7IVBg+N3rB34CovA3fHyL9pOXlgnFXZtya0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gdRJm20UBxeN3WLL8WcCdQPjjEu1Ad3wZHO52PKvAu5OQCzAYmPGQbV6BfHGC4uWK
         AwG4vWzBHtVK+wNf4psC8CuHJaHs7XwJywTjlY2sn4zjVPTkHwFt+/8NtfrGNIt318
         r+gvfoLvdX7uZZyYWiCU+Yi/7/O5xRV91OLx3brA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chengguang Xu <cgxu519@gmx.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 160/241] chardev: add additional check for minor range overlap
Date:   Sun,  9 Jun 2019 18:41:42 +0200
Message-Id: <20190609164152.386477349@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164147.729157653@linuxfoundation.org>
References: <20190609164147.729157653@linuxfoundation.org>
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
index 24b142569ca9b..d0655ca894816 100644
--- a/fs/char_dev.c
+++ b/fs/char_dev.c
@@ -130,6 +130,12 @@ __register_chrdev_region(unsigned int major, unsigned int baseminor,
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




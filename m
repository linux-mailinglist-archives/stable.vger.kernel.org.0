Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 120AD2F559
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:47:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729038AbfE3Eqa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:46:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:51986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728647AbfE3DLl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:11:41 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57B66244C4;
        Thu, 30 May 2019 03:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185901;
        bh=bGWh8woQtXz5m+43YaRhu03gvWUMuFyE+qLFTPAiZ50=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2YIUISKpjpdwl8zgAJGgxkRRQ2fUThP8uW1CZ84/N+H4h02Qnq+wNcrtZibQPYcET
         IyenKtk4VrAKLYmauXM5pCjz41H7VOjaXAP2MqYoPONA4LjLlFWknicpQgRaI7P93P
         bcKf+9pmgNl+R3FVW1cZHaAM2ziD5tTS0i1n4XOk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chengguang Xu <cgxu519@gmx.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 270/405] chardev: add additional check for minor range overlap
Date:   Wed, 29 May 2019 20:04:28 -0700
Message-Id: <20190530030554.569076207@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
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
index a279c58fe3606..8a63cfa290053 100644
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




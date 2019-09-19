Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0179CB86CF
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:32:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390858AbfISWN6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:13:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:53212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732518AbfISWN5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:13:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7CE3521928;
        Thu, 19 Sep 2019 22:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568931236;
        bh=NoWiiN+YR+siC2fuxXMqW2KZlDXfQK2sAy7N7qhgESU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lCtj4dluXspUDRxvIQj+F3rr3PL+7G+WUz2xoi/mQjRST+FSPMPnNFdPTbOtl8Zd7
         R5a/g4It7JKvy5UhcLuCfYUXSNCwX+AVe5Kcn7uC57oEHg14FOfOfuBT53L8VfBtU0
         NYpxnPeP6bnx9oBVsmhvCqtIGF4F+gN+OyzqzMH8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 53/79] cifs: Use kzfree() to zero out the password
Date:   Fri, 20 Sep 2019 00:03:38 +0200
Message-Id: <20190919214812.145410684@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214807.612593061@linuxfoundation.org>
References: <20190919214807.612593061@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 478228e57f81f6cb60798d54fc02a74ea7dd267e ]

It's safer to zero out the password so that it can never be disclosed.

Fixes: 0c219f5799c7 ("cifs: set domainName when a domain-key is used in multiuser")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/connect.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 75727518b272a..c290e231f9188 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2876,7 +2876,7 @@ cifs_set_cifscreds(struct smb_vol *vol, struct cifs_ses *ses)
 			rc = -ENOMEM;
 			kfree(vol->username);
 			vol->username = NULL;
-			kfree(vol->password);
+			kzfree(vol->password);
 			vol->password = NULL;
 			goto out_key_put;
 		}
-- 
2.20.1




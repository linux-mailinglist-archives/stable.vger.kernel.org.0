Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 048F23CE20A
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:13:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346975AbhGSP2l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:28:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:43682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349240AbhGSP0S (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:26:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 67961610D0;
        Mon, 19 Jul 2021 16:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710816;
        bh=xl29QhYHZSBk7PjdUCAurjytbpKgIz+GTPk5gzw+iaU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Si0dQU/+pJhfMs3UVus22fMZYvTGYuCKjZIYA4atDnmRSkS4OYAuCRKR3s7JmJp+c
         wX7GPnsfdjY2yohc2uRX75HJAknQgHJWb9Jo5GBz3bRmSdfuiVwjsw4NGXx6rE7lSC
         CtRprj3FaDEjMCJjombweCDUcjbMGHViei+9fZoI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Koby Elbaz <kelbaz@habana.ai>,
        Oded Gabbay <ogabbay@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 119/351] habanalabs: remove node from list before freeing the node
Date:   Mon, 19 Jul 2021 16:51:05 +0200
Message-Id: <20210719144948.415081789@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Koby Elbaz <kelbaz@habana.ai>

[ Upstream commit f5eb7bf0c487a212ebda3c1b048fc3ccabacc147 ]

fix the following smatch warnings:

goya_pin_memory_before_cs()
warn: '&userptr->job_node' not removed from list

gaudi_pin_memory_before_cs()
warn: '&userptr->job_node' not removed from list

Signed-off-by: Koby Elbaz <kelbaz@habana.ai>
Reviewed-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/habanalabs/gaudi/gaudi.c | 1 +
 drivers/misc/habanalabs/goya/goya.c   | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/misc/habanalabs/gaudi/gaudi.c b/drivers/misc/habanalabs/gaudi/gaudi.c
index f6a56d5f2ae7..d4f764da013c 100644
--- a/drivers/misc/habanalabs/gaudi/gaudi.c
+++ b/drivers/misc/habanalabs/gaudi/gaudi.c
@@ -4934,6 +4934,7 @@ already_pinned:
 	return 0;
 
 unpin_memory:
+	list_del(&userptr->job_node);
 	hl_unpin_host_memory(hdev, userptr);
 free_userptr:
 	kfree(userptr);
diff --git a/drivers/misc/habanalabs/goya/goya.c b/drivers/misc/habanalabs/goya/goya.c
index e0ad2a269779..d4ac10b9f25e 100644
--- a/drivers/misc/habanalabs/goya/goya.c
+++ b/drivers/misc/habanalabs/goya/goya.c
@@ -3270,6 +3270,7 @@ already_pinned:
 	return 0;
 
 unpin_memory:
+	list_del(&userptr->job_node);
 	hl_unpin_host_memory(hdev, userptr);
 free_userptr:
 	kfree(userptr);
-- 
2.30.2




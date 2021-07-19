Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF45E3CE4C1
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:35:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349711AbhGSPqG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:46:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:37058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236339AbhGSPmH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:42:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 61F50613E3;
        Mon, 19 Jul 2021 16:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711712;
        bh=JzkuAcSmVBtG76fI/d037P05ZTfdP1DYnXJZSR8G6ls=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cueHfgOYz/0ZTo1p2DDqKWerFSw0EzZvgo/2B/DALzuURGU0rcz1vbj+IhrolMMp5
         0ElvHvNFW6nIMxi9YtgT/geaEmHqJKEXx/sFLRAlpYLuqsLbTWMAKdru+XqvISP8yt
         WJY/Bxtpl/4DiQO6uQZmu7Q5s/cx7XZwTEF7SFdw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Koby Elbaz <kelbaz@habana.ai>,
        Oded Gabbay <ogabbay@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 104/292] habanalabs: remove node from list before freeing the node
Date:   Mon, 19 Jul 2021 16:52:46 +0200
Message-Id: <20210719144945.919616354@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.514164272@linuxfoundation.org>
References: <20210719144942.514164272@linuxfoundation.org>
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
index a03f13aa47f8..0c6092ebbc04 100644
--- a/drivers/misc/habanalabs/gaudi/gaudi.c
+++ b/drivers/misc/habanalabs/gaudi/gaudi.c
@@ -4901,6 +4901,7 @@ already_pinned:
 	return 0;
 
 unpin_memory:
+	list_del(&userptr->job_node);
 	hl_unpin_host_memory(hdev, userptr);
 free_userptr:
 	kfree(userptr);
diff --git a/drivers/misc/habanalabs/goya/goya.c b/drivers/misc/habanalabs/goya/goya.c
index ed566c52ccaa..45c9065c4b92 100644
--- a/drivers/misc/habanalabs/goya/goya.c
+++ b/drivers/misc/habanalabs/goya/goya.c
@@ -3249,6 +3249,7 @@ already_pinned:
 	return 0;
 
 unpin_memory:
+	list_del(&userptr->job_node);
 	hl_unpin_host_memory(hdev, userptr);
 free_userptr:
 	kfree(userptr);
-- 
2.30.2




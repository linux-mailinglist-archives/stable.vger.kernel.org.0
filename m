Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40C913C2E6B
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233735AbhGJC1I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:27:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:43326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232524AbhGJC0h (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:26:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D733A613CC;
        Sat, 10 Jul 2021 02:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883828;
        bh=KVl5Z7EL1bfUcpunYKuwJFM9lGykpGF8c+Qa7itN/4s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m3IBL7LQDkfEtTcl0j/y1DlvRo16X87VgnXtp3EgxAthxiig1jTnNyJ2V1KNWKaR0
         OZ7HJG4A+8v6luC8iwtsdmRnEQH24tQrPpcrfnStxOyE8ZclzKqbf387tj04t1OuJg
         frLatAmhBwDYvJygGsMJqmjZGGei0P3skfL3om1tXr0QKRDLY4u+O38uc4v/3BzU4A
         HniEA/GtbsmmsHIJ4miqkFtC29e/d01sICikWIbd5NpDVVRecWe3u8D32tdyOJ0FV3
         sqfRDe1aqpAIO6LDCM55SnlmxWk7HYG6wKHwq0NsVoXpTHzdWe07y+r0qF+lRvCNf/
         yvXukaOGkZK9w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Koby Elbaz <kelbaz@habana.ai>, Oded Gabbay <ogabbay@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.12 076/104] habanalabs: remove node from list before freeing the node
Date:   Fri,  9 Jul 2021 22:21:28 -0400
Message-Id: <20210710022156.3168825-76-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022156.3168825-1-sashal@kernel.org>
References: <20210710022156.3168825-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
@@ -4901,6 +4901,7 @@ static int gaudi_pin_memory_before_cs(struct hl_device *hdev,
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
@@ -3249,6 +3249,7 @@ static int goya_pin_memory_before_cs(struct hl_device *hdev,
 	return 0;
 
 unpin_memory:
+	list_del(&userptr->job_node);
 	hl_unpin_host_memory(hdev, userptr);
 free_userptr:
 	kfree(userptr);
-- 
2.30.2


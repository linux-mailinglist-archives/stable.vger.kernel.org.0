Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 701CD2F25B
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728868AbfE3EVF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:21:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:37724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729095AbfE3DPQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:15:16 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3AB1E2456F;
        Thu, 30 May 2019 03:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186115;
        bh=jP6U941xMJ/pMv0W8Qfpa6TpUNeBvAA7kHsdYd6KMp0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pV/M/XrDYJrdxRLxo+6OSN9Ww2fyyF23ths6U2vvlyXPTdJslzlkBodj/xd073p7a
         OxEI6tMMnXlsyEsCmyUCasHJvZl15q5zzjdTga8zmKMj6v6WbB5UMPNsJ94i7B/19f
         IbgbynYtL9wdTnf8B8Nyl82M7/mFYNcw35aTB2RY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kangjie Lu <kjlu@umn.edu>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 267/346] tty: ipwireless: fix missing checks for ioremap
Date:   Wed, 29 May 2019 20:05:40 -0700
Message-Id: <20190530030554.508373699@linuxfoundation.org>
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

[ Upstream commit 1bbb1c318cd8a3a39e8c3e2e83d5e90542d6c3e3 ]

ipw->attr_memory and ipw->common_memory are assigned with the
return value of ioremap. ioremap may fail, but no checks
are enforced. The fix inserts the checks to avoid potential
NULL pointer dereferences.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/ipwireless/main.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/tty/ipwireless/main.c b/drivers/tty/ipwireless/main.c
index 3475e841ef5c1..4c18bbfe1a92e 100644
--- a/drivers/tty/ipwireless/main.c
+++ b/drivers/tty/ipwireless/main.c
@@ -114,6 +114,10 @@ static int ipwireless_probe(struct pcmcia_device *p_dev, void *priv_data)
 
 	ipw->common_memory = ioremap(p_dev->resource[2]->start,
 				resource_size(p_dev->resource[2]));
+	if (!ipw->common_memory) {
+		ret = -ENOMEM;
+		goto exit1;
+	}
 	if (!request_mem_region(p_dev->resource[2]->start,
 				resource_size(p_dev->resource[2]),
 				IPWIRELESS_PCCARD_NAME)) {
@@ -134,6 +138,10 @@ static int ipwireless_probe(struct pcmcia_device *p_dev, void *priv_data)
 
 	ipw->attr_memory = ioremap(p_dev->resource[3]->start,
 				resource_size(p_dev->resource[3]));
+	if (!ipw->attr_memory) {
+		ret = -ENOMEM;
+		goto exit3;
+	}
 	if (!request_mem_region(p_dev->resource[3]->start,
 				resource_size(p_dev->resource[3]),
 				IPWIRELESS_PCCARD_NAME)) {
-- 
2.20.1




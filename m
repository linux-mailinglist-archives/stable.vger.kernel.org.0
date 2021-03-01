Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D8BB3283CA
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:27:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233771AbhCAQYb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:24:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:57264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235510AbhCAQVx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:21:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C36B564F1F;
        Mon,  1 Mar 2021 16:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614615522;
        bh=awi5jKWbcfBp5iuBfOW4Wkl5w5qutcH25w9VHcf23zw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PHb79vEhH12qGUvYNUG96BUn62JZS4d9l8u6fOzYM4C8eNpO8UXX6/YEpHNmb2EJP
         GtSD5n69fUedfVZj+CwzKYKYlCQMPQWqEXMJFUHOZFRf4G0IfsVT68C3QiXmjRsng6
         O3HGUw46PhMlWXn/i9nB2OqZun0DN8JpUIrA9G3I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 29/93] media: cx25821: Fix a bug when reallocating some dma memory
Date:   Mon,  1 Mar 2021 17:12:41 +0100
Message-Id: <20210301161008.341974176@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161006.881950696@linuxfoundation.org>
References: <20210301161006.881950696@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit b2de3643c5024fc4fd128ba7767c7fb8b714bea7 ]

This function looks like a realloc.

However, if 'risc->cpu != NULL', the memory will be freed, but never
reallocated with the bigger 'size'.
Explicitly set 'risc->cpu' to NULL, so that the reallocation is
correctly performed a few lines below.

[hverkuil: NULL != risc->cpu -> risc->cpu]

Fixes: 5ede94c70553 ("[media] cx25821: remove bogus btcx_risc dependency)
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/cx25821/cx25821-core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/pci/cx25821/cx25821-core.c b/drivers/media/pci/cx25821/cx25821-core.c
index 54398d8a4696c..b43cf85ed5f05 100644
--- a/drivers/media/pci/cx25821/cx25821-core.c
+++ b/drivers/media/pci/cx25821/cx25821-core.c
@@ -990,8 +990,10 @@ int cx25821_riscmem_alloc(struct pci_dev *pci,
 	__le32 *cpu;
 	dma_addr_t dma = 0;
 
-	if (NULL != risc->cpu && risc->size < size)
+	if (risc->cpu && risc->size < size) {
 		pci_free_consistent(pci, risc->size, risc->cpu, risc->dma);
+		risc->cpu = NULL;
+	}
 	if (NULL == risc->cpu) {
 		cpu = pci_zalloc_consistent(pci, size, &dma);
 		if (NULL == cpu)
-- 
2.27.0




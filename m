Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39DD63289BE
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:05:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236622AbhCASD6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:03:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:49700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239174AbhCAR6k (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:58:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 76C8264F6B;
        Mon,  1 Mar 2021 17:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618360;
        bh=vbuVeIEFL7Jimxs3iKdmSS2pCjQ/tt0oQ2cjTvP/l/I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KMxJ9pIPi/0ftX248nMB7zJPmR6FjKKjEB6QRhvEQ7A9s9kyaRhMMqIi031ctPD2N
         XA0NWSHHu3kIll5xXNgQy1M6PO88I1SIIjdJrfRq13NZz1X+pBU29EOIJQUXIUeoB0
         wcBP9NeM76J8DtvBtn97Ri7eE2DI0g2AWdlvfY2E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 058/663] staging: media: atomisp: Fix size_t format specifier in hmm_alloc() debug statemenet
Date:   Mon,  1 Mar 2021 17:05:06 +0100
Message-Id: <20210301161144.614235720@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

[ Upstream commit bfe21ef195a9f2785747e698dfd19f75554e2d91 ]

Fix this build warning on 32-bit:

  drivers/staging/media/atomisp/pci/hmm/hmm.c: In function ‘hmm_alloc’:
  drivers/staging/media/atomisp/pci/hmm/hmm.c:272:3: warning: format ‘%ld’ \
     expects argument of type ‘long int’, but argument 6 has type ‘size_t {aka unsigned int}’ [-Wformat=]
     "%s: pages: 0x%08x (%ld bytes), type: %d from highmem %d, user ptr %p, cached %d\n",
     ^

Fixes: 03884c93560c ("media: atomisp: add debug for hmm alloc")
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lore.kernel.org/r/20201126181150.10576-1-bp@alien8.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/atomisp/pci/hmm/hmm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/atomisp/pci/hmm/hmm.c b/drivers/staging/media/atomisp/pci/hmm/hmm.c
index e0eaff0f8a228..6a5ee46070898 100644
--- a/drivers/staging/media/atomisp/pci/hmm/hmm.c
+++ b/drivers/staging/media/atomisp/pci/hmm/hmm.c
@@ -269,7 +269,7 @@ ia_css_ptr hmm_alloc(size_t bytes, enum hmm_bo_type type,
 		hmm_set(bo->start, 0, bytes);
 
 	dev_dbg(atomisp_dev,
-		"%s: pages: 0x%08x (%ld bytes), type: %d from highmem %d, user ptr %p, cached %d\n",
+		"%s: pages: 0x%08x (%zu bytes), type: %d from highmem %d, user ptr %p, cached %d\n",
 		__func__, bo->start, bytes, type, from_highmem, userptr, cached);
 
 	return bo->start;
-- 
2.27.0




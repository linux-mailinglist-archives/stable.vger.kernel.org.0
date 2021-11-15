Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 928544514C9
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 21:13:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345999AbhKOUNJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 15:13:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:45402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345016AbhKOT0B (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:26:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C47763706;
        Mon, 15 Nov 2021 19:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637003323;
        bh=1AzvUSBQZa7Ht1KP2fo2mVxv+n6FnHdFQnfDkLnaqnw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bJjuxZG0zE90ufW6Rn9fLWZhsUfs1Xkcr7YaNCDkN9BiXFDtuKykcELc0J4KuBTci
         egucEa9pZHf/P71isvRovFcALXsSu+YZ0dbRtcsxG8BbPZZT0MDT1H0r7S1d2D9kfd
         YkZH1fIyJznD7Bl+0pIa88IcPr9T56FjlWncMHKg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Dong Aisheng <aisheng.dong@nxp.com>,
        Peng Fan <peng.fan@nxp.com>
Subject: [PATCH 5.15 893/917] remoteproc: Fix the wrong default value of is_iomem
Date:   Mon, 15 Nov 2021 18:06:28 +0100
Message-Id: <20211115165459.331119379@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dong Aisheng <aisheng.dong@nxp.com>

commit 970675f61bf5761d7e5326f6e4df995ecdba5e11 upstream.

Currently the is_iomem is a random value in the stack which may
be default to true even on those platforms that not use iomem to
store firmware.

Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
Fixes: 40df0a91b2a5 ("remoteproc: add is_iomem to da_to_va")
Reviewed-and-tested-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Dong Aisheng <aisheng.dong@nxp.com>
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210910090621.3073540-3-peng.fan@oss.nxp.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/remoteproc/remoteproc_coredump.c   |    2 +-
 drivers/remoteproc/remoteproc_elf_loader.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/remoteproc/remoteproc_coredump.c
+++ b/drivers/remoteproc/remoteproc_coredump.c
@@ -152,8 +152,8 @@ static void rproc_copy_segment(struct rp
 			       struct rproc_dump_segment *segment,
 			       size_t offset, size_t size)
 {
+	bool is_iomem = false;
 	void *ptr;
-	bool is_iomem;
 
 	if (segment->dump) {
 		segment->dump(rproc, segment, dest, offset, size);
--- a/drivers/remoteproc/remoteproc_elf_loader.c
+++ b/drivers/remoteproc/remoteproc_elf_loader.c
@@ -178,8 +178,8 @@ int rproc_elf_load_segments(struct rproc
 		u64 filesz = elf_phdr_get_p_filesz(class, phdr);
 		u64 offset = elf_phdr_get_p_offset(class, phdr);
 		u32 type = elf_phdr_get_p_type(class, phdr);
+		bool is_iomem = false;
 		void *ptr;
-		bool is_iomem;
 
 		if (type != PT_LOAD)
 			continue;



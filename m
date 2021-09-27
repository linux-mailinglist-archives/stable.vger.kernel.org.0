Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50E82419B59
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:16:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236674AbhI0RRi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:17:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:53982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236850AbhI0RPg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:15:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D0D2611CE;
        Mon, 27 Sep 2021 17:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762666;
        bh=ZE3DqIiRVFnILrPLDrv/NgYtp8zDJdR9RR9LZV5uYlM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G/IYhUqw8W6cva0xP2kP5EEpj3TMVMwCxYRJN2ofKdc5F4dY9/pmhev6PQns9ALgr
         UG+ZdIigIbOCpSi2ElgNT8u+zC3wOLqFJZFm3vJaRhDZIHiGpuqUt18fu6ZZiTEued
         LHtLNzCgW4t7CBGsHou1z88MRCLXmspKYUC88PVs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Borislav Petkov <bp@suse.de>
Subject: [PATCH 5.10 099/103] EDAC/dmc520: Assign the proper type to dimm->edac_mode
Date:   Mon, 27 Sep 2021 19:03:11 +0200
Message-Id: <20210927170229.191547859@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170225.702078779@linuxfoundation.org>
References: <20210927170225.702078779@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

commit 54607282fae6148641a08d81a6e0953b541249c7 upstream.

dimm->edac_mode contains values of type enum edac_type - not the
corresponding capability flags. Fix that.

Fixes: 1088750d7839 ("EDAC: Add EDAC driver for DMC520")
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/20210916085258.7544-1-bp@alien8.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/edac/dmc520_edac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/edac/dmc520_edac.c
+++ b/drivers/edac/dmc520_edac.c
@@ -464,7 +464,7 @@ static void dmc520_init_csrow(struct mem
 			dimm->grain	= pvt->mem_width_in_bytes;
 			dimm->dtype	= dt;
 			dimm->mtype	= mt;
-			dimm->edac_mode	= EDAC_FLAG_SECDED;
+			dimm->edac_mode	= EDAC_SECDED;
 			dimm->nr_pages	= pages_per_rank / csi->nr_channels;
 		}
 	}



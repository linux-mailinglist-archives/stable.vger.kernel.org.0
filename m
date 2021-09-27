Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06551419CA3
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:29:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236076AbhI0Rag (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:30:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:44586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238226AbhI0R2f (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:28:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 642F961504;
        Mon, 27 Sep 2021 17:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632763058;
        bh=ZE3DqIiRVFnILrPLDrv/NgYtp8zDJdR9RR9LZV5uYlM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GzIFwPDCrGun5EIoP2aepOq+u6X/rl1+sXzMiBQyefhSkfUpYwlyk7kH1blxsZXLw
         PCDkdpy+hrDLZvgMOFCeRdoVsRN4h6q8Ns4xzgVChKq60nHqjptoI2L2ZmcoTjAj1e
         U6R69IJt4WUkHPtIkgWIlZKZUC3b9nBZ3klKTrHA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Borislav Petkov <bp@suse.de>
Subject: [PATCH 5.14 151/162] EDAC/dmc520: Assign the proper type to dimm->edac_mode
Date:   Mon, 27 Sep 2021 19:03:17 +0200
Message-Id: <20210927170238.653718262@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
References: <20210927170233.453060397@linuxfoundation.org>
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



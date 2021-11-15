Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ED5745274C
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 03:17:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245292AbhKPCUh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 21:20:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:57920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238456AbhKORnE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:43:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E4B56328C;
        Mon, 15 Nov 2021 17:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997284;
        bh=2N7Xac2r5l6QKOWZe2w133+I3zGkIS31NUiC+55RYbs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=scsscZZCGLmVlDsEHVjMys6+KY0vg24cEIZEoqksYYw9ELKF4KvdvFzayEkeC+6Ix
         6DLi68pBP19mv44G1z5Gq7l4VIVLZMSzJ+1x6UxF/Fq6Ec7vHFdEDtsEHSt3rvdkX5
         c6AovsD+0cdTk0DblzJdAinVmiZQHWEDdpc3pYac=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Meeta Saggi <msaggi@purestorage.com>,
        Eric Badger <ebadger@purestorage.com>,
        Tony Luck <tony.luck@intel.com>
Subject: [PATCH 5.10 093/575] EDAC/sb_edac: Fix top-of-high-memory value for Broadwell/Haswell
Date:   Mon, 15 Nov 2021 17:56:58 +0100
Message-Id: <20211115165346.869486276@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Badger <ebadger@purestorage.com>

commit 537bddd069c743759addf422d0b8f028ff0f8dbc upstream.

The computation of TOHM is off by one bit. This missed bit results in
too low a value for TOHM, which can cause errors in regular memory to
incorrectly report:

  EDAC MC0: 1 CE Error at MMIOH area, on addr 0x000000207fffa680 on any memory

Fixes: 50d1bb93672f ("sb_edac: add support for Haswell based systems")
Cc: stable@vger.kernel.org
Reported-by: Meeta Saggi <msaggi@purestorage.com>
Signed-off-by: Eric Badger <ebadger@purestorage.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Link: https://lore.kernel.org/r/20211010170127.848113-1-ebadger@purestorage.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/edac/sb_edac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/edac/sb_edac.c
+++ b/drivers/edac/sb_edac.c
@@ -1052,7 +1052,7 @@ static u64 haswell_get_tohm(struct sbrid
 	pci_read_config_dword(pvt->info.pci_vtd, HASWELL_TOHM_1, &reg);
 	rc = ((reg << 6) | rc) << 26;
 
-	return rc | 0x1ffffff;
+	return rc | 0x3ffffff;
 }
 
 static u64 knl_get_tolm(struct sbridge_pvt *pvt)



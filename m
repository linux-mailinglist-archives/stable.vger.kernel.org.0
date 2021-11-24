Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A979245BF40
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:53:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345990AbhKXM4Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:56:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:60468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346813AbhKXMyO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:54:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F90061165;
        Wed, 24 Nov 2021 12:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757082;
        bh=D6cjJmYZRAErMpKjBavOXto80P7Y9uQzZAcy3wm3m+o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FAG93pJpB+qjl+VlW2qTslG3W6rig6cHg3wCLybxmZkXOJLGEB5lOL9SLPS8ZQw1R
         HU6uyaTZ7DhiT/JInV89zGIvSjvlhj7v1V38Bc+3Qn4mwF4ZlPEXkEhmxh604UBer2
         elP3m4XENVfUCxDAYzd1EDly16dTiXxE8k8/c718=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Meeta Saggi <msaggi@purestorage.com>,
        Eric Badger <ebadger@purestorage.com>,
        Tony Luck <tony.luck@intel.com>
Subject: [PATCH 4.19 045/323] EDAC/sb_edac: Fix top-of-high-memory value for Broadwell/Haswell
Date:   Wed, 24 Nov 2021 12:53:55 +0100
Message-Id: <20211124115720.390849280@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
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
@@ -1021,7 +1021,7 @@ static u64 haswell_get_tohm(struct sbrid
 	pci_read_config_dword(pvt->info.pci_vtd, HASWELL_TOHM_1, &reg);
 	rc = ((reg << 6) | rc) << 26;
 
-	return rc | 0x1ffffff;
+	return rc | 0x3ffffff;
 }
 
 static u64 knl_get_tolm(struct sbridge_pvt *pvt)



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12C1C45B9E5
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:03:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236800AbhKXMGD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:06:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:60110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242160AbhKXMFY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:05:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 90CCC61057;
        Wed, 24 Nov 2021 12:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637755335;
        bh=SX7DoHxLaNiYCfImBUEd3rkhgizUcIMBHSMjr+UyZLY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XB9GPQNpApWUebcM/t5QpWWPgDQLZc8y95MzOJx9AuJlngkzoRsOUR2xFpOSd9Alq
         JkfC5mzey//URPGJdg6AzGVy8kgzeLyw6j1WM6jlEzoBkTnxkZnU8ZhyZ+nKPpSzP7
         PlYZSVF+6XZmYkFxlNpjhcj5oCov2YxOCM1ye+zU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Meeta Saggi <msaggi@purestorage.com>,
        Eric Badger <ebadger@purestorage.com>,
        Tony Luck <tony.luck@intel.com>
Subject: [PATCH 4.4 025/162] EDAC/sb_edac: Fix top-of-high-memory value for Broadwell/Haswell
Date:   Wed, 24 Nov 2021 12:55:28 +0100
Message-Id: <20211124115659.143839894@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115658.328640564@linuxfoundation.org>
References: <20211124115658.328640564@linuxfoundation.org>
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
@@ -848,7 +848,7 @@ static u64 haswell_get_tohm(struct sbrid
 	pci_read_config_dword(pvt->info.pci_vtd, HASWELL_TOHM_1, &reg);
 	rc = ((reg << 6) | rc) << 26;
 
-	return rc | 0x1ffffff;
+	return rc | 0x3ffffff;
 }
 
 static u64 haswell_rir_limit(u32 reg)



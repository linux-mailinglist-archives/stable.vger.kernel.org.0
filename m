Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74176D9EF9
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:04:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438431AbfJPV7N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 17:59:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:53714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438427AbfJPV7N (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:59:13 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D35E21D7F;
        Wed, 16 Oct 2019 21:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571263152;
        bh=eBXi4eUco+qCfMawbbaI//iav+3ieFt2vwWQoS4XPDc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SW/BUHmMXbEZ6caxMy3hzShb1myZjHdNirgVL3j3TRbAoTXvA5Zwh8EChhejGA8T0
         xMWpPH/dO5GAKmDzWazZXhWd99cMmPVq7JSTCy55Bontr84G9r3OJYCKVnOTK+6JVh
         3n5+Og4fAlavpd6/C5m8l2NTnSvbSXRA3hLS53/M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hung-Te Lin <hungte@chromium.org>,
        Brian Norris <briannorris@chromium.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Guenter Roeck <groeck@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 080/112] firmware: google: increment VPD key_len properly
Date:   Wed, 16 Oct 2019 14:51:12 -0700
Message-Id: <20191016214904.524571232@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214844.038848564@linuxfoundation.org>
References: <20191016214844.038848564@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Norris <briannorris@chromium.org>

[ Upstream commit 442f1e746e8187b9deb1590176f6b0ff19686b11 ]

Commit 4b708b7b1a2c ("firmware: google: check if size is valid when
decoding VPD data") adds length checks, but the new vpd_decode_entry()
function botched the logic -- it adds the key length twice, instead of
adding the key and value lengths separately.

On my local system, this means vpd.c's vpd_section_create_attribs() hits
an error case after the first attribute it parses, since it's no longer
looking at the correct offset. With this patch, I'm back to seeing all
the correct attributes in /sys/firmware/vpd/...

Fixes: 4b708b7b1a2c ("firmware: google: check if size is valid when decoding VPD data")
Cc: <stable@vger.kernel.org>
Cc: Hung-Te Lin <hungte@chromium.org>
Signed-off-by: Brian Norris <briannorris@chromium.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Guenter Roeck <groeck@chromium.org>
Link: https://lore.kernel.org/r/20190930214522.240680-1-briannorris@chromium.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/google/vpd_decode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/google/vpd_decode.c b/drivers/firmware/google/vpd_decode.c
index dda525c0f9682..5c6f2a74f1049 100644
--- a/drivers/firmware/google/vpd_decode.c
+++ b/drivers/firmware/google/vpd_decode.c
@@ -52,7 +52,7 @@ static int vpd_decode_entry(const u32 max_len, const u8 *input_buf,
 	if (max_len - consumed < *entry_len)
 		return VPD_FAIL;
 
-	consumed += decoded_len;
+	consumed += *entry_len;
 	*_consumed = consumed;
 	return VPD_OK;
 }
-- 
2.20.1




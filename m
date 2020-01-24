Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BA7A147C7B
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:52:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388100AbgAXJwC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:52:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:53580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732431AbgAXJwA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:52:00 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 63855214AF;
        Fri, 24 Jan 2020 09:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579859520;
        bh=3DY4Q/At/5uqLC/hjORaJvMumyLKJRBPYPh8+I1dwe8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YoPt7Kh0cUEAG879LT3g0Mx/2J9LjKLjwO9cDEgCkCMTtXWctSjFS/lKwP9VfHiGL
         7Iub0Ag2X5SoDvqOsbNzKzbwdsQwtWwFHIKoXF6Yl7Wimnkt/65D/tu6inw+9wkbfx
         5aCY8xktWPO7FzdvwEir5Vf0NKB4j5yVo8QDSYh4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nicholas Mc Guire <hofrat@osadl.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 122/343] staging: rtlwifi: Use proper enum for return in halmac_parse_psd_data_88xx
Date:   Fri, 24 Jan 2020 10:29:00 +0100
Message-Id: <20200124092936.049272815@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092919.490687572@linuxfoundation.org>
References: <20200124092919.490687572@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

[ Upstream commit e8edc32d70a4e09160835792eb5d1af71a0eec14 ]

Clang warns:

drivers/staging/rtlwifi/halmac/halmac_88xx/halmac_func_88xx.c:2472:11:
warning: implicit conversion from enumeration type 'enum
halmac_cmd_process_status' to different enumeration type 'enum
halmac_ret_status' [-Wenum-conversion]
                        return HALMAC_CMD_PROCESS_ERROR;
                        ~~~~~~ ^~~~~~~~~~~~~~~~~~~~~~~~
1 warning generated.

Fix this by using the proper enum for allocation failures,
HALMAC_RET_MALLOC_FAIL, which is used in the rest of this file.

Fixes: e4b08e16b7d9 ("staging: r8822be: check kzalloc return or bail")
Link: https://github.com/ClangBuiltLinux/linux/issues/375
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Reviewed-by: Nicholas Mc Guire <hofrat@osadl.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/rtlwifi/halmac/halmac_88xx/halmac_func_88xx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtlwifi/halmac/halmac_88xx/halmac_func_88xx.c b/drivers/staging/rtlwifi/halmac/halmac_88xx/halmac_func_88xx.c
index 15091ee587dbf..65edd14a1147a 100644
--- a/drivers/staging/rtlwifi/halmac/halmac_88xx/halmac_func_88xx.c
+++ b/drivers/staging/rtlwifi/halmac/halmac_88xx/halmac_func_88xx.c
@@ -2495,7 +2495,7 @@ halmac_parse_psd_data_88xx(struct halmac_adapter *halmac_adapter, u8 *c2h_buf,
 	if (!psd_set->data) {
 		psd_set->data = kzalloc(psd_set->data_size, GFP_KERNEL);
 		if (!psd_set->data)
-			return HALMAC_CMD_PROCESS_ERROR;
+			return HALMAC_RET_MALLOC_FAIL;
 	}
 
 	if (segment_id == 0)
-- 
2.20.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2E838AB04
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 13:21:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238912AbhETLUG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 07:20:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:37898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239844AbhETLRE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 07:17:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C68146194D;
        Thu, 20 May 2021 10:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621505373;
        bh=aqSnn32DClRk/sKgfHKM1/7v4s/2EXYqYOp9LYOrsQo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IJ+634vXMX4v8M5y1g12c1+FjucCnHVqkVG00V/zr6wIj+bWLvlHcNoipj0b26ImI
         Zej/sCx7jLQI1r27X4Js4+oglxSGF1xAidYRsvzY+we/wqi1HBdPNiKCJcX7IQHDMl
         iGpfQPsqcIDWp6+J+dEOzccdOtosAzOmRIFmNvFE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 104/190] scsi: fcoe: Fix mismatched fcoe_wwn_from_mac declaration
Date:   Thu, 20 May 2021 11:22:48 +0200
Message-Id: <20210520092105.633546421@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092102.149300807@linuxfoundation.org>
References: <20210520092102.149300807@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 5b11c9d80bde81f6896cc85b23aeaa9502a704ed ]

An old cleanup changed the array size from MAX_ADDR_LEN to unspecified in
the declaration, but now gcc-11 warns about this:

drivers/scsi/fcoe/fcoe_ctlr.c:1972:37: error: argument 1 of type ‘unsigned char[32]’ with mismatched bound [-Werror=array-parameter=]
 1972 | u64 fcoe_wwn_from_mac(unsigned char mac[MAX_ADDR_LEN],
      |                       ~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~
In file included from /git/arm-soc/drivers/scsi/fcoe/fcoe_ctlr.c:33:
include/scsi/libfcoe.h:252:37: note: previously declared as ‘unsigned char[]’
  252 | u64 fcoe_wwn_from_mac(unsigned char mac[], unsigned int, unsigned int);
      |                       ~~~~~~~~~~~~~~^~~~~

Change the type back to what the function definition uses.

Link: https://lore.kernel.org/r/20210322164702.957810-1-arnd@kernel.org
Fixes: fdd78027fd47 ("[SCSI] fcoe: cleans up libfcoe.h and adds fcoe.h for fcoe module")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/scsi/libfcoe.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/scsi/libfcoe.h b/include/scsi/libfcoe.h
index e59180264591..004bf0ca8884 100644
--- a/include/scsi/libfcoe.h
+++ b/include/scsi/libfcoe.h
@@ -256,7 +256,7 @@ int fcoe_ctlr_recv_flogi(struct fcoe_ctlr *, struct fc_lport *,
 			 struct fc_frame *);
 
 /* libfcoe funcs */
-u64 fcoe_wwn_from_mac(unsigned char mac[], unsigned int, unsigned int);
+u64 fcoe_wwn_from_mac(unsigned char mac[MAX_ADDR_LEN], unsigned int, unsigned int);
 int fcoe_libfc_config(struct fc_lport *, struct fcoe_ctlr *,
 		      const struct libfc_function_template *, int init_fcp);
 u32 fcoe_fc_crc(struct fc_frame *fp);
-- 
2.30.2




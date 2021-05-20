Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B993738A920
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239168AbhETK6H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:58:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:52232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238218AbhETK4A (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:56:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB56E61CE6;
        Thu, 20 May 2021 10:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504895;
        bh=wEos7WXOMHm+jSsREr1wT7HK3fZ2ULV1lTmouuYlNw4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bajhpbXSMLkGEfDOhRJsHR9xdUuNKeEM++NwteVIwN9tHqrNGFA+qkYOv8PG6OLKS
         aGatFO8FSpoJkKtrqLGooSMLeHeIdewdJmsZb57tln/nM92XhgXkv8xEUKZawvGlEC
         p/y8hmo3Nbo4HyvRAJbBO5Sg9WpSk74XyiDAuRpM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 129/240] scsi: fcoe: Fix mismatched fcoe_wwn_from_mac declaration
Date:   Thu, 20 May 2021 11:22:01 +0200
Message-Id: <20210520092112.993458670@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092108.587553970@linuxfoundation.org>
References: <20210520092108.587553970@linuxfoundation.org>
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
index 6be92eede5c0..a911f993219d 100644
--- a/include/scsi/libfcoe.h
+++ b/include/scsi/libfcoe.h
@@ -261,7 +261,7 @@ int fcoe_ctlr_recv_flogi(struct fcoe_ctlr *, struct fc_lport *,
 			 struct fc_frame *);
 
 /* libfcoe funcs */
-u64 fcoe_wwn_from_mac(unsigned char mac[], unsigned int, unsigned int);
+u64 fcoe_wwn_from_mac(unsigned char mac[MAX_ADDR_LEN], unsigned int, unsigned int);
 int fcoe_libfc_config(struct fc_lport *, struct fcoe_ctlr *,
 		      const struct libfc_function_template *, int init_fcp);
 u32 fcoe_fc_crc(struct fc_frame *fp);
-- 
2.30.2




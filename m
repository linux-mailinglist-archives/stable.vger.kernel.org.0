Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73CF72F7A39
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:47:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388013AbhAOMhh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:37:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:44844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388010AbhAOMhg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:37:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5874F23136;
        Fri, 15 Jan 2021 12:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714215;
        bh=ZjuFERDep951Vpl8wawyBksRr1P0VTcRCIqE6qG51oY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CgDKCYtGmbqelQwf1BG7OXR0OEw4tI4TO4mkkF0GA5xDGw/zUbJ9y4L4ClEAGjeoN
         508cP90EM7TtkGF46oOC64gPkPTI0dxaZMYaxIJzlyDVPzv5LRuZ4GWli5gDFj4Xe3
         Yy9cH+wBxpFU0Zalw3PI5CcOPmbY4uR28t2QhORk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Avri Altman <avri.altman@wdc.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 009/103] scsi: ufs: Fix -Wsometimes-uninitialized warning
Date:   Fri, 15 Jan 2021 13:27:02 +0100
Message-Id: <20210115122006.497238497@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115122006.047132306@linuxfoundation.org>
References: <20210115122006.047132306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 4c60244dc37262023d24b167e245055c06bc0b77 ]

clang complains about a possible code path in which a variable is used
without an initialization:

drivers/scsi/ufs/ufshcd.c:7690:3: error: variable 'sdp' is used uninitialized whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
                BUG_ON(1);
                ^~~~~~~~~
include/asm-generic/bug.h:63:36: note: expanded from macro 'BUG_ON'
 #define BUG_ON(condition) do { if (unlikely(condition)) BUG(); } while (0)
                                   ^~~~~~~~~~~~~~~~~~~

Turn the BUG_ON(1) into an unconditional BUG() that makes it clear to clang
that this code path is never hit.

Link: https://lore.kernel.org/r/20201203223137.1205933-1-arnd@kernel.org
Fixes: 4f3e900b6282 ("scsi: ufs: Clear UAC for FFU and RPMB LUNs")
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 02f161468daf5..7558b4abebfc5 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -7651,7 +7651,7 @@ static int ufshcd_clear_ua_wlun(struct ufs_hba *hba, u8 wlun)
 	else if (wlun == UFS_UPIU_RPMB_WLUN)
 		sdp = hba->sdev_rpmb;
 	else
-		BUG_ON(1);
+		BUG();
 	if (sdp) {
 		ret = scsi_device_get(sdp);
 		if (!ret && !scsi_device_online(sdp)) {
-- 
2.27.0




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEB712E3DED
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:22:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502606AbgL1OV4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:21:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:57454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502605AbgL1OVz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:21:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 944FC207B2;
        Mon, 28 Dec 2020 14:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165275;
        bh=AK7XCILHPpL3L3oD1C9CcQLwkGhD9XSQgN2dYQDHpUE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jDju1ltIJNUGgEMtE5WRc/JDCn1oJL6UjGVg724jKDVdZPzXgL50wFPX8cXpY2lTM
         w57hm4qqD60PGvPx3KnRPIjCkikcA7vacWciro1e7bhC3xLpWzsrSGBhK4ZxLeKIv3
         NQUz2ROt/8e5ft/Yf9gl+n0UPcc8YNukbI0oLORY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tobias Klauser <tklauser@distanz.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 473/717] devlink: use _BITUL() macro instead of BIT() in the UAPI header
Date:   Mon, 28 Dec 2020 13:47:51 +0100
Message-Id: <20201228125043.626486345@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tobias Klauser <tklauser@distanz.ch>

[ Upstream commit 75f4d4544db9fa34e1f04174f27d9f8a387be37d ]

The BIT() macro is not available for the UAPI headers. Moreover, it can
be defined differently in user space headers. Thus, replace its usage
with the _BITUL() macro which is already used in other macro definitions
in <linux/devlink.h>.

Fixes: dc64cc7c6310 ("devlink: Add devlink reload limit option")
Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
Link: https://lore.kernel.org/r/20201215102531.16958-1-tklauser@distanz.ch
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/devlink.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index 5203f54a2be1c..cf89c318f2ac9 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -322,7 +322,7 @@ enum devlink_reload_limit {
 	DEVLINK_RELOAD_LIMIT_MAX = __DEVLINK_RELOAD_LIMIT_MAX - 1
 };
 
-#define DEVLINK_RELOAD_LIMITS_VALID_MASK (BIT(__DEVLINK_RELOAD_LIMIT_MAX) - 1)
+#define DEVLINK_RELOAD_LIMITS_VALID_MASK (_BITUL(__DEVLINK_RELOAD_LIMIT_MAX) - 1)
 
 enum devlink_attr {
 	/* don't change the order or add anything between, this is ABI! */
-- 
2.27.0




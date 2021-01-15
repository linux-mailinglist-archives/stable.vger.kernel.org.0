Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B91BF2F79D5
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:42:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733055AbhAOMlg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:41:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:47220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733289AbhAOMjm (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:39:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4CE72223E0;
        Fri, 15 Jan 2021 12:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714341;
        bh=1Hn2HAFM8/AmLvKL2zOQLbIPRb3lAPDXtHGfMVpItG8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b2Imnk0tdy4krM3c0Vn5wGLUmxVLJBTp0LKsWiN/5/z79TYH/4a1xTRoHaEtF/F7c
         2HuHPKeXur1cbryXLhsMfQ22zAnvMOtXezkRV4EzlG4XY3jXY06OKgGRMRUjVnpYeB
         +AlKmwgmQ60W3d/eMw+vCDb4Oq/yH6IwSv5RQCo0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 092/103] net: mvneta: fix error message when MTU too large for XDP
Date:   Fri, 15 Jan 2021 13:28:25 +0100
Message-Id: <20210115122010.461542417@linuxfoundation.org>
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

From: Marek Behún <kabel@kernel.org>

commit 0d136f5cd9a7ba6ded7f8ff17e8b1ba680f37625 upstream.

The error message says that "Jumbo frames are not supported on XDP", but
the code checks for mtu > MVNETA_MAX_RX_BUF_SIZE, not mtu > 1500.

Fix this error message.

Signed-off-by: Marek Behún <kabel@kernel.org>
Fixes: 0db51da7a8e9 ("net: mvneta: add basic XDP support")
Cc: Lorenzo Bianconi <lorenzo@kernel.org>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Link: https://lore.kernel.org/r/20210105172333.21613-1-kabel@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/marvell/mvneta.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -4409,7 +4409,7 @@ static int mvneta_xdp_setup(struct net_d
 	struct bpf_prog *old_prog;
 
 	if (prog && dev->mtu > MVNETA_MAX_RX_BUF_SIZE) {
-		NL_SET_ERR_MSG_MOD(extack, "Jumbo frames not supported on XDP");
+		NL_SET_ERR_MSG_MOD(extack, "MTU too large for XDP");
 		return -EOPNOTSUPP;
 	}
 



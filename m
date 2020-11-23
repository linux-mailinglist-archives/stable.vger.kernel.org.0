Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD39A2C0A9E
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:54:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729538AbgKWMXH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:23:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:60162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729529AbgKWMXH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:23:07 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F0F0D20857;
        Mon, 23 Nov 2020 12:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134186;
        bh=5Z6Q/dhNhz1ZL8aMdl6VGg40qpC16Jsc9z2btMKstbQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dv5U0hutU0QRZFjKrZaEA7uUxgbXhoyqo69XChxJQ73OQMztyfUI5Ws87h6D3pIRD
         Jz2sTWrPEyaIfMpUVkTAEHKShSNNW7YVdiJtub74aFCD4ufWAkAmUqQ96t3XNwTDwx
         pyDBAcYdYAQcbva7PnPZhv2ej7ZvWHW6qKu/OaBw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.4 09/38] qlcnic: fix error return code in qlcnic_83xx_restart_hw()
Date:   Mon, 23 Nov 2020 13:21:55 +0100
Message-Id: <20201123121804.763162592@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121804.306030358@linuxfoundation.org>
References: <20201123121804.306030358@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Changzhong <zhangchangzhong@huawei.com>

[ Upstream commit 3beb9be165083c2964eba1923601c3bfac0b02d4 ]

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Fixes: 3ced0a88cd4c ("qlcnic: Add support to run firmware POST")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Link: https://lore.kernel.org/r/1605248186-16013-1-git-send-email-zhangchangzhong@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c
@@ -2255,7 +2255,8 @@ static int qlcnic_83xx_restart_hw(struct
 
 	/* Boot either flash image or firmware image from host file system */
 	if (qlcnic_load_fw_file == 1) {
-		if (qlcnic_83xx_load_fw_image_from_host(adapter))
+		err = qlcnic_83xx_load_fw_image_from_host(adapter);
+		if (err)
 			return err;
 	} else {
 		QLC_SHARED_REG_WR32(adapter, QLCNIC_FW_IMG_VALID,



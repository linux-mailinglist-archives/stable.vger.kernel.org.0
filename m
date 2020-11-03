Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF1F82A5807
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:49:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730572AbgKCVrW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:47:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:46110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731932AbgKCUvO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:51:14 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7333F22404;
        Tue,  3 Nov 2020 20:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436673;
        bh=pCkPEgzzpwvdBgw1qXhxWLv8JjtaADj2Anv/szpqaqI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YFRAEwFnQT/kVdOax1SPVNKnJNO6IBEd2Xs43QCNeT5TJKtx/Y/oD1wfbVzdl/BvZ
         J7BJ61NrXl369Xxs8NCUNNCceZLXdfznezQkX3iJXxexdaPAR+yxuPP8eSX1iFcJhJ
         Irxg1MLAmytrIIRkFYNLzxqBLIapOYyDJuOFaIac=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Dewar <alex.dewar90@gmail.com>,
        Markus Mayer <mmayer@broadcom.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH 5.9 354/391] memory: brcmstb_dpfe: Fix memory leak
Date:   Tue,  3 Nov 2020 21:36:45 +0100
Message-Id: <20201103203411.023398836@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Dewar <alex.dewar90@gmail.com>

commit 4da1edcf8f226d53c02c6b0e3077d581115b30d0 upstream.

In brcmstb_dpfe_download_firmware(), memory is allocated to variable fw by
firmware_request_nowarn(), but never released. Fix up to release fw on
all return paths.

Cc: <stable@vger.kernel.org>
Fixes: 2f330caff577 ("memory: brcmstb: Add driver for DPFE")
Signed-off-by: Alex Dewar <alex.dewar90@gmail.com>
Acked-by: Markus Mayer <mmayer@broadcom.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20200820172118.781324-1-alex.dewar90@gmail.com
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/memory/brcmstb_dpfe.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/drivers/memory/brcmstb_dpfe.c
+++ b/drivers/memory/brcmstb_dpfe.c
@@ -656,8 +656,10 @@ static int brcmstb_dpfe_download_firmwar
 		return (ret == -ENOENT) ? -EPROBE_DEFER : ret;
 
 	ret = __verify_firmware(&init, fw);
-	if (ret)
-		return -EFAULT;
+	if (ret) {
+		ret = -EFAULT;
+		goto release_fw;
+	}
 
 	__disable_dcpu(priv);
 
@@ -676,18 +678,20 @@ static int brcmstb_dpfe_download_firmwar
 
 	ret = __write_firmware(priv->dmem, dmem, dmem_size, is_big_endian);
 	if (ret)
-		return ret;
+		goto release_fw;
 	ret = __write_firmware(priv->imem, imem, imem_size, is_big_endian);
 	if (ret)
-		return ret;
+		goto release_fw;
 
 	ret = __verify_fw_checksum(&init, priv, header, init.chksum);
 	if (ret)
-		return ret;
+		goto release_fw;
 
 	__enable_dcpu(priv);
 
-	return 0;
+release_fw:
+	release_firmware(fw);
+	return ret;
 }
 
 static ssize_t generic_show(unsigned int command, u32 response[],



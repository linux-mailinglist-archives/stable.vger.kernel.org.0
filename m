Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 905B31CAFE6
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:24:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729410AbgEHNVb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 09:21:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:33254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728659AbgEHMkL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:40:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4BF772495F;
        Fri,  8 May 2020 12:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941610;
        bh=PlbFzpe2GTCYD6NCJaVRbTS6iN/i2eqHzAd5x2hLV6w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iZWXoHW5hcw3wiQTSHJdsujmHwYornlBR1stDkCgB+weUrcM8zgp0ZV/peZDhHNAz
         9Gkjx3PuM6Hh6SJ58FSXV73tyHVj5w2wgRx/vkm6D6Z6DrVuZRJcvmeQ4k7S8IKApm
         fn9g0orKj/5xC0ajOu1RUz3fesCHqVkeu8NyHWZQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Raja Mani <rmani@qti.qualcomm.com>,
        Kalle Valo <kvalo@qca.qualcomm.com>
Subject: [PATCH 4.4 099/312] ath10k: free cached fw bin contents when get board id fails
Date:   Fri,  8 May 2020 14:31:30 +0200
Message-Id: <20200508123131.488611653@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Raja Mani <rmani@qti.qualcomm.com>

commit b9c191be3fbdd9d78be11160dd7a3ddb9fdc6d42 upstream.

ath10k_core_probe_fw() simply returns error without freeing
cached firmware file content when get board id operation fails.
Free cached fw bin data in failure case to avoid memory leak.

Fixes: db0984e51a18 ("ath10k: select board data based on BMI chip id and board id")
Signed-off-by: Raja Mani <rmani@qti.qualcomm.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/ath10k/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -1805,7 +1805,7 @@ static int ath10k_core_probe_fw(struct a
 	if (ret && ret != -EOPNOTSUPP) {
 		ath10k_err(ar, "failed to get board id from otp for qca99x0: %d\n",
 			   ret);
-		return ret;
+		goto err_free_firmware_files;
 	}
 
 	ret = ath10k_core_fetch_board_file(ar);



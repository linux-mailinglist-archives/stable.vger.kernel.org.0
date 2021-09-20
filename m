Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF8B841253A
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:41:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382835AbhITSm3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:42:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:56468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1382451AbhITSk2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:40:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 866B163339;
        Mon, 20 Sep 2021 17:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632159077;
        bh=Lt8H//3PYyjNlRMNuMGGebseg7RKsl3v0b76htK/ZxM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VrlOIw1vlWVKc+LwBTjR0e9XQaVMc4LqXIzf851xzVW2Bb3XiqRl61IsMC9X4Gcoc
         85oEiLpEJ6Pg0GA4f+PFtNxZqb1Uziu1GKaa/FiwZ/1jGz8yCQ5Q0wa3f5gSx+5ywE
         1eohYN1XXij10seLrXZMWIRJ2ROT1r80iXg5NvXc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Stultz <john.stultz@linaro.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Steev Klimaszewski <steev@kali.org>
Subject: [PATCH 5.14 033/168] net: qrtr: revert check in qrtr_endpoint_post()
Date:   Mon, 20 Sep 2021 18:42:51 +0200
Message-Id: <20210920163922.738362939@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
References: <20210920163921.633181900@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit d2cabd2dc8da78faf9b690ea521d03776686c9fe upstream.

I tried to make this check stricter as a hardenning measure but it broke
audo and wifi on these devices so revert it.

Fixes: aaa8e4922c88 ("net: qrtr: make checks in qrtr_endpoint_post() stricter")
Reported-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Tested-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Steev Klimaszewski <steev@kali.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/qrtr/qrtr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/qrtr/qrtr.c
+++ b/net/qrtr/qrtr.c
@@ -493,7 +493,7 @@ int qrtr_endpoint_post(struct qrtr_endpo
 		goto err;
 	}
 
-	if (!size || size & 3 || len != size + hdrlen)
+	if (!size || len != ALIGN(size, 4) + hdrlen)
 		goto err;
 
 	if (cb->dst_port != QRTR_PORT_CTRL && cb->type != QRTR_TYPE_DATA &&



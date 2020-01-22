Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFA20144FF9
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 10:42:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387789AbgAVJms (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 04:42:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:34846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387786AbgAVJms (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 04:42:48 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5EA9824686;
        Wed, 22 Jan 2020 09:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579686167;
        bh=NJH0x6mrZKdduu+9oqEYWb28XwjUZRK5hBaz8Far3hA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fPTrc2cXouMs/ZCz/JWK4xURhpFkFYKQrp4ODihSS5BODAKfD3GmugV4fYWYEhm7O
         uk3+gEsKb0e+kHiAPiWxzTlwUp7hfHso4Woav0cGpJI4XzfDaWgfvprvSYrAlDBHpn
         rWlhWrv9i8MYOmOH5YAtB/PpsDgtKovrkrB7I3BE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 072/103] net/wan/fsl_ucc_hdlc: fix out of bounds write on array utdm_info
Date:   Wed, 22 Jan 2020 10:29:28 +0100
Message-Id: <20200122092814.159493424@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092803.587683021@linuxfoundation.org>
References: <20200122092803.587683021@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit ddf420390526ede3b9ff559ac89f58cb59d9db2f ]

Array utdm_info is declared as an array of MAX_HDLC_NUM (4) elements
however up to UCC_MAX_NUM (8) elements are potentially being written
to it.  Currently we have an array out-of-bounds write error on the
last 4 elements. Fix this by making utdm_info UCC_MAX_NUM elements in
size.

Addresses-Coverity: ("Out-of-bounds write")
Fixes: c19b6d246a35 ("drivers/net: support hdlc function for QE-UCC")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wan/fsl_ucc_hdlc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wan/fsl_ucc_hdlc.c
+++ b/drivers/net/wan/fsl_ucc_hdlc.c
@@ -76,7 +76,7 @@ static struct ucc_tdm_info utdm_primary_
 	},
 };
 
-static struct ucc_tdm_info utdm_info[MAX_HDLC_NUM];
+static struct ucc_tdm_info utdm_info[UCC_MAX_NUM];
 
 static int uhdlc_init(struct ucc_hdlc_private *priv)
 {



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF4AD144F52
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 10:36:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731318AbgAVJgn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 04:36:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:52222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731268AbgAVJgj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 04:36:39 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F169320704;
        Wed, 22 Jan 2020 09:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579685799;
        bh=CtDNPQM0JsyQC2PUySSifKGoLe1qIywQcUz1zW0SFdg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WNhGtUITl9GCBZgvicUV04yug4v11CST2d9vLV9MZqEN/jQ3KXzztSbtWdXdH44rx
         qc5t0Ngah1tcaUUFS1yyezCWwFjoq/PqBzabSEkwHUVYWJrBObT81vUc0BqMoLXfZg
         Me2zkA/T4u0JOQ07WwJ5Z33kY8e1WtrRm2Cr/7xo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 83/97] net/wan/fsl_ucc_hdlc: fix out of bounds write on array utdm_info
Date:   Wed, 22 Jan 2020 10:29:27 +0100
Message-Id: <20200122092809.683512719@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092755.678349497@linuxfoundation.org>
References: <20200122092755.678349497@linuxfoundation.org>
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
@@ -77,7 +77,7 @@ static struct ucc_tdm_info utdm_primary_
 	},
 };
 
-static struct ucc_tdm_info utdm_info[MAX_HDLC_NUM];
+static struct ucc_tdm_info utdm_info[UCC_MAX_NUM];
 
 static int uhdlc_init(struct ucc_hdlc_private *priv)
 {



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2EBA1CABC5
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729480AbgEHMqu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:46:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:48550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728853AbgEHMqs (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:46:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 08A2F2495E;
        Fri,  8 May 2020 12:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942008;
        bh=hCvt6OfUUrqHDdta7wCR11ND9UpW1jb4L9Mq/vlQU1w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cesKLAuc3M+zbSkYxV2DSAvzxnBkRvAMmsxCWopg3cfc3lCp+esQhSXzFrnYKpUml
         jn3h5L4Dq7lwutf+jvm5Pi6DHlwF1JN4Z6VUv6VFBrE5y6LOC/Jhpg5pJrHGY8OCxv
         LoU5YmijB0dXKDQt81dywDNGX2osS1K3ACjTVchQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 259/312] net: bcmsysport: Device stats are unsigned long
Date:   Fri,  8 May 2020 14:34:10 +0200
Message-Id: <20200508123142.621706930@linuxfoundation.org>
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

From: Florian Fainelli <f.fainelli@gmail.com>

commit 016eb55157166132b094e53434748cae35e18455 upstream.

On 64bits kernels, device stats are 64bits wide, not 32bits.

Fixes: 80105befdb4b ("net: systemport: add Broadcom SYSTEMPORT Ethernet MAC driver")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/broadcom/bcmsysport.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/broadcom/bcmsysport.c
+++ b/drivers/net/ethernet/broadcom/bcmsysport.c
@@ -396,7 +396,7 @@ static void bcm_sysport_get_stats(struct
 		else
 			p = (char *)priv;
 		p += s->stat_offset;
-		data[i] = *(u32 *)p;
+		data[i] = *(unsigned long *)p;
 	}
 }
 



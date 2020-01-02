Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28CEC12F0D3
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:56:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728077AbgABWz5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:55:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:34314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728234AbgABWSq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:18:46 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1917B2253D;
        Thu,  2 Jan 2020 22:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003526;
        bh=jkeFTtf4Zp47zVtKtE+iaHCA9aRYTcKmzpJUTSdGcoY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1DWxOc0nOhldEA6xxaitAy++VpWhrbExFBp0wXkYnpCo2TH7HkuVFcoA4ZXxyFOPw
         uCVrMaGps6gCbJ3F+YepM/nF9dZBHR2Tgud4CNahNFCOxhJg/+y1D+LKLeGBt929Y7
         4eRFTknMtPesULUj7QlRYg1Vul1fjLFZDGVbDy2E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taehee Yoo <ap420073@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH 5.4 178/191] gtp: avoid zero size hashtable
Date:   Thu,  2 Jan 2020 23:07:40 +0100
Message-Id: <20200102215848.339891688@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102215829.911231638@linuxfoundation.org>
References: <20200102215829.911231638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit 6a902c0f31993ab02e1b6ea7085002b9c9083b6a ]

GTP default hashtable size is 1024 and userspace could set specific
hashtable size with IFLA_GTP_PDP_HASHSIZE. If hashtable size is set to 0
from userspace,  hashtable will not work and panic will occur.

Fixes: 459aa660eb1d ("gtp: add initial driver for datapath of GPRS Tunneling Protocol (GTP-U)")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/gtp.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -660,10 +660,13 @@ static int gtp_newlink(struct net *src_n
 	if (err < 0)
 		return err;
 
-	if (!data[IFLA_GTP_PDP_HASHSIZE])
+	if (!data[IFLA_GTP_PDP_HASHSIZE]) {
 		hashsize = 1024;
-	else
+	} else {
 		hashsize = nla_get_u32(data[IFLA_GTP_PDP_HASHSIZE]);
+		if (!hashsize)
+			hashsize = 1024;
+	}
 
 	err = gtp_hashtable_new(gtp, hashsize);
 	if (err < 0)



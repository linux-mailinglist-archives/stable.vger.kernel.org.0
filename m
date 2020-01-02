Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D89712ECE4
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:23:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729189AbgABWXD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:23:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:44200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728893AbgABWW7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:22:59 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 20623227BF;
        Thu,  2 Jan 2020 22:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003778;
        bh=VSbxciRBW1NU4N+Z4pzUXw6YKwRStrA6h3PqUi1d9kg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mFNS6H7isdL8UTfoirzHhLI/BwfZeT5J5STEnGBJ+tIoU1gAOGl65sYGMb3OednRM
         QKaKQpP2uyRUbADPhbRHjX/Goe/P29m/LQUunakkS93YPhMXlSAsyyM6ouMk3M07Cs
         oM3jFnsp0MTd7FMC0nJ/FBV7mqkN5V7hlUTFNANY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taehee Yoo <ap420073@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH 4.19 111/114] gtp: avoid zero size hashtable
Date:   Thu,  2 Jan 2020 23:08:03 +0100
Message-Id: <20200102220040.300302593@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102220029.183913184@linuxfoundation.org>
References: <20200102220029.183913184@linuxfoundation.org>
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
@@ -671,10 +671,13 @@ static int gtp_newlink(struct net *src_n
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



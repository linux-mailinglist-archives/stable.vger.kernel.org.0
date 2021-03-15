Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B86333B58F
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:56:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231384AbhCONyq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:54:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:57380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231206AbhCONyL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:54:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 03FCC64EEC;
        Mon, 15 Mar 2021 13:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816451;
        bh=fnPdWvMASGiLdK/9GsNFk91Fm5EoUeVFCzeX4Nibtt4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OUYp/22Ntbq/hSWyygDV13bYAfDKlSaU4H+51cJFNxdttXXZe8YGYJOc81xim48G4
         BJW1hfCO+EhehfrsPG4q3t+uyp/nHtyoVopcwMIYG+zlGwDmYNXSpyfO6xIyg0cQgq
         BV/svTPoMq0H1Yy9mTfS8AbBZg7VDMS/Mz0RcG7s=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 4.9 46/78] staging: rtl8712: unterminated string leads to read overflow
Date:   Mon, 15 Mar 2021 14:52:09 +0100
Message-Id: <20210315135213.574612367@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135212.060847074@linuxfoundation.org>
References: <20210315135212.060847074@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Dan Carpenter <dan.carpenter@oracle.com>

commit d660f4f42ccea50262c6ee90c8e7ad19a69fb225 upstream.

The memdup_user() function does not necessarily return a NUL terminated
string so this can lead to a read overflow.  Switch from memdup_user()
to strndup_user() to fix this bug.

Fixes: c6dc001f2add ("staging: r8712u: Merging Realtek's latest (v2.6.6). Various fixes.")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/YDYSR+1rj26NRhvb@mwanda
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8712/rtl871x_ioctl_linux.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
+++ b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
@@ -932,7 +932,7 @@ static int r871x_wx_set_priv(struct net_
 	struct iw_point *dwrq = (struct iw_point *)awrq;
 
 	len = dwrq->length;
-	ext = memdup_user(dwrq->pointer, len);
+	ext = strndup_user(dwrq->pointer, len);
 	if (IS_ERR(ext))
 		return PTR_ERR(ext);
 



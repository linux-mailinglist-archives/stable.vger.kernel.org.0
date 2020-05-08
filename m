Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86C961CAFDB
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:23:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728647AbgEHNU6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 09:20:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:34542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727786AbgEHMkk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:40:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2586F20731;
        Fri,  8 May 2020 12:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941640;
        bh=9qbft4kDNoCKCrZE+chhA1A4VuP0bMF+RQz7OOYlRIM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uIqY6XCpP3YqE+13sfl3YHo7BCOzxRIRWDgrvl4w1Fqcc5kQCkklGSO2cySPzad6z
         ELIHLvNLb7sz7nsdxIG7/gGd0DJisE0yzoVT5+YRqjdRyrK4//PORZVhusk6P2tYCx
         p57/2egAn/Y7+4Ym0hBSWke/+UB6c6pJfYKpvcog=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Eckelmann <sven@open-mesh.com>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Antonio Quartulli <a@unstable.cc>
Subject: [PATCH 4.4 114/312] batman-adv: Fix lockdep annotation of batadv_tlv_container_remove
Date:   Fri,  8 May 2020 14:31:45 +0200
Message-Id: <20200508123132.495114406@linuxfoundation.org>
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

From: Sven Eckelmann <sven@open-mesh.com>

commit 008a374487070a391c12aa39288fd8511f822cab upstream.

The function handles tlv containers and not tlv handlers. Thus the
lockdep_assert_held has to check for the container_list lock.

Fixes: 2c72d655b044 ("batman-adv: Annotate deleting functions with external lock via lockdep")
Signed-off-by: Sven Eckelmann <sven@open-mesh.com>
Signed-off-by: Marek Lindner <mareklindner@neomailbox.ch>
Signed-off-by: Antonio Quartulli <a@unstable.cc>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/batman-adv/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/batman-adv/main.c
+++ b/net/batman-adv/main.c
@@ -747,7 +747,7 @@ static u16 batadv_tvlv_container_list_si
 static void batadv_tvlv_container_remove(struct batadv_priv *bat_priv,
 					 struct batadv_tvlv_container *tvlv)
 {
-	lockdep_assert_held(&bat_priv->tvlv.handler_list_lock);
+	lockdep_assert_held(&bat_priv->tvlv.container_list_lock);
 
 	if (!tvlv)
 		return;



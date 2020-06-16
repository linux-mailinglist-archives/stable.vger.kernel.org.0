Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 527541FBB06
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 18:16:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731151AbgFPPka (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:40:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:55124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731196AbgFPPk3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:40:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D61A3207C4;
        Tue, 16 Jun 2020 15:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322029;
        bh=ehGZLwBStwiNoBJPxCADAHxsq8vyqACAuHk60HMadMY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yvpgdwcg649maVWZINlj0nzNNn+g2HQO6pbEXkjs2R4XWQ4xMi8RUcy5GKMxOjQkj
         yIzspkBBeb/o3C1K89Xa/N5yjvMOVR0uUjfxsHo/ycvvOo74nJINs+NBE0FtPnAzmG
         Hek+fSHS4WqMlIZb2RCStI3x8Ylk2frKqTYDKkVI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.4 079/134] crypto: cavium/nitrox - Fix nitrox_get_first_device() when ndevlist is fully iterated
Date:   Tue, 16 Jun 2020 17:34:23 +0200
Message-Id: <20200616153104.552206373@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153100.633279950@linuxfoundation.org>
References: <20200616153100.633279950@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

commit 320bdbd816156f9ca07e5fed7bfb449f2908dda7 upstream.

When a list is completely iterated with 'list_for_each_entry(x, ...)', x is
not NULL at the end.

While at it, remove a useless initialization of the ndev variable. It
is overridden by 'list_for_each_entry'.

Fixes: f2663872f073 ("crypto: cavium - Register the CNN55XX supported crypto algorithms.")
Cc: <stable@vger.kernel.org>
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/cavium/nitrox/nitrox_main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/crypto/cavium/nitrox/nitrox_main.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_main.c
@@ -278,7 +278,7 @@ static void nitrox_remove_from_devlist(s
 
 struct nitrox_device *nitrox_get_first_device(void)
 {
-	struct nitrox_device *ndev = NULL;
+	struct nitrox_device *ndev;
 
 	mutex_lock(&devlist_lock);
 	list_for_each_entry(ndev, &ndevlist, list) {
@@ -286,7 +286,7 @@ struct nitrox_device *nitrox_get_first_d
 			break;
 	}
 	mutex_unlock(&devlist_lock);
-	if (!ndev)
+	if (&ndev->list == &ndevlist)
 		return NULL;
 
 	refcount_inc(&ndev->refcnt);



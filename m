Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA7581577B6
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:02:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729212AbgBJMkj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:40:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:40998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729035AbgBJMki (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:40:38 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C51524672;
        Mon, 10 Feb 2020 12:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338438;
        bh=eemhR6Ru7qO7yi4QKm/U7unt7CD/VUvZkbGxGq9Z+10=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DQXrfS3wflste5FMmfMPhvCeouVwIJ0XNlXZbGvhspzndoBjVRZcc/aC9R+CUSL8s
         Kl6Atfyodgy6DnXDQUUZchfZa9QrMVxnsTtzSvnvMN/DcQUl79CBl/2r95o8BvNv85
         98zC09l1NXxO5qC+vkydd06d0TIO9rC9I8SCa7Bk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Corentin Labbe <clabbe.montjoie@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.5 174/367] crypto: sun8i-ss - fix removal of module
Date:   Mon, 10 Feb 2020 04:31:27 -0800
Message-Id: <20200210122440.903610748@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Corentin Labbe <clabbe.montjoie@gmail.com>

commit 7b3d853ead8187288bf99df38ed71ee02773a65f upstream.

Removing the driver cause an oops due to the fact we clean an extra
channel.
Let's give the right index to the cleaning function.
Fixes: f08fcced6d00 ("crypto: allwinner - Add sun8i-ss cryptographic offloader")

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
@@ -595,7 +595,7 @@ error_alg:
 error_irq:
 	sun8i_ss_pm_exit(ss);
 error_pm:
-	sun8i_ss_free_flows(ss, MAXFLOW);
+	sun8i_ss_free_flows(ss, MAXFLOW - 1);
 	return err;
 }
 
@@ -609,7 +609,7 @@ static int sun8i_ss_remove(struct platfo
 	debugfs_remove_recursive(ss->dbgfs_dir);
 #endif
 
-	sun8i_ss_free_flows(ss, MAXFLOW);
+	sun8i_ss_free_flows(ss, MAXFLOW - 1);
 
 	sun8i_ss_pm_exit(ss);
 



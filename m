Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 554301577B5
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:02:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729778AbgBJMkk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:40:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:41150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728154AbgBJMkj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:40:39 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E4AB52173E;
        Mon, 10 Feb 2020 12:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338439;
        bh=5QD9YOC95JGAUEOA86RzolZ5SR5kMSDUR274K8u+1o4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gNnAzbckLb5K3bCMF5kRSVYhjWUnLT/SfT3VJLlCW4ByOC59BytdQEiN6CJh3uNay
         bt0e2VhUqQeUG/1oO+cCTyf25pbnGsFyWO0BcnNwIVn61YIORpO8k5periSDLhUs6x
         GoCxgQz0Ymbycc55+II3KT50NRK0lkjvqYwLBMfU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Corentin Labbe <clabbe.montjoie@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.5 175/367] crypto: amlogic - fix removal of module
Date:   Mon, 10 Feb 2020 04:31:28 -0800
Message-Id: <20200210122440.982219829@linuxfoundation.org>
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

commit 24775ac2fe68132d3e0e7cd3a0521ccb1a5d7243 upstream.

Removing the driver cause an oops due to the fact we clean an extra
channel.
Let's give the right index to the cleaning function.
Fixes: 48fe583fe541 ("crypto: amlogic - Add crypto accelerator for amlogic GXL")

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/amlogic/amlogic-gxl-core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/crypto/amlogic/amlogic-gxl-core.c
+++ b/drivers/crypto/amlogic/amlogic-gxl-core.c
@@ -289,7 +289,7 @@ static int meson_crypto_probe(struct pla
 error_alg:
 	meson_unregister_algs(mc);
 error_flow:
-	meson_free_chanlist(mc, MAXFLOW);
+	meson_free_chanlist(mc, MAXFLOW - 1);
 	clk_disable_unprepare(mc->busclk);
 	return err;
 }
@@ -304,7 +304,7 @@ static int meson_crypto_remove(struct pl
 
 	meson_unregister_algs(mc);
 
-	meson_free_chanlist(mc, MAXFLOW);
+	meson_free_chanlist(mc, MAXFLOW - 1);
 
 	clk_disable_unprepare(mc->busclk);
 	return 0;



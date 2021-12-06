Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 107AC469C44
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:18:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352254AbhLFPVn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:21:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357781AbhLFPTA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:19:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64524C061746;
        Mon,  6 Dec 2021 07:13:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 312BFB8101B;
        Mon,  6 Dec 2021 15:13:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A558C341C2;
        Mon,  6 Dec 2021 15:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803580;
        bh=N2Qii4doKbDiNqMT4N8lSF9Js3ON1OVkKdTLLR+VTeM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dvrKjZgvfXQbycoZbf7gdeqCYoso52ZPai31jcDl9IfQDbKqqfW4AOOHzCZPEyVqt
         8MORYbVr+Srvl6qbkXWKu20HkF0b8rDw/fjaGNIAn/voFDz5xa2zHDwgGmL9/sVa7Y
         J0FL9U6btYW+hV5Ni55elEJYGOdcBdBSAz3u9yPw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 44/70] net: marvell: mvpp2: Fix the computation of shared CPUs
Date:   Mon,  6 Dec 2021 15:56:48 +0100
Message-Id: <20211206145553.455034240@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145551.909846023@linuxfoundation.org>
References: <20211206145551.909846023@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

commit b83f5ac7d922e69a109261f5f940eebbd4e514c4 upstream.

'bitmap_fill()' fills a bitmap one 'long' at a time.
It is likely that an exact number of bits is expected.

Use 'bitmap_set()' instead in order not to set unexpected bits.

Fixes: e531f76757eb ("net: mvpp2: handle cases where more CPUs are available than s/w threads")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -5773,7 +5773,7 @@ static int mvpp2_probe(struct platform_d
 
 	shared = num_present_cpus() - priv->nthreads;
 	if (shared > 0)
-		bitmap_fill(&priv->lock_map,
+		bitmap_set(&priv->lock_map, 0,
 			    min_t(int, shared, MVPP2_MAX_THREADS));
 
 	for (i = 0; i < MVPP2_MAX_THREADS; i++) {


